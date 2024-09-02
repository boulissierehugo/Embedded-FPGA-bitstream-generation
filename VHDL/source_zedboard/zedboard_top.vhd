
-- Connexion of components (master -> slave) :
-- (axi3) PS7 GP0  -> USER_IP

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity zedboard_top is
  port(
    gclk   : in  std_logic;

    sw     : in  std_logic_vector(7 downto 0);

		btnc   : in  std_logic;
		btnd   : in  std_logic;
		btnl   : in  std_logic;
		btnr   : in  std_logic;
		btnu   : in  std_logic;

    led    : out std_logic_vector(7 downto 0)
	);
end zedboard_top;

architecture synth of zedboard_top is

	-- Constants for user IP

	constant C_S_AXI_DATA_WIDTH : integer := 32;
	constant C_S_AXI_ADDR_WIDTH : integer := 32;
	constant C_S_AXI_ID_WIDTH   : integer := 12;
	constant C_S_AXI_SIZE_WIDTH : integer := 2;

	-- Signals for AXI3 channel : PS7 GP0 -> User IP

	signal GP_AXI_ACLK    : std_logic := '0';
	signal GP_AXI_ARESETN : std_logic := '0';

	signal GP_AXI_AWVALID : std_logic := '0';
	signal GP_AXI_AWREADY : std_logic := '0';
	signal GP_AXI_AWID    : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_AWADDR  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_AWLEN   : std_logic_vector(3 downto 0) := (others => '0');
	signal GP_AXI_AWSIZE  : std_logic_vector(C_S_AXI_SIZE_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_AWBURST : std_logic_vector(1 downto 0) := (others => '0');
	signal GP_AXI_AWLOCK  : std_logic_vector(1 downto 0) := (others => '0');
	signal GP_AXI_AWCACHE : std_logic_vector(3 downto 0) := (others => '0');
	signal GP_AXI_AWPROT  : std_logic_vector(2 downto 0) := (others => '0');
	signal GP_AXI_AWQOS   : std_logic_vector(3 downto 0) := (others => '0');

	signal GP_AXI_WVALID  : std_logic := '0';
	signal GP_AXI_WREADY  : std_logic := '0';
	signal GP_AXI_WID     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_WDATA   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_WSTRB   : std_logic_vector(C_S_AXI_DATA_WIDTH/8-1 downto 0) := (others => '0');
	signal GP_AXI_WLAST   : std_logic := '0';

	signal GP_AXI_BVALID  : std_logic := '0';
	signal GP_AXI_BREADY  : std_logic := '0';
	signal GP_AXI_BID     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_BRESP   : std_logic_vector(1 downto 0) := (others => '0');

	signal GP_AXI_ARVALID : std_logic := '0';
	signal GP_AXI_ARREADY : std_logic := '0';
	signal GP_AXI_ARID    : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_ARADDR  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_ARLEN   : std_logic_vector(3 downto 0) := (others => '0');
	signal GP_AXI_ARSIZE  : std_logic_vector(C_S_AXI_SIZE_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_ARBURST : std_logic_vector(1 downto 0) := (others => '0');
	signal GP_AXI_ARLOCK  : std_logic_vector(1 downto 0) := (others => '0');
	signal GP_AXI_ARCACHE : std_logic_vector(3 downto 0) := (others => '0');
	signal GP_AXI_ARPROT  : std_logic_vector(2 downto 0) := (others => '0');
	signal GP_AXI_ARQOS   : std_logic_vector(3 downto 0) := (others => '0');

	signal GP_AXI_RVALID  : std_logic := '0';
	signal GP_AXI_RREADY  : std_logic := '0';
	signal GP_AXI_RID     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_RDATA   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
	signal GP_AXI_RLAST   : std_logic := '0';
	signal GP_AXI_RRESP   : std_logic_vector(1 downto 0) := (others => '0');

	-- PS7 connections : Generated clocks and resets
	signal FCLKCLK    : std_logic_vector(3 downto 0) := (others => '0');
	signal FCLKRESETN : std_logic_vector(3 downto 0) := (others => '1');

	-- PS7 connection : to indicate that the FPGA design is active on AXI ports
	signal FPGAIDLEN : std_logic := '0';

	-- Local double buffering for reset
	signal local_resetn_buf1 : std_logic := '1';
	signal local_resetn_buf2 : std_logic := '1';

	-- Note : The size of some PS7 ports depend on actual chip footprint
	-- Port MIO :
	-- Footprint clg400 and above : 54 bits
	-- Footprint clg225 and below : 32 bits
	constant PS7_MIO_SIZE : natural := 54;
	-- Port DDRDQ (minor impact on PS7 component declaration) :
	-- Footprint clg400 and above : 32 bits
	-- Footprint clg225 and below : 16 bits
	constant PS7_DDRDQ_SIZE : natural := 32;
	-- ADC signal pairs (no impact on PS7 component declaration) :
	-- Footprint clg400 and above : 12 pairs
	-- Footprint clg225 and below : 4 pairs

	component PS7
		port (

			-- PS system clock and reset

			PSCLK   : inout std_logic;  -- System reference clock
			PSPORB  : inout std_logic;  -- Power-On reset, active low
			PSSRSTB : inout std_logic;  -- System reset, active low

			-- PS DDR ports

			DDRCKN   : inout std_logic;
			DDRCKP   : inout std_logic;
			DDRCKE   : inout std_logic;
			DDRCSB   : inout std_logic;
			DDRRASB  : inout std_logic;
			DDRCASB  : inout std_logic;
			DDRWEB   : inout std_logic;
			DDRBA    : inout std_logic_vector( 2 downto 0);
			DDRA     : inout std_logic_vector(14 downto 0);
			DDRODT   : inout std_logic;
			DDRDRSTB : inout std_logic;
			DDRDQ    : inout std_logic_vector(PS7_DDRDQ_SIZE-1 downto 0);
			DDRDM    : inout std_logic_vector( 3 downto 0);
			DDRDQSN  : inout std_logic_vector( 3 downto 0);
			DDRDQSP  : inout std_logic_vector( 3 downto 0);

			DDRVRN   : inout std_logic;
			DDRVRP   : inout std_logic;

			-- PS Multiplexed I/O ports

			MIO : inout std_logic_vector(PS7_MIO_SIZE-1 downto 0);

			-- PS-PL Extended Multiplexed I/O signals

			EMIOCAN0PHYTX : out std_logic;
			EMIOCAN0PHYRX : in  std_logic;

			EMIOCAN1PHYTX : out std_logic;
			EMIOCAN1PHYRX : in  std_logic;

			EMIOENET0GMIITXD         : out std_logic_vector(7 downto 0);
			EMIOENET0GMIITXEN        : out std_logic;
			EMIOENET0GMIITXER        : out std_logic;
			EMIOENET0MDIOMDC         : out std_logic;
			EMIOENET0MDIOO           : out std_logic;
			EMIOENET0MDIOTN          : out std_logic;
			EMIOENET0PTPDELAYREQRX   : out std_logic;
			EMIOENET0PTPDELAYREQTX   : out std_logic;
			EMIOENET0PTPPDELAYREQRX  : out std_logic;
			EMIOENET0PTPPDELAYREQTX  : out std_logic;
			EMIOENET0PTPPDELAYRESPRX : out std_logic;
			EMIOENET0PTPPDELAYRESPTX : out std_logic;
			EMIOENET0PTPSYNCFRAMERX  : out std_logic;
			EMIOENET0PTPSYNCFRAMETX  : out std_logic;
			EMIOENET0SOFRX           : out std_logic;
			EMIOENET0SOFTX           : out std_logic;
			EMIOENET0EXTINTIN        : in  std_logic;
			EMIOENET0GMIICOL         : in  std_logic;
			EMIOENET0GMIICRS         : in  std_logic;
			EMIOENET0GMIIRXCLK       : in  std_logic;
			EMIOENET0GMIIRXD         : in  std_logic_vector(7 downto 0);
			EMIOENET0GMIIRXDV        : in  std_logic;
			EMIOENET0GMIIRXER        : in  std_logic;
			EMIOENET0GMIITXCLK       : in  std_logic;
			EMIOENET0MDIOI           : in  std_logic;

			EMIOENET1GMIITXD         : out std_logic_vector(7 downto 0);
			EMIOENET1GMIITXEN        : out std_logic;
			EMIOENET1GMIITXER        : out std_logic;
			EMIOENET1MDIOMDC         : out std_logic;
			EMIOENET1MDIOO           : out std_logic;
			EMIOENET1MDIOTN          : out std_logic;
			EMIOENET1PTPDELAYREQRX   : out std_logic;
			EMIOENET1PTPDELAYREQTX   : out std_logic;
			EMIOENET1PTPPDELAYREQRX  : out std_logic;
			EMIOENET1PTPPDELAYREQTX  : out std_logic;
			EMIOENET1PTPPDELAYRESPRX : out std_logic;
			EMIOENET1PTPPDELAYRESPTX : out std_logic;
			EMIOENET1PTPSYNCFRAMERX  : out std_logic;
			EMIOENET1PTPSYNCFRAMETX  : out std_logic;
			EMIOENET1SOFRX           : out std_logic;
			EMIOENET1SOFTX           : out std_logic;
			EMIOENET1EXTINTIN        : in  std_logic;
			EMIOENET1GMIICOL         : in  std_logic;
			EMIOENET1GMIICRS         : in  std_logic;
			EMIOENET1GMIIRXCLK       : in  std_logic;
			EMIOENET1GMIIRXD         : in  std_logic_vector(7 downto 0);
			EMIOENET1GMIIRXDV        : in  std_logic;
			EMIOENET1GMIIRXER        : in  std_logic;
			EMIOENET1GMIITXCLK       : in  std_logic;
			EMIOENET1MDIOI           : in  std_logic;

			EMIOGPIOO  : out std_logic_vector(63 downto 0);
			EMIOGPIOTN : out std_logic_vector(63 downto 0);
			EMIOGPIOI  : in  std_logic_vector(63 downto 0);

			EMIOI2C0SCLO  : out std_logic;
			EMIOI2C0SCLTN : out std_logic;
			EMIOI2C0SDAO  : out std_logic;
			EMIOI2C0SDATN : out std_logic;
			EMIOI2C0SCLI  : in  std_logic;
			EMIOI2C0SDAI  : in  std_logic;

			EMIOI2C1SCLO  : out std_logic;
			EMIOI2C1SCLTN : out std_logic;
			EMIOI2C1SDAO  : out std_logic;
			EMIOI2C1SDATN : out std_logic;
			EMIOI2C1SCLI  : in  std_logic;
			EMIOI2C1SDAI  : in  std_logic;

			EMIOPJTAGTDO  : out std_logic;
			EMIOPJTAGTDTN : out std_logic;
			EMIOPJTAGTCK  : in  std_logic;
			EMIOPJTAGTDI  : in  std_logic;
			EMIOPJTAGTMS  : in  std_logic;

			EMIOSDIO0BUSPOW  : out std_logic;
			EMIOSDIO0BUSVOLT : out std_logic_vector(2 downto 0);
			EMIOSDIO0CLK     : out std_logic;
			EMIOSDIO0CMDO    : out std_logic;
			EMIOSDIO0CMDTN   : out std_logic;
			EMIOSDIO0DATAO   : out std_logic_vector(3 downto 0);
			EMIOSDIO0DATATN  : out std_logic_vector(3 downto 0);
			EMIOSDIO0LED     : out std_logic;
			EMIOSDIO0CDN     : in  std_logic;
			EMIOSDIO0CLKFB   : in  std_logic;
			EMIOSDIO0CMDI    : in  std_logic;
			EMIOSDIO0DATAI   : in  std_logic_vector(3 downto 0);
			EMIOSDIO0WP      : in  std_logic;

			EMIOSDIO1BUSPOW  : out std_logic;
			EMIOSDIO1BUSVOLT : out std_logic_vector(2 downto 0);
			EMIOSDIO1CLK     : out std_logic;
			EMIOSDIO1CMDO    : out std_logic;
			EMIOSDIO1CMDTN   : out std_logic;
			EMIOSDIO1DATAO   : out std_logic_vector(3 downto 0);
			EMIOSDIO1DATATN  : out std_logic_vector(3 downto 0);
			EMIOSDIO1LED     : out std_logic;
			EMIOSDIO1CDN     : in  std_logic;
			EMIOSDIO1CLKFB   : in  std_logic;
			EMIOSDIO1CMDI    : in  std_logic;
			EMIOSDIO1DATAI   : in  std_logic_vector(3 downto 0);
			EMIOSDIO1WP      : in  std_logic;

			EMIOSPI0MO     : out std_logic;
			EMIOSPI0MOTN   : out std_logic;
			EMIOSPI0SCLKO  : out std_logic;
			EMIOSPI0SCLKTN : out std_logic;
			EMIOSPI0SO     : out std_logic;
			EMIOSPI0SSNTN  : out std_logic;
			EMIOSPI0SSON   : out std_logic_vector(2 downto 0);
			EMIOSPI0STN    : out std_logic;
			EMIOSPI0MI     : in  std_logic;
			EMIOSPI0SCLKI  : in  std_logic;
			EMIOSPI0SI     : in  std_logic;
			EMIOSPI0SSIN   : in  std_logic;

			EMIOSPI1MO     : out std_logic;
			EMIOSPI1MOTN   : out std_logic;
			EMIOSPI1SCLKO  : out std_logic;
			EMIOSPI1SCLKTN : out std_logic;
			EMIOSPI1SO     : out std_logic;
			EMIOSPI1SSNTN  : out std_logic;
			EMIOSPI1SSON   : out std_logic_vector(2 downto 0);
			EMIOSPI1STN    : out std_logic;
			EMIOSPI1MI     : in  std_logic;
			EMIOSPI1SCLKI  : in  std_logic;
			EMIOSPI1SI     : in  std_logic;
			EMIOSPI1SSIN   : in  std_logic;

			EMIOTRACECTL  : out std_logic;
			EMIOTRACEDATA : out std_logic_vector(31 downto 0);
			EMIOTRACECLK  : in  std_logic;

			EMIOTTC0WAVEO : out std_logic_vector(2 downto 0);
			EMIOTTC1WAVEO : out std_logic_vector(2 downto 0);
			EMIOTTC0CLKI  : in  std_logic_vector(2 downto 0);
			EMIOTTC1CLKI  : in  std_logic_vector(2 downto 0);

			EMIOUART0DTRN : out std_logic;
			EMIOUART0RTSN : out std_logic;
			EMIOUART0TX   : out std_logic;
			EMIOUART0CTSN : in  std_logic;
			EMIOUART0DCDN : in  std_logic;
			EMIOUART0DSRN : in  std_logic;
			EMIOUART0RIN  : in  std_logic;
			EMIOUART0RX   : in  std_logic;

			EMIOUART1DTRN : out std_logic;
			EMIOUART1RTSN : out std_logic;
			EMIOUART1TX   : out std_logic;
			EMIOUART1CTSN : in  std_logic;
			EMIOUART1DCDN : in  std_logic;
			EMIOUART1DSRN : in  std_logic;
			EMIOUART1RIN  : in  std_logic;
			EMIOUART1RX   : in  std_logic;

			EMIOUSB0PORTINDCTL    : out std_logic_vector(1 downto 0);
			EMIOUSB0VBUSPWRSELECT : out std_logic;
			EMIOUSB0VBUSPWRFAULT  : in  std_logic;

			EMIOUSB1PORTINDCTL    : out std_logic_vector(1 downto 0);
			EMIOUSB1VBUSPWRSELECT : out std_logic;
			EMIOUSB1VBUSPWRFAULT  : in  std_logic;

			EMIOWDTCLKI : in  std_logic;
			EMIOWDTRSTO : out std_logic;

			EMIOSRAMINTIN : in std_logic;

			-- PS-PL Event signals

			EVENTEVENTO : out std_logic;
			EVENTEVENTI : in  std_logic;

			EVENTSTANDBYWFE : out std_logic_vector(1 downto 0);
			EVENTSTANDBYWFI : out std_logic_vector(1 downto 0);

			-- PS-PL Clocks and resets

			FCLKCLK      : out std_logic_vector(3 downto 0);
			FCLKRESETN   : out std_logic_vector(3 downto 0);
			FCLKCLKTRIGN : in  std_logic_vector(3 downto 0);

			-- PS-PL Fabric Trace Monitor and Debug : Trace

			FTMDTRACEINCLOCK : in std_logic;
			FTMDTRACEINATID  : in std_logic_vector(3 downto 0);
			FTMDTRACEINDATA  : in std_logic_vector(31 downto 0);
			FTMDTRACEINVALID : in std_logic;

			-- PS-PL Fabric Trace Monitor and Debug : Triggers

			FTMTF2PTRIG      : in  std_logic_vector( 3 downto 0);
			FTMTF2PDEBUG     : in  std_logic_vector(31 downto 0);
			FTMTF2PTRIGACK   : out std_logic_vector( 3 downto 0);

			FTMTP2FTRIG      : out std_logic_vector( 3 downto 0);
			FTMTP2FDEBUG     : out std_logic_vector(31 downto 0);
			FTMTP2FTRIGACK   : in  std_logic_vector( 3 downto 0);

			-- PS-PL DDR urgent/arbitration

			DDRARB : in std_logic_vector(3 downto 0);

			-- PS-PL AXI Idle, active low

			FPGAIDLEN : in std_logic;

			-- PS-PL DMA controller

			DMA0ACLK    : in  std_logic;
			DMA0RSTN    : out std_logic;
			DMA0DATYPE  : out std_logic_vector(1 downto 0);
			DMA0DRREADY : out std_logic;
			DMA0DRLAST  : in  std_logic;
			DMA0DRTYPE  : in  std_logic_vector(1 downto 0);
			DMA0DRVALID : in  std_logic;
			DMA0DAVALID : out std_logic;
			DMA0DAREADY : in  std_logic;

			DMA1ACLK    : in  std_logic;
			DMA1RSTN    : out std_logic;
			DMA1DATYPE  : out std_logic_vector(1 downto 0);
			DMA1DRREADY : out std_logic;
			DMA1DRLAST  : in  std_logic;
			DMA1DRTYPE  : in  std_logic_vector(1 downto 0);
			DMA1DRVALID : in  std_logic;
			DMA1DAVALID : out std_logic;
			DMA1DAREADY : in  std_logic;

			DMA2ACLK    : in  std_logic;
			DMA2RSTN    : out std_logic;
			DMA2DATYPE  : out std_logic_vector(1 downto 0);
			DMA2DRREADY : out std_logic;
			DMA2DRLAST  : in  std_logic;
			DMA2DRTYPE  : in  std_logic_vector(1 downto 0);
			DMA2DRVALID : in  std_logic;
			DMA2DAVALID : out std_logic;
			DMA2DAREADY : in  std_logic;

			DMA3ACLK    : in  std_logic;
			DMA3RSTN    : out std_logic;
			DMA3DATYPE  : out std_logic_vector(1 downto 0);
			DMA3DRREADY : out std_logic;
			DMA3DRLAST  : in  std_logic;
			DMA3DRTYPE  : in  std_logic_vector(1 downto 0);
			DMA3DRVALID : in  std_logic;
			DMA3DAVALID : out std_logic;
			DMA3DAREADY : in  std_logic;

			-- PS-PL Interrupt signals

			IRQP2F : out std_logic_vector(28 downto 0);
			IRQF2P : in  std_logic_vector(19 downto 0);

			-- Master AXI General Purpose GP0

			MAXIGP0ACLK    : in  std_logic;
			MAXIGP0ARESETN : out std_logic;

			MAXIGP0AWADDR  : out std_logic_vector(31 downto 0);
			MAXIGP0AWBURST : out std_logic_vector( 1 downto 0);
			MAXIGP0AWCACHE : out std_logic_vector( 3 downto 0);
			MAXIGP0AWID    : out std_logic_vector(11 downto 0);
			MAXIGP0AWLEN   : out std_logic_vector( 3 downto 0);
			MAXIGP0AWLOCK  : out std_logic_vector( 1 downto 0);
			MAXIGP0AWPROT  : out std_logic_vector( 2 downto 0);
			MAXIGP0AWQOS   : out std_logic_vector( 3 downto 0);
			MAXIGP0AWSIZE  : out std_logic_vector( 1 downto 0);
			MAXIGP0AWVALID : out std_logic;
			MAXIGP0AWREADY : in  std_logic;

			MAXIGP0WDATA   : out std_logic_vector(31 downto 0);
			MAXIGP0WID     : out std_logic_vector(11 downto 0);
			MAXIGP0WLAST   : out std_logic;
			MAXIGP0WSTRB   : out std_logic_vector( 3 downto 0);
			MAXIGP0WVALID  : out std_logic;
			MAXIGP0WREADY  : in  std_logic;

			MAXIGP0BREADY  : out std_logic;
			MAXIGP0BID     : in  std_logic_vector(11 downto 0);
			MAXIGP0BRESP   : in  std_logic_vector( 1 downto 0);
			MAXIGP0BVALID  : in  std_logic;

			MAXIGP0ARADDR  : out std_logic_vector(31 downto 0);
			MAXIGP0ARBURST : out std_logic_vector( 1 downto 0);
			MAXIGP0ARCACHE : out std_logic_vector( 3 downto 0);
			MAXIGP0ARID    : out std_logic_vector(11 downto 0);
			MAXIGP0ARLEN   : out std_logic_vector( 3 downto 0);
			MAXIGP0ARLOCK  : out std_logic_vector( 1 downto 0);
			MAXIGP0ARPROT  : out std_logic_vector( 2 downto 0);
			MAXIGP0ARQOS   : out std_logic_vector( 3 downto 0);
			MAXIGP0ARSIZE  : out std_logic_vector( 1 downto 0);
			MAXIGP0ARVALID : out std_logic;
			MAXIGP0ARREADY : in  std_logic;

			MAXIGP0RREADY  : out std_logic;
			MAXIGP0RDATA   : in  std_logic_vector(31 downto 0);
			MAXIGP0RID     : in  std_logic_vector(11 downto 0);
			MAXIGP0RLAST   : in  std_logic;
			MAXIGP0RRESP   : in  std_logic_vector( 1 downto 0);
			MAXIGP0RVALID  : in  std_logic;

			-- Master AXI General Purpose GP1

			MAXIGP1ACLK    : in  std_logic;
			MAXIGP1ARESETN : out std_logic;

			MAXIGP1AWADDR  : out std_logic_vector(31 downto 0);
			MAXIGP1AWBURST : out std_logic_vector( 1 downto 0);
			MAXIGP1AWCACHE : out std_logic_vector( 3 downto 0);
			MAXIGP1AWID    : out std_logic_vector(11 downto 0);
			MAXIGP1AWLEN   : out std_logic_vector( 3 downto 0);
			MAXIGP1AWLOCK  : out std_logic_vector( 1 downto 0);
			MAXIGP1AWPROT  : out std_logic_vector( 2 downto 0);
			MAXIGP1AWQOS   : out std_logic_vector( 3 downto 0);
			MAXIGP1AWSIZE  : out std_logic_vector( 1 downto 0);
			MAXIGP1AWVALID : out std_logic;
			MAXIGP1AWREADY : in  std_logic;

			MAXIGP1WDATA   : out std_logic_vector(31 downto 0);
			MAXIGP1WID     : out std_logic_vector(11 downto 0);
			MAXIGP1WLAST   : out std_logic;
			MAXIGP1WSTRB   : out std_logic_vector( 3 downto 0);
			MAXIGP1WVALID  : out std_logic;
			MAXIGP1WREADY  : in  std_logic;

			MAXIGP1BREADY  : out std_logic;
			MAXIGP1BID     : in  std_logic_vector(11 downto 0);
			MAXIGP1BRESP   : in  std_logic_vector( 1 downto 0);
			MAXIGP1BVALID  : in  std_logic;

			MAXIGP1ARADDR  : out std_logic_vector(31 downto 0);
			MAXIGP1ARBURST : out std_logic_vector( 1 downto 0);
			MAXIGP1ARCACHE : out std_logic_vector( 3 downto 0);
			MAXIGP1ARID    : out std_logic_vector(11 downto 0);
			MAXIGP1ARLEN   : out std_logic_vector( 3 downto 0);
			MAXIGP1ARLOCK  : out std_logic_vector( 1 downto 0);
			MAXIGP1ARPROT  : out std_logic_vector( 2 downto 0);
			MAXIGP1ARQOS   : out std_logic_vector( 3 downto 0);
			MAXIGP1ARSIZE  : out std_logic_vector( 1 downto 0);
			MAXIGP1ARVALID : out std_logic;
			MAXIGP1ARREADY : in  std_logic;

			MAXIGP1RREADY  : out std_logic;
			MAXIGP1RDATA   : in  std_logic_vector(31 downto 0);
			MAXIGP1RID     : in  std_logic_vector(11 downto 0);
			MAXIGP1RLAST   : in  std_logic;
			MAXIGP1RRESP   : in  std_logic_vector( 1 downto 0);
			MAXIGP1RVALID  : in  std_logic;

			-- Slave AXI General Purpose GP0

			SAXIGP0ACLK    : in  std_logic;
			SAXIGP0ARESETN : out std_logic;

			SAXIGP0AWADDR  : in  std_logic_vector(31 downto 0);
			SAXIGP0AWBURST : in  std_logic_vector( 1 downto 0);
			SAXIGP0AWCACHE : in  std_logic_vector( 3 downto 0);
			SAXIGP0AWID    : in  std_logic_vector( 5 downto 0);
			SAXIGP0AWLEN   : in  std_logic_vector( 3 downto 0);
			SAXIGP0AWLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIGP0AWPROT  : in  std_logic_vector( 2 downto 0);
			SAXIGP0AWQOS   : in  std_logic_vector( 3 downto 0);
			SAXIGP0AWSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIGP0AWVALID : in  std_logic;
			SAXIGP0AWREADY : out std_logic;

			SAXIGP0WDATA   : in  std_logic_vector(31 downto 0);
			SAXIGP0WID     : in  std_logic_vector( 5 downto 0);
			SAXIGP0WLAST   : in  std_logic;
			SAXIGP0WSTRB   : in  std_logic_vector( 3 downto 0);
			SAXIGP0WVALID  : in  std_logic;
			SAXIGP0WREADY  : out std_logic;

			SAXIGP0BREADY  : in  std_logic;
			SAXIGP0BID     : out std_logic_vector( 5 downto 0);
			SAXIGP0BRESP   : out std_logic_vector( 1 downto 0);
			SAXIGP0BVALID  : out std_logic;

			SAXIGP0ARADDR  : in  std_logic_vector(31 downto 0);
			SAXIGP0ARBURST : in  std_logic_vector( 1 downto 0);
			SAXIGP0ARCACHE : in  std_logic_vector( 3 downto 0);
			SAXIGP0ARID    : in  std_logic_vector( 5 downto 0);
			SAXIGP0ARLEN   : in  std_logic_vector( 3 downto 0);
			SAXIGP0ARLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIGP0ARPROT  : in  std_logic_vector( 2 downto 0);
			SAXIGP0ARQOS   : in  std_logic_vector( 3 downto 0);
			SAXIGP0ARSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIGP0ARVALID : in  std_logic;
			SAXIGP0ARREADY : out std_logic;

			SAXIGP0RREADY  : in  std_logic;
			SAXIGP0RDATA   : out std_logic_vector(31 downto 0);
			SAXIGP0RID     : out std_logic_vector( 5 downto 0);
			SAXIGP0RLAST   : out std_logic;
			SAXIGP0RRESP   : out std_logic_vector( 1 downto 0);
			SAXIGP0RVALID  : out std_logic;

			-- Slave AXI General Purpose GP1

			SAXIGP1ACLK    : in  std_logic;
			SAXIGP1ARESETN : out std_logic;

			SAXIGP1AWADDR  : in  std_logic_vector(31 downto 0);
			SAXIGP1AWBURST : in  std_logic_vector( 1 downto 0);
			SAXIGP1AWCACHE : in  std_logic_vector( 3 downto 0);
			SAXIGP1AWID    : in  std_logic_vector( 5 downto 0);
			SAXIGP1AWLEN   : in  std_logic_vector( 3 downto 0);
			SAXIGP1AWLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIGP1AWPROT  : in  std_logic_vector( 2 downto 0);
			SAXIGP1AWQOS   : in  std_logic_vector( 3 downto 0);
			SAXIGP1AWSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIGP1AWVALID : in  std_logic;
			SAXIGP1AWREADY : out std_logic;

			SAXIGP1WDATA   : in  std_logic_vector(31 downto 0);
			SAXIGP1WID     : in  std_logic_vector( 5 downto 0);
			SAXIGP1WLAST   : in  std_logic;
			SAXIGP1WSTRB   : in  std_logic_vector( 3 downto 0);
			SAXIGP1WVALID  : in  std_logic;
			SAXIGP1WREADY  : out std_logic;

			SAXIGP1BREADY  : in  std_logic;
			SAXIGP1BID     : out std_logic_vector( 5 downto 0);
			SAXIGP1BRESP   : out std_logic_vector( 1 downto 0);
			SAXIGP1BVALID  : out std_logic;

			SAXIGP1ARADDR  : in  std_logic_vector(31 downto 0);
			SAXIGP1ARBURST : in  std_logic_vector( 1 downto 0);
			SAXIGP1ARCACHE : in  std_logic_vector( 3 downto 0);
			SAXIGP1ARID    : in  std_logic_vector( 5 downto 0);
			SAXIGP1ARLEN   : in  std_logic_vector( 3 downto 0);
			SAXIGP1ARLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIGP1ARPROT  : in  std_logic_vector( 2 downto 0);
			SAXIGP1ARQOS   : in  std_logic_vector( 3 downto 0);
			SAXIGP1ARSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIGP1ARVALID : in  std_logic;
			SAXIGP1ARREADY : out std_logic;

			SAXIGP1RREADY  : in  std_logic;
			SAXIGP1RDATA   : out std_logic_vector(31 downto 0);
			SAXIGP1RID     : out std_logic_vector( 5 downto 0);
			SAXIGP1RLAST   : out std_logic;
			SAXIGP1RRESP   : out std_logic_vector( 1 downto 0);
			SAXIGP1RVALID  : out std_logic;

			-- Slave AXI High Performance HP0

			SAXIHP0ACLK    : in  std_logic;
			SAXIHP0ARESETN : out std_logic;

			SAXIHP0AWADDR  : in  std_logic_vector(31 downto 0);
			SAXIHP0AWBURST : in  std_logic_vector( 1 downto 0);
			SAXIHP0AWCACHE : in  std_logic_vector( 3 downto 0);
			SAXIHP0AWID    : in  std_logic_vector( 5 downto 0);
			SAXIHP0AWLEN   : in  std_logic_vector( 3 downto 0);
			SAXIHP0AWLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIHP0AWPROT  : in  std_logic_vector( 2 downto 0);
			SAXIHP0AWQOS   : in  std_logic_vector( 3 downto 0);
			SAXIHP0AWSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIHP0AWVALID : in  std_logic;
			SAXIHP0AWREADY : out std_logic;

			SAXIHP0WDATA   : in  std_logic_vector(63 downto 0);
			SAXIHP0WID     : in  std_logic_vector( 5 downto 0);
			SAXIHP0WLAST   : in  std_logic;
			SAXIHP0WSTRB   : in  std_logic_vector( 7 downto 0);
			SAXIHP0WVALID  : in  std_logic;
			SAXIHP0WREADY  : out std_logic;

			SAXIHP0BREADY  : in  std_logic;
			SAXIHP0BID     : out std_logic_vector( 5 downto 0);
			SAXIHP0BRESP   : out std_logic_vector( 1 downto 0);
			SAXIHP0BVALID  : out std_logic;

			SAXIHP0ARADDR  : in  std_logic_vector(31 downto 0);
			SAXIHP0ARBURST : in  std_logic_vector( 1 downto 0);
			SAXIHP0ARCACHE : in  std_logic_vector( 3 downto 0);
			SAXIHP0ARID    : in  std_logic_vector( 5 downto 0);
			SAXIHP0ARLEN   : in  std_logic_vector( 3 downto 0);
			SAXIHP0ARLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIHP0ARPROT  : in  std_logic_vector( 2 downto 0);
			SAXIHP0ARQOS   : in  std_logic_vector( 3 downto 0);
			SAXIHP0ARSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIHP0ARVALID : in  std_logic;
			SAXIHP0ARREADY : out std_logic;

			SAXIHP0RREADY  : in  std_logic;
			SAXIHP0RDATA   : out std_logic_vector(63 downto 0);
			SAXIHP0RID     : out std_logic_vector( 5 downto 0);
			SAXIHP0RLAST   : out std_logic;
			SAXIHP0RRESP   : out std_logic_vector( 1 downto 0);
			SAXIHP0RVALID  : out std_logic;

			SAXIHP0WACOUNT : out std_logic_vector( 5 downto 0);
			SAXIHP0WCOUNT  : out std_logic_vector( 7 downto 0);
			SAXIHP0RACOUNT : out std_logic_vector( 2 downto 0);
			SAXIHP0RCOUNT  : out std_logic_vector( 7 downto 0);

			SAXIHP0WRISSUECAP1EN : in std_logic;
			SAXIHP0RDISSUECAP1EN : in std_logic;

			-- Slave AXI High Performance HP1

			SAXIHP1ACLK    : in  std_logic;
			SAXIHP1ARESETN : out std_logic;

			SAXIHP1AWADDR  : in  std_logic_vector(31 downto 0);
			SAXIHP1AWBURST : in  std_logic_vector( 1 downto 0);
			SAXIHP1AWCACHE : in  std_logic_vector( 3 downto 0);
			SAXIHP1AWID    : in  std_logic_vector( 5 downto 0);
			SAXIHP1AWLEN   : in  std_logic_vector( 3 downto 0);
			SAXIHP1AWLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIHP1AWPROT  : in  std_logic_vector( 2 downto 0);
			SAXIHP1AWQOS   : in  std_logic_vector( 3 downto 0);
			SAXIHP1AWSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIHP1AWVALID : in  std_logic;
			SAXIHP1AWREADY : out std_logic;

			SAXIHP1WDATA   : in  std_logic_vector(63 downto 0);
			SAXIHP1WID     : in  std_logic_vector( 5 downto 0);
			SAXIHP1WLAST   : in  std_logic;
			SAXIHP1WSTRB   : in  std_logic_vector( 7 downto 0);
			SAXIHP1WVALID  : in  std_logic;
			SAXIHP1WREADY  : out std_logic;

			SAXIHP1BREADY  : in  std_logic;
			SAXIHP1BID     : out std_logic_vector( 5 downto 0);
			SAXIHP1BRESP   : out std_logic_vector( 1 downto 0);
			SAXIHP1BVALID  : out std_logic;

			SAXIHP1ARADDR  : in  std_logic_vector(31 downto 0);
			SAXIHP1ARBURST : in  std_logic_vector( 1 downto 0);
			SAXIHP1ARCACHE : in  std_logic_vector( 3 downto 0);
			SAXIHP1ARID    : in  std_logic_vector( 5 downto 0);
			SAXIHP1ARLEN   : in  std_logic_vector( 3 downto 0);
			SAXIHP1ARLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIHP1ARPROT  : in  std_logic_vector( 2 downto 0);
			SAXIHP1ARQOS   : in  std_logic_vector( 3 downto 0);
			SAXIHP1ARSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIHP1ARVALID : in  std_logic;
			SAXIHP1ARREADY : out std_logic;

			SAXIHP1RREADY  : in  std_logic;
			SAXIHP1RDATA   : out std_logic_vector(63 downto 0);
			SAXIHP1RID     : out std_logic_vector( 5 downto 0);
			SAXIHP1RLAST   : out std_logic;
			SAXIHP1RRESP   : out std_logic_vector( 1 downto 0);
			SAXIHP1RVALID  : out std_logic;

			SAXIHP1WACOUNT : out std_logic_vector( 5 downto 0);
			SAXIHP1WCOUNT  : out std_logic_vector( 7 downto 0);
			SAXIHP1RACOUNT : out std_logic_vector( 2 downto 0);
			SAXIHP1RCOUNT  : out std_logic_vector( 7 downto 0);

			SAXIHP1WRISSUECAP1EN : in std_logic;
			SAXIHP1RDISSUECAP1EN : in std_logic;

			-- Slave AXI High Performance HP2

			SAXIHP2ACLK    : in  std_logic;
			SAXIHP2ARESETN : out std_logic;

			SAXIHP2AWADDR  : in  std_logic_vector(31 downto 0);
			SAXIHP2AWBURST : in  std_logic_vector( 1 downto 0);
			SAXIHP2AWCACHE : in  std_logic_vector( 3 downto 0);
			SAXIHP2AWID    : in  std_logic_vector( 5 downto 0);
			SAXIHP2AWLEN   : in  std_logic_vector( 3 downto 0);
			SAXIHP2AWLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIHP2AWPROT  : in  std_logic_vector( 2 downto 0);
			SAXIHP2AWQOS   : in  std_logic_vector( 3 downto 0);
			SAXIHP2AWSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIHP2AWVALID : in  std_logic;
			SAXIHP2AWREADY : out std_logic;

			SAXIHP2WDATA   : in  std_logic_vector(63 downto 0);
			SAXIHP2WID     : in  std_logic_vector( 5 downto 0);
			SAXIHP2WLAST   : in  std_logic;
			SAXIHP2WSTRB   : in  std_logic_vector( 7 downto 0);
			SAXIHP2WVALID  : in  std_logic;
			SAXIHP2WREADY  : out std_logic;

			SAXIHP2BREADY  : in  std_logic;
			SAXIHP2BID     : out std_logic_vector( 5 downto 0);
			SAXIHP2BRESP   : out std_logic_vector( 1 downto 0);
			SAXIHP2BVALID  : out std_logic;

			SAXIHP2ARADDR  : in  std_logic_vector(31 downto 0);
			SAXIHP2ARBURST : in  std_logic_vector( 1 downto 0);
			SAXIHP2ARCACHE : in  std_logic_vector( 3 downto 0);
			SAXIHP2ARID    : in  std_logic_vector( 5 downto 0);
			SAXIHP2ARLEN   : in  std_logic_vector( 3 downto 0);
			SAXIHP2ARLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIHP2ARPROT  : in  std_logic_vector( 2 downto 0);
			SAXIHP2ARQOS   : in  std_logic_vector( 3 downto 0);
			SAXIHP2ARSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIHP2ARVALID : in  std_logic;
			SAXIHP2ARREADY : out std_logic;

			SAXIHP2RREADY  : in  std_logic;
			SAXIHP2RDATA   : out std_logic_vector(63 downto 0);
			SAXIHP2RID     : out std_logic_vector( 5 downto 0);
			SAXIHP2RLAST   : out std_logic;
			SAXIHP2RRESP   : out std_logic_vector( 1 downto 0);
			SAXIHP2RVALID  : out std_logic;

			SAXIHP2WACOUNT : out std_logic_vector( 5 downto 0);
			SAXIHP2WCOUNT  : out std_logic_vector( 7 downto 0);
			SAXIHP2RACOUNT : out std_logic_vector( 2 downto 0);
			SAXIHP2RCOUNT  : out std_logic_vector( 7 downto 0);

			SAXIHP2WRISSUECAP1EN : in std_logic;
			SAXIHP2RDISSUECAP1EN : in std_logic;

			-- Slave AXI High Performance HP3

			SAXIHP3ACLK    : in  std_logic;
			SAXIHP3ARESETN : out std_logic;

			SAXIHP3AWADDR  : in  std_logic_vector(31 downto 0);
			SAXIHP3AWBURST : in  std_logic_vector( 1 downto 0);
			SAXIHP3AWCACHE : in  std_logic_vector( 3 downto 0);
			SAXIHP3AWID    : in  std_logic_vector( 5 downto 0);
			SAXIHP3AWLEN   : in  std_logic_vector( 3 downto 0);
			SAXIHP3AWLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIHP3AWPROT  : in  std_logic_vector( 2 downto 0);
			SAXIHP3AWQOS   : in  std_logic_vector( 3 downto 0);
			SAXIHP3AWSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIHP3AWVALID : in  std_logic;
			SAXIHP3AWREADY : out std_logic;

			SAXIHP3WDATA   : in  std_logic_vector(63 downto 0);
			SAXIHP3WID     : in  std_logic_vector( 5 downto 0);
			SAXIHP3WLAST   : in  std_logic;
			SAXIHP3WSTRB   : in  std_logic_vector( 7 downto 0);
			SAXIHP3WVALID  : in  std_logic;
			SAXIHP3WREADY  : out std_logic;

			SAXIHP3BREADY  : in  std_logic;
			SAXIHP3BID     : out std_logic_vector( 5 downto 0);
			SAXIHP3BRESP   : out std_logic_vector( 1 downto 0);
			SAXIHP3BVALID  : out std_logic;

			SAXIHP3ARADDR  : in  std_logic_vector(31 downto 0);
			SAXIHP3ARBURST : in  std_logic_vector( 1 downto 0);
			SAXIHP3ARCACHE : in  std_logic_vector( 3 downto 0);
			SAXIHP3ARID    : in  std_logic_vector( 5 downto 0);
			SAXIHP3ARLEN   : in  std_logic_vector( 3 downto 0);
			SAXIHP3ARLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIHP3ARPROT  : in  std_logic_vector( 2 downto 0);
			SAXIHP3ARQOS   : in  std_logic_vector( 3 downto 0);
			SAXIHP3ARSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIHP3ARVALID : in  std_logic;
			SAXIHP3ARREADY : out std_logic;

			SAXIHP3RREADY  : in  std_logic;
			SAXIHP3RDATA   : out std_logic_vector(63 downto 0);
			SAXIHP3RID     : out std_logic_vector( 5 downto 0);
			SAXIHP3RLAST   : out std_logic;
			SAXIHP3RRESP   : out std_logic_vector( 1 downto 0);
			SAXIHP3RVALID  : out std_logic;

			SAXIHP3WACOUNT : out std_logic_vector( 5 downto 0);
			SAXIHP3WCOUNT  : out std_logic_vector( 7 downto 0);
			SAXIHP3RACOUNT : out std_logic_vector( 2 downto 0);
			SAXIHP3RCOUNT  : out std_logic_vector( 7 downto 0);

			SAXIHP3WRISSUECAP1EN : in std_logic;
			SAXIHP3RDISSUECAP1EN : in std_logic;

			-- Slave AXI Accelerator Coherency Port ACP

			SAXIACPACLK    : in std_logic;
			SAXIACPARESETN : out std_logic;

			SAXIACPAWREADY : out std_logic;
			SAXIACPAWADDR  : in  std_logic_vector(31 downto 0);
			SAXIACPAWBURST : in  std_logic_vector( 1 downto 0);
			SAXIACPAWCACHE : in  std_logic_vector( 3 downto 0);
			SAXIACPAWID    : in  std_logic_vector( 2 downto 0);
			SAXIACPAWLEN   : in  std_logic_vector( 3 downto 0);
			SAXIACPAWLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIACPAWPROT  : in  std_logic_vector( 2 downto 0);
			SAXIACPAWQOS   : in  std_logic_vector( 3 downto 0);
			SAXIACPAWSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIACPAWUSER  : in  std_logic_vector( 4 downto 0);
			SAXIACPAWVALID : in  std_logic;

			SAXIACPWREADY  : out std_logic;
			SAXIACPWDATA   : in  std_logic_vector(63 downto 0);
			SAXIACPWID     : in  std_logic_vector( 2 downto 0);
			SAXIACPWLAST   : in  std_logic;
			SAXIACPWSTRB   : in  std_logic_vector( 7 downto 0);
			SAXIACPWVALID  : in  std_logic;

			SAXIACPBID     : out std_logic_vector( 2 downto 0);
			SAXIACPBRESP   : out std_logic_vector( 1 downto 0);
			SAXIACPBVALID  : out std_logic;
			SAXIACPBREADY  : in  std_logic;

			SAXIACPARREADY : out std_logic;
			SAXIACPARADDR  : in  std_logic_vector(31 downto 0);
			SAXIACPARBURST : in  std_logic_vector( 1 downto 0);
			SAXIACPARCACHE : in  std_logic_vector( 3 downto 0);
			SAXIACPARID    : in  std_logic_vector( 2 downto 0);
			SAXIACPARLEN   : in  std_logic_vector( 3 downto 0);
			SAXIACPARLOCK  : in  std_logic_vector( 1 downto 0);
			SAXIACPARPROT  : in  std_logic_vector( 2 downto 0);
			SAXIACPARQOS   : in  std_logic_vector( 3 downto 0);
			SAXIACPARSIZE  : in  std_logic_vector( 1 downto 0);
			SAXIACPARUSER  : in  std_logic_vector( 4 downto 0);
			SAXIACPARVALID : in  std_logic;

			SAXIACPRDATA   : out std_logic_vector(63 downto 0);
			SAXIACPRID     : out std_logic_vector( 2 downto 0);
			SAXIACPRLAST   : out std_logic;
			SAXIACPRRESP   : out std_logic_vector( 1 downto 0);
			SAXIACPRVALID  : out std_logic;
			SAXIACPRREADY  : in  std_logic

		);
	end component;

	component simple_slave_axi3 is
		generic (
			C_S_AXI_DATA_WIDTH : integer := 32;
			C_S_AXI_ADDR_WIDTH : integer := 32;
			C_S_AXI_ID_WIDTH   : integer := 12;
			C_S_AXI_SIZE_WIDTH : integer := 2
		);
		port (

			sw  : in  std_logic_vector(3 downto 0);
			btn : in  std_logic_vector(3 downto 0);
			led : out std_logic_vector(3 downto 0);

			S_AXI_ACLK    : in  std_logic;
			S_AXI_ARESETN : in  std_logic;

			S_AXI_AWVALID : in  std_logic;
			S_AXI_AWREADY : out std_logic;
			S_AXI_AWID    : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
			S_AXI_AWLEN   : in  std_logic_vector(3 downto 0);
			S_AXI_AWSIZE  : in  std_logic_vector(C_S_AXI_SIZE_WIDTH-1 downto 0);
			S_AXI_AWBURST : in  std_logic_vector(1 downto 0);
			S_AXI_AWLOCK  : in  std_logic_vector(1 downto 0);
			S_AXI_AWCACHE : in  std_logic_vector(3 downto 0);
			S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);
			S_AXI_AWQOS   : in  std_logic_vector(3 downto 0);

			S_AXI_WVALID  : in  std_logic;
			S_AXI_WREADY  : out std_logic;
			S_AXI_WID     : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
			S_AXI_WSTRB   : in  std_logic_vector(C_S_AXI_DATA_WIDTH/8-1 downto 0);
			S_AXI_WLAST   : in  std_logic;

			S_AXI_BVALID  : out std_logic;
			S_AXI_BREADY  : in  std_logic;
			S_AXI_BID     : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_BRESP   : out std_logic_vector(1 downto 0);

			S_AXI_ARVALID : in  std_logic;
			S_AXI_ARREADY : out std_logic;
			S_AXI_ARID    : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
			S_AXI_ARLEN   : in  std_logic_vector(3 downto 0);
			S_AXI_ARSIZE  : in  std_logic_vector(C_S_AXI_SIZE_WIDTH-1 downto 0);
			S_AXI_ARBURST : in  std_logic_vector(1 downto 0);
			S_AXI_ARLOCK  : in  std_logic_vector(1 downto 0);
			S_AXI_ARCACHE : in  std_logic_vector(3 downto 0);
			S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);
			S_AXI_ARQOS   : in  std_logic_vector(3 downto 0);

			S_AXI_RVALID  : out std_logic;
			S_AXI_RREADY  : in  std_logic;
			S_AXI_RID     : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
			S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
			S_AXI_RLAST   : out std_logic;
			S_AXI_RRESP   : out std_logic_vector(1 downto 0)

		);
	end component;

begin

	-- AXI clocks are driven by the external clock
	--GP_AXI_ACLK <= gclk;

	-- AXI clocks are driven by FCLK0
	GP_AXI_ACLK <= FCLKCLK(0);

	-- Reset from FCLKRESETN0, with double buffering
	process(GP_AXI_ACLK)
	begin
		if rising_edge(GP_AXI_ACLK) then
			local_resetn_buf1 <= FCLKRESETN(0);
			local_resetn_buf2 <= local_resetn_buf1;
		end if;
	end process;
	GP_AXI_ARESETN <= local_resetn_buf2;

	-- Indicate to the PS7 that the FPGA design is active on AXI ports
	FPGAIDLEN <= '1';

	PS7_inst : PS7
		port map (

			-- PS system clock and reset

			PSCLK   => open, -- inout std_logic  -- System reference clock
			PSPORB  => open, -- inout std_logic  -- Power-On reset, active low
			PSSRSTB => open, -- inout std_logic  -- System reset, active low

			-- PS DDR ports

			DDRCKN   => open, -- inout std_logic
			DDRCKP   => open, -- inout std_logic
			DDRCKE   => open, -- inout std_logic
			DDRCSB   => open, -- inout std_logic
			DDRRASB  => open, -- inout std_logic
			DDRCASB  => open, -- inout std_logic
			DDRWEB   => open, -- inout std_logic
			DDRBA    => open, -- inout std_logic_vector( 2 downto 0)
			DDRA     => open, -- inout std_logic_vector(14 downto 0)
			DDRODT   => open, -- inout std_logic
			DDRDRSTB => open, -- inout std_logic
			DDRDQ    => open, -- inout std_logic_vector(31 downto 0)
			DDRDM    => open, -- inout std_logic_vector( 3 downto 0)
			DDRDQSN  => open, -- inout std_logic_vector( 3 downto 0)
			DDRDQSP  => open, -- inout std_logic_vector( 3 downto 0)

			DDRVRN   => open, -- inout std_logic
			DDRVRP   => open, -- inout std_logic

			-- PS Multiplexed I/O ports

			MIO => open, -- inout std_logic_vector(53 downto 0)

			-- PS-PL Extended Multiplexed I/O signals

			EMIOCAN0PHYTX => open,            -- out std_logic
			EMIOCAN0PHYRX => '0',             -- in  std_logic

			EMIOCAN1PHYTX => open,            -- out std_logic
			EMIOCAN1PHYRX => '0',             -- in  std_logic

			EMIOENET0GMIITXD         => open,            -- out std_logic_vector(7 downto 0)
			EMIOENET0GMIITXEN        => open,            -- out std_logic
			EMIOENET0GMIITXER        => open,            -- out std_logic
			EMIOENET0MDIOMDC         => open,            -- out std_logic
			EMIOENET0MDIOO           => open,            -- out std_logic
			EMIOENET0MDIOTN          => open,            -- out std_logic
			EMIOENET0PTPDELAYREQRX   => open,            -- out std_logic
			EMIOENET0PTPDELAYREQTX   => open,            -- out std_logic
			EMIOENET0PTPPDELAYREQRX  => open,            -- out std_logic
			EMIOENET0PTPPDELAYREQTX  => open,            -- out std_logic
			EMIOENET0PTPPDELAYRESPRX => open,            -- out std_logic
			EMIOENET0PTPPDELAYRESPTX => open,            -- out std_logic
			EMIOENET0PTPSYNCFRAMERX  => open,            -- out std_logic
			EMIOENET0PTPSYNCFRAMETX  => open,            -- out std_logic
			EMIOENET0SOFRX           => open,            -- out std_logic
			EMIOENET0SOFTX           => open,            -- out std_logic
			EMIOENET0EXTINTIN        => '0',             -- in  std_logic
			EMIOENET0GMIICOL         => '0',             -- in  std_logic
			EMIOENET0GMIICRS         => '0',             -- in  std_logic
			EMIOENET0GMIIRXCLK       => '0',             -- in  std_logic
			EMIOENET0GMIIRXD         => (others => '0'), -- in  std_logic_vector(7 downto 0)
			EMIOENET0GMIIRXDV        => '0',             -- in  std_logic
			EMIOENET0GMIIRXER        => '0',             -- in  std_logic
			EMIOENET0GMIITXCLK       => '0',             -- in  std_logic
			EMIOENET0MDIOI           => '0',             -- in  std_logic

			EMIOENET1GMIITXD         => open,            -- out std_logic_vector(7 downto 0)
			EMIOENET1GMIITXEN        => open,            -- out std_logic
			EMIOENET1GMIITXER        => open,            -- out std_logic
			EMIOENET1MDIOMDC         => open,            -- out std_logic
			EMIOENET1MDIOO           => open,            -- out std_logic
			EMIOENET1MDIOTN          => open,            -- out std_logic
			EMIOENET1PTPDELAYREQRX   => open,            -- out std_logic
			EMIOENET1PTPDELAYREQTX   => open,            -- out std_logic
			EMIOENET1PTPPDELAYREQRX  => open,            -- out std_logic
			EMIOENET1PTPPDELAYREQTX  => open,            -- out std_logic
			EMIOENET1PTPPDELAYRESPRX => open,            -- out std_logic
			EMIOENET1PTPPDELAYRESPTX => open,            -- out std_logic
			EMIOENET1PTPSYNCFRAMERX  => open,            -- out std_logic
			EMIOENET1PTPSYNCFRAMETX  => open,            -- out std_logic
			EMIOENET1SOFRX           => open,            -- out std_logic
			EMIOENET1SOFTX           => open,            -- out std_logic
			EMIOENET1EXTINTIN        => '0',             -- in  std_logic
			EMIOENET1GMIICOL         => '0',             -- in  std_logic
			EMIOENET1GMIICRS         => '0',             -- in  std_logic
			EMIOENET1GMIIRXCLK       => '0',             -- in  std_logic
			EMIOENET1GMIIRXD         => (others => '0'), -- in  std_logic_vector(7 downto 0)
			EMIOENET1GMIIRXDV        => '0',             -- in  std_logic
			EMIOENET1GMIIRXER        => '0',             -- in  std_logic
			EMIOENET1GMIITXCLK       => '0',             -- in  std_logic
			EMIOENET1MDIOI           => '0',             -- in  std_logic

			EMIOGPIOO  => open,            -- out std_logic_vector(63 downto 0)
			EMIOGPIOTN => open,            -- out std_logic_vector(63 downto 0)
			EMIOGPIOI  => (others => '0'), -- in  std_logic_vector(63 downto 0)

			EMIOI2C0SCLO  => open,            -- out std_logic
			EMIOI2C0SCLTN => open,            -- out std_logic
			EMIOI2C0SDAO  => open,            -- out std_logic
			EMIOI2C0SDATN => open,            -- out std_logic
			EMIOI2C0SCLI  => '0',             -- in  std_logic
			EMIOI2C0SDAI  => '0',             -- in  std_logic

			EMIOI2C1SCLO  => open,            -- out std_logic
			EMIOI2C1SCLTN => open,            -- out std_logic
			EMIOI2C1SDAO  => open,            -- out std_logic
			EMIOI2C1SDATN => open,            -- out std_logic
			EMIOI2C1SCLI  => '0',             -- in  std_logic
			EMIOI2C1SDAI  => '0',             -- in  std_logic

			EMIOPJTAGTDO  => open,            -- out std_logic
			EMIOPJTAGTDTN => open,            -- out std_logic
			EMIOPJTAGTCK  => '0',             -- in  std_logic
			EMIOPJTAGTDI  => '0',             -- in  std_logic
			EMIOPJTAGTMS  => '0',             -- in  std_logic

			EMIOSDIO0BUSPOW  => open,            -- out std_logic
			EMIOSDIO0BUSVOLT => open,            -- out std_logic_vector(2 downto 0)
			EMIOSDIO0CLK     => open,            -- out std_logic
			EMIOSDIO0CMDO    => open,            -- out std_logic
			EMIOSDIO0CMDTN   => open,            -- out std_logic
			EMIOSDIO0DATAO   => open,            -- out std_logic_vector(3 downto 0)
			EMIOSDIO0DATATN  => open,            -- out std_logic_vector(3 downto 0)
			EMIOSDIO0LED     => open,            -- out std_logic
			EMIOSDIO0CDN     => '0',             -- in  std_logic
			EMIOSDIO0CLKFB   => '0',             -- in  std_logic
			EMIOSDIO0CMDI    => '0',             -- in  std_logic
			EMIOSDIO0DATAI   => (others => '0'), -- in  std_logic_vector(3 downto 0)
			EMIOSDIO0WP      => '0',             -- in  std_logic

			EMIOSDIO1BUSPOW  => open,            -- out std_logic
			EMIOSDIO1BUSVOLT => open,            -- out std_logic_vector(2 downto 0)
			EMIOSDIO1CLK     => open,            -- out std_logic
			EMIOSDIO1CMDO    => open,            -- out std_logic
			EMIOSDIO1CMDTN   => open,            -- out std_logic
			EMIOSDIO1DATAO   => open,            -- out std_logic_vector(3 downto 0)
			EMIOSDIO1DATATN  => open,            -- out std_logic_vector(3 downto 0)
			EMIOSDIO1LED     => open,            -- out std_logic
			EMIOSDIO1CDN     => '0',             -- in  std_logic
			EMIOSDIO1CLKFB   => '0',             -- in  std_logic
			EMIOSDIO1CMDI    => '0',             -- in  std_logic
			EMIOSDIO1DATAI   => (others => '0'), -- in  std_logic_vector(3 downto 0)
			EMIOSDIO1WP      => '0',             -- in  std_logic

			EMIOSPI0MO     => open,            -- out std_logic
			EMIOSPI0MOTN   => open,            -- out std_logic
			EMIOSPI0SCLKO  => open,            -- out std_logic
			EMIOSPI0SCLKTN => open,            -- out std_logic
			EMIOSPI0SO     => open,            -- out std_logic
			EMIOSPI0SSNTN  => open,            -- out std_logic
			EMIOSPI0SSON   => open,            -- out std_logic_vector(2 downto 0)
			EMIOSPI0STN    => open,            -- out std_logic
			EMIOSPI0MI     => '0',             -- in  std_logic
			EMIOSPI0SCLKI  => '0',             -- in  std_logic
			EMIOSPI0SI     => '0',             -- in  std_logic
			EMIOSPI0SSIN   => '0',             -- in  std_logic

			EMIOSPI1MO     => open,            -- out std_logic
			EMIOSPI1MOTN   => open,            -- out std_logic
			EMIOSPI1SCLKO  => open,            -- out std_logic
			EMIOSPI1SCLKTN => open,            -- out std_logic
			EMIOSPI1SO     => open,            -- out std_logic
			EMIOSPI1SSNTN  => open,            -- out std_logic
			EMIOSPI1SSON   => open,            -- out std_logic_vector(2 downto 0)
			EMIOSPI1STN    => open,            -- out std_logic
			EMIOSPI1MI     => '0',             -- in  std_logic
			EMIOSPI1SCLKI  => '0',             -- in  std_logic
			EMIOSPI1SI     => '0',             -- in  std_logic
			EMIOSPI1SSIN   => '0',             -- in  std_logic

			EMIOTRACECTL  => open,            -- out std_logic
			EMIOTRACEDATA => open,            -- out std_logic_vector(31 downto 0)
			EMIOTRACECLK  => '0',             -- in  std_logic

			EMIOTTC0WAVEO => open,            -- out std_logic_vector(2 downto 0)
			EMIOTTC1WAVEO => open,            -- out std_logic_vector(2 downto 0)
			EMIOTTC0CLKI  => (others => '0'), -- in  std_logic_vector(2 downto 0)
			EMIOTTC1CLKI  => (others => '0'), -- in  std_logic_vector(2 downto 0)

			EMIOUART0DTRN => open,            -- out std_logic
			EMIOUART0RTSN => open,            -- out std_logic
			EMIOUART0TX   => open,            -- out std_logic
			EMIOUART0CTSN => '0',             -- in  std_logic
			EMIOUART0DCDN => '0',             -- in  std_logic
			EMIOUART0DSRN => '0',             -- in  std_logic
			EMIOUART0RIN  => '0',             -- in  std_logic
			EMIOUART0RX   => '0',             -- in  std_logic

			EMIOUART1DTRN => open,            -- out std_logic
			EMIOUART1RTSN => open,            -- out std_logic
			EMIOUART1TX   => open,            -- out std_logic
			EMIOUART1CTSN => '0',             -- in  std_logic
			EMIOUART1DCDN => '0',             -- in  std_logic
			EMIOUART1DSRN => '0',             -- in  std_logic
			EMIOUART1RIN  => '0',             -- in  std_logic
			EMIOUART1RX   => '0',             -- in  std_logic

			EMIOUSB0PORTINDCTL    => open,            -- out std_logic_vector(1 downto 0)
			EMIOUSB0VBUSPWRSELECT => open,            -- out std_logic
			EMIOUSB0VBUSPWRFAULT  => '0',             -- in  std_logic

			EMIOUSB1PORTINDCTL    => open,            -- out std_logic_vector(1 downto 0)
			EMIOUSB1VBUSPWRSELECT => open,            -- out std_logic
			EMIOUSB1VBUSPWRFAULT  => '0',             -- in  std_logic

			EMIOWDTCLKI => '0',             -- in  std_logic
			EMIOWDTRSTO => open,            -- out std_logic

			EMIOSRAMINTIN => '0',             -- in std_logic

			-- PS-PL Event signals

			EVENTEVENTO => open,            -- out std_logic
			EVENTEVENTI => '0',             -- in  std_logic

			EVENTSTANDBYWFE => open,            -- out std_logic_vector(1 downto 0)
			EVENTSTANDBYWFI => open,            -- out std_logic_vector(1 downto 0)

			-- PS-PL Clocks and resets

			FCLKCLK      => FCLKCLK,         -- out std_logic_vector(3 downto 0)
			FCLKRESETN   => FCLKRESETN,      -- out std_logic_vector(3 downto 0)
			FCLKCLKTRIGN => (others => '0'), -- in  std_logic_vector(3 downto 0)

			-- PS-PL Fabric Trace Monitor and Debug - Trace

			FTMDTRACEINCLOCK => '0',             -- in  std_logic
			FTMDTRACEINATID  => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			FTMDTRACEINDATA  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			FTMDTRACEINVALID => '0',             -- in  std_logic

			-- PS-PL Fabric Trace Monitor and Debug - Triggers

			FTMTF2PTRIG      => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			FTMTF2PDEBUG     => (others => '0'), -- in  std_logic_vector(31 downto 0)
			FTMTF2PTRIGACK   => open,            -- out std_logic_vector( 3 downto 0)

			FTMTP2FTRIG      => open,            -- out std_logic_vector( 3 downto 0)
			FTMTP2FDEBUG     => open,            -- out std_logic_vector(31 downto 0)
			FTMTP2FTRIGACK   => (others => '0'), -- in  std_logic_vector( 3 downto 0)

			-- PS-PL DDR urgent/arbitration

			DDRARB => (others => '0'), -- in  std_logic_vector(3 downto 0)

			-- PS-PL AXI Idle, active low

			FPGAIDLEN => FPGAIDLEN, -- in std_logic

			-- PS-PL DMA controller

			DMA0ACLK    => '0',             -- in  std_logic
			DMA0RSTN    => open,            -- out std_logic
			DMA0DATYPE  => open,            -- out std_logic_vector(1 downto 0)
			DMA0DRREADY => open,            -- out std_logic
			DMA0DRLAST  => '0',             -- in  std_logic
			DMA0DRTYPE  => (others => '0'), -- in  std_logic_vector(1 downto 0)
			DMA0DRVALID => '0',             -- in  std_logic
			DMA0DAVALID => open,            -- out std_logic
			DMA0DAREADY => '0',             -- in  std_logic

			DMA1ACLK    => '0',             -- in  std_logic
			DMA1RSTN    => open,            -- out std_logic
			DMA1DATYPE  => open,            -- out std_logic_vector(1 downto 0)
			DMA1DRREADY => open,            -- out std_logic
			DMA1DRLAST  => '0',             -- in  std_logic
			DMA1DRTYPE  => (others => '0'), -- in  std_logic_vector(1 downto 0)
			DMA1DRVALID => '0',             -- in  std_logic
			DMA1DAVALID => open,            -- out std_logic
			DMA1DAREADY => '0',             -- in  std_logic

			DMA2ACLK    => '0',             -- in  std_logic
			DMA2RSTN    => open,            -- out std_logic
			DMA2DATYPE  => open,            -- out std_logic_vector(1 downto 0)
			DMA2DRREADY => open,            -- out std_logic
			DMA2DRLAST  => '0',             -- in  std_logic
			DMA2DRTYPE  => (others => '0'), -- in  std_logic_vector(1 downto 0)
			DMA2DRVALID => '0',             -- in  std_logic
			DMA2DAVALID => open,            -- out std_logic
			DMA2DAREADY => '0',             -- in  std_logic

			DMA3ACLK    => '0',             -- in  std_logic
			DMA3RSTN    => open,            -- out std_logic
			DMA3DATYPE  => open,            -- out std_logic_vector(1 downto 0)
			DMA3DRREADY => open,            -- out std_logic
			DMA3DRLAST  => '0',             -- in  std_logic
			DMA3DRTYPE  => (others => '0'), -- in  std_logic_vector(1 downto 0)
			DMA3DRVALID => '0',             -- in  std_logic
			DMA3DAVALID => open,            -- out std_logic
			DMA3DAREADY => '0',             -- in  std_logic

			-- PS-PL Interrupt signals

			IRQP2F => open,            -- out std_logic_vector(28 downto 0)
			IRQF2P => (others => '0'), -- in  std_logic_vector(19 downto 0)

			-- Master AXI General Purpose GP0

			MAXIGP0ACLK    => GP_AXI_ACLK,     -- in  std_logic
			MAXIGP0ARESETN => open,            -- out std_logic

			MAXIGP0AWADDR  => GP_AXI_AWADDR,   -- out std_logic_vector(31 downto 0)
			MAXIGP0AWBURST => GP_AXI_AWBURST,  -- out std_logic_vector( 1 downto 0)
			MAXIGP0AWCACHE => GP_AXI_AWCACHE,  -- out std_logic_vector( 3 downto 0)
			MAXIGP0AWID    => GP_AXI_AWID,     -- out std_logic_vector(11 downto 0)
			MAXIGP0AWLEN   => GP_AXI_AWLEN,    -- out std_logic_vector( 3 downto 0)
			MAXIGP0AWLOCK  => GP_AXI_AWLOCK,   -- out std_logic_vector( 1 downto 0)
			MAXIGP0AWPROT  => GP_AXI_AWPROT,   -- out std_logic_vector( 2 downto 0)
			MAXIGP0AWQOS   => GP_AXI_AWQOS,    -- out std_logic_vector( 3 downto 0)
			MAXIGP0AWSIZE  => GP_AXI_AWSIZE,   -- out std_logic_vector( 1 downto 0)
			MAXIGP0AWVALID => GP_AXI_AWVALID,  -- out std_logic
			MAXIGP0AWREADY => GP_AXI_AWREADY,  -- in  std_logic

			MAXIGP0WDATA   => GP_AXI_WDATA,    -- out std_logic_vector(31 downto 0)
			MAXIGP0WID     => GP_AXI_WID,      -- out std_logic_vector(11 downto 0)
			MAXIGP0WLAST   => GP_AXI_WLAST,    -- out std_logic
			MAXIGP0WSTRB   => GP_AXI_WSTRB,    -- out std_logic_vector( 3 downto 0)
			MAXIGP0WVALID  => GP_AXI_WVALID,   -- out std_logic
			MAXIGP0WREADY  => GP_AXI_WREADY,   -- in  std_logic

			MAXIGP0BREADY  => GP_AXI_BREADY,   -- out std_logic
			MAXIGP0BID     => GP_AXI_BID,      -- in  std_logic_vector(11 downto 0)
			MAXIGP0BRESP   => GP_AXI_BRESP,    -- in  std_logic_vector( 1 downto 0)
			MAXIGP0BVALID  => GP_AXI_BVALID,   -- in  std_logic

			MAXIGP0ARADDR  => GP_AXI_ARADDR,   -- out std_logic_vector(31 downto 0)
			MAXIGP0ARBURST => GP_AXI_ARBURST,  -- out std_logic_vector( 1 downto 0)
			MAXIGP0ARCACHE => GP_AXI_ARCACHE,  -- out std_logic_vector( 3 downto 0)
			MAXIGP0ARID    => GP_AXI_ARID,     -- out std_logic_vector(11 downto 0)
			MAXIGP0ARLEN   => GP_AXI_ARLEN,    -- out std_logic_vector( 3 downto 0)
			MAXIGP0ARLOCK  => GP_AXI_ARLOCK,   -- out std_logic_vector( 1 downto 0)
			MAXIGP0ARPROT  => GP_AXI_ARPROT,   -- out std_logic_vector( 2 downto 0)
			MAXIGP0ARQOS   => GP_AXI_ARQOS,    -- out std_logic_vector( 3 downto 0)
			MAXIGP0ARSIZE  => GP_AXI_ARSIZE,   -- out std_logic_vector( 1 downto 0)
			MAXIGP0ARVALID => GP_AXI_ARVALID,  -- out std_logic
			MAXIGP0ARREADY => GP_AXI_ARREADY,  -- in  std_logic

			MAXIGP0RREADY  => GP_AXI_RREADY,   -- out std_logic
			MAXIGP0RDATA   => GP_AXI_RDATA,    -- in  std_logic_vector(31 downto 0)
			MAXIGP0RID     => GP_AXI_RID,      -- in  std_logic_vector(11 downto 0)
			MAXIGP0RLAST   => GP_AXI_RLAST,    -- in  std_logic
			MAXIGP0RRESP   => GP_AXI_RRESP,    -- in  std_logic_vector( 1 downto 0)
			MAXIGP0RVALID  => GP_AXI_RVALID,   -- in  std_logic

			-- Master AXI General Purpose GP1

			MAXIGP1ACLK    => '0',             -- in  std_logic
			MAXIGP1ARESETN => open,            -- out std_logic

			MAXIGP1AWADDR  => open,            -- out std_logic_vector(31 downto 0)
			MAXIGP1AWBURST => open,            -- out std_logic_vector( 1 downto 0)
			MAXIGP1AWCACHE => open,            -- out std_logic_vector( 3 downto 0)
			MAXIGP1AWID    => open,            -- out std_logic_vector(11 downto 0)
			MAXIGP1AWLEN   => open,            -- out std_logic_vector( 3 downto 0)
			MAXIGP1AWLOCK  => open,            -- out std_logic_vector( 1 downto 0)
			MAXIGP1AWPROT  => open,            -- out std_logic_vector( 2 downto 0)
			MAXIGP1AWQOS   => open,            -- out std_logic_vector( 3 downto 0)
			MAXIGP1AWSIZE  => open,            -- out std_logic_vector( 1 downto 0)
			MAXIGP1AWVALID => open,            -- out std_logic
			MAXIGP1AWREADY => '0',             -- in  std_logic

			MAXIGP1WDATA   => open,            -- out std_logic_vector(31 downto 0)
			MAXIGP1WID     => open,            -- out std_logic_vector(11 downto 0)
			MAXIGP1WLAST   => open,            -- out std_logic
			MAXIGP1WSTRB   => open,            -- out std_logic_vector( 3 downto 0)
			MAXIGP1WVALID  => open,            -- out std_logic
			MAXIGP1WREADY  => '0',             -- in  std_logic

			MAXIGP1BREADY  => open,            -- out std_logic
			MAXIGP1BID     => (others => '0'), -- in  std_logic_vector(11 downto 0)
			MAXIGP1BRESP   => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			MAXIGP1BVALID  => '0',             -- in  std_logic

			MAXIGP1ARADDR  => open,            -- out std_logic_vector(31 downto 0)
			MAXIGP1ARBURST => open,            -- out std_logic_vector( 1 downto 0)
			MAXIGP1ARCACHE => open,            -- out std_logic_vector( 3 downto 0)
			MAXIGP1ARID    => open,            -- out std_logic_vector(11 downto 0)
			MAXIGP1ARLEN   => open,            -- out std_logic_vector( 3 downto 0)
			MAXIGP1ARLOCK  => open,            -- out std_logic_vector( 1 downto 0)
			MAXIGP1ARPROT  => open,            -- out std_logic_vector( 2 downto 0)
			MAXIGP1ARQOS   => open,            -- out std_logic_vector( 3 downto 0)
			MAXIGP1ARSIZE  => open,            -- out std_logic_vector( 1 downto 0)
			MAXIGP1ARVALID => open,            -- out std_logic
			MAXIGP1ARREADY => '0',             -- in  std_logic

			MAXIGP1RREADY  => open,            -- out std_logic
			MAXIGP1RDATA   => (others => '0'), -- in  std_logic_vector(31 downto 0)
			MAXIGP1RID     => (others => '0'), -- in  std_logic_vector(11 downto 0)
			MAXIGP1RLAST   => '0',             -- in  std_logic
			MAXIGP1RRESP   => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			MAXIGP1RVALID  => '0',             -- in  std_logic

			-- Slave AXI General Purpose GP0

			SAXIGP0ACLK    => '0',             -- in  std_logic
			SAXIGP0ARESETN => open,            -- out std_logic

			SAXIGP0AWADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIGP0AWBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP0AWCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP0AWID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIGP0AWLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP0AWLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP0AWPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIGP0AWQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP0AWSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP0AWVALID => '0',             -- in  std_logic
			SAXIGP0AWREADY => open,            -- out std_logic

			SAXIGP0WDATA   => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIGP0WID     => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIGP0WLAST   => '0',             -- in  std_logic
			SAXIGP0WSTRB   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP0WVALID  => '0',             -- in  std_logic
			SAXIGP0WREADY  => open,            -- out std_logic

			SAXIGP0BREADY  => '0',             -- in  std_logic
			SAXIGP0BID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIGP0BRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIGP0BVALID  => open,            -- out std_logic

			SAXIGP0ARADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIGP0ARBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP0ARCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP0ARID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIGP0ARLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP0ARLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP0ARPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIGP0ARQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP0ARSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP0ARVALID => '0',             -- in  std_logic
			SAXIGP0ARREADY => open,            -- out std_logic

			SAXIGP0RREADY  => '0',             -- in  std_logic
			SAXIGP0RDATA   => open,            -- out std_logic_vector(31 downto 0)
			SAXIGP0RID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIGP0RLAST   => open,            -- out std_logic
			SAXIGP0RRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIGP0RVALID  => open,            -- out std_logic

			-- Slave AXI General Purpose GP1

			SAXIGP1ACLK    => '0',             -- in  std_logic
			SAXIGP1ARESETN => open,            -- out std_logic

			SAXIGP1AWADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIGP1AWBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP1AWCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP1AWID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIGP1AWLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP1AWLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP1AWPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIGP1AWQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP1AWSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP1AWVALID => '0',             -- in  std_logic
			SAXIGP1AWREADY => open,            -- out std_logic

			SAXIGP1WDATA   => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIGP1WID     => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIGP1WLAST   => '0',             -- in  std_logic
			SAXIGP1WSTRB   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP1WVALID  => '0',             -- in  std_logic
			SAXIGP1WREADY  => open,            -- out std_logic

			SAXIGP1BREADY  => '0',             -- in  std_logic
			SAXIGP1BID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIGP1BRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIGP1BVALID  => open,            -- out std_logic

			SAXIGP1ARADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIGP1ARBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP1ARCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP1ARID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIGP1ARLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP1ARLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP1ARPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIGP1ARQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIGP1ARSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIGP1ARVALID => '0',             -- in  std_logic
			SAXIGP1ARREADY => open,            -- out std_logic

			SAXIGP1RREADY  => '0',             -- in  std_logic
			SAXIGP1RDATA   => open,            -- out std_logic_vector(31 downto 0)
			SAXIGP1RID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIGP1RLAST   => open,            -- out std_logic
			SAXIGP1RRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIGP1RVALID  => open,            -- out std_logic

			-- Slave AXI High Performance HP0

			SAXIHP0ACLK    => '0',             -- in  std_logic
			SAXIHP0ARESETN => open,            -- out std_logic

			SAXIHP0AWADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIHP0AWBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP0AWCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP0AWID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP0AWLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP0AWLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP0AWPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIHP0AWQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP0AWSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP0AWVALID => '0',             -- in  std_logic
			SAXIHP0AWREADY => open,            -- out std_logic

			SAXIHP0WDATA   => (others => '0'), -- in  std_logic_vector(63 downto 0)
			SAXIHP0WID     => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP0WLAST   => '0',             -- in  std_logic
			SAXIHP0WSTRB   => (others => '0'), -- in  std_logic_vector( 7 downto 0)
			SAXIHP0WVALID  => '0',             -- in  std_logic
			SAXIHP0WREADY  => open,            -- out std_logic

			SAXIHP0BREADY  => '0',             -- in  std_logic
			SAXIHP0BID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP0BRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIHP0BVALID  => open,            -- out std_logic

			SAXIHP0ARADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIHP0ARBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP0ARCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP0ARID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP0ARLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP0ARLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP0ARPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIHP0ARQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP0ARSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP0ARVALID => '0',             -- in  std_logic
			SAXIHP0ARREADY => open,            -- out std_logic

			SAXIHP0RREADY  => '0',             -- in  std_logic
			SAXIHP0RDATA   => open,            -- out std_logic_vector(63 downto 0)
			SAXIHP0RID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP0RLAST   => open,            -- out std_logic
			SAXIHP0RRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIHP0RVALID  => open,            -- out std_logic

			SAXIHP0WACOUNT => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP0WCOUNT  => open,            -- out std_logic_vector( 7 downto 0)
			SAXIHP0RACOUNT => open,            -- out std_logic_vector( 2 downto 0)
			SAXIHP0RCOUNT  => open,            -- out std_logic_vector( 7 downto 0)

			SAXIHP0WRISSUECAP1EN => '0', --  in std_logic
			SAXIHP0RDISSUECAP1EN => '0', --  in std_logic

			-- Slave AXI High Performance HP1

			SAXIHP1ACLK    => '0',             -- in  std_logic
			SAXIHP1ARESETN => open,            -- out std_logic

			SAXIHP1AWADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIHP1AWBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP1AWCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP1AWID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP1AWLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP1AWLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP1AWPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIHP1AWQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP1AWSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP1AWVALID => '0',             -- in  std_logic
			SAXIHP1AWREADY => open,            -- out std_logic

			SAXIHP1WDATA   => (others => '0'), -- in  std_logic_vector(63 downto 0)
			SAXIHP1WID     => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP1WLAST   => '0',             -- in  std_logic
			SAXIHP1WSTRB   => (others => '0'), -- in  std_logic_vector( 7 downto 0)
			SAXIHP1WVALID  => '0',             -- in  std_logic
			SAXIHP1WREADY  => open,            -- out std_logic

			SAXIHP1BREADY  => '0',             -- in  std_logic
			SAXIHP1BID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP1BRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIHP1BVALID  => open,            -- out std_logic

			SAXIHP1ARADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIHP1ARBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP1ARCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP1ARID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP1ARLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP1ARLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP1ARPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIHP1ARQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP1ARSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP1ARVALID => '0',             -- in  std_logic
			SAXIHP1ARREADY => open,            -- out std_logic

			SAXIHP1RREADY  => '0',             -- in  std_logic
			SAXIHP1RDATA   => open,            -- out std_logic_vector(63 downto 0)
			SAXIHP1RID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP1RLAST   => open,            -- out std_logic
			SAXIHP1RRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIHP1RVALID  => open,            -- out std_logic

			SAXIHP1WACOUNT => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP1WCOUNT  => open,            -- out std_logic_vector( 7 downto 0)
			SAXIHP1RACOUNT => open,            -- out std_logic_vector( 2 downto 0)
			SAXIHP1RCOUNT  => open,            -- out std_logic_vector( 7 downto 0)

			SAXIHP1WRISSUECAP1EN => '0', --  in std_logic
			SAXIHP1RDISSUECAP1EN => '0', --  in std_logic

			-- Slave AXI High Performance HP2

			SAXIHP2ACLK    => '0',             -- in  std_logic
			SAXIHP2ARESETN => open,            -- out std_logic

			SAXIHP2AWADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIHP2AWBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP2AWCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP2AWID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP2AWLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP2AWLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP2AWPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIHP2AWQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP2AWSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP2AWVALID => '0',             -- in  std_logic
			SAXIHP2AWREADY => open,            -- out std_logic

			SAXIHP2WDATA   => (others => '0'), -- in  std_logic_vector(63 downto 0)
			SAXIHP2WID     => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP2WLAST   => '0',             -- in  std_logic
			SAXIHP2WSTRB   => (others => '0'), -- in  std_logic_vector( 7 downto 0)
			SAXIHP2WVALID  => '0',             -- in  std_logic
			SAXIHP2WREADY  => open,            -- out std_logic

			SAXIHP2BREADY  => '0',             -- in  std_logic
			SAXIHP2BID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP2BRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIHP2BVALID  => open,            -- out std_logic

			SAXIHP2ARADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIHP2ARBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP2ARCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP2ARID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP2ARLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP2ARLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP2ARPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIHP2ARQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP2ARSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP2ARVALID => '0',             -- in  std_logic
			SAXIHP2ARREADY => open,            -- out std_logic

			SAXIHP2RREADY  => '0',             -- in  std_logic
			SAXIHP2RDATA   => open,            -- out std_logic_vector(63 downto 0)
			SAXIHP2RID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP2RLAST   => open,            -- out std_logic
			SAXIHP2RRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIHP2RVALID  => open,            -- out std_logic

			SAXIHP2WACOUNT => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP2WCOUNT  => open,            -- out std_logic_vector( 7 downto 0)
			SAXIHP2RACOUNT => open,            -- out std_logic_vector( 2 downto 0)
			SAXIHP2RCOUNT  => open,            -- out std_logic_vector( 7 downto 0)

			SAXIHP2WRISSUECAP1EN => '0', -- in  std_logic
			SAXIHP2RDISSUECAP1EN => '0', -- in  std_logic

			-- Slave AXI High Performance HP3

			SAXIHP3ACLK    => '0',             -- in  std_logic
			SAXIHP3ARESETN => open,            -- out std_logic

			SAXIHP3AWADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIHP3AWBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP3AWCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP3AWID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP3AWLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP3AWLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP3AWPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIHP3AWQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP3AWSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP3AWVALID => '0',             -- in  std_logic
			SAXIHP3AWREADY => open,            -- out std_logic

			SAXIHP3WDATA   => (others => '0'), -- in  std_logic_vector(63 downto 0)
			SAXIHP3WID     => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP3WLAST   => '0',             -- in  std_logic
			SAXIHP3WSTRB   => (others => '0'), -- in  std_logic_vector( 7 downto 0)
			SAXIHP3WVALID  => '0',             -- in  std_logic
			SAXIHP3WREADY  => open,            -- out std_logic

			SAXIHP3BREADY  => '0',             -- in  std_logic
			SAXIHP3BID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP3BRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIHP3BVALID  => open,            -- out std_logic

			SAXIHP3ARADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIHP3ARBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP3ARCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP3ARID    => (others => '0'), -- in  std_logic_vector( 5 downto 0)
			SAXIHP3ARLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP3ARLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP3ARPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIHP3ARQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIHP3ARSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIHP3ARVALID => '0',             -- in  std_logic
			SAXIHP3ARREADY => open,            -- out std_logic

			SAXIHP3RREADY  => '0',             -- in  std_logic
			SAXIHP3RDATA   => open,            -- out std_logic_vector(63 downto 0)
			SAXIHP3RID     => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP3RLAST   => open,            -- out std_logic
			SAXIHP3RRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIHP3RVALID  => open,            -- out std_logic

			SAXIHP3WACOUNT => open,            -- out std_logic_vector( 5 downto 0)
			SAXIHP3WCOUNT  => open,            -- out std_logic_vector( 7 downto 0)
			SAXIHP3RACOUNT => open,            -- out std_logic_vector( 2 downto 0)
			SAXIHP3RCOUNT  => open,            -- out std_logic_vector( 7 downto 0)

			SAXIHP3WRISSUECAP1EN => '0', -- in  std_logic
			SAXIHP3RDISSUECAP1EN => '0', -- in  std_logic

			-- Slave AXI Accelerator Coherency Port ACP

			SAXIACPACLK    => '0',             -- in  std_logic
			SAXIACPARESETN => open,            -- out std_logic

			SAXIACPAWREADY => open,            -- out std_logic
			SAXIACPAWADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIACPAWBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIACPAWCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIACPAWID    => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIACPAWLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIACPAWLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIACPAWPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIACPAWQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIACPAWSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIACPAWUSER  => (others => '0'), -- in  std_logic_vector( 4 downto 0)
			SAXIACPAWVALID => '0',             -- in  std_logic

			SAXIACPWREADY  => open,            -- out std_logic
			SAXIACPWDATA   => (others => '0'), -- in  std_logic_vector(63 downto 0)
			SAXIACPWID     => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIACPWLAST   => '0',             -- in  std_logic
			SAXIACPWSTRB   => (others => '0'), -- in  std_logic_vector( 7 downto 0)
			SAXIACPWVALID  => '0',             -- in  std_logic

			SAXIACPBID     => open,            -- out std_logic_vector( 2 downto 0)
			SAXIACPBRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIACPBVALID  => open,            -- out std_logic
			SAXIACPBREADY  => '0',             -- in  std_logic

			SAXIACPARREADY => open,            -- out std_logic
			SAXIACPARADDR  => (others => '0'), -- in  std_logic_vector(31 downto 0)
			SAXIACPARBURST => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIACPARCACHE => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIACPARID    => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIACPARLEN   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIACPARLOCK  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIACPARPROT  => (others => '0'), -- in  std_logic_vector( 2 downto 0)
			SAXIACPARQOS   => (others => '0'), -- in  std_logic_vector( 3 downto 0)
			SAXIACPARSIZE  => (others => '0'), -- in  std_logic_vector( 1 downto 0)
			SAXIACPARUSER  => (others => '0'), -- in  std_logic_vector( 4 downto 0)
			SAXIACPARVALID => '0',             -- in  std_logic

			SAXIACPRDATA   => open,            -- out std_logic_vector(63 downto 0)
			SAXIACPRID     => open,            -- out std_logic_vector( 2 downto 0)
			SAXIACPRLAST   => open,            -- out std_logic
			SAXIACPRRESP   => open,            -- out std_logic_vector( 1 downto 0)
			SAXIACPRVALID  => open,            -- out std_logic
			SAXIACPRREADY  => '0'              -- in  std_logic

		);

	user_inst : simple_slave_axi3
		generic map (
			C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
			C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH,
			C_S_AXI_ID_WIDTH   => C_S_AXI_ID_WIDTH,
			C_S_AXI_SIZE_WIDTH => C_S_AXI_SIZE_WIDTH
		)
		port map (

			sw  => sw(3 downto 0),
			btn(3) => btnl,
			btn(2) => btnr,
			btn(1) => btnu,
			btn(0) => btnd,
			led(3 downto 0) => led(3 downto 0),

			S_AXI_ACLK    => GP_AXI_ACLK,
			S_AXI_ARESETN => GP_AXI_ARESETN,

			S_AXI_AWVALID => GP_AXI_AWVALID,
			S_AXI_AWREADY => GP_AXI_AWREADY,
			S_AXI_AWID    => GP_AXI_AWID,
			S_AXI_AWADDR  => GP_AXI_AWADDR,
			S_AXI_AWLEN   => GP_AXI_AWLEN,
			S_AXI_AWSIZE  => GP_AXI_AWSIZE,
			S_AXI_AWBURST => GP_AXI_AWBURST,
			S_AXI_AWLOCK  => GP_AXI_AWLOCK,
			S_AXI_AWCACHE => GP_AXI_AWCACHE,
			S_AXI_AWPROT  => GP_AXI_AWPROT,
			S_AXI_AWQOS   => GP_AXI_AWQOS,

			S_AXI_WVALID  => GP_AXI_WVALID,
			S_AXI_WREADY  => GP_AXI_WREADY,
			S_AXI_WID     => GP_AXI_WID,
			S_AXI_WDATA   => GP_AXI_WDATA,
			S_AXI_WSTRB   => GP_AXI_WSTRB,
			S_AXI_WLAST   => GP_AXI_WLAST,

			S_AXI_BVALID  => GP_AXI_BVALID,
			S_AXI_BREADY  => GP_AXI_BREADY,
			S_AXI_BID     => GP_AXI_BID,
			S_AXI_BRESP   => GP_AXI_BRESP,

			S_AXI_ARVALID => GP_AXI_ARVALID,
			S_AXI_ARREADY => GP_AXI_ARREADY,
			S_AXI_ARID    => GP_AXI_ARID,
			S_AXI_ARADDR  => GP_AXI_ARADDR,
			S_AXI_ARLEN   => GP_AXI_ARLEN,
			S_AXI_ARSIZE  => GP_AXI_ARSIZE,
			S_AXI_ARBURST => GP_AXI_ARBURST,
			S_AXI_ARLOCK  => GP_AXI_ARLOCK,
			S_AXI_ARCACHE => GP_AXI_ARCACHE,
			S_AXI_ARPROT  => GP_AXI_ARPROT,
			S_AXI_ARQOS   => GP_AXI_ARQOS,

			S_AXI_RVALID  => GP_AXI_RVALID,
			S_AXI_RREADY  => GP_AXI_RREADY,
			S_AXI_RID     => GP_AXI_RID,
			S_AXI_RDATA   => GP_AXI_RDATA,
			S_AXI_RLAST   => GP_AXI_RLAST,
			S_AXI_RRESP   => GP_AXI_RRESP

		);

end architecture;


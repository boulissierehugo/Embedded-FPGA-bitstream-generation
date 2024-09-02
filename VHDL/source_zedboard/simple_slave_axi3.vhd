
-- Limitations :
-- - Write Address and Data must be received in-order, with same ID
--   Operations with different IDs result in SLVERR response
-- - No handling for burst transfers : ports AxLEN, AxBURST, AxSIZE are not used
--   Operations with bursts result in SLVERR response
-- - No handling for AxLOCK, AxCACHE, AxPROT, AxQOS
--   Response will still be OKAY
-- - Operations that result in non-OKAY response are still executed in slave registers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_slave_axi3 is
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
end simple_slave_axi3;

architecture synth of simple_slave_axi3 is

	-- Possible responses
	constant AXI_RESP_OKAY   : std_logic_vector(1 downto 0) := "00";
	constant AXI_RESP_EXOKAY : std_logic_vector(1 downto 0) := "01";
	constant AXI_RESP_SLVERR : std_logic_vector(1 downto 0) := "10";
	constant AXI_RESP_DECERR : std_logic_vector(1 downto 0) := "11";

	-- AXI state machine registers
	signal reg_awready : std_logic;
	signal reg_awaddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal reg_bvalid  : std_logic;
	signal reg_bid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
	signal reg_bresp   : std_logic_vector(1 downto 0);
	signal reg_arready : std_logic;
	signal reg_araddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	signal reg_rvalid  : std_logic;
	signal reg_rid     : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
	signal reg_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal reg_rresp   : std_logic_vector(1 downto 0);

	-- Compute the minimum number of bits needed to store the input value
	function storebitsnb(vin : natural) return natural is
		variable r : natural := 1;
		variable v : natural := vin;
	begin
		loop
			exit when v <= 1;
			r := r + 1;
			v := v / 2;
		end loop;
		return r;
	end function;

	-- Selection of address bits to target the slave registers
	constant SLAVE_REGS_NB : natural := 8;
	constant ADDR_LSB  : integer := storebitsnb(C_S_AXI_DATA_WIDTH/8-1);
	constant ADDR_BITS : integer := storebitsnb(SLAVE_REGS_NB-1);

	-- Slave registers
	signal slv_reg0	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg1	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg2	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg3	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg4	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg5	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg6	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
	signal slv_reg7	:std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

	-- Intermediate signals for simple read / write to slave registers
	signal slv_reg_wren 	: std_logic;
	signal slv_reg_wraddr : std_logic_vector(ADDR_BITS-1 downto 0);
	-- Intermediate signals for simple read from slave registers
	signal slv_reg_rden 	: std_logic;
	signal slv_reg_rdaddr : std_logic_vector(ADDR_BITS-1 downto 0);

begin

	-- I/O Connections assignments

	S_AXI_AWREADY <= reg_awready;
	S_AXI_WREADY  <= reg_awready;
	S_AXI_BVALID  <= reg_bvalid;
	S_AXI_BID     <= reg_bid;
	S_AXI_BRESP   <= reg_bresp;
	S_AXI_ARREADY <= reg_arready;
	S_AXI_RVALID  <= reg_rvalid;
	S_AXI_RID     <= reg_rid;
	S_AXI_RDATA   <= reg_rdata;
	S_AXI_RRESP   <= reg_rresp;
	S_AXI_RLAST   <= '1';

	-- Intermediate signals for simple write to slave registers
	slv_reg_wren   <= reg_awready;
	slv_reg_wraddr <= reg_awaddr(ADDR_BITS-1 + ADDR_LSB downto ADDR_LSB);

	-- Intermediate signals for simple read from slave registers
	slv_reg_rden   <= reg_arready and S_AXI_ARVALID;
	slv_reg_rdaddr <= reg_araddr(ADDR_BITS-1 + ADDR_LSB downto ADDR_LSB);

	process (S_AXI_ACLK)
	begin
		if rising_edge(S_AXI_ACLK) then

			-- Generate the Ready signal for both Write Address and Write Data
			-- This is asserted for exactly one clock cycle
			if reg_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and (reg_bvalid = '0' or S_AXI_BREADY = '1') then
				reg_awready <= '1';
			else
				reg_awready <= '0';
			end if;

			-- Write Address latching
			-- Also prepare Write response
			if reg_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' then
				reg_awaddr <= S_AXI_AWADDR;
				reg_bid    <= S_AXI_AWID;
				reg_bresp  <= AXI_RESP_OKAY;
				if unsigned(S_AXI_AWADDR) >= SLAVE_REGS_NB * (C_S_AXI_DATA_WIDTH / 8) then
					reg_bresp <= AXI_RESP_DECERR;
				end if;
				if unsigned(S_AXI_AWLEN) > 0 then
					reg_bresp <= AXI_RESP_SLVERR;
				end if;
				if S_AXI_AWID /= S_AXI_WID then
					reg_bresp <= AXI_RESP_SLVERR;
				end if;
			end if;

			-- Generate the Valid signal for Write Response
			if reg_awready = '1' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and reg_bvalid = '0' then
				-- Present valid response to the master
				reg_bvalid <= '1';
			elsif S_AXI_BREADY = '1' and reg_bvalid = '1' then
				-- Response is accepted by the master
				reg_bvalid <= '0';
			end if;

			-- Generate the Ready signal for Read response
			-- This is asserted for exactly one clock cycle
			if (reg_arready = '0' or S_AXI_ARVALID = '0') and (reg_rvalid = '0' or S_AXI_RREADY = '1') then
				-- Indicates that the slave has accepted the valid read address
				reg_arready <= '1';
				-- Read Address and ID latching
				reg_araddr  <= S_AXI_ARADDR;
				reg_bid     <= S_AXI_ARID;
				-- Also prepare Read response
				reg_rresp   <= AXI_RESP_OKAY;
				if unsigned(S_AXI_ARADDR) >= SLAVE_REGS_NB * (C_S_AXI_DATA_WIDTH / 8) then
					reg_rresp <= AXI_RESP_DECERR;
				end if;
				if unsigned(S_AXI_ARLEN) > 0 then
					reg_rresp <= AXI_RESP_SLVERR;
				end if;
			else
				reg_arready <= '0';
			end if;

			-- Generate the read response
			if slv_reg_rden = '1' and reg_rvalid = '0' then
				-- Present valid read data to the master
				reg_rvalid <= '1';
			elsif reg_rvalid = '1' and S_AXI_RREADY = '1' then
				-- Read data is accepted by the master
				reg_rvalid <= '0';
			end if;

			-- Reset (active low)
			if S_AXI_ARESETN = '0' then
				reg_awready <= '0';
				reg_awaddr  <= (others => '0');
				reg_bvalid  <= '0';
				reg_bresp   <= AXI_RESP_OKAY;
				reg_arready <= '0';
				reg_araddr  <= (others => '0');
				reg_rvalid  <= '0';
				reg_rdata   <= (others => '0');
				reg_rresp   <= AXI_RESP_OKAY;
			end if;

			----------------------------------------------------
			-- Demonstration user functionality
			----------------------------------------------------

			-- Write operation to memory-mapped slave registers
			-- Write strobes are used to select byte enables of slave registers while writing
			if slv_reg_wren = '1' then

				if slv_reg_wraddr = "000" then
					-- Slave register 0
					for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
						if ( S_AXI_WSTRB(byte_index) = '1' ) then
							slv_reg0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
						end if;
					end loop;
				elsif slv_reg_wraddr = "001" then
					-- Slave register 1
					for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
						if ( S_AXI_WSTRB(byte_index) = '1' ) then
							slv_reg1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
						end if;
					end loop;
				elsif slv_reg_wraddr = "010" then
					-- Slave register 2
					for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
						if ( S_AXI_WSTRB(byte_index) = '1' ) then
							slv_reg2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
						end if;
					end loop;
				elsif slv_reg_wraddr = "011" then
					-- Slave register 3
					for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
						if ( S_AXI_WSTRB(byte_index) = '1' ) then
							slv_reg3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
						end if;
					end loop;
				else
					-- Other intentionally un-mapped registers : no action
				end if;

			end if;  -- Write enable

			-- Read operation from memory-mapped slave registers
			if slv_reg_rden = '1' then
				-- Address decoding
				case to_integer(unsigned(slv_reg_rdaddr)) is
					when 0 =>
						reg_rdata <= slv_reg0;
					when 1 =>
						reg_rdata <= slv_reg1;
						reg_rdata(3 downto 0) <= sw;
					when 2 =>
						reg_rdata <= slv_reg2;
					when 3 =>
						reg_rdata <= slv_reg3;
					when 4 =>
						reg_rdata <= slv_reg4;
					when 5 =>
						reg_rdata <= slv_reg5;
					when 6 =>
						reg_rdata <= slv_reg6;
					when 7 =>
						reg_rdata <= slv_reg7;
					when others =>
						reg_rdata <= (others => '0');
				end case;
				
			end if;

			-- Increment reg0 each time it is read
			-- Don't increment when it is written to
			if (slv_reg_rden = '1' and slv_reg_rdaddr = "000") and not(slv_reg_wren = '1' and slv_reg_wraddr = "000") then
				slv_reg0 <= std_logic_vector(unsigned(slv_reg0) + 1);
			end if;

			-- Reset (active low)
			if S_AXI_ARESETN = '0' then
				slv_reg0 <= (others => '0');
				slv_reg1 <= (others => '0');
				slv_reg2 <= (others => '0');
				slv_reg3 <= (others => '0');
				slv_reg4 <= (others => '0');
				slv_reg5 <= (others => '0');
				slv_reg6 <= (others => '0');
				slv_reg7 <= (others => '0');
			end if;

			----------------------------------------------------
			-- End of demonstration user functionality
			----------------------------------------------------

		end if;  -- rising_edge(S_AXI_ACLK)
	end process;

	led <= slv_reg1(3 downto 0);

end architecture;


// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
// Date        : Fri Jun 14 15:46:38 2024
// Host        : woodkid running 64-bit Arch Linux
// Command     : write_verilog
//               /home/prostboa/Projets/projet-cnn-pour-stagiaires-2023/vc709/zybo-nn-ip-wrapper/run/project_2017.2/project_2017.2.srcs/sources_1/bd/design_top/ip/design_top_axi_protocol_converter_0_0/export_netlist/project_design_top_axi_protocol_converter_0_0.v
// Design      : design_top_axi_protocol_converter_0_0
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_top_axi_protocol_converter_0_0,axi_protocol_converter_v2_1_13_axi_protocol_converter,{}" *) (* CORE_GENERATION_INFO = "design_top_axi_protocol_converter_0_0,axi_protocol_converter_v2_1_13_axi_protocol_converter,{x_ipProduct=Vivado 2017.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=axi_protocol_converter,x_ipVersion=2.1,x_ipCoreRevision=13,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_FAMILY=zynq,C_M_AXI_PROTOCOL=2,C_S_AXI_PROTOCOL=1,C_IGNORE_ID=0,C_AXI_ID_WIDTH=12,C_AXI_ADDR_WIDTH=32,C_AXI_DATA_WIDTH=32,C_AXI_SUPPORTS_WRITE=1,C_AXI_SUPPORTS_READ=1,C_AXI_SUPPORTS_USER_SIGNALS=0,C_AXI_AWUSER_WIDTH=1,C_AXI_ARUSER_WIDTH=1,C_AXI_WUSER_WIDTH=1,C_AXI_RUSER_WIDTH=1,C_AXI_BUSER_WIDTH=1,C_TRANSLATION_MODE=0}" *) (* DowngradeIPIdentifiedWarnings = "yes" *)
(* X_CORE_INFO = "axi_protocol_converter_v2_1_13_axi_protocol_converter,Vivado 2017.2" *)
(* STRUCTURAL_NETLIST = "yes" *)
module design_top_axi_protocol_converter_0_0
   (aclk,
    aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awqos,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wid,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arqos,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    m_axi_awaddr,
    m_axi_awprot,
    m_axi_awvalid,
    m_axi_awready,
    m_axi_wdata,
    m_axi_wstrb,
    m_axi_wvalid,
    m_axi_wready,
    m_axi_bresp,
    m_axi_bvalid,
    m_axi_bready,
    m_axi_araddr,
    m_axi_arprot,
    m_axi_arvalid,
    m_axi_arready,
    m_axi_rdata,
    m_axi_rresp,
    m_axi_rvalid,
    m_axi_rready);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK CLK" *) input aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST RST" *) input aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWID" *) input [11:0]s_axi_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *) input [31:0]s_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWLEN" *) input [3:0]s_axi_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWSIZE" *) input [2:0]s_axi_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWBURST" *) input [1:0]s_axi_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWLOCK" *) input [1:0]s_axi_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWCACHE" *) input [3:0]s_axi_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *) input [2:0]s_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWQOS" *) input [3:0]s_axi_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *) input s_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) output s_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WID" *) input [11:0]s_axi_wid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *) input [31:0]s_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *) input [3:0]s_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WLAST" *) input s_axi_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *) input s_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *) output s_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BID" *) output [11:0]s_axi_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *) output [1:0]s_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *) output s_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *) input s_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARID" *) input [11:0]s_axi_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *) input [31:0]s_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARLEN" *) input [3:0]s_axi_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARSIZE" *) input [2:0]s_axi_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARBURST" *) input [1:0]s_axi_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARLOCK" *) input [1:0]s_axi_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARCACHE" *) input [3:0]s_axi_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *) input [2:0]s_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARQOS" *) input [3:0]s_axi_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *) input s_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *) output s_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RID" *) output [11:0]s_axi_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *) output [31:0]s_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *) output [1:0]s_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RLAST" *) output s_axi_rlast ;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *) output s_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *) input s_axi_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWADDR" *) output [31:0]m_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWPROT" *) output [2:0]m_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWVALID" *) output m_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI AWREADY" *) input m_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WDATA" *) output [31:0]m_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WSTRB" *) output [3:0]m_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WVALID" *) output m_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI WREADY" *) input m_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BRESP" *) input [1:0]m_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BVALID" *) input m_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI BREADY" *) output m_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARADDR" *) output [31:0]m_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARPROT" *) output [2:0]m_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARVALID" *) output m_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI ARREADY" *) input m_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RDATA" *) input [31:0]m_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RRESP" *) input [1:0]m_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RVALID" *) input m_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI RREADY" *) output m_axi_rready;

  wire aclk;
  wire aresetn;
  wire [31:0]m_axi_araddr;
  wire m_axi_arready;
  wire m_axi_arvalid;
  wire m_axi_awready;
  wire m_axi_awvalid;
  wire m_axi_bready;
  wire [1:0]m_axi_bresp;
  wire m_axi_bvalid;
  wire [31:0]m_axi_rdata;
  wire m_axi_rready;
  wire [1:0]m_axi_rresp;
  wire m_axi_rvalid;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire [31:0]s_axi_araddr;
  wire [11:0]s_axi_arid;
  wire [2:0]s_axi_arprot;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [11:0]s_axi_awid;
  wire [2:0]s_axi_awprot;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [11:0]s_axi_rid;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire [3:0]s_axi_wstrb;
  wire s_axi_wvalid;

  assign m_axi_arprot[2:0] = s_axi_arprot;
  assign m_axi_awaddr[31:0] = m_axi_araddr;
  assign m_axi_awprot[2:0] = s_axi_awprot;
  assign m_axi_wdata[31:0] = s_axi_wdata;
  assign m_axi_wstrb[3:0] = s_axi_wstrb;
  assign s_axi_bid[11:0] = s_axi_rid;
  assign s_axi_bresp[1:0] = m_axi_bresp;
  assign s_axi_rdata[31:0] = m_axi_rdata;
  assign s_axi_rresp[1:0] = m_axi_rresp;
	assign s_axi_rlast = 1'h1;

  design_top_axi_protocol_converter_0_0axi_protocol_converter_v2_1_13_axi_protocol_converter inst
       (.aclk(aclk),
        .aresetn(aresetn),
        .m_axi_araddr(m_axi_araddr),
        .m_axi_arready(m_axi_arready),
        .m_axi_arvalid(m_axi_arvalid),
        .m_axi_awready(m_axi_awready),
        .m_axi_awvalid(m_axi_awvalid),
        .m_axi_bready(m_axi_bready),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_rready(m_axi_rready),
        .m_axi_rvalid(m_axi_rvalid),
        .m_axi_wready(m_axi_wready),
        .m_axi_wvalid(m_axi_wvalid),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arid(s_axi_arid),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awid(s_axi_awid),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rid(s_axi_rid),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "axi_protocol_converter_v2_1_13_axi_protocol_converter" *)
module design_top_axi_protocol_converter_0_0axi_protocol_converter_v2_1_13_axi_protocol_converter
   (s_axi_rid,
    s_axi_arready,
    s_axi_awready,
    s_axi_wready,
    s_axi_bvalid,
    s_axi_rvalid,
    m_axi_wvalid,
    m_axi_bready,
    m_axi_rready,
    m_axi_arvalid,
    m_axi_araddr,
    m_axi_awvalid,
    m_axi_bvalid,
    s_axi_bready,
    m_axi_rvalid,
    s_axi_rready,
    aclk,
    m_axi_arready,
    s_axi_arvalid,
    m_axi_awready,
    s_axi_awvalid,
    m_axi_wready,
    s_axi_wvalid,
    s_axi_arid,
    s_axi_awid,
    s_axi_araddr,
    s_axi_awaddr,
    aresetn);
  output [11:0]s_axi_rid;
  output s_axi_arready;
  output s_axi_awready;
  output s_axi_wready;
  output s_axi_bvalid;
  output s_axi_rvalid;
  output m_axi_wvalid;
  output m_axi_bready;
  output m_axi_rready;
  output m_axi_arvalid;
  output [31:0]m_axi_araddr;
  output m_axi_awvalid;
  input m_axi_bvalid;
  input s_axi_bready;
  input m_axi_rvalid;
  input s_axi_rready;
  input aclk;
  input m_axi_arready;
  input s_axi_arvalid;
  input m_axi_awready;
  input s_axi_awvalid;
  input m_axi_wready;
  input s_axi_wvalid;
  input [11:0]s_axi_arid;
  input [11:0]s_axi_awid;
  input [31:0]s_axi_araddr;
  input [31:0]s_axi_awaddr;
  input aresetn;

  wire aclk;
  wire aresetn;
  wire [31:0]m_axi_araddr;
  wire m_axi_arready;
  wire m_axi_arvalid;
  wire m_axi_awready;
  wire m_axi_awvalid;
  wire m_axi_bready;
  wire m_axi_bvalid;
  wire m_axi_rready;
  wire m_axi_rvalid;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire [31:0]s_axi_araddr;
  wire [11:0]s_axi_arid;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [11:0]s_axi_awid;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [11:0]s_axi_rid;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire s_axi_wready;
  wire s_axi_wvalid;

  design_top_axi_protocol_converter_0_0axi_protocol_converter_v2_1_13_axilite_conv \gen_axilite.gen_axilite_conv.axilite_conv_inst
       (.aclk(aclk),
        .aresetn(aresetn),
        .m_axi_araddr(m_axi_araddr),
        .m_axi_arready(m_axi_arready),
        .m_axi_arvalid(m_axi_arvalid),
        .m_axi_awready(m_axi_awready),
        .m_axi_awvalid(m_axi_awvalid),
        .m_axi_bready(m_axi_bready),
        .m_axi_bvalid(m_axi_bvalid),
        .m_axi_rready(m_axi_rready),
        .m_axi_rvalid(m_axi_rvalid),
        .m_axi_wready(m_axi_wready),
        .m_axi_wvalid(m_axi_wvalid),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arid(s_axi_arid),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awid(s_axi_awid),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rid(s_axi_rid),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "axi_protocol_converter_v2_1_13_axilite_conv" *)
module design_top_axi_protocol_converter_0_0axi_protocol_converter_v2_1_13_axilite_conv
   (s_axi_rid,
    s_axi_arready,
    s_axi_awready,
    s_axi_wready,
    s_axi_bvalid,
    s_axi_rvalid,
    m_axi_wvalid,
    m_axi_bready,
    m_axi_rready,
    m_axi_arvalid,
    m_axi_araddr,
    m_axi_awvalid,
    m_axi_bvalid,
    s_axi_bready,
    m_axi_rvalid,
    s_axi_rready,
    aclk,
    m_axi_arready,
    s_axi_arvalid,
    m_axi_awready,
    s_axi_awvalid,
    m_axi_wready,
    s_axi_wvalid,
    s_axi_arid,
    s_axi_awid,
    s_axi_araddr,
    s_axi_awaddr,
    aresetn);
  output [11:0]s_axi_rid;
  output s_axi_arready;
  output s_axi_awready;
  output s_axi_wready;
  output s_axi_bvalid;
  output s_axi_rvalid;
  output m_axi_wvalid;
  output m_axi_bready;
  output m_axi_rready;
  output m_axi_arvalid;
  output [31:0]m_axi_araddr;
  output m_axi_awvalid;
  input m_axi_bvalid;
  input s_axi_bready;
  input m_axi_rvalid;
  input s_axi_rready;
  input aclk;
  input m_axi_arready;
  input s_axi_arvalid;
  input m_axi_awready;
  input s_axi_awvalid;
  input m_axi_wready;
  input s_axi_wvalid;
  input [11:0]s_axi_arid;
  input [11:0]s_axi_awid;
  input [31:0]s_axi_araddr;
  input [31:0]s_axi_awaddr;
  input aresetn;

  wire \<const0> ;
  wire \<const1> ;
  wire aclk;
  wire [0:0]areset_d;
  wire \areset_d_reg_n_0_[1] ;
  wire aresetn;
  wire busy;
  wire busy_i_1_n_0;
  wire busy_i_2_n_0;
  wire [31:0]m_axi_araddr;
  wire m_axi_arready;
  wire m_axi_arvalid;
  wire m_axi_awready;
  wire m_axi_awvalid;
  wire m_axi_bready;
  wire m_axi_bvalid;
  wire m_axi_rready;
  wire m_axi_rvalid;
  wire m_axi_wready;
  wire m_axi_wvalid;
  wire [11:0]p_1_in;
  wire [0:0]p_1_out;
  wire read_active;
  wire read_active_i_1_n_0;
  wire read_req1__0;
  wire [31:0]s_axi_araddr;
  wire [11:0]s_axi_arid;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [11:0]s_axi_awid;
  wire s_axi_awready;
  wire s_axi_awready_INST_0_i_1_n_0;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [11:0]s_axi_rid;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire s_axi_wready;
  wire s_axi_wvalid;
  wire \s_axid[11]_i_1_n_0 ;
  wire write_active;
  wire write_active_i_1_n_0;
  wire write_complete__0;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  LUT1 #(
    .INIT(2'h1))
    \areset_d[0]_i_1
       (.I0(aresetn),
        .O(p_1_out));
  FDRE #(
    .INIT(1'b0))
    \areset_d_reg[0]
       (.C(aclk),
        .CE(\<const1> ),
        .D(p_1_out),
        .Q(areset_d),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \areset_d_reg[1]
       (.C(aclk),
        .CE(\<const1> ),
        .D(areset_d),
        .Q(\areset_d_reg_n_0_[1] ),
        .R(\<const0> ));
  LUT6 #(
    .INIT(64'h00000000FFFFAEAA))
    busy_i_1
       (.I0(busy),
        .I1(s_axi_awvalid),
        .I2(s_axi_awready_INST_0_i_1_n_0),
        .I3(m_axi_awready),
        .I4(s_axi_arready),
        .I5(busy_i_2_n_0),
        .O(busy_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFF888))
    busy_i_2
       (.I0(m_axi_bvalid),
        .I1(s_axi_bready),
        .I2(m_axi_rvalid),
        .I3(s_axi_rready),
        .I4(areset_d),
        .I5(\areset_d_reg_n_0_[1] ),
        .O(busy_i_2_n_0));
  FDRE #(
    .INIT(1'b0))
    busy_reg
       (.C(aclk),
        .CE(\<const1> ),
        .D(busy_i_1_n_0),
        .Q(busy),
        .R(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair12" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[0]_INST_0
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_awaddr[0]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[0]));
  (* SOFT_HLUTNM = "soft_lutpair20" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[10]_INST_0
       (.I0(s_axi_araddr[10]),
        .I1(s_axi_awaddr[10]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[10]));
  (* SOFT_HLUTNM = "soft_lutpair19" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[11]_INST_0
       (.I0(s_axi_araddr[11]),
        .I1(s_axi_awaddr[11]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[11]));
  (* SOFT_HLUTNM = "soft_lutpair18" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[12]_INST_0
       (.I0(s_axi_araddr[12]),
        .I1(s_axi_awaddr[12]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[12]));
  (* SOFT_HLUTNM = "soft_lutpair17" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[13]_INST_0
       (.I0(s_axi_araddr[13]),
        .I1(s_axi_awaddr[13]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[13]));
  (* SOFT_HLUTNM = "soft_lutpair14" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[14]_INST_0
       (.I0(s_axi_araddr[14]),
        .I1(s_axi_awaddr[14]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[14]));
  (* SOFT_HLUTNM = "soft_lutpair13" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[15]_INST_0
       (.I0(s_axi_araddr[15]),
        .I1(s_axi_awaddr[15]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[15]));
  (* SOFT_HLUTNM = "soft_lutpair11" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[16]_INST_0
       (.I0(s_axi_araddr[16]),
        .I1(s_axi_awaddr[16]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[16]));
  (* SOFT_HLUTNM = "soft_lutpair10" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[17]_INST_0
       (.I0(s_axi_araddr[17]),
        .I1(s_axi_awaddr[17]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[17]));
  (* SOFT_HLUTNM = "soft_lutpair17" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[18]_INST_0
       (.I0(s_axi_araddr[18]),
        .I1(s_axi_awaddr[18]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[18]));
  (* SOFT_HLUTNM = "soft_lutpair16" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[19]_INST_0
       (.I0(s_axi_araddr[19]),
        .I1(s_axi_awaddr[19]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[19]));
  (* SOFT_HLUTNM = "soft_lutpair19" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[1]_INST_0
       (.I0(s_axi_araddr[1]),
        .I1(s_axi_awaddr[1]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[1]));
  (* SOFT_HLUTNM = "soft_lutpair16" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[20]_INST_0
       (.I0(s_axi_araddr[20]),
        .I1(s_axi_awaddr[20]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[20]));
  (* SOFT_HLUTNM = "soft_lutpair15" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[21]_INST_0
       (.I0(s_axi_araddr[21]),
        .I1(s_axi_awaddr[21]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[21]));
  (* SOFT_HLUTNM = "soft_lutpair15" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[22]_INST_0
       (.I0(s_axi_araddr[22]),
        .I1(s_axi_awaddr[22]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[22]));
  (* SOFT_HLUTNM = "soft_lutpair14" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[23]_INST_0
       (.I0(s_axi_araddr[23]),
        .I1(s_axi_awaddr[23]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[23]));
  (* SOFT_HLUTNM = "soft_lutpair13" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[24]_INST_0
       (.I0(s_axi_araddr[24]),
        .I1(s_axi_awaddr[24]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[24]));
  (* SOFT_HLUTNM = "soft_lutpair12" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[25]_INST_0
       (.I0(s_axi_araddr[25]),
        .I1(s_axi_awaddr[25]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[25]));
  (* SOFT_HLUTNM = "soft_lutpair11" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[26]_INST_0
       (.I0(s_axi_araddr[26]),
        .I1(s_axi_awaddr[26]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[26]));
  (* SOFT_HLUTNM = "soft_lutpair10" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[27]_INST_0
       (.I0(s_axi_araddr[27]),
        .I1(s_axi_awaddr[27]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[27]));
  (* SOFT_HLUTNM = "soft_lutpair7" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[28]_INST_0
       (.I0(s_axi_araddr[28]),
        .I1(s_axi_awaddr[28]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[28]));
  (* SOFT_HLUTNM = "soft_lutpair9" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[29]_INST_0
       (.I0(s_axi_araddr[29]),
        .I1(s_axi_awaddr[29]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[29]));
  (* SOFT_HLUTNM = "soft_lutpair20" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[2]_INST_0
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_awaddr[2]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[2]));
  (* SOFT_HLUTNM = "soft_lutpair9" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[30]_INST_0
       (.I0(s_axi_araddr[30]),
        .I1(s_axi_awaddr[30]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[30]));
  (* SOFT_HLUTNM = "soft_lutpair7" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[31]_INST_0
       (.I0(s_axi_araddr[31]),
        .I1(s_axi_awaddr[31]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[31]));
  (* SOFT_HLUTNM = "soft_lutpair21" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[3]_INST_0
       (.I0(s_axi_araddr[3]),
        .I1(s_axi_awaddr[3]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[3]));
  (* SOFT_HLUTNM = "soft_lutpair23" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[4]_INST_0
       (.I0(s_axi_araddr[4]),
        .I1(s_axi_awaddr[4]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[4]));
  (* SOFT_HLUTNM = "soft_lutpair23" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[5]_INST_0
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_awaddr[5]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[5]));
  (* SOFT_HLUTNM = "soft_lutpair22" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[6]_INST_0
       (.I0(s_axi_araddr[6]),
        .I1(s_axi_awaddr[6]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[6]));
  (* SOFT_HLUTNM = "soft_lutpair22" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[7]_INST_0
       (.I0(s_axi_araddr[7]),
        .I1(s_axi_awaddr[7]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[7]));
  (* SOFT_HLUTNM = "soft_lutpair18" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[8]_INST_0
       (.I0(s_axi_araddr[8]),
        .I1(s_axi_awaddr[8]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[8]));
  (* SOFT_HLUTNM = "soft_lutpair21" *)
  LUT3 #(
    .INIT(8'hAC))
    \m_axi_araddr[9]_INST_0
       (.I0(s_axi_araddr[9]),
        .I1(s_axi_awaddr[9]),
        .I2(m_axi_arvalid),
        .O(m_axi_araddr[9]));
  LUT5 #(
    .INIT(32'h00000100))
    m_axi_arvalid_INST_0
       (.I0(\areset_d_reg_n_0_[1] ),
        .I1(areset_d),
        .I2(write_active),
        .I3(s_axi_arvalid),
        .I4(busy),
        .O(m_axi_arvalid));
  LUT6 #(
    .INIT(64'h2020202200000000))
    m_axi_awvalid_INST_0
       (.I0(s_axi_awvalid),
        .I1(busy),
        .I2(write_active),
        .I3(s_axi_arvalid),
        .I4(read_active),
        .I5(read_req1__0),
        .O(m_axi_awvalid));
  (* SOFT_HLUTNM = "soft_lutpair0" *)
  LUT2 #(
    .INIT(4'h1))
    m_axi_awvalid_INST_0_i_1
       (.I0(\areset_d_reg_n_0_[1] ),
        .I1(areset_d),
        .O(read_req1__0));
  (* SOFT_HLUTNM = "soft_lutpair24" *)
  LUT2 #(
    .INIT(4'h8))
    m_axi_bready_INST_0
       (.I0(s_axi_bready),
        .I1(write_active),
        .O(m_axi_bready));
  (* SOFT_HLUTNM = "soft_lutpair25" *)
  LUT2 #(
    .INIT(4'h8))
    m_axi_rready_INST_0
       (.I0(s_axi_rready),
        .I1(read_active),
        .O(m_axi_rready));
  (* SOFT_HLUTNM = "soft_lutpair8" *)
  LUT3 #(
    .INIT(8'h02))
    m_axi_wvalid_INST_0
       (.I0(s_axi_wvalid),
        .I1(areset_d),
        .I2(\areset_d_reg_n_0_[1] ),
        .O(m_axi_wvalid));
  LUT6 #(
    .INIT(64'h0000000E000E000E))
    read_active_i_1
       (.I0(read_active),
        .I1(m_axi_arvalid),
        .I2(\areset_d_reg_n_0_[1] ),
        .I3(areset_d),
        .I4(m_axi_rvalid),
        .I5(s_axi_rready),
        .O(read_active_i_1_n_0));
  FDRE #(
    .INIT(1'b0))
    read_active_reg
       (.C(aclk),
        .CE(\<const1> ),
        .D(read_active_i_1_n_0),
        .Q(read_active),
        .R(\<const0> ));
  LUT6 #(
    .INIT(64'h0000000000000020))
    s_axi_arready_INST_0
       (.I0(m_axi_arready),
        .I1(busy),
        .I2(s_axi_arvalid),
        .I3(write_active),
        .I4(areset_d),
        .I5(\areset_d_reg_n_0_[1] ),
        .O(s_axi_arready));
  LUT4 #(
    .INIT(16'h0200))
    s_axi_awready_INST_0
       (.I0(m_axi_awready),
        .I1(s_axi_awready_INST_0_i_1_n_0),
        .I2(busy),
        .I3(s_axi_awvalid),
        .O(s_axi_awready));
  (* SOFT_HLUTNM = "soft_lutpair0" *)
  LUT5 #(
    .INIT(32'hEEEEFFFE))
    s_axi_awready_INST_0_i_1
       (.I0(areset_d),
        .I1(\areset_d_reg_n_0_[1] ),
        .I2(read_active),
        .I3(s_axi_arvalid),
        .I4(write_active),
        .O(s_axi_awready_INST_0_i_1_n_0));
  LUT2 #(
    .INIT(4'h8))
    s_axi_bvalid_INST_0
       (.I0(m_axi_bvalid),
        .I1(write_active),
        .O(s_axi_bvalid));
  (* SOFT_HLUTNM = "soft_lutpair25" *)
  LUT2 #(
    .INIT(4'h8))
    s_axi_rvalid_INST_0
       (.I0(m_axi_rvalid),
        .I1(read_active),
        .O(s_axi_rvalid));
  (* SOFT_HLUTNM = "soft_lutpair8" *)
  LUT3 #(
    .INIT(8'h02))
    s_axi_wready_INST_0
       (.I0(m_axi_wready),
        .I1(areset_d),
        .I2(\areset_d_reg_n_0_[1] ),
        .O(s_axi_wready));
  (* SOFT_HLUTNM = "soft_lutpair1" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[0]_i_1
       (.I0(s_axi_arid[0]),
        .I1(s_axi_awid[0]),
        .I2(m_axi_arvalid),
        .O(p_1_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair6" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[10]_i_1
       (.I0(s_axi_arid[10]),
        .I1(s_axi_awid[10]),
        .I2(m_axi_arvalid),
        .O(p_1_in[10]));
  LUT6 #(
    .INIT(64'h0000AAA2000000A0))
    \s_axid[11]_i_1
       (.I0(read_req1__0),
        .I1(read_active),
        .I2(s_axi_arvalid),
        .I3(write_active),
        .I4(busy),
        .I5(s_axi_awvalid),
        .O(\s_axid[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[11]_i_2
       (.I0(s_axi_arid[11]),
        .I1(s_axi_awid[11]),
        .I2(m_axi_arvalid),
        .O(p_1_in[11]));
  (* SOFT_HLUTNM = "soft_lutpair2" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[1]_i_1
       (.I0(s_axi_arid[1]),
        .I1(s_axi_awid[1]),
        .I2(m_axi_arvalid),
        .O(p_1_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[2]_i_1
       (.I0(s_axi_arid[2]),
        .I1(s_axi_awid[2]),
        .I2(m_axi_arvalid),
        .O(p_1_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[3]_i_1
       (.I0(s_axi_arid[3]),
        .I1(s_axi_awid[3]),
        .I2(m_axi_arvalid),
        .O(p_1_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair3" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[4]_i_1
       (.I0(s_axi_arid[4]),
        .I1(s_axi_awid[4]),
        .I2(m_axi_arvalid),
        .O(p_1_in[4]));
  (* SOFT_HLUTNM = "soft_lutpair4" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[5]_i_1
       (.I0(s_axi_arid[5]),
        .I1(s_axi_awid[5]),
        .I2(m_axi_arvalid),
        .O(p_1_in[5]));
  (* SOFT_HLUTNM = "soft_lutpair2" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[6]_i_1
       (.I0(s_axi_arid[6]),
        .I1(s_axi_awid[6]),
        .I2(m_axi_arvalid),
        .O(p_1_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair1" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[7]_i_1
       (.I0(s_axi_arid[7]),
        .I1(s_axi_awid[7]),
        .I2(m_axi_arvalid),
        .O(p_1_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair5" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[8]_i_1
       (.I0(s_axi_arid[8]),
        .I1(s_axi_awid[8]),
        .I2(m_axi_arvalid),
        .O(p_1_in[8]));
  (* SOFT_HLUTNM = "soft_lutpair6" *)
  LUT3 #(
    .INIT(8'hAC))
    \s_axid[9]_i_1
       (.I0(s_axi_arid[9]),
        .I1(s_axi_awid[9]),
        .I2(m_axi_arvalid),
        .O(p_1_in[9]));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[0]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[0]),
        .Q(s_axi_rid[0]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[10]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[10]),
        .Q(s_axi_rid[10]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[11]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[11]),
        .Q(s_axi_rid[11]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[1]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[1]),
        .Q(s_axi_rid[1]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[2]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[2]),
        .Q(s_axi_rid[2]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[3]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[3]),
        .Q(s_axi_rid[3]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[4]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[4]),
        .Q(s_axi_rid[4]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[5]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[5]),
        .Q(s_axi_rid[5]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[6]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[6]),
        .Q(s_axi_rid[6]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[7]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[7]),
        .Q(s_axi_rid[7]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[8]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[8]),
        .Q(s_axi_rid[8]),
        .R(\<const0> ));
  FDRE #(
    .INIT(1'b0))
    \s_axid_reg[9]
       (.C(aclk),
        .CE(\s_axid[11]_i_1_n_0 ),
        .D(p_1_in[9]),
        .Q(s_axi_rid[9]),
        .R(\<const0> ));
  LUT6 #(
    .INIT(64'h00000000AAAE0000))
    write_active_i_1
       (.I0(write_active),
        .I1(s_axi_awvalid),
        .I2(busy),
        .I3(s_axi_awready_INST_0_i_1_n_0),
        .I4(read_req1__0),
        .I5(write_complete__0),
        .O(write_active_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *)
  LUT2 #(
    .INIT(4'h8))
    write_active_i_2
       (.I0(m_axi_bvalid),
        .I1(s_axi_bready),
        .O(write_complete__0));
  FDRE #(
    .INIT(1'b0))
    write_active_reg
       (.C(aclk),
        .CE(\<const1> ),
        .D(write_active_i_1_n_0),
        .Q(write_active),
        .R(\<const0> ));
endmodule

// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Mon Aug 31 18:11:04 2026
// Host        : Pacheco running 64-bit major release  (build 9200)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file
//               C:/Users/diego/Documents/Reconfig/Tutorial1/Tutorial1.sim/sim_1/impl/timing/xsim/XilinxIntro_tb_time_impl.v
// Design      : XilinxIntro
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

(* ECO_CHECKSUM = "1603df21" *) 
(* NotValidForBitStream *)
module XilinxIntro
   (i_a,
    i_b,
    i_s0,
    i_s1,
    o_result);
  input i_a;
  input i_b;
  input i_s0;
  input i_s1;
  output o_result;

  wire i_a;
  wire i_a_IBUF;
  wire i_b;
  wire i_b_IBUF;
  wire i_s0;
  wire i_s0_IBUF;
  wire i_s1;
  wire i_s1_IBUF;
  wire o_result;
  wire o_result_OBUF;

initial begin
 $sdf_annotate("XilinxIntro_tb_time_impl.sdf",,,,"tool_control");
end
  IBUF i_a_IBUF_inst
       (.I(i_a),
        .O(i_a_IBUF));
  IBUF i_b_IBUF_inst
       (.I(i_b),
        .O(i_b_IBUF));
  IBUF i_s0_IBUF_inst
       (.I(i_s0),
        .O(i_s0_IBUF));
  IBUF i_s1_IBUF_inst
       (.I(i_s1),
        .O(i_s1_IBUF));
  OBUF o_result_OBUF_inst
       (.I(o_result_OBUF),
        .O(o_result));
  LUT4 #(
    .INIT(16'h6E85)) 
    o_result_OBUF_inst_i_1
       (.I0(i_a_IBUF),
        .I1(i_b_IBUF),
        .I2(i_s0_IBUF),
        .I3(i_s1_IBUF),
        .O(o_result_OBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif

# ==== Clock input ====
set_property PACKAGE_PIN E3 [get_ports CLK_100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_100MHZ]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK_100MHZ]

## ==== Push Button ====
## upper button
set_property PACKAGE_PIN M18 [get_ports RST]
set_property IOSTANDARD LVCMOS33 [get_ports RST]
## lower button
set_property PACKAGE_PIN P18 [get_ports WR_BTN]
set_property IOSTANDARD LVCMOS33 [get_ports WR_BTN]

set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[0]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[1]}]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[2]}]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[3]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[4]}]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[5]}]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[6]}]
set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[7]}]
set_property -dict {PACKAGE_PIN T8 IOSTANDARD LVCMOS18} [get_ports {SWITCHES[8]}]
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS18} [get_ports {SWITCHES[9]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[10]}]
set_property -dict {PACKAGE_PIN T13 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[11]}]
set_property -dict {PACKAGE_PIN H6 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[12]}]
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[13]}]
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[14]}]
set_property -dict {PACKAGE_PIN V10 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[15]}]

# ==== LEDs ====
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {LEDs[0]}]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports {LEDs[1]}]
set_property -dict {PACKAGE_PIN J13 IOSTANDARD LVCMOS33} [get_ports {LEDs[2]}]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports {LEDs[3]}]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {LEDs[4]}]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {LEDs[5]}]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {LEDs[6]}]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {LEDs[7]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {LEDs[8]}]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports {LEDs[9]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {LEDs[10]}]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports {LEDs[11]}]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {LEDs[12]}]
set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {LEDs[13]}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {LEDs[14]}]
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33} [get_ports {LEDs[15]}]

# ==== UART ====
#set_property -dict {PACKAGE_PIN C4  IOSTANDARD LVCMOS33} [get_ports {UART_RX}]
#set_property -dict {PACKAGE_PIN D4  IOSTANDARD LVCMOS33} [get_ports {UART_TX}]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list CLK_100MHZ_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list s_axi_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 9 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {s_axi_awaddr[0]} {s_axi_awaddr[1]} {s_axi_awaddr[2]} {s_axi_awaddr[3]} {s_axi_awaddr[4]} {s_axi_awaddr[5]} {s_axi_awaddr[6]} {s_axi_awaddr[7]} {s_axi_awaddr[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {s_axi_bresp[0]} {s_axi_bresp[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list s_axi_bvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list s_axi_bready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 9 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {s_axi_araddr[0]} {s_axi_araddr[1]} {s_axi_araddr[2]} {s_axi_araddr[3]} {s_axi_araddr[4]} {s_axi_araddr[5]} {s_axi_araddr[6]} {s_axi_araddr[7]} {s_axi_araddr[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list s_axi_rready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list s_axi_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list s_axi_arvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list s_axi_arready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {s_axi_rdata[0]} {s_axi_rdata[1]} {s_axi_rdata[2]} {s_axi_rdata[3]} {s_axi_rdata[4]} {s_axi_rdata[5]} {s_axi_rdata[6]} {s_axi_rdata[7]} {s_axi_rdata[8]} {s_axi_rdata[9]} {s_axi_rdata[10]} {s_axi_rdata[11]} {s_axi_rdata[12]} {s_axi_rdata[13]} {s_axi_rdata[14]} {s_axi_rdata[15]} {s_axi_rdata[16]} {s_axi_rdata[17]} {s_axi_rdata[18]} {s_axi_rdata[19]} {s_axi_rdata[20]} {s_axi_rdata[21]} {s_axi_rdata[22]} {s_axi_rdata[23]} {s_axi_rdata[24]} {s_axi_rdata[25]} {s_axi_rdata[26]} {s_axi_rdata[27]} {s_axi_rdata[28]} {s_axi_rdata[29]} {s_axi_rdata[30]} {s_axi_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list s_axi_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list s_axi_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 2 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {s_axi_rresp[0]} {s_axi_rresp[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {s_axi_wdata[0]} {s_axi_wdata[1]} {s_axi_wdata[2]} {s_axi_wdata[3]} {s_axi_wdata[4]} {s_axi_wdata[5]} {s_axi_wdata[6]} {s_axi_wdata[7]} {s_axi_wdata[8]} {s_axi_wdata[9]} {s_axi_wdata[10]} {s_axi_wdata[11]} {s_axi_wdata[12]} {s_axi_wdata[13]} {s_axi_wdata[14]} {s_axi_wdata[15]} {s_axi_wdata[16]} {s_axi_wdata[17]} {s_axi_wdata[18]} {s_axi_wdata[19]} {s_axi_wdata[20]} {s_axi_wdata[21]} {s_axi_wdata[22]} {s_axi_wdata[23]} {s_axi_wdata[24]} {s_axi_wdata[25]} {s_axi_wdata[26]} {s_axi_wdata[27]} {s_axi_wdata[28]} {s_axi_wdata[29]} {s_axi_wdata[30]} {s_axi_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 4 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {s_axi_wstrb[0]} {s_axi_wstrb[1]} {s_axi_wstrb[2]} {s_axi_wstrb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list s_axi_rvalid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets CLK_100MHZ_IBUF_BUFG]
# ==== Clock input ====
# ==== needed for designs with external clock
set_property PACKAGE_PIN E3 [get_ports CLK_100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_100MHZ]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK_100MHZ]

# ==== PS/2 Mouse/Keyboard Port (PS2) ====
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports PS2_CLK]
create_clock -period 100.000 -name PS2_CLK_pin -waveform {0.000 50.000} -add [get_ports PS2_CLK]

set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports PS2_DATA]

# ==== Push Button ====
set_property PACKAGE_PIN P18 [get_ports BTN_UP]
set_property IOSTANDARD LVCMOS33 [get_ports BTN_UP]

set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {SWITCH[0]}]

# ==== LEDs ====
set_property PACKAGE_PIN H17 [get_ports {LEDS[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[0]}]
set_property PACKAGE_PIN K15 [get_ports {LEDS[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[1]}]
set_property PACKAGE_PIN J13 [get_ports {LEDS[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[2]}]
set_property PACKAGE_PIN N14 [get_ports {LEDS[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[3]}]
set_property PACKAGE_PIN R18 [get_ports {LEDS[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[4]}]
set_property PACKAGE_PIN V17 [get_ports {LEDS[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[5]}]
set_property PACKAGE_PIN U17 [get_ports {LEDS[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[6]}]
set_property PACKAGE_PIN U16 [get_ports {LEDS[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[7]}]
#set_property PACKAGE_PIN V16 [get_ports {LEDS[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[8]}]
#set_property PACKAGE_PIN T15 [get_ports {LEDS[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[9]}]
#set_property PACKAGE_PIN V11 [get_ports CLK_SMA]
#set_property IOSTANDARD LVCMOS33 [get_ports CLK_SMA]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 2 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 65536 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list your_instance_name/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {sreg[0]} {sreg[1]} {sreg[2]} {sreg[3]} {sreg[4]} {sreg[5]} {sreg[6]} {sreg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list p_0_in]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list PS2_CLK_IBUF_BUFG]]
set_property C_CLK_INPUT_FREQ_HZ 25000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER true [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out1]

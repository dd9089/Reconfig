# ==== Clock input ====
set_property PACKAGE_PIN E3 [get_ports clk_100MHz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100MHz]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk_100MHz]

## ==== Push Button ====
set_property PACKAGE_PIN M18 [get_ports sys_rst]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst]

#set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[0]}]
#set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[1]}]
#set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[2]}]
#set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[3]}]
#set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[4]}]
#set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[5]}]
#set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[6]}]
#set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports {SWITCHES[7]}]

# ==== LEDs ====
set_property PACKAGE_PIN H17 [get_ports {LEDs[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDs[0]}]
set_property PACKAGE_PIN K15 [get_ports {LEDs[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDs[1]}]
set_property PACKAGE_PIN J13 [get_ports {LEDs[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDs[2]}]
set_property PACKAGE_PIN N14 [get_ports {LEDs[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDs[3]}]
set_property PACKAGE_PIN R18 [get_ports {LEDs[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDs[4]}]
set_property PACKAGE_PIN V17 [get_ports {LEDs[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDs[5]}]
set_property PACKAGE_PIN U17 [get_ports {LEDs[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDs[6]}]
set_property PACKAGE_PIN U16 [get_ports {LEDs[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDs[7]}]

# ==== UART ====
set_property -dict {PACKAGE_PIN C4  IOSTANDARD LVCMOS33} [get_ports {i_UART_RX}]
set_property -dict {PACKAGE_PIN D4  IOSTANDARD LVCMOS33} [get_ports {o_UART_TX}]
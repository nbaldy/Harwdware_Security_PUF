

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches
set_property PACKAGE_PIN V17 [get_ports {switch[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {switch[0]}]
set_property PACKAGE_PIN V16 [get_ports {switch[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {switch[1]}]
set_property PACKAGE_PIN W16 [get_ports {switch[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {switch[2]}]
set_property PACKAGE_PIN W14 [get_ports {sw[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W13 [get_ports {sw[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]

## LEDs
set_property PACKAGE_PIN U16 [get_ports {led}]
set_property IOSTANDARD LVCMOS33 [get_ports {led}]

##Buttons
set_property PACKAGE_PIN W19 [get_ports puf_en]

set_property IOSTANDARD LVCMOS33 [get_ports puf_en]
set_property PACKAGE_PIN U18 [get_ports rst]

set_property IOSTANDARD LVCMOS33 [get_ports rst]

#USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports rx]

set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]

set_property IOSTANDARD LVCMOS33 [get_ports tx]
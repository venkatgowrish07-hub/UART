## ============================================================
## UART.xdc  –  Basys3 constraints
## ============================================================

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches – boardip  (SW7-SW0)
set_property PACKAGE_PIN V17 [get_ports {boardip[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {boardip[0]}]
set_property PACKAGE_PIN V16 [get_ports {boardip[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {boardip[1]}]
set_property PACKAGE_PIN W16 [get_ports {boardip[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {boardip[2]}]
set_property PACKAGE_PIN W17 [get_ports {boardip[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {boardip[3]}]
set_property PACKAGE_PIN W15 [get_ports {boardip[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {boardip[4]}]
set_property PACKAGE_PIN V15 [get_ports {boardip[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {boardip[5]}]
set_property PACKAGE_PIN W14 [get_ports {boardip[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {boardip[6]}]
set_property PACKAGE_PIN W13 [get_ports {boardip[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {boardip[7]}]

## Switch SW8 – uart_case_switch (upper→lower case)
set_property PACKAGE_PIN V2  [get_ports uart_case_switch]
set_property IOSTANDARD LVCMOS33 [get_ports uart_case_switch]

## Switches SW12-SW9 – add_value[3:0]
set_property PACKAGE_PIN T3  [get_ports {add_value[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {add_value[0]}]
set_property PACKAGE_PIN T2  [get_ports {add_value[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {add_value[1]}]
set_property PACKAGE_PIN R3  [get_ports {add_value[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {add_value[2]}]
set_property PACKAGE_PIN W2  [get_ports {add_value[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {add_value[3]}]

## LEDs  (LD7-LD0)
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]

## Buttons
set_property PACKAGE_PIN T18 [get_ports load]
set_property IOSTANDARD LVCMOS33 [get_ports load]
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## 7-segment display – segments
set_property PACKAGE_PIN W7  [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN W6  [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U8  [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V8  [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5  [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V5  [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U7  [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

## 7-segment display – anodes
set_property PACKAGE_PIN U2  [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4  [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4  [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4  [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

## USB-RS232
set_property PACKAGE_PIN B18 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]
set_property PACKAGE_PIN A18 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]

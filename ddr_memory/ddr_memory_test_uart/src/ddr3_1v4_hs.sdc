//Copyright (C)2014-2026 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.12.02_SP1 (64-bit) 
//Created Time: 2026-04-03 19:16:13

create_clock -name clk400 -period 2.5 -waveform {0 1.25} [get_nets {memory_clk}]
create_clock -name clk100 -period 10 -waveform {0 5} [get_ports {clk}]
create_clock -name sysclk -period 10 -waveform {0 5} [get_pins {u_ddr3/gw3_top/u_ddr_phy_top/fclkdiv/CLKOUT}]
set_clock_groups -exclusive -group [get_clocks {clk400}] -group [get_clocks {clk100}] -group [get_clocks {sysclk}]

//Copyright (C)2014-2022 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.9 Beta1-1
//Created Time: 2022-12-15 10:24:07
create_clock -name div_clk -period 10 -waveform {0 5} [get_pins {uut_div2/CLKOUT}]
//create_clock -name cfg_clk -period 10 -waveform {0 5} [get_pins {uut_div7/CLKOUT}]
//create_clock -name div_clk -period 20 -waveform {0 10} [get_pins {uut_div2/CLKOUT}]
//create_clock -name cfg_clk -period 20 -waveform {0 10} [get_pins {uut_div7/CLKOUT}]
//set_clock_groups -exclusive -group [get_clocks {div_clk}] -group [get_clocks {cfg_clk}]
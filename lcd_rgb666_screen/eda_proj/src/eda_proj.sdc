//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9.01 (64-bit) 
//Created Time: 2024-03-10 15:59:04
create_clock -name pllclk -period 25 -waveform {0 12.5} [get_nets {sc_clk}]

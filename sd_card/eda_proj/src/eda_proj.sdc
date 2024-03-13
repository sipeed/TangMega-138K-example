//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9.01 (64-bit) 
//Created Time: 2024-03-13 19:13:34
create_clock -name clkin -period 20 -waveform {0 10} [get_ports {clk_50M}]

//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9.01 (64-bit) 
//Created Time: 2024-03-25 11:56:48
create_clock -name dclk -period 26.867 -waveform {0 13.434} [get_ports {lcd_dclk}]
create_clock -name pclk -period 10.965 -waveform {0 5.482} [get_ports {cmos_pclk}]
create_clock -name base -period 20 -waveform {0 10} [get_ports {clk}]
create_clock -name camvsync -period 166666.672 -waveform {0 83333.336} [get_ports {cmos_vsync}]
create_generated_clock -name xclk -source [get_ports {clk}] -master_clock base -divide_by 25 -multiply_by 12 [get_ports {cmos_xclk}]

//Copyright (C)2014-2026 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Part Number: GW5AST-LV138PG484AC1/I0
//Device: GW5AST-138
//Device Version: C


//Change the instance name and port connections to the signal names
//--------Copy here to design--------
    Gowin_PLL your_instance_name(
        .clkin(clkin), //input  clkin
        .init_clk(init_clk), //input  init_clk
        .enclk0(enclk0), //input  enclk0
        .enclk1(enclk1), //input  enclk1
        .enclk2(enclk2), //input  enclk2
        .clkout0(clkout0), //output  clkout0
        .clkout1(clkout1), //output  clkout1
        .clkout2(clkout2), //output  clkout2
        .lock(lock), //output  lock
        .reset(reset) //input  reset
);


//--------Copy end-------------------

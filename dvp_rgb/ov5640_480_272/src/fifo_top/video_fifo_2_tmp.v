//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.9.01 (64-bit)
//Part Number: GW5AST-LV138FPG676AC2/I1
//Device: GW5AST-138
//Device Version: B
//Created Time: Thu Mar 21 19:32:12 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	video_fifo your_instance_name(
		.Data(Data_i), //input [15:0] Data
		.Reset(Reset_i), //input Reset
		.WrClk(WrClk_i), //input WrClk
		.RdClk(RdClk_i), //input RdClk
		.WrEn(WrEn_i), //input WrEn
		.RdEn(RdEn_i), //input RdEn
		.Q(Q_o), //output [15:0] Q
		.Empty(Empty_o), //output Empty
		.Full(Full_o) //output Full
	);

//--------Copy end-------------------

`timescale 1ns/1ns
   
module Joycon_top #(
	parameter CLK_FREQ_HZ = 50_000_000
) (
	input clk,
	input rst_n,

	/* Joycon Interface */
	input  joycon_L_txd,
	output joycon_L_rxd,
	output joycon_L_rst,
	output joycon_L_fc, 

	input  joycon_R_txd,
	output joycon_R_rxd,
	output joycon_R_rst,
	output joycon_R_fc, 

	/* State_output */
	//output [11:0] neslike_key,
	output [7:0] leds
 );

	wire [11:0] neslike_key;

	//Connection State
	wire Left_JOYCON_Connected;
	wire Right_JOYCON_Connected;

	// Buttons
	/*	
		Notes: Keys[21:0] Define:
    	[21:16]: Control
			[21]:"ScreenShot" [20]:"Home" [19]:"Left Stick BTN" [18]:"Right Stick BTN" [17]:"+" [16]:"-"
		[15:8]: Left Side Buttons
        	[15]:"ZL" [14]:"L" [13]:"SL" [12]:"SR" [11]:"LEFT" [10]:"RIGHT" [9]:"UP" [8]:"DOWN"
		[7:0]: Left Side Buttons
			[7]:"ZR" [6]:"R" [5]:"SL" [4]:"SR" [3]:"A" [2]:"B" [1]:"X" [0]:"Y"
	*/
	wire [21:0] Keys;
	wire [15:0] Left_keys;
	wire [15:0] Right_keys;

	// Sticks, Center at 8'h7F
	wire [7:0] Left_Stick_X;
	wire [7:0] Left_Stick_Y;
	wire [7:0] Right_Stick_X;
	wire [7:0] Right_Stick_Y;

	//Gyro
	wire [15:0] Left_GYRO_X;
	wire [15:0] Left_GYRO_Y;
	wire [15:0] Left_GYRO_Z;
	wire [15:0] Right_GYRO_X;
	wire [15:0] Right_GYRO_Y;
	wire [15:0] Right_GYRO_Z;

	//Acc
	wire [15:0] Left_ACC_X;
	wire [15:0] Left_ACC_Y;
	wire [15:0] Left_ACC_Z;
	wire [15:0] Right_ACC_X;
	wire [15:0] Right_ACC_Y;
	wire [15:0] Right_ACC_Z;

	Joycon_uart_fsm # (
    	.CLK_FREQ_HZ(CLK_FREQ_HZ),	//Change Freq need also change UART IP Clock Param
		.JOYCON_IS_LEFT("true")
	) Joycon_left (
		.clk(clk),
		.rst_n(rst_n),
		/* Joycon Interface */
		.joycon_txd(joycon_L_txd),
		.joycon_rxd(joycon_L_rxd),
		.joycon_rst(joycon_L_rst),
		.joycon_fc (joycon_L_fc),
		/* State_output */
		.joycon_detected(Left_JOYCON_Connected),
		.Botton_Value(Left_keys),
		.Stick_X(Left_Stick_X),
		.Stick_Y(Left_Stick_Y),
		.GYRO_X(Left_GYRO_X),
		.GYRO_Y(Left_GYRO_Y),
		.GYRO_Z(Left_GYRO_Z),
		.ACC_X(Left_ACC_X),
		.ACC_Y(Left_ACC_Y),
		.ACC_Z(Left_ACC_Z),
		.Joycon_State_update()
 	);

	Joycon_uart_fsm # (
    	.CLK_FREQ_HZ(CLK_FREQ_HZ),	//Change Freq need also change UART IP Clock Param
		.JOYCON_IS_LEFT("false")
	) Joycon_right (
		.clk(clk),
		.rst_n(rst_n),
		/* Joycon Interface */
		.joycon_txd(joycon_R_txd),
		.joycon_rxd(joycon_R_rxd),
		.joycon_rst(joycon_R_rst),
		.joycon_fc (joycon_R_fc),
		/* State_output */
		.joycon_detected(Right_JOYCON_Connected),
		.Botton_Value(Right_keys),
		.Stick_X(Right_Stick_X),
		.Stick_Y(Right_Stick_Y),
		.GYRO_X(Right_GYRO_X),
		.GYRO_Y(Right_GYRO_Y),
		.GYRO_Z(Right_GYRO_Z),
		.ACC_X(Right_ACC_X),
		.ACC_Y(Right_ACC_Y),
		.ACC_Z(Right_ACC_Z),
		.Joycon_State_update()
 	);

	// Merge Left & Right Joycon Keys
	assign Keys[21] = Left_keys[13];	//"ScreenShot"
	assign Keys[20] = Right_keys[12];	//"Home"
	assign Keys[19] = Left_keys[11];	//"Left Stick BTN"
	assign Keys[18] = Right_keys[10];	//"Right Stick BTN"
	assign Keys[17] = Right_keys[9];	//"+"
	assign Keys[16] = Left_keys[8];		//"-"

	assign Keys[15:8] = Left_keys[7:0];	//[7]:"ZL" [6]:"L" [5]:"SL" [4]:"SR" [3]:"LEFT" [2]:"RIGHT" [1]:"UP" [0]:"DOWN"
	assign Keys[7:0]  = Right_keys[7:0];//[7]:"ZR" [6]:"R" [5]:"SL" [4]:"SR" [3]:"A" [2]:"B" [1]:"X" [0]:"Y"

	assign leds[0] = ~Keys[1];	//X
	assign leds[1] = ~Keys[0];	//Y
	assign leds[2] = ~(Right_Stick_X > 8'hA0);	//Right
	assign leds[3] = ~(Right_Stick_X < 8'h30);	//Left
	assign leds[4] = ~(Right_Stick_Y > 8'hA0);	//Up
	assign leds[5] = ~(Right_Stick_Y < 8'h30);	//Down
	assign leds[6] = ~Keys[17];		//+
	assign leds[7] = ~Keys[18];		//"Right Stick BTN"


	/*	
		Notes: Keys[21:0] Define:
    	[21:16]: Control
			[21]:"ScreenShot" [20]:"Home" [19]:"Left Stick BTN" [18]:"Right Stick BTN" [17]:"+" [16]:"-"
		[15:8]: Left Side Buttons
        	[15]:"ZL" [14]:"L" [13]:"SL" [12]:"SR" [11]:"LEFT" [10]:"RIGHT" [9]:"UP" [8]:"DOWN"
		[7:0]: Left Side Buttons
			[7]:"ZR" [6]:"R" [5]:"SL" [4]:"SR" [3]:"A" [2]:"B" [1]:"X" [0]:"Y"
	*/
	//(RB LB X A RIGHT LEFT DOWN UP START SELECT Y B)
	assign neslike_key[11] = Keys[6];	//R
	assign neslike_key[10] = Keys[14];	//L
	assign neslike_key[9]  = Keys[1];	//X
	assign neslike_key[8]  = Keys[3];	//A
	assign neslike_key[7]  = Keys[10];	//RT
	assign neslike_key[6]  = Keys[11];	//LT
	assign neslike_key[5]  = Keys[8];	//DN
	assign neslike_key[4]  = Keys[9];	//UP
	assign neslike_key[3]  = Keys[17];	//START
	assign neslike_key[2]  = Keys[16];	//SELECT
	assign neslike_key[1]  = Keys[0];	//Y
	assign neslike_key[0]  = Keys[2];	//B

endmodule


`timescale 1ns/1ns
   
module Joycon_uart_fsm #(
	parameter CLK_FREQ_HZ = 50_000_000,
    parameter JOYCON_IS_LEFT = "true"
) (
	input clk,
	input rst_n,

	/* Joycon Interface */
	input  joycon_txd,   
	output joycon_rxd,  //inverted
	output joycon_rst,  //=1:in rst
	output joycon_fc,   //FlowControl, 1:availible to receive

	/* State_output */
	output joycon_detected,

	output [15:0] Botton_Value,
	output [7:0]  Stick_X,
	output [7:0]  Stick_Y,
	output [15:0] GYRO_X,
	output [15:0] GYRO_Y,
	output [15:0] GYRO_Z,
	output [15:0] ACC_X,
	output [15:0] ACC_Y,
	output [15:0] ACC_Z,
	output Joycon_State_update
 );
	/* Fixed Signal */
	wire inv_joycon_rxd;
	assign joycon_rxd = ~inv_joycon_rxd;

	assign joycon_rst = 0;
	assign joycon_fc = 1;

	/* JOYCON Init& Periodic Read Status Module */
		//UART Steram Interface
	wire [7:0] uart_txdata;
	wire uart_tx_data_valid;
	wire uart_tx_data_ready;
	wire [7:0] uart_rxdata;
	wire uart_rx_data_valid;
	wire uart_rx_data_ready;

	wire uart_reset_n_fault;

	Joycon_fsm # (
    	.CLK_FREQ_HZ(CLK_FREQ_HZ),
		.JOYCON_IS_LEFT(JOYCON_IS_LEFT)
	) JoyCon_FSM_inst (
		.clk(clk),
		.rst_n(rst_n),
    	/* UART Stream Interface */
    	.tx_data(uart_txdata),
    	.tx_data_valid(uart_tx_data_valid),
    	.tx_data_ready(uart_tx_data_ready),
    	.rx_data(uart_rxdata),
    	.rx_data_valid(uart_rx_data_valid),
    	.rx_data_ready(uart_rx_data_ready),
    	/* Fault Recovery */
    	.uart_core_rst_n_o(uart_reset_n_fault),
    	/* State_output */
    	.Joycon_Detected(joycon_detected),
        	// Joycon states
		.Botton_Value(Botton_Value),
		.Stick_X(Stick_X),
		.Stick_Y(Stick_Y),
		.GYRO_X(GYRO_X),
		.GYRO_Y(GYRO_Y),
		.GYRO_Z(GYRO_Z),
		.ACC_X(ACC_X),
		.ACC_Y(ACC_Y),
		.ACC_Z(ACC_Z),
    	.Joycon_State_update(Joycon_State_update)
 	);

		//UART Core Interface(SRAM Like)
	wire uart_we;
	wire [2:0] uart_waddr;
	wire [7:0] uart_wdata;
	wire uart_re;
	wire [2:0] uart_raddr;
	wire [7:0] uart_rdata;

	uart_fsm #(
	//UART Register Value Param
		.Reg_LCR_VAL(8'h03),    //8n1
		.Reg_MCR_VAL(8'h00)     //Modem mode not used
	) uart_control_core (
		.clk(clk),
		.rst_n(rst_n & uart_reset_n_fault),
		/* UART SRAM Interface */
		.uart_we(uart_we),
		.uart_waddr(uart_waddr),
		.uart_wdata(uart_wdata),
		.uart_rd(uart_re),
		.uart_raddr(uart_raddr),
		.uart_rdata(uart_rdata),
		/* DataStream Interface */
		.tx_data(uart_txdata),
		.tx_data_valid(uart_tx_data_valid),
		.tx_data_ready(uart_tx_data_ready),
		.rx_data(uart_rxdata),
		.rx_data_valid(uart_rx_data_valid),
		.rx_data_ready(uart_rx_data_ready)
	);

	uart_core joycon_uart_core(
		// Clock & Rst
		.I_CLK(clk),
		.I_RESETN(rst_n & uart_reset_n_fault),
		// SRAM Interface
		.I_TX_EN(uart_we),      //WE
		.I_WADDR(uart_waddr),   //WADDR[2:0]
		.I_WDATA(uart_wdata),   //WDATA[7:0]
		.I_RX_EN(uart_re),      //RE
		.I_RADDR(uart_raddr),   //RADDR[2:0]
		.O_RDATA(uart_rdata),   //RDATA[7:0]
		// UART RX
		.SIN(joycon_txd),
		.RxRDYn(),  //Ready to receive
		// UART TX
		.SOUT(inv_joycon_rxd), //output SOUT
		.TxRDYn(),  //Ready to send
		// Modem interface   
		.DDIS(),    //O, Disable Driver
		.INTR(),    //O, Interrupt
		.DCDn(1'b0),
		.CTSn(1'b0),
		.DSRn(1'b0),
		.RIn(1'b0),
		.DTRn(),
		.RTSn()     //Request to send
	);

endmodule


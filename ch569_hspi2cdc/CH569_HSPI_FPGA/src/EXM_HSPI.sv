
module EXM_HSPI
#(
    parameter	TX_LEN = 12'd512 - 1,			//tx length
    parameter	HSPI_UDF = 26'h00F0F0F,			//user define filed
    parameter	TX_ADDR = 9'h000,				//address of tx data 
    parameter	RX_ADDR = 9'h100				//address of rx data
)(
	//tx signal
	HTCLK,
	HTREQ,
	HTRDY,
	HTVLD,
	HTD,
	HTOE,
	tx_act,
	//rx signal
	HRCLK,
	HRACT,
	HRVLD,
	HTACK,
	HRD,
	//global signal
	rstn,
	clk,
	dat_mod,
	//RAM signal
	ram_clk,
	ram_csn,
	ram_wen,
	ram_addr,
	ram_rdata,
	ram_wdata
);

output 	HTCLK;			//tx clock(max:120MHz)	
output 	HTREQ;			//tx request
input	HTRDY;			//tx ready
output	HTVLD;			//tx data valid
output 	[31:0] HTD;		//tx data
output 	[2:0] HTOE;			//tx I/O output enable
input	tx_act;			//tx trigger

input	HRCLK;			//rx clock(max:120MHz)
input	HRACT;			//rx active
input	HRVLD;			//rx data valid
output	HTACK;			//ack to transmitter
input 	[31:0] HRD;		//rx data

input	rstn;			//global reset signal, low action
input	clk;			//global clock
input 	[1:0] dat_mod;	//HSPI data mode, 00 - 8bits, 01 - 16bits, 1x - 32bits

output	ram_clk;		//ram clock
output	ram_csn;		//ram chip-select, low action
output	ram_wen;		//ram write enable, low action
output	[8:0] ram_addr;		//ram address
output	[31:0] ram_wdata;	//ram write data
input	[31:0] ram_rdata;	//ram read data

parameter 	IDLE = 2'b00;
parameter 	WAIT_RDY = 2'b01;
parameter 	TRAN_HD = 2'b10;
parameter 	TRAN_DAT = 2'b11;

//signal define
wire	wire_rst;
reg		reg_reset;
reg		reg_reset_dly;
wire	wire_reset_sync;
reg		reg_tx_ack;
reg		reg_tran_req;
wire	wire_tran_dat_end;
reg		reg_tx_rdy;
wire	wire_st_tran_hd;
wire	wire_st_tran_dat;
wire	wire_tran_hd_entry;
wire	wire_tran_dat_entry;
reg 	[1:0] reg_state;
wire	wire_end_32b;
wire	wire_end_16b;
wire	wire_end_8b;
wire	wire_dat8;
wire	wire_dat16;
wire	wire_dat32;
reg 	[11:0] reg_tran_cnt;
reg		reg_pif_tran_period;
reg		reg_tran_dat_end_d1;
reg		reg_tran_dat_end_d2;
wire	wire_crc1_sel;
wire 	[31:0] wire_tran_hd_dat;
reg 	[3:0] reg_tran_num;
reg 	[31:0] wire_send_data;
wire 	[31:0] wire_tx_crc_res32;
wire	[15:0] wire_tx_crc_res;
wire	[15:0] wire_tx_crc_out;
reg		reg_tx_req_dly;
reg		reg_tx_vld_dly;
reg		[31:0] reg_tx_dat_dly;	
wire	wire_tx_crc_clr;
wire 	wire_tx_crc_en;
wire 	[31:0] wire_tx_crc_in;
reg		reg_rx_active;
reg		reg_rx_act_d1;
reg		reg_rx_valid;
reg 	[31:0] reg_rx_data;
wire	wire_rx_end;
reg		reg_rxv1;
reg		reg_rx_data_period;
wire	wire_rx_crc_clr;
wire 	[31:0] wire_recv_crc_in;
wire	wire_recv_check;
reg		reg_rx_crc_err;
wire 	[31:0] wire_recv_crc_out32;
wire	[15:0] wire_recv_crc_out16;
wire	[15:0] wire_recv_crc_out8;
wire 	[15:0] wire_recv_crc_res;
reg		reg_num_mismatch;
reg 	[3:0] reg_recv_num;
reg		reg_recv_check;
wire	wire_crc_en;
wire	wire_crc_clr;
wire	wire_crc_clk;
wire 	[31:0] wire_crc_in;	
wire 	[31:0] wire_crc_out32;
wire	[15:0] wire_crc_out16;
wire	[15:0] wire_crc_out8;
reg		reg_rx_active_sync;
wire	wire_st_tran_idle;
wire	wire_hd_end;
wire	wire_tx_complete;
wire	wire_crc2_sel;
reg		[3:0] reg_hd_shift;
wire	wire_tran_hd1_sel;
wire	wire_tran_hd2_sel;
wire	wire_tran_hd3_sel;
wire	wire_tran_hd4_sel;
reg		[2:0] reg_tx_oe_dly;
reg		reg_rx_vld_d1;
reg		reg_rx_vld_d2;
reg		reg_rxv2;
reg 	[31:0] reg_rx_data_d1;
reg 	[31:0] reg_rx_data_d2;
reg		[3:0] reg_got_num;
reg 	[3:0] reg_rx_vld_shift;
wire	wire_rx_vld_d;
reg		reg_ram_cs_tx;
reg		[8:0] reg_ram_addr_tx;
reg		[8:0] reg_ram_addr_rx;
reg		reg_tran_dat_vld;
reg		reg_tx_oe;
wire	wire_rx_dat_start;
reg		reg_act;
reg		reg_act_dly;
wire	wire_act;

assign wire_rst = ~rstn;
always @(posedge HRCLK or posedge wire_rst) begin	
	if (wire_rst) begin
		reg_reset <= 1'b1;
		reg_reset_dly <= 1'b1;
	end
	else begin
		reg_reset <= 1'b0;
		reg_reset_dly <= reg_reset;
	end
end

assign wire_reset_sync = reg_reset_dly;

assign wire_dat8 = dat_mod==2'b00;
assign wire_dat16 = dat_mod==2'b01;
assign wire_dat32 = dat_mod[1];

always @(posedge clk) begin
	reg_act <= tx_act;
	reg_act_dly <= reg_act;
end

assign wire_act = reg_act & ~reg_act_dly;

//************* tx logic ***************
always @(posedge clk) reg_rx_active_sync <= HRACT;		//sync HRACT

always @(posedge clk or posedge wire_rst) begin
	if (wire_rst) reg_tx_ack <= 1'b0;
	else if (reg_tx_ack) begin
		if (!reg_rx_active_sync) reg_tx_ack <= 1'b0;
	end
	else if (wire_st_tran_idle & reg_rx_active_sync) begin		//set when transmitter idle and rx active
		reg_tx_ack <= 1'b1;
	end
end		
	
assign HTACK = reg_tx_ack;

always @(posedge clk or posedge wire_rst) begin		//tx request
	if (wire_rst) reg_tran_req <= 1'b0;
	else if (wire_tran_dat_end) reg_tran_req <= 1'b0;
	else if (wire_act & !reg_rx_active_sync) reg_tran_req <= 1'b1;
end

reg		reg_tran_req_dly;
always @(posedge clk) begin
	reg_tx_rdy <= HTRDY;					//sync tx ready signal
	reg_tran_req_dly <= reg_tran_req;
end

wire	wire_wait_rdy_act;
assign wire_wait_rdy_act = reg_tran_req & !reg_tran_req_dly;
assign wire_tran_hd_entry = reg_tx_rdy & reg_state == WAIT_RDY;	//tx header entry
assign wire_tran_dat_entry = wire_hd_end & reg_state == TRAN_HD;	//tx data entry

assign wire_hd_end = wire_dat8 ? reg_hd_shift[2] & !reg_hd_shift[3]
					 		   : wire_dat16 ? reg_hd_shift[0] & !reg_hd_shift[1]
					 			   			: wire_st_tran_hd & !reg_hd_shift[0];

always @(posedge clk or posedge wire_rst) begin		//tx FSM
	if (wire_rst) reg_state <= IDLE;	//default IDLE
	else begin
		case(reg_state)
			IDLE: if (wire_wait_rdy_act) reg_state <= WAIT_RDY;					//wait tirgger
			WAIT_RDY: if (wire_tran_hd_entry) reg_state <= TRAN_HD;		//keep wait until tx ready
			TRAN_HD:  if (wire_tran_dat_entry) reg_state <= TRAN_DAT;	//tx UDF
			TRAN_DAT: if (wire_tran_dat_end) reg_state <= IDLE;			//tx data payload
			default: reg_state <= IDLE;
		endcase
	end
end

wire	wire_st_tran_wait;
assign wire_st_tran_wait = reg_state == WAIT_RDY;
assign wire_st_tran_idle = reg_state == IDLE;
assign wire_st_tran_hd = reg_state == TRAN_HD;
assign wire_st_tran_dat = reg_state == TRAN_DAT;

always @(posedge clk or posedge wire_rst) begin		//tx count
	if (wire_rst) reg_tran_cnt <= 12'd0;
	else if (wire_tran_dat_entry) reg_tran_cnt <= 12'd0;	//clear when new data tx begin
	else if (wire_st_tran_dat) reg_tran_cnt <= reg_tran_cnt + 1'b1;		//keep increase during data tx state
end

assign wire_end_32b = reg_tran_cnt == TX_LEN[11:2];		//32bits mode data end
assign wire_end_16b = reg_tran_cnt == {1'b0, TX_LEN[11:1]};
assign wire_end_8b = reg_tran_cnt == TX_LEN;
assign wire_tran_dat_end = wire_st_tran_dat & (wire_dat8 ? wire_end_8b : wire_dat16 ? wire_end_16b : wire_end_32b);			//data payload tx end

assign wire_tx_complete = wire_dat8 ? wire_crc2_sel : wire_crc1_sel;
always @(posedge clk or posedge wire_rst) begin		//tx period
	if (wire_rst) reg_pif_tran_period <= 1'b0;
	else if (reg_tx_rdy & wire_st_tran_wait) reg_pif_tran_period <= 1'b1;
	else if (wire_tx_complete) reg_pif_tran_period <= 1'b0;
end

always @(posedge clk) begin
	reg_tran_dat_end_d1 <= wire_tran_dat_end;
	reg_tran_dat_end_d2 <= reg_tran_dat_end_d1;
end

always @(posedge clk) begin
	reg_hd_shift <= {reg_hd_shift[2:0],wire_st_tran_hd};
end

assign wire_crc1_sel = reg_tran_dat_end_d1;
assign wire_crc2_sel = reg_tran_dat_end_d2 & wire_dat8;

assign wire_tran_hd1_sel = wire_st_tran_hd & !reg_hd_shift[0];						//the 1th header tran cycle, used for all mode
assign wire_tran_hd2_sel = reg_hd_shift[0] & !reg_hd_shift[1] & ~wire_dat32;	//the 2th header tran cycle, used for dat8 and dat16 mode 
assign wire_tran_hd3_sel = reg_hd_shift[1] & !reg_hd_shift[2] & wire_dat8;		//the 3th header tran cycle, used for only dat8 mode
assign wire_tran_hd4_sel = reg_hd_shift[2] & !reg_hd_shift[3] & wire_dat8;		//the 4th header tran cycle, used for only dat8 mode
assign wire_tran_hd_dat = {TX_LEN[1:0], reg_tran_num, HSPI_UDF};	//content of header

always @(*) begin
	if (wire_tran_hd1_sel) wire_send_data = wire_tran_hd_dat;
	else if (wire_tran_hd2_sel) wire_send_data = wire_dat16 ? wire_tran_hd_dat>>16 : wire_tran_hd_dat>>8;
	else if (wire_tran_hd3_sel) wire_send_data = wire_tran_hd_dat>>16;
	else if (wire_tran_hd4_sel) wire_send_data = wire_tran_hd_dat>>24;
	else if (wire_crc1_sel) wire_send_data = wire_dat8 ? {4{wire_tx_crc_res[7:0]}} : wire_dat16 ? {2{wire_tx_crc_res}} : wire_tx_crc_res32;
	else if (wire_crc2_sel) wire_send_data = {4{wire_tx_crc_res[15:8]}};
	else wire_send_data = ram_rdata;
end

always @(posedge clk or posedge wire_rst) begin		//tx sequence count
	if (wire_rst) reg_tran_num <= 4'd0;
	else if (wire_tran_dat_end) reg_tran_num <= reg_tran_num + 1'b1;	//increase when tx done
end

always @(posedge clk or posedge wire_rst) begin
	if (wire_rst) reg_tran_dat_vld <= 1'b0;
	else if (wire_tran_dat_end) reg_tran_dat_vld <= 1'b0;		//de-assert data valid signal
	else if (wire_tran_dat_entry) reg_tran_dat_vld <= 1'b1;		//assert data valid signal
end

always @(posedge clk or posedge wire_rst) begin
	if (wire_rst) reg_tx_oe <= 1'b0;
	else if (wire_tran_hd_entry) reg_tx_oe <= 1'b1;		//set OE when start tx header
	else if (wire_dat8 ? wire_crc2_sel : wire_crc1_sel) reg_tx_oe <= 1'b0;	//clear OE when CRC send over
end

always @(posedge clk) begin
	reg_tx_req_dly <= reg_tran_req | wire_crc1_sel | wire_crc2_sel;
	reg_tx_vld_dly <= wire_st_tran_hd | reg_tran_dat_vld | wire_crc1_sel | wire_crc2_sel;
	reg_tx_dat_dly <= wire_send_data;
	reg_tx_oe_dly <= {wire_dat32 & reg_tx_oe, (wire_dat16 | wire_dat32) & reg_tx_oe, reg_tx_oe};
end

//tx interface signal
assign #0.2 HTREQ = reg_tx_req_dly;
assign #0.2 HTD = reg_tx_dat_dly;
assign #0.2 HTVLD = reg_tx_vld_dly;
assign #0.2 HTOE = reg_tx_oe_dly;	
assign #0.1 HTCLK = ~clk;


//************* rx logic ***************
always @(posedge HRCLK) begin
	reg_rx_active <= HRACT;		
	reg_rx_act_d1 <= reg_rx_active;
	reg_rx_valid <= HRVLD;		
	reg_rx_vld_d1 <= reg_rx_valid;
	reg_rx_vld_d2 <= reg_rx_vld_d1;
	reg_rx_data <= HRD;
	reg_rx_data_d1 <= reg_rx_data;
	reg_rx_data_d2 <= reg_rx_data_d1;
end

assign wire_rx_end = !HRACT & reg_rx_active;		//rx done when HRACT falling
always @(posedge HRCLK or posedge wire_reset_sync) begin	//data active period
	if (wire_reset_sync) reg_rxv1 <= 1'b0;
	else if (reg_rx_valid) reg_rxv1 <= 1'b1;
	else if (wire_rx_end) reg_rxv1 <= 1'b0;
end

always @(posedge HRCLK or posedge wire_reset_sync) begin
	if (wire_reset_sync) reg_rxv2 <= 1'b0;
	else if (reg_rx_vld_d1) reg_rxv2 <= 1'b1;
	else if (wire_rx_end) reg_rxv2 <= 1'b0;
end

assign wire_rx_dat_start = !reg_rx_data_period & (wire_dat8 ? reg_rx_vld_shift[2] & !reg_rx_vld_shift[3] 
															: wire_dat16 ? reg_rx_vld_shift[0] & !reg_rx_vld_shift[1]
																		 : wire_rx_vld_d & !reg_rx_vld_shift[0]);

always @(posedge HRCLK or posedge wire_reset_sync) begin		//receive data period
	if (wire_reset_sync) reg_rx_data_period <= 1'b0;
	else if (wire_rx_dat_start) reg_rx_data_period <= 1'b1;
	else if (wire_rx_end) reg_rx_data_period <= 1'b0;
end

assign wire_rx_vld_d = wire_dat8 ? reg_rxv2 & reg_rx_vld_d2 : reg_rxv1 & reg_rx_vld_d1;		//data valid
always @(posedge HRCLK) reg_rx_vld_shift <= {reg_rx_vld_shift[2:0], wire_rx_vld_d};	//rxvalid delay
always @(posedge HRCLK or posedge wire_reset_sync) begin
	if (wire_reset_sync) reg_got_num <= 4'd0;
	else if (wire_dat8) begin
		if (reg_rx_vld_shift[2] & !reg_rx_vld_shift[3] & !reg_rx_data_period) reg_got_num <= reg_rx_data_d2[5:2];
	end
	else if (wire_dat16) begin
		if (reg_rx_vld_d1 & !reg_rx_vld_d2 & !reg_rx_data_period) reg_got_num <= reg_rx_data[13:10];
	end
	else begin
		if (reg_rx_valid & !reg_rx_vld_d1 & !reg_rx_data_period) reg_got_num <= reg_rx_data[29:26];
	end
end

assign wire_recv_check = !reg_rx_active & reg_rx_act_d1;	//rx status check
always @(posedge HRCLK or posedge wire_reset_sync) begin
	if (wire_reset_sync) reg_rx_crc_err <= 1'b0;
	else if (wire_rx_end) reg_rx_crc_err <= 1'b0;	//clear last CRC flag before new CRC result coming
	else if (wire_recv_check) begin
		if (wire_dat32) reg_rx_crc_err <= wire_recv_crc_out32 != 32'hC704DD7B;	//32bit CRC check
		else reg_rx_crc_err <= wire_recv_crc_res != 16'h800d;	//8bit/16bits CRC check
	end
end

always @(posedge HRCLK or posedge wire_reset_sync) begin	//tx and rx sequence match check
	if (wire_reset_sync) reg_num_mismatch <= 1'b0;
	else if (wire_recv_check) reg_num_mismatch <= reg_recv_num != reg_got_num;
end

always @(posedge HRCLK) reg_recv_check <= wire_recv_check;
always @(posedge HRCLK or posedge wire_reset_sync) begin	//rx sequence count
	if (wire_reset_sync) reg_recv_num <= 4'd0;
	else if (reg_recv_check & !reg_num_mismatch & !reg_rx_crc_err) reg_recv_num <= reg_recv_num + 1'b1;
end

//************* crc logic ***************
//tx crc
assign wire_tx_crc_clr = wire_rst | wire_tran_hd_entry;		//CRC module reset
assign wire_tx_crc_en = wire_st_tran_dat | wire_st_tran_hd;		//calculate CRC during header and data payload tx period
assign wire_tx_crc_in  = {wire_send_data[0], wire_send_data[1], wire_send_data[2], wire_send_data[3],
						  wire_send_data[4], wire_send_data[5], wire_send_data[6], wire_send_data[7],
						  wire_send_data[8], wire_send_data[9], wire_send_data[10], wire_send_data[11],
						  wire_send_data[12], wire_send_data[13], wire_send_data[14], wire_send_data[15],
						  wire_send_data[16], wire_send_data[17], wire_send_data[18], wire_send_data[19],
						  wire_send_data[20], wire_send_data[21], wire_send_data[22], wire_send_data[23],
						  wire_send_data[24], wire_send_data[25], wire_send_data[26], wire_send_data[27],
						  wire_send_data[28], wire_send_data[29], wire_send_data[30], wire_send_data[31]
						  };

assign wire_tx_crc_out = wire_dat8 ? wire_crc_out8 : wire_dat16 ? wire_crc_out16 : 16'd0;
assign wire_tx_crc_res = {~wire_tx_crc_out[0], ~wire_tx_crc_out[1], ~wire_tx_crc_out[2], ~wire_tx_crc_out[3], 
						  ~wire_tx_crc_out[4], ~wire_tx_crc_out[5], ~wire_tx_crc_out[6], ~wire_tx_crc_out[7],
						  ~wire_tx_crc_out[8], ~wire_tx_crc_out[9], ~wire_tx_crc_out[10], ~wire_tx_crc_out[11], 
						  ~wire_tx_crc_out[12], ~wire_tx_crc_out[13], ~wire_tx_crc_out[14], ~wire_tx_crc_out[15] 
						  };

assign wire_tx_crc_res32 = {~wire_crc_out32[0], ~wire_crc_out32[1], ~wire_crc_out32[2], ~wire_crc_out32[3], 
						    ~wire_crc_out32[4], ~wire_crc_out32[5], ~wire_crc_out32[6], ~wire_crc_out32[7],
						    ~wire_crc_out32[8], ~wire_crc_out32[9], ~wire_crc_out32[10], ~wire_crc_out32[11], 
						    ~wire_crc_out32[12], ~wire_crc_out32[13], ~wire_crc_out32[14], ~wire_crc_out32[15], 
						    ~wire_crc_out32[16], ~wire_crc_out32[17], ~wire_crc_out32[18], ~wire_crc_out32[19],
						    ~wire_crc_out32[20], ~wire_crc_out32[21], ~wire_crc_out32[22], ~wire_crc_out32[23],
						    ~wire_crc_out32[24], ~wire_crc_out32[25], ~wire_crc_out32[26], ~wire_crc_out32[27],
						    ~wire_crc_out32[28], ~wire_crc_out32[29], ~wire_crc_out32[30], ~wire_crc_out32[31]
						   };

//rx crc
assign wire_rx_crc_clr = wire_reset_sync | HRACT & !reg_rx_active;		//rx crc module reset
assign wire_recv_crc_in = {reg_rx_data[0], reg_rx_data[1], reg_rx_data[2], reg_rx_data[3],
						   reg_rx_data[4], reg_rx_data[5], reg_rx_data[6], reg_rx_data[7],
						   reg_rx_data[8], reg_rx_data[9], reg_rx_data[10], reg_rx_data[11],
						   reg_rx_data[12], reg_rx_data[13], reg_rx_data[14], reg_rx_data[15],
						   reg_rx_data[16], reg_rx_data[17], reg_rx_data[18], reg_rx_data[19],
						   reg_rx_data[20], reg_rx_data[21], reg_rx_data[22], reg_rx_data[23],
						   reg_rx_data[24], reg_rx_data[25], reg_rx_data[26], reg_rx_data[27],
						   reg_rx_data[28], reg_rx_data[29], reg_rx_data[30], reg_rx_data[31]					   
						  };

assign wire_recv_crc_res = wire_dat8 ? wire_recv_crc_out8 : wire_dat16 ? wire_recv_crc_out16 : 16'd0;

assign wire_crc_en = wire_tx_crc_en;		//CRC calculate enable
assign wire_crc_clr = wire_tx_crc_clr | wire_rx_crc_clr & ~reg_pif_tran_period;	//CRC reset
assign wire_crc_clk = clk;						//CRC clock
assign wire_crc_in = wire_tx_crc_in;	//CRC datain
assign wire_recv_crc_out8 = wire_crc_out8;
assign wire_recv_crc_out16 = wire_crc_out16;
assign wire_recv_crc_out32 = wire_crc_out32;

crc16_16b m_crc16 (
	.clk(wire_crc_clk),
	.rst(wire_crc_clr),
	.crc_en(wire_crc_en),
	.data_in(wire_crc_in[31:16]),
	.crc_out(wire_crc_out16)
);

//***************  RAM operation  *****************
always @(posedge clk or posedge wire_rst) begin		//ram cs during tx
	if (wire_rst) reg_ram_cs_tx <= 1'b0;
	else begin
		if (wire_tran_hd_entry) reg_ram_cs_tx <= 1'b1;
		else if (wire_tran_dat_end) reg_ram_cs_tx <= 1'b0;
	end
end

always @(posedge clk or posedge wire_rst) begin		//ram read address
	if (wire_rst) reg_ram_addr_tx <= 9'd0;
	else if (wire_tran_hd_entry) reg_ram_addr_tx <= TX_ADDR;
	else if (wire_tran_dat_entry | wire_st_tran_dat & !wire_tran_dat_end) reg_ram_addr_tx <= reg_ram_addr_tx + 1'b1;
end

always @(posedge HRCLK or posedge wire_reset_sync) begin	//ram write address
	if (wire_reset_sync) reg_ram_addr_rx <= 9'd0;
	else if (HRVLD & !reg_rx_valid) reg_ram_addr_rx <= RX_ADDR;
	else if (reg_rx_data_period) reg_ram_addr_rx <= reg_ram_addr_rx + 1'b1;
end

assign ram_clk = reg_tx_rdy & reg_tran_req ? clk : HRCLK;			//make sure that ram_csn inactive when switch ram clock
assign ram_csn = reg_tx_rdy & reg_tran_req ? !(reg_ram_cs_tx & !wire_tran_dat_end) : !reg_rx_data_period;
assign ram_wen = !reg_rx_data_period;
assign ram_addr = reg_tx_rdy & reg_tran_req ? reg_ram_addr_tx : reg_ram_addr_rx;
assign ram_wdata = wire_dat8 ? reg_rx_data_d2 : reg_rx_data_d1;


endmodule

module crc16_16b(				//crc[15:0]=1+x^2+x^15+x^16;
  input [15:0] data_in,
  input crc_en,
  output [15:0] crc_out,
  input rst,
  input clk);

  logic [15:0] lfsr_q, lfsr_c;

  assign crc_out = lfsr_q;

  always_comb begin
    lfsr_c[0] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[15];
    lfsr_c[1] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14];
    lfsr_c[2] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[14] ^ data_in[0] ^ data_in[1] ^ data_in[14];
    lfsr_c[3] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[15] ^ data_in[1] ^ data_in[2] ^ data_in[15];
    lfsr_c[4] = lfsr_q[2] ^ lfsr_q[3] ^ data_in[2] ^ data_in[3];
    lfsr_c[5] = lfsr_q[3] ^ lfsr_q[4] ^ data_in[3] ^ data_in[4];
    lfsr_c[6] = lfsr_q[4] ^ lfsr_q[5] ^ data_in[4] ^ data_in[5];
    lfsr_c[7] = lfsr_q[5] ^ lfsr_q[6] ^ data_in[5] ^ data_in[6];
    lfsr_c[8] = lfsr_q[6] ^ lfsr_q[7] ^ data_in[6] ^ data_in[7];
    lfsr_c[9] = lfsr_q[7] ^ lfsr_q[8] ^ data_in[7] ^ data_in[8];
    lfsr_c[10] = lfsr_q[8] ^ lfsr_q[9] ^ data_in[8] ^ data_in[9];
    lfsr_c[11] = lfsr_q[9] ^ lfsr_q[10] ^ data_in[9] ^ data_in[10];
    lfsr_c[12] = lfsr_q[10] ^ lfsr_q[11] ^ data_in[10] ^ data_in[11];
    lfsr_c[13] = lfsr_q[11] ^ lfsr_q[12] ^ data_in[11] ^ data_in[12];
    lfsr_c[14] = lfsr_q[12] ^ lfsr_q[13] ^ data_in[12] ^ data_in[13];
    lfsr_c[15] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15];

  end // always

  always_ff @(negedge clk, posedge rst) begin
    if (rst) lfsr_q <= 16'hffff;
    else lfsr_q <= crc_en ? lfsr_c : lfsr_q;
  end // always
endmodule // crc

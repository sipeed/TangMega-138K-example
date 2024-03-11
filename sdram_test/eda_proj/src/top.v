
module top(
    input reset,
    inout [15:0] SDRAM_DQ,
    output [12:0]SDRAM_A,
    output [1:0] SDRAM_BA,
    output SDRAM_nCS,
    output SDRAM_nWE,
    output SDRAM_nRAS,
    output SDRAM_nCAS,
    output SDRAM_CLK,
    output SDRAM_CKE,
    output [1:0] SDRAM_DQM,

    output reg led_succeed,
    output reg led_fault
);
wire osc_out;
Gowin_OSC osc(
    .oscout(osc_out) //output oscout
);
wire clk_66p7m;
wire clk_66p7m_shifted;
wire clk_266m;

Gowin_PLL systempll(
        .clkout0(clk_266m), //output clkout0
        .clkout1(clk_66p7m), //output clkout1
        .clkout2(clk_66p7m_shifted), //output clkout2
        .clkin(osc_out) //input clkin
    );
localparam BIT_SEQ = 8'b10011100;
reg sdram_read;
reg sdram_write;
wire sdram_busy;
wire sdram_data_ready;
wire [7:0] sdram_dout;
reg [7:0] sdram_din;

sdram sdram_inst(
    .SDRAM_DQ(SDRAM_DQ),
    .SDRAM_A(SDRAM_A),
    .SDRAM_BA(SDRAM_BA),
    .SDRAM_nCS(SDRAM_nCS),
    .SDRAM_nWE(SDRAM_nWE),
    .SDRAM_nRAS(SDRAM_nRAS),
    .SDRAM_nCAS(SDRAM_nCAS),
    .SDRAM_CLK(SDRAM_CLK),
    .SDRAM_CKE(SDRAM_CKE),
    .SDRAM_DQM(SDRAM_DQM),

    .clk(clk_66p7m),
    .clk_sdram(clk_66p7m_shifted),
    .resetn(~reset),
    .refresh((!(sdram_read || sdram_write))? clk_66p7m : 1'b0),
    .addr(sdram_address[26:1]),
    .din(sdram_din),
    .dout(sdram_dout),
    .rd(sdram_read),
    .wr(sdram_write),
    .busy(sdram_busy),
    .data_ready(sdram_data_ready)
);

reg data_correct;
reg scan_finished;

reg [26:0] sdram_address;

always @(negedge clk_266m or posedge reset) begin
    if(reset) begin
        sdram_address <= 0;
        scan_finished <= 0;
    end else if(sdram_address == ~(26'b0)) begin
        led_succeed <= 1;
        scan_finished <= 1;
    end else if(data_correct && (!(scan_finished)) && (!sdram_busy)) begin
        sdram_address <= sdram_address + 1;
        sdram_din <= BIT_SEQ;
        if(sdram_address[0] == 0) begin 
            sdram_write <= 1;
            sdram_read <= 0;
        end else if(sdram_address[0] == 1) begin
            sdram_write <= 0;
            sdram_read <= 1;
        end
    end

end

always @(posedge sdram_data_ready) begin 
    if(reset) begin
        data_correct <= 1;
        led_fault <= 0;
    end else begin
        data_correct <= (BIT_SEQ == sdram_dout);
        if(!(BIT_SEQ == sdram_dout)) led_fault <= 1;
    end
end
endmodule

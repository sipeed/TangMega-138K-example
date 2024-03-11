module led (
    output [15:0]    led
);
wire clk;
Gowin_OSC f2p1mosc_inst(
        .oscout(clk) //output oscout 2.1Mhz
);
reg [32:0] time_cnt;
reg [15:0] led_reg;
always @(posedge clk) begin
    if(time_cnt < 1000000) begin
        time_cnt <= time_cnt + 'b1;
    end else begin
        time_cnt <= 'd0;
        if(led_reg[15]) begin
            led_reg[15:0] <= 'd1;
        end else begin
            led_reg <= (led_reg << 1) | 'b1 ;            
        end
    end
end
assign led[15:0] = ~led_reg[15:0];
endmodule
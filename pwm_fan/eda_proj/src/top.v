module top(
    input  clk,
    output fan_pwm,
    input  key_in
);
reg [16:0] count;
reg [16:0] target;

always @(posedge clk ) begin
    count <= count + 1; 
end
always @(negedge key_in ) begin
    target = (target!=0) ? (target << 1) : (1<<4);
end

assign fan_pwm = count > target;

           
endmodule

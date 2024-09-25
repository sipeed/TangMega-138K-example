module top(
	input 	clk,
	input	rst_n,
	output  WS2812
);

	wire TE;
	reg [8:0] hue;
	reg hue_valid;
	always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
		begin
			hue <= 9'd0;
			hue_valid <= 0;
		end else begin
			if(TE)
			begin
				if(hue >= 9'd359)
				begin
					hue <= 9'd0;
				end else begin
					hue <= hue + 1;
				end
				hue_valid <= 1;
			end else begin
				hue <= hue;
				hue_valid <= 0;
			end
		end
	end

	wire [7:0] led_r;
	wire [7:0] led_g;
	wire [7:0] led_b;
	wire led_rgb_valid;
	hsv2rgb hsv2rgb_inst(
		.sys_clk(clk),
		.rst_n(rst_n),
    	.Hue(hue),        	 //0-359
    	.Saturation(8'd200), //0-255
    	.Value(8'd30),      //0-255
    	.hsv_valid(hue_valid),
		.R(led_r),
		.G(led_g),
		.B(led_b),
		.rgb_out_valid(led_rgb_valid)
);

	WS2812 #(
		.clk_freq(50_000_000),	//20ns
		.fps(10),
		.used_led(1),
		.independent_led_ctrl("false")
	) WS2812_inst (
		.sys_clk(clk),
		.rst_n(rst_n),
		.Do(WS2812),
		/* LED Input Interface, Sync to sys_clk */
		.pixel_addr(0),
		.pixel_Red(led_r),
		.pixel_Green(led_g),
		.pixel_Blue(led_b),
		.pixel_valid(led_rgb_valid),
		.TE(TE)
	);

endmodule
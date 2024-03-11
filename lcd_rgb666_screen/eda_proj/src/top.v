module TOP (
    input reset,
    output   [5:0] r_out,
    output   [5:0] g_out,
    output   [5:0] b_out,
    output   sc_clk,
    output   sc_hs,
    output   sc_vs,
    output   sc_de
);

wire oscout_l;
wire oscout;
Gowin_OSC osc_inst(
        .oscout(oscout_l), //output oscout
        .oscen(1'b1) //input oscen
    );
Gowin_PLL pll_inst(
        .clkout0(oscout), //output clkout0
        .clkin(oscout_l) //input clkin
    );
    // Horizen count to Hsync, then next Horizen line.

    parameter       H_Pixel_Valid    = 16'd800; 
    parameter       H_FrontPorch     = 16'd210;
    parameter       H_BackPorch      = 16'd182;  

    parameter       PixelForHS       = H_Pixel_Valid + H_FrontPorch + H_BackPorch;

    parameter       V_Pixel_Valid    = 16'd480; 
    parameter       V_FrontPorch     = 16'd45;  
    parameter       V_BackPorch      = 16'd8;    

    parameter       PixelForVS       = V_Pixel_Valid + V_FrontPorch + V_BackPorch;

    // Horizen pixel count

    reg         [15:0]  H_PixelCount;
    reg         [15:0]  V_PixelCount;

    always @(  posedge oscout  or posedge reset)begin
        if(reset) begin 
            V_PixelCount      <=  16'b0;
            H_PixelCount      <=  16'b0;
            end
        else if(  H_PixelCount == PixelForHS ) begin
            V_PixelCount      <=  V_PixelCount + 1'b1;
            H_PixelCount      <=  16'b0;
            end
        else if(  V_PixelCount == PixelForVS ) begin
            V_PixelCount      <=  16'b0;
            H_PixelCount      <=  16'b0;
            end
        else begin
            V_PixelCount      <=  V_PixelCount ;
            H_PixelCount      <=  H_PixelCount + 1'b1;
        end
    end

    // SYNC-DE MODE
    assign  sc_clk      = oscout;
    assign  sc_de       =    ( H_PixelCount >= H_BackPorch ) && ( H_PixelCount <= H_Pixel_Valid + H_BackPorch ) &&
                        ( V_PixelCount >= V_BackPorch ) && ( V_PixelCount <= V_Pixel_Valid + V_BackPorch ) && oscout;

    // color bar
    localparam          Colorbar_width   =   H_Pixel_Valid / 18;

    assign  r_out     = ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 0  )) ? 6'b000000 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 1  )) ? 6'b000001 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 2  )) ? 6'b000010 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 3  )) ? 6'b000100 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 4  )) ? 6'b001000 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 5  )) ? 6'b010000 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 6  )) ? 6'b100000 : 6'b000000;

    assign  g_out    =  ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 7  )) ? 6'b000001:
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 8  )) ? 6'b000010:
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 9  )) ? 6'b000100:
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 10 )) ? 6'b001000:
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 11 )) ? 6'b010000:
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 12 )) ? 6'b100000:  6'b000000;

    assign  b_out    =  ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 13 )) ? 6'b000001 : 
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 14 )) ? 6'b000010 :    
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 15 )) ? 6'b000100 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 16 )) ? 6'b001000 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 17 )) ? 6'b010000 :
                        ( H_PixelCount < ( H_BackPorch +  Colorbar_width * 18 )) ? 6'b100000 : 6'b000000;

endmodule 

`timescale 1ns/1ns
module hsv2rgb
(
	input sys_clk,
	input rst_n,

    input [8:0] Hue,        //0-359
    input [7:0] Saturation, //0-255
    input [7:0] Value,      //0-255
    input hsv_valid,

	output  [7:0] R,
	output  [7:0] G,
	output  [7:0] B,
	output  rgb_out_valid
);

/*
    define V : [0-255]
    define S : [0-255]
    define H : [0-359]

    Hi = to_intger(H/60)
    f  = H % 60

    VS = (255 x V - V x S) / 255
    VSF = VS x (f/60)

    case Hi
        0: (R, G, B) = (V,          (V-VS+VSF),     (V-VS)      )
        1: (R, G, B) = ((V-VSF),    V,              (V-VS)      )
        2: (R, G, B) = ((V-VS),     V,              (V-VS+VSF)  )
        3: (R, G, B) = ((V-VS),     (V-VSF),        V           )
        4: (R, G, B) = ((V-VS+VSF), (V-VS),         V           )
        5: (R, G, B) = (V,          (V-VS),         (V-VSF)     )
    endcase
*/


/* End at clk6 */
    wire [15:0] VxS;
    wire VxS_valid;
    //Latency: log2(A_len)+1, = 5 clock
    multiply #(
        .A_len(8),
        .B_len(8),
        .singed("false")
    ) VmultS (
        .clk(sys_clk),
        .ce(1'b1),
        .rst_n(rst_n),
        .A(Saturation),
        .A_valid(hsv_valid),
        .B(Value),
        .B_valid(hsv_valid),
        .S(VxS),
        .S_valid(VxS_valid)
    );

/* Hi & f gen(end at Clk6) */
    /* Pipe1 */
    reg [7:0] Hue_max180;
    reg [7:0] V_d1;
    reg [2:0] hi_d1;
    reg h_valid_d1;

    /* Pipe2 */
    reg [7:0] Hue_max120;
    reg [2:0] hi_d2;
    reg [7:0] V_d2;
    reg h_valid_d2;

    /* Pipe3 */
    reg [7:0] Hue_max60;
    reg [2:0] hi_d3;
    reg [7:0] V_d3;
    reg h_valid_d3;

    /* Pipe4 */
    reg [7:0] Hue_d4;
    reg [2:0] hi_d4;
    reg [7:0] V_d4;
    reg h_valid_d4;

    /* Pipe5 */
    reg [5:0] f_diff;
    reg [2:0] hi;
    reg [7:0] V_d5;
    reg hi_f_valid;
    always@(posedge sys_clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            Hue_max180  <= 0;
            Hue_max120  <= 0;
            Hue_max60   <= 0;
            Hue_d4  <= 0;
            f_diff  <= 0;
            V_d1 <= 0;
            V_d2 <= 0;
            V_d3 <= 0;
            V_d4 <= 0;
            V_d5 <= 0;
            hi_d1   <= 0;
            hi_d2   <= 0;
            hi_d3   <= 0;
            hi_d4   <= 0;
            hi  <= 0;
            h_valid_d1  <= 0;
            h_valid_d2  <= 0;
            h_valid_d3  <= 0;
            h_valid_d4  <= 0;
            hi_f_valid  <= 0;
        end else begin
            /* pipe1, check Hue > 180? */
            Hue_max180 <= (Hue >= 9'd180) ? (Hue - 9'd180) : Hue;
            hi_d1 <= (Hue >= 9'd180) ? 3 : 0;
            V_d1 <= Value;
            h_valid_d1 <= hsv_valid;

            /* Pipe 2, Check Hue(-180) > 60? */
            Hue_max120 <= (Hue_max180 >= 8'd60) ? (Hue_max180 - 8'd60) : Hue_max180;
            hi_d2 <= (Hue_max180 >= 8'd60) ? (hi_d1 + 1) : hi_d1;
            V_d2 <= V_d1;
            h_valid_d2 <= h_valid_d1;

            /* Pipe 3, Check Hue(-180-60) > 60? */
            Hue_max60 <= (Hue_max120 >= 8'd60) ? (Hue_max120 - 8'd60) : Hue_max120;
            hi_d3 <= (Hue_max120 >= 8'd60) ? (hi_d2 + 1) : hi_d2;
            V_d3 <= V_d2;
            h_valid_d3 <= h_valid_d2;

            /* Pipe 4, Check Hue(-180-60) > 60? */
            Hue_d4 <= Hue_max60;
            hi_d4 <= hi_d3;
            V_d4 <= V_d3;
            h_valid_d4 <= h_valid_d3;

            /* Pipe 5, Latch Final Hi & f */
            f_diff <= Hue_d4;
            hi <= hi_d4;
            V_d5 <= V_d4;
            hi_f_valid <= h_valid_d4;

        end
    end

/************* After Pipe 6 *****************/

    /* start at clk6, end at clk11 */
    wire [13:0] VSf60;
    wire VSf60_Valid;
    //Latency: log2(A_len)+1, = 5 clock
    multiply #(
        .A_len(8),
        .B_len(6),
        .singed("false")
    ) VSmultif (
        .clk(sys_clk),
        .ce(1'b1),
        .rst_n(rst_n),
        .A(VxS[15:8]),
        .A_valid(VxS_valid),
        .B(f_diff),
        .B_valid(hi_f_valid),
        .S(VSf60),
        .S_valid(VSf60_Valid)
    );

    /* start at clk11, end at clk22 */
    //Latency: out_len+3, = 11 clock
    wire [7:0] VSf;
    wire VSf_Valid;
    divide #(
        .in0_len(14),
        .in1_len(6),
        .out_len(8),
        .is_signed("false")
    ) div_VSF (
        .clk(sys_clk),
        .clk_ce(1'b1),
        .rst_n(rst_n),
        .dividend(VSf60),
        .dividend_valid(VSf60_Valid),
        .divisor(6'd60),
        .divisor_valid(1'b1),
        .quot(VSf),    //商
        .remd(),    //余数   
        .out_valid(VSf_Valid), 
        .div_by_zero()              //除以0标识    
);

    /* Pipe6 to pipe22, 15Clk */
    reg [2:0] Hi[15:0];
    reg [7:0] V_dx[15:0];
    reg [7:0] VmVS[15:0];
    reg pipe_data_valid[15:0];

    reg [7:0] VmVSpVSF;   //V - VS + VSF
    reg [7:0] VmVSF;      //V - VSF

    reg [7:0] R_value;
    reg [7:0] G_value;
    reg [7:0] B_value;
    reg rgb_valid;

    reg [7:0] i;

    always@(posedge sys_clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            for(i=0; i<16; i=i+1)
            begin
                Hi[i] <= 0;
                V_dx[i] <= 0;
                VmVS[i] <= 0;
                pipe_data_valid[i] <= 0;
            end
            VmVSpVSF <= 0;
            VmVSF <= 0;
            R_value <= 0;
            G_value <= 0;
            B_value <= 0;
            rgb_valid <= 0;
        end else begin
            //Clk6 to clk22
            for(i=0; i<16; i=i+1)
            begin
                if(i==0)
                begin
                    Hi[0] <= hi;
                    V_dx[0] <= V_d5;
                    VmVS[0] <= V_d5 - VxS[15:8];
                    pipe_data_valid[0] <= hi_f_valid;
                end else begin
                    Hi[i] <= Hi[i-1];
                    V_dx[i] <= V_dx[i-1];
                    VmVS[i] <= VmVS[i-1];
                    pipe_data_valid[i] <= pipe_data_valid[i-1];
                end
            end

            //clk22 extra signal
            VmVSpVSF <= VmVS[14] + VSf;
            VmVSF <= V_dx[14] - VSf;

            case(Hi[15])
            0:
            begin
                R_value <= V_dx[15];
                G_value <= VmVSpVSF;
                B_value <= VmVS[15];
                rgb_valid <= pipe_data_valid[15];
            end
            1:
            begin
                R_value <= VmVSF;
                G_value <= V_dx[15];
                B_value <= VmVS[15];
                rgb_valid <= pipe_data_valid[15];
            end
            2:
            begin
                R_value <= VmVS[15];
                G_value <= V_dx[15];
                B_value <= VmVSpVSF;
                rgb_valid <= pipe_data_valid[15];
            end
            3:
            begin
                R_value <= VmVS[15];
                G_value <= VmVSF;
                B_value <= V_dx[15];
                rgb_valid <= pipe_data_valid[15];
            end
            4:
            begin
                R_value <= VmVSpVSF;
                G_value <= VmVS[15];
                B_value <= V_dx[15];
                rgb_valid <= pipe_data_valid[15];
            end
            5:
            begin
                R_value <= V_dx[15];
                G_value <= VmVS[15];
                B_value <= VmVSF;
                rgb_valid <= pipe_data_valid[15];
            end
            default:
            begin
                R_value <= R_value;
                G_value <= G_value;
                B_value <= B_value;
                rgb_valid <= 0;
            end
            endcase
        end
    end


    assign R = R_value;
	assign G = G_value;
	assign B = B_value;
	assign rgb_out_valid = rgb_valid;


endmodule

`timescale 1ns / 1ns
module multiply #(
    parameter A_len = 12,
    parameter B_len = 12,
    parameter singed = "true"
) (
    input clk,
    input ce,
    input rst_n,

    input [A_len-1 : 0]    A,
    input A_valid,

    input [B_len-1 : 0]    B,
    input B_valid,

    output [A_len+B_len-1 : 0]   S,
    output S_valid
);
/* S = A * B */
/* Pipeline level = 1+log2(B_len) */
/* Latency: log2(A_len)+1, AB中更长的数放输入B能提高速度 */
/* 
 * 注：正数不用做下面的操作
 * 补码-------->------------>------------->原码（去符号）
 *      去符号    取反（-1）    +1（取反）
 * 原码---------->----------->------------>补码（补符号）
 *      -1(取反)    取反（+1）  加符号
 * 问题：强行加符号会导致0变的不正确
 */

 /* 
 * 注：正数不用做下面的操作
 * 补码------------>------------->原码（去符号） ----->>>符号位已经被取反,可以直接直接忽略
 *       取反           +1
 * 源码------------>------------->补码（补符号） ----->>>符号已经置位
 *       取反           +1  
 * 例： 0: 取反=1111_1111, +1=0000_0000
 *     1: 取反=1111_1110, +1=1111_1111=0xff = -1
 */

localparam integer pipeline_level = $clog2((singed=="true")?(A_len-1):(A_len)) + 1;
localparam integer add_level = $clog2((singed=="true")?(A_len-1):(A_len));

reg [A_len-1 : 0]    iA;
reg [B_len-1 : 0]    iB;

reg sign_1;
reg a_valid_1;
reg b_valid_1;

generate
begin:input_process
    /* signed signal process */
    if(singed == "true")
    begin  
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                iA <= 0;
                iB <= 0;
                sign_1 <= 0;
            end else begin
                if(ce)
                begin
                    if(A[A_len-1] == 1)
                    begin
                        iA <= ~{1'd1, A[A_len-2 : 0]} + 1;
                    end else begin
                        iA <= A;
                    end

                    if(B[B_len-1] == 1)
                    begin
                        iB <= ~{1'd1, B[B_len-2 : 0]} + 1;
                    end else begin
                        iB <= B;
                    end
                    
                    sign_1 <= A[A_len-1] ^ B[B_len-1];
                end
            end
        end
    end else begin: latch_nosigned
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                iA <= 0;
                iB <= 0;
            end else begin
                if(ce)
                begin
                    iA <= A;
                    iB <= B;
                end
            end
        end
    end

    /* valid signal process*/
    always @(posedge clk or negedge rst_n) 
    begin
        if(!rst_n)
        begin
            a_valid_1 <= 0;
            b_valid_1 <= 0;
        end else begin
            if(ce)
            begin
                a_valid_1 <= A_valid;
                b_valid_1 <= B_valid;
            end
        end
    end
end
endgenerate

/* Pipeline 1---A[i]*B */
reg [A_len+B_len-1 : 0] pipe_AixB[(2**add_level) -1 : 0];
reg sign_pipe1;
reg a_valid_2;
reg b_valid_2;

generate
begin:pipe1
    /* signed signal process */
    if(singed == "true")
    begin:pipe1_sign
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                sign_pipe1 <= 0;
            end else begin
                if(ce)
                begin
                    sign_pipe1 <= sign_1;
                end
            end
        end
    end

    /* Multiply core */
    genvar i;
    for(i=0; i < (2**add_level) ; i=i+1)
    begin:shift
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                pipe_AixB[i][A_len+B_len-1 : 0] <= 'h00;
            end else begin
                if(ce)
                begin
                    if(iA[i] == 1'b1)
                    begin
                        pipe_AixB[i][A_len+B_len-1 : 0] <= iB << i;
                    end else begin
                        pipe_AixB[i][A_len+B_len-1 : 0] <= 'h00;
                    end
                end
            end
        end
    end

    /* valid signal process*/
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            a_valid_2 <= 0;
            b_valid_2 <= 0;
        end else begin
            if(ce)
            begin
                a_valid_2 <= a_valid_1;
                b_valid_2 <= b_valid_1;
            end
        end
    end
end
endgenerate

/* Pipeline 2 ---sum each ak*B */
reg [A_len+B_len-1 : 0] pipe_add1[(2**(add_level-1)) - 1 : 0];
reg sign_pipe2;
reg a_valid_3;
reg b_valid_3;

generate
begin:pipe2
    /* signed signal process */
    if(singed == "true")
    begin:pipe2_sign
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                sign_pipe2 <= 0;
            end else begin
                if(ce)
                begin
                    sign_pipe2 <= sign_pipe1;
                end
            end
        end
    end

    /* Multiply core */
    genvar i;
    for(i=0; i < (2**(add_level-1)) ; i=i+1)
    begin:add1
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                pipe_add1[i][A_len+B_len-1 : 0] <= 'h00;
            end else begin
                if(ce)
                begin
                    pipe_add1[i][A_len+B_len-1 : 0] <= pipe_AixB[i*2][A_len+B_len-1 : 0] + pipe_AixB[i*2+1][A_len+B_len-1 : 0];
                end
            end
        end
    end

    /* valid signal process*/
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            a_valid_3 <= 0;
            b_valid_3 <= 0;
        end else begin
            if(ce)
            begin
                a_valid_3 <= a_valid_2;
                b_valid_3 <= b_valid_2;
            end
        end
    end
end
endgenerate

    

/* Pipeline3 */
reg [A_len+B_len-1 : 0] pipe_add2[(2**(add_level-2)) - 1 : 0];
reg sign_pipe3;
reg a_valid_4;
reg b_valid_4;

generate
if(pipeline_level > 2)
begin:pipe3
    /* signed signal process */
    if(singed == "true")
    begin:pipe3_sign
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                sign_pipe3 <= 0;
            end else begin
                if(ce)
                begin
                    sign_pipe3 <= sign_pipe2;
                end
            end
        end
    end

    /* Multiply core */
    genvar i;
    for(i=0; i < (2**(add_level-2)) ; i=i+1)
    begin:add2
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                pipe_add2[i][A_len+B_len-1 : 0] <= 'h00;
            end else begin
                if(ce)
                begin
                    pipe_add2[i][A_len+B_len-1 : 0] <= pipe_add1[i*2][A_len+B_len-1 : 0] + pipe_add1[i*2+1][A_len+B_len-1 : 0];
                end
            end
        end
    end

    /* valid signal process*/
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            a_valid_4 <= 0;
            b_valid_4 <= 0;
        end else begin
            if(ce)
            begin
                a_valid_4 <= a_valid_3;
                b_valid_4 <= b_valid_3;
            end
        end
    end
end
endgenerate
    

/* Pipeline4 */
reg [A_len+B_len-1 : 0] pipe_add3[(2**(add_level-3)) - 1 : 0];
reg sign_pipe4;
reg a_valid_5;
reg b_valid_5;

generate
if(pipeline_level > 3)
begin: pipe4
    /* signed signal process */
    if(singed == "true")
    begin:pipe4_sign
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                sign_pipe4 <= 0;
            end else begin
                if(ce)
                begin
                    sign_pipe4 <= sign_pipe3;
                end
            end
        end
    end

    /* Multiply core */
    genvar i;
    for(i=0; i < (2**(add_level-3)) ; i=i+1)
    begin:add3
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                pipe_add3[i][A_len+B_len-1 : 0] <= 'h00;
            end else begin
                if(ce)
                begin
                    pipe_add3[i][A_len+B_len-1 : 0] <= pipe_add2[i*2][A_len+B_len-1 : 0] + pipe_add2[i*2+1][A_len+B_len-1 : 0];
                end
            end
        end
    end

    /* valid signal process*/
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            a_valid_5 <= 0;
            b_valid_5 <= 0;
        end else begin
            if(ce)
            begin
                a_valid_5 <= a_valid_4;
                b_valid_5 <= b_valid_4;
            end
        end
    end
end
endgenerate    

/* Pipeline5 */
reg [A_len+B_len-1 : 0] pipe_add4[(2**(add_level-4)) - 1 : 0];
reg sign_pipe5;
reg a_valid_6;
reg b_valid_6;

generate
if(pipeline_level > 4)
begin: pipe5
    /* signed signal process */
    if(singed == "true")
    begin:pipe5_sign
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                sign_pipe5 <= 0;
            end else begin
                if(ce)
                begin
                    sign_pipe5 <= sign_pipe4;
                end
            end
        end
    end

    /* Multiply core */
    genvar i;
    for(i=0; i < (2**(add_level-4)) ; i=i+1)
    begin:add4
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                pipe_add4[i][A_len+B_len-1 : 0] <= 'h00;
            end else begin
                if(ce)
                begin
                    pipe_add4[i][A_len+B_len-1 : 0] <= pipe_add3[i*2][A_len+B_len-1 : 0] + pipe_add3[i*2+1][A_len+B_len-1 : 0];
                end
            end
        end
    end

    /* valid signal process*/
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            a_valid_6 <= 0;
            b_valid_6 <= 0;
        end else begin
            if(ce)
            begin
                a_valid_6 <= a_valid_5;
                b_valid_6 <= b_valid_5;
            end
        end
    end
end
endgenerate  

/* Pipeline6 */
reg [A_len+B_len-1 : 0] pipe_add5[(2**(add_level-5)) - 1 : 0];
reg sign_pipe6;
reg a_valid_7;
reg b_valid_7;

generate
if(pipeline_level > 5)
begin: pipe6
    /* signed signal process */
    if(singed == "true")
    begin:pipe6_sign
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                sign_pipe6 <= 0;
            end else begin
                if(ce)
                begin
                    sign_pipe6 <= sign_pipe5;
                end
            end
        end
    end

    /* Multiply core */
    genvar i;
    for(i=0; i < (2**(add_level-5)) ; i=i+1)
    begin:add4
        always @(posedge clk or negedge rst_n) 
        begin
            if(!rst_n)
            begin
                pipe_add5[i][A_len+B_len-1 : 0] <= 'h00;
            end else begin
                if(ce)
                begin
                    pipe_add5[i][A_len+B_len-1 : 0] <= pipe_add4[i*2][A_len+B_len-1 : 0] + pipe_add4[i*2+1][A_len+B_len-1 : 0];
                end
            end
        end
    end

    /* valid signal process*/
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            a_valid_7 <= 0;
            b_valid_7 <= 0;
        end else begin
            if(ce)
            begin
                a_valid_7 <= a_valid_6;
                b_valid_7 <= b_valid_6;
            end
        end
    end
end
endgenerate  

/* Output Port */
generate
begin:pipe_out
    case (pipeline_level)
        /* Support: input port A lenth: 1-2  */
        2: begin
            assign S = (singed == "true") ?  (sign_pipe2) ?
                                            (~pipe_add1[0][A_len+B_len-1:0]+1)  :
                                            pipe_add1[0][A_len+B_len-1:0]       :
                                pipe_add1[0][A_len+B_len-1 : 0];
            assign S_valid = (a_valid_3 & b_valid_3);
        end
        /* Support: input port A lenth: 3-4  */
        3: begin
            assign S = (singed == "true") ?  (sign_pipe3) ?
                                            (~pipe_add2[0][A_len+B_len-1:0]+1)  :
                                            pipe_add2[0][A_len+B_len-1:0]       : 
                                pipe_add2[0][A_len+B_len-1 : 0];
            assign S_valid = (a_valid_4 & b_valid_4);
        end
        /* Support: input port A lenth: 5-8  */
        4: begin 
            assign S = (singed == "true") ?  (sign_pipe4) ?
                                            (~pipe_add3[0][A_len+B_len-1:0]+1)  :
                                            pipe_add3[0][A_len+B_len-1:0]       : 
                                pipe_add3[0][A_len+B_len-1 : 0];
            assign S_valid = (a_valid_5 & b_valid_5);
        end
        /* Support: input port A lenth: 9-16  */                        
        5: begin 
            assign S = (singed == "true") ?  (sign_pipe5) ?
                                            (~pipe_add4[0][A_len+B_len-1:0]+1)  :
                                            pipe_add4[0][A_len+B_len-1:0]       : 
                                pipe_add4[0][A_len+B_len-1 : 0];
            assign S_valid = (a_valid_6 & b_valid_6);
        end
        /* Support: input port A lenth: 17-32  */ 
        6: begin 
            assign S = (singed == "true") ?  (sign_pipe6) ?
                                            (~pipe_add5[0][A_len+B_len-1:0]+1)  :
                                            pipe_add5[0][A_len+B_len-1:0]       : 
                                pipe_add5[0][A_len+B_len-1 : 0];
            assign S_valid = (a_valid_7 & b_valid_7);
        end
        /* Unsupport: input port A lenth */ 
        default: begin 
            assign S = 0;
            assign S_valid = 0;
        end
    endcase 
end
endgenerate

endmodule

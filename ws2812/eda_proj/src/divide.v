module divide #(
    parameter in0_len = 8,
    parameter in1_len = 8,
    parameter out_len = 8,
    parameter is_signed = "true"
)(
    input clk,
    input clk_ce,
    input rst_n,

    input [in0_len-1 : 0] dividend, //分子
    input dividend_valid,

    input [in1_len-1 : 0] divisor,  //分母
    input divisor_valid,

    output [out_len-1 : 0] quot,    //商
    output [out_len-1 : 0] remd,    //余数   
    output out_valid, 

    output div_by_zero              //除以0标识    
);
/* N/D = Q,R  ====> N = D * Q + R */
/* ===> N - R = E(Q*d^k) */
/* ===> (N - Q<<i) > 0 ? Di = 1 &&& N = (N - Q<<i) */

 /* 
 * 注：正数不用做下面的操作
 * 补码------------>------------->原码（去符号） ----->>>符号位已经被取反,可以直接直接忽略
 *       取反           +1
 * 源码------------>------------->补码（补符号） ----->>>符号已经置位
 *       取反           +1  
 * 例： 0: 取反=1111_1111, +1=0000_0000
 *      1: 取反=1111_1110, +1=1111_1111=0xff = -1
 */

localparam max_len = (in0_len > in1_len+out_len)? in0_len : in1_len+out_len;

/* 每级的被除数 */
reg [in0_len-1 : 0] i_dividend[0:out_len];
reg i_dividend_valid[0:out_len];
/* 每级的除数 */
reg [in1_len-1 : 0] i_divisor[0:out_len];
reg i_divisor_valid[0:out_len];
/* 每级的商 */
reg [out_len-1 : 0] i_quot[0:out_len-1];
/* 每级的减法结果 */
wire [max_len:0]    sub[0:out_len-1];
/* 符号 */
reg sign[0:out_len]; 
/* 输出的寄存器 */
reg [out_len-1 : 0] out_quot;
reg [out_len-1 : 0] out_remd;
reg i_out_valid;
/* 除以0 */
reg div_zero;

assign quot = out_quot;
assign remd = out_remd;
assign out_valid = i_out_valid;
assign div_by_zero = div_zero;


generate
begin:input_process
    /* Input & sign process */
    if(is_signed == "true")
    begin
        always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
            begin
                i_dividend[0][in0_len-1 : 0] <= 0;
                i_divisor[0][in1_len-1 : 0] <= 0;
                sign[0] <= 1'b0;
            end else begin
                if(clk_ce)
                begin
                    sign[0] <= dividend[in0_len-1] ^ divisor[in1_len-1];

                    if(dividend[in0_len-1])
                    begin
                        i_dividend[0][in0_len-1 : 0] <= (~dividend[in0_len-1 : 0] + 1);
                    end else begin
                        i_dividend[0][in0_len-1 : 0] <= dividend;
                    end

                    if(divisor[in1_len-1])
                    begin
                        i_divisor[0][in1_len-1 : 0] <= (~divisor[in1_len-1 : 0] + 1);
                    end else begin
                        i_divisor[0][in1_len-1 : 0] <= divisor;
                    end
                end 
            end
        end
    end else begin
        always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
            begin
                i_dividend[0][in0_len-1 : 0] <= 0;
                i_divisor[0][in1_len-1 : 0] <= 0;
                sign[0] <= 1'b0;
            end else begin
                if(clk_ce)
                begin
                    i_dividend[0][in0_len-1 : 0] <= dividend;
                    i_divisor[0][in1_len-1 : 0] <= divisor;
                    sign[0] <= 1'b0;
                end
            end
        end
    end

    /* Data Valid Process */
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i_dividend_valid[0] <= 0;
            i_divisor_valid[0] <= 0;
        end else begin
            if(clk_ce)
            begin
                i_dividend_valid[0] <= dividend_valid;
                i_divisor_valid[0]  <= divisor_valid;
            end
        end
    end
end
endgenerate

/*
    分子-分母<<0  -- 分子-分母<<1 -- ..... 分子-分母<<len(分子）
              分子 => 分子
*/
/* PipeLine */
genvar i;
generate 
    for (i = 0; i < out_len; i = i + 1)
    begin : loop

        assign sub[i][max_len:0] = i_dividend[i][in0_len-1 : 0] - (i_divisor[i] << (out_len-1 -i));

        always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
            begin
                i_dividend[i+1][in0_len-1 : 0] <= 0;
                i_divisor[i+1][in1_len-1 : 0] <= 0;
                i_quot[i][out_len-1 : 0] <= 0;
            end else begin
                if(clk_ce)
                begin
                    i_divisor[i+1][in1_len-1 : 0] <= i_divisor[i][in1_len-1 : 0];   //被除数移动到下一级pipeline
                    
                    if(i_divisor[i][in1_len-1 : 0] == 0)
                    begin
                        i_dividend[i+1][in0_len-1 : 0] <= 0;
                        i_quot[i][out_len-1 : 0] <= 0; 
                    end else begin
                        if(sub[i][max_len] == 1) //N < Di*Q
                        begin
                            i_dividend[i+1][in0_len-1 : 0] <= i_dividend[i][in0_len-1 : 0]; //被除数保留
                            if(i == 0)
                                i_quot[i][out_len-1 : 0] <= 0;         
                            else
                                i_quot[i][out_len-1 : 0] <= i_quot[i-1][out_len-1 : 0];         //商不变（被除数小于除数）
                        end else begin  //N > Di*Q
                            i_dividend[i+1][in0_len-1 : 0] <= sub[i][in0_len-1 : 0];           //余数为相减
                            if(i == 0)
                                i_quot[i][out_len-1 : 0] <= (1 << (out_len-1));
                            else
                                i_quot[i][out_len-1 : 0] <= i_quot[i-1][out_len-1 : 0] | (1 << (out_len-1 -i)); //商置位
                        end
                    end
                end
            end
        end

        /* signed signal process */
        if(is_signed == "true")
        begin
            always@(posedge clk or negedge rst_n)
            begin
                if(!rst_n)
                begin
                    sign[i+1] <= 1'b0;
                end else begin
                    if(clk_ce)
                    begin
                        sign[i+1] <= sign[i];
                    end
                end
            end
        end

        /* Data Valid Process */
        always@(posedge clk or negedge rst_n)
        begin
            if(!rst_n)
            begin
                i_dividend_valid[i+1] <= 0;
                i_divisor_valid[i+1] <= 0;
            end else begin
                if(clk_ce)
                begin
                    i_dividend_valid[i+1] <= i_dividend_valid[i];
                    i_divisor_valid[i+1]  <= i_divisor_valid[i];
                end
            end
        end
    end
endgenerate

/* Output Process */
generate
if(is_signed == "true")
begin
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            out_quot <= 0;
            out_remd <= 0;
            div_zero <= 1'b0;
            i_out_valid <= 1'b0;
        end else begin
            if(clk_ce)
            begin
                if(i_divisor[out_len][in1_len-1 : 0] == 0)
                begin
                    out_quot <= 0;
                    out_remd <= 0;
                    div_zero <= 1'b1;
                end else begin
                    div_zero <= 1'b0;
                    if(sign[out_len] == 1)
                    begin
                        out_quot <= (~i_quot[out_len-1][out_len-1 : 0] + 1);
                        out_remd <= (~i_dividend[out_len][out_len-1 : 0] + 1);
                    end else begin
                        out_quot <= i_quot[out_len-1][out_len-1 : 0];
                        out_remd <= i_dividend[out_len][out_len-1 : 0];
                    end
                end

                i_out_valid <= i_dividend_valid[out_len] & i_divisor_valid[out_len];
            end
        end
    end
end else begin
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            out_quot <= 0;
            out_remd <= 0;
            div_zero <= 1'b0;
            i_out_valid <= 1'b0;
        end else begin
            if(clk_ce)
            begin
                if(i_divisor[out_len][in1_len-1 : 0] == 0)
                begin
                    out_quot <= 0;
                    out_remd <= 0;
                    div_zero <= 1'b1;
                end else begin
                    out_quot <= i_quot[out_len-1][out_len-1 : 0];
                    out_remd <= i_dividend[out_len][out_len-1 : 0];
                    div_zero <= 1'b0;
                end

                i_out_valid <= i_dividend_valid[out_len] & i_divisor_valid[out_len];
            end
        end
    end
end
endgenerate

endmodule
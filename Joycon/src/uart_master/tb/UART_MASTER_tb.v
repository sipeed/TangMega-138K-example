
`timescale 1ns/1ps
module tb () ;
    reg I_CLK ; 
    reg rst_n ; 
    reg key2 ; 
    wire tx_o ; 
    reg rx_o ; 
    reg state_flag = 0 ; 
    reg error_flag = 0 ; 
    wire start ; 
    wire [(8 - 1):0] O_RDATA ; 
    reg I_TX_EN ; 
    reg [2:0] I_WADDR ; 
    reg [(8 - 1):0] I_WDATA ; 
    reg I_RX_EN ; 
    reg [2:0] I_RADDR ; 
    wire DDIS ; 
    wire INTR ; 
    wire RxRDYn ; 
    wire TxRDYn ; 
    wire DCDn ; 
    wire CTSn ; 
    wire DSRn ; 
    wire RIn ; 
    wire DTRn ; 
    wire RTSn ; 
    wire rstn1 ; 
    reg [7:0] delay_rst = 0 ; 
    reg [7:0] delay_key2 = 0 ; 
    reg [15:0] counter0 ; 
    reg clk_en ; 
    reg [7:0] lsr_wr ; 
    reg [7:0] rd_data ; 
    reg start_dl ; 
    reg receive_flag ; 
    reg [3:0] wr_cntl ; 
    reg [3:0] wr_reg ; 
    reg [3:0] wr_index ; 
    reg [3:0] wr_rd_reg ; 
    GSR GSR (.GSRI(1'b1)) ; 
    assign rstn1 = (&{delay_rst[5],(!delay_rst[4]),(!delay_rst[3]),(!delay_rst[2]),(!delay_rst[1]),(!delay_rst[0])}) ; 
    assign start = (&{delay_key2[5],(!delay_key2[4]),(!delay_key2[3]),(!delay_key2[2]),(!delay_key2[1]),(!delay_key2[0])}) ; 
    initial
        begin
            I_CLK = 0 ;
            counter0 = 0 ;
            forever
                #(10) I_CLK = (~I_CLK) ;
        end
    always
        @(posedge I_CLK)
        if ((counter0 == 16'd49999)) 
            begin
                counter0 <=  16'd0 ;
                clk_en <=  1'b1 ;
            end
        else
            begin
                counter0 <=  (counter0 + 16'd1) ;
                clk_en <=  1'b0 ;
            end
    always
        @(posedge I_CLK)
        if ((clk_en == 1'b1)) 
            begin
                delay_rst[7:1] <=  delay_rst[6:0] ;
                delay_rst[0] <=  rst_n ;
            end
    always
        @(posedge I_CLK)
        if ((clk_en == 1'b1)) 
            begin
                delay_key2[7:1] <=  delay_key2[6:0] ;
                delay_key2[0] <=  key2 ;
            end
    initial
        begin
            rst_n = 1 ;
            key2 = 1 ;
            #(2000000) ;
            rst_n = 0 ;
            #(6000000) ;
            rst_n = 1 ;
            #(2000000) ;
            key2 = 0 ;
            #(6000000) ;
            key2 = 1 ;
            #(2000000) ;
            key2 = 0 ;
            #(6000000) ;
            key2 = 1 ;
            #(2000000) ;
            key2 = 0 ;
            #(6000000) ;
            key2 = 1 ;
            #(2000000) ;
            $finish  ;
        end
    always
        @(negedge rst_n or posedge I_CLK)
        begin
            if ((!rst_n)) 
                start_dl <=  1'b0 ;
            else
                start_dl <=  start ;
        end
    always
        @(posedge I_CLK)
        begin
            rx_o = tx_o ;
        end
    always
        @(negedge rst_n or posedge I_CLK)
        begin
            if ((!rst_n)) 
                begin
                    I_TX_EN <=  1'b0 ;
                    I_WADDR <=  3'b0 ;
                    I_WDATA <=  {8{1'b0}} ;
                    I_RX_EN <=  1'b0 ;
                    I_RADDR <=  3'b0 ;
                    wr_index <=  0 ;
                    wr_cntl <=  0 ;
                    wr_reg <=  0 ;
                    wr_rd_reg <=  0 ;
                    lsr_wr <=  0 ;
                    rd_data <=  0 ;
                    state_flag <=  1'b0 ;
                    error_flag <=  1'b0 ;
                    receive_flag <=  1'b0 ;
                end
            else
                begin
                    if ((wr_index == 0)) 
                        begin
                            case (wr_cntl)
                            0 : 
                                if (((start_dl == 1'b0) && (start == 1'b1))) 
                                    begin
                                        I_TX_EN <=  1'b1 ;
                                        I_WADDR <=  3'b011 ;
                                        I_WDATA <=  8'h2b ;
                                        wr_cntl <=  1 ;
                                    end
                                else
                                    begin
                                        I_TX_EN <=  1'b0 ;
                                        wr_cntl <=  0 ;
                                    end
                            1 : 
                                begin
                                    I_TX_EN <=  1'b0 ;
                                    I_WADDR <=  3'b000 ;
                                    I_WDATA <=  8'h00 ;
                                    wr_cntl <=  2 ;
                                end
                            2 : 
                                begin
                                    wr_index <=  1 ;
                                    wr_cntl <=  0 ;
                                end
                            endcase 
                        end
                    else
                        if ((wr_index == 1)) 
                            begin
                                case (wr_rd_reg)
                                0 : 
                                    begin
                                        I_RX_EN <=  1'b1 ;
                                        I_RADDR <=  3'b101 ;
                                        wr_rd_reg <=  1 ;
                                    end
                                1 : 
                                    begin
                                        I_RX_EN <=  1'b0 ;
                                        wr_rd_reg <=  2 ;
                                    end
                                2 : 
                                    begin
                                        rd_data <=  O_RDATA ;
                                        wr_rd_reg <=  3 ;
                                    end
                                3 : 
                                    begin
                                        if ((rd_data[6] == 1'b1)) 
                                            begin
                                                wr_rd_reg <=  0 ;
                                                wr_index <=  2 ;
                                            end
                                        else
                                            begin
                                                wr_rd_reg <=  0 ;
                                                wr_index <=  1 ;
                                            end
                                    end
                                endcase 
                            end
                        else
                            if ((wr_index == 2)) 
                                begin
                                    case (wr_reg)
                                    0 : 
                                        begin
                                            I_TX_EN <=  1'b1 ;
                                            I_WADDR <=  3'b000 ;
                                            I_WDATA <=  8'h06 ;
                                            wr_reg <=  1 ;
                                        end
                                    1 : 
                                        begin
                                            I_TX_EN <=  1'b0 ;
                                            I_WADDR <=  3'b000 ;
                                            I_WDATA <=  8'h00 ;
                                            wr_reg <=  2 ;
                                        end
                                    2 : 
                                        begin
                                            wr_index <=  3 ;
                                            wr_reg <=  0 ;
                                        end
                                    endcase 
                                end
                            else
                                if ((wr_index == 3)) 
                                    begin
                                        case (wr_rd_reg)
                                        0 : 
                                            begin
                                                I_RX_EN <=  1'b1 ;
                                                I_RADDR <=  3'b101 ;
                                                wr_rd_reg <=  1 ;
                                            end
                                        1 : 
                                            begin
                                                I_RX_EN <=  1'b0 ;
                                                wr_rd_reg <=  2 ;
                                            end
                                        2 : 
                                            begin
                                                rd_data <=  O_RDATA ;
                                                wr_rd_reg <=  3 ;
                                            end
                                        3 : 
                                            begin
                                                if ((rd_data[6] == 1'b1)) 
                                                    begin
                                                        wr_rd_reg <=  0 ;
                                                        wr_index <=  4 ;
                                                    end
                                                else
                                                    begin
                                                        wr_rd_reg <=  0 ;
                                                        wr_index <=  3 ;
                                                    end
                                            end
                                        endcase 
                                    end
                                else
                                    if ((wr_index == 4)) 
                                        begin
                                            case (wr_rd_reg)
                                            0 : 
                                                begin
                                                    I_RX_EN <=  1'b1 ;
                                                    I_RADDR <=  3'b000 ;
                                                    wr_rd_reg <=  1 ;
                                                end
                                            1 : 
                                                begin
                                                    I_RX_EN <=  1'b0 ;
                                                    wr_rd_reg <=  2 ;
                                                end
                                            2 : 
                                                begin
                                                    state_flag <=  1'b1 ;
                                                    rd_data <=  O_RDATA ;
                                                    wr_rd_reg <=  3 ;
                                                end
                                            3 : 
                                                begin
                                                    wr_rd_reg <=  0 ;
                                                    wr_index <=  0 ;
                                                    if ((receive_flag == 1'b1)) 
                                                        begin
                                                            if ((rd_data != 6)) 
                                                                begin
                                                                    error_flag <=  1'b1 ;
                                                                end
                                                        end
                                                    else
                                                        begin
                                                            error_flag <=  1'b0 ;
                                                            receive_flag <=  1'b1 ;
                                                        end
                                                end
                                            endcase 
                                        end
                end
        end
    initial
        begin
            #(34000000) ;
            $finish  ;
        end
    uart_core u_UART_MASTER_Top (.I_CLK(I_CLK), .I_RESETN(rst_n), .I_TX_EN(I_TX_EN), .I_WADDR(I_WADDR), .I_WDATA(I_WDATA), .I_RX_EN(I_RX_EN), .I_RADDR(I_RADDR), .O_RDATA(O_RDATA), .DDIS(DDIS), .INTR(INTR), .SIN(rx_o), .RxRDYn(RxRDYn), .SOUT(tx_o), .TxRDYn(TxRDYn), .DCDn(DCDn), 
                .CTSn(CTSn), .DSRn(DSRn), .RIn(RIn), .DTRn(DTRn), .RTSn(RTSn)) ; 
endmodule



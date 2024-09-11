`timescale 1ns/1ns
   

module uart_fsm #(
    //UART Register Value Param
    parameter Reg_LCR_VAL = 8'h03,    //8n1
    parameter Reg_MCR_VAL = 8'h00     //Modem mode not used
)(
    input clk,
    input rst_n,

    /* UART SRAM Interface */
    output reg uart_we,
    output reg [2:0] uart_waddr,  
    output reg [7:0] uart_wdata, 
    output reg uart_rd,
    output reg [2:0] uart_raddr,
    input      [7:0] uart_rdata,

    /* DataStream Interface */
    input [7:0] tx_data,
    input       tx_data_valid,
    output reg  tx_data_ready,

    output reg [7:0] rx_data,
    output reg       rx_data_valid,
    input            rx_data_ready
 );

    //UART Register Address Param
    localparam ADDR_RBR = 3'h0;  //Address of Receive Buffer Register
    localparam ADDR_THR = 3'h0;  //Address of Send Buffer Register
    localparam ADDR_IER = 3'h1;  //Address of Interrupt Enable Register
    localparam ADDR_IIR = 3'h2;  //Address of Interrupt Indicate Register
    localparam ADDR_LCR = 3'h3;  //Address of Line control Register
    localparam ADDR_MCR = 3'h4;  //Address of Modem Control Register
    localparam ADDR_LSR = 3'h5;  //Address of Line State Register
    localparam ADDR_MSR = 3'h6;  //Address of Modem state Register

    /* FSM Start */
    reg [7:0] step;
    reg [2:0] fsm_state;

        //FSM States
    localparam UART_IPCORE_INIT     = 3'b000;
    localparam UART_CORE_IDLE       = 3'b001;
    localparam UART_WAIT_SEND_DONE  = 3'b011;
    localparam UART_CHECK_RXBUF     = 3'b101;
    localparam UART_RECEIVE         = 3'b100;

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
                //UART SRAM Interface
            uart_we     <= 0;
            uart_waddr  <= 0;
            uart_wdata  <= 0;
            uart_rd     <= 0;
            uart_raddr  <= 0;
                //Uart_FSM
            step <= 0;
            fsm_state <= UART_IPCORE_INIT;
                //Interface
            tx_data_ready <= 0;
            rx_data <= 0;
            rx_data_valid <= 0;
        end else begin
            case(fsm_state)
            UART_IPCORE_INIT:
            begin
                if(step == 1) begin //UART IP Init Done
                        // Set MCR
                    uart_we <= 1;
                    uart_waddr <= ADDR_MCR;
                    uart_wdata <= Reg_MCR_VAL;
                    uart_rd <= 0;
                    uart_raddr <= 0;
                        // User interface Ready
                    tx_data_ready <= 1;
                    rx_data <= 0;
                    rx_data_valid <= 0;
                        // Jump to IDLE
                    fsm_state <= UART_CORE_IDLE;
                    step <= 0;
                end else begin
                        // Set LCR
                    uart_we <= 1;
                    uart_waddr <= ADDR_LCR;
                    uart_wdata <= Reg_LCR_VAL;
                    uart_rd <= 0;
                    uart_raddr <= 0;
                        // User interface not ready
                    tx_data_ready <= 0;
                    rx_data <= 0;
                    rx_data_valid <= 0;
                        // Next Setting
                    fsm_state <= fsm_state;
                    step <= step + 1;
                end
            end
            UART_CORE_IDLE:
            begin
                step <= 0;
                rx_data <= rx_data;
                rx_data_valid <= 0;

                if(tx_data_ready && tx_data_valid)  //TX
                begin
                        //Write TX BUF
                    uart_we <= 1;
                    uart_waddr <= ADDR_THR;
                    uart_wdata <= tx_data;
                    uart_rd <= 0;
                    uart_raddr <= 0;

                    tx_data_ready <= 0;
                    
                    fsm_state <= UART_WAIT_SEND_DONE;
                end else if(rx_data_ready)  //RX
                begin
                    uart_we <= 0;
                    uart_waddr <= 0;
                    uart_wdata <= 0;
                    uart_rd <= 1;
                    uart_raddr <= ADDR_LSR;

                    tx_data_ready <= 0; 

                    fsm_state <= UART_CHECK_RXBUF;
                end else begin
                    uart_we <= 0;
                    uart_waddr <= 0;
                    uart_wdata <= 0;
                    uart_rd <= 0;
                    uart_raddr <= 0;

                    tx_data_ready <= 1;
                    
                    fsm_state <= fsm_state;
                end
            end
            UART_WAIT_SEND_DONE:
            begin
                rx_data <= rx_data;
                rx_data_valid <= 0;

                //if(step == 4 && uart_rdata[5] == 1) begin    //TX FIFO Empty, turn to next_state
                if(step == 4 && uart_rdata[6] == 1) begin    //TX FIFO Empty, turn to next_state
                    uart_we <= 0;
                    uart_waddr <= 0;
                    uart_wdata <= 0;
                    uart_rd <= 0;
                    uart_raddr <= 0;

                    step <= 0;
                    tx_data_ready <= 1; 
                    fsm_state <= UART_CORE_IDLE;
                end else begin
                    uart_we <= 0;
                    uart_waddr <= 0;
                    uart_wdata <= 0;
                    uart_rd <= 1;
                    uart_raddr <= ADDR_LSR;

                    if(step < 4)    // Read command Need to wait 3 clk
                        step <= step + 1;
                    else
                        step <= 4;

                    tx_data_ready <= 0; 

                    fsm_state <= fsm_state;
                end
            end
            UART_CHECK_RXBUF:
            begin
                rx_data <= rx_data;
                rx_data_valid <= 0;
                tx_data_ready <= 0; 

                if(step == 3 && uart_rdata[0] == 1) begin    //RX FIFO Not Empty, Perform Read
                    uart_we <= 0;
                    uart_waddr <= 0;
                    uart_wdata <= 0;
                    uart_rd <= 1;
                    uart_raddr <= ADDR_RBR;

                    step <= 0;
                    fsm_state <= UART_RECEIVE;
                end else begin
                    uart_we <= 0;
                    uart_waddr <= 0;
                    uart_wdata <= 0;
                    uart_rd <= 1;
                    uart_raddr <= ADDR_LSR;

                    if(step < 3)    // Read command Need to wait 2 clk(first READ LSR in IDLE)
                        step <= step + 1;
                    else
                        step <= 3;
                    fsm_state <= fsm_state;
                end
            end
            UART_RECEIVE:
            begin
                uart_we <= 0;
                uart_waddr <= 0;
                uart_wdata <= 0;
                uart_rd <= 0;
                uart_raddr <= 0;

                tx_data_ready <= 0; 

                if(rx_data_ready && rx_data_valid)
                begin
                    rx_data <= rx_data;
                    rx_data_valid <= 0;
                    step <= 0;
                    fsm_state <= UART_CORE_IDLE;
                end else begin
                    if(step == 3)
                    begin
                        rx_data <= uart_rdata;
                        rx_data_valid <= 1;
                        step <= step + 1;
                    end else if(step == 4)
                    begin
                        rx_data <= rx_data;
                        rx_data_valid <= rx_data_valid;
                        step <= step;
                    end else begin
                        rx_data <= rx_data;
                        rx_data_valid <= rx_data_valid;
                        step <= step + 1;
                    end
                    fsm_state <= fsm_state;
                end
            end
            default:
            begin
                
            end
            endcase
        end
    end
  
endmodule



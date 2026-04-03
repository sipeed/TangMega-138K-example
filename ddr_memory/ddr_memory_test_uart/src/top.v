module top(
    input                       clk,
    input                       key1_F4,
    input                       uart_rx,
    output                      uart_tx,

    output                      led_V13,
    output [15-1:0]             ddr_addr,       //ROW_WIDTH=15
    output [3-1:0]              ddr_bank,       //BANK_WIDTH=3
    output                      ddr_cs,
    output                      ddr_ras,
    output                      ddr_cas,
    output                      ddr_we,
    output                      ddr_ck,
    output                      ddr_ck_n,
    output                      ddr_cke,
    output                      ddr_odt,
    output                      ddr_reset_n,
    output [4-1:0]              ddr_dm,         //DM_WIDTH=2
    inout  [32-1:0]             ddr_dq,         //DQ_WIDTH=16
    inout  [4-1:0]              ddr_dqs,        //DQS_WIDTH=2
    inout  [4-1:0]              ddr_dqs_n       //DQS_WIDTH=2
);

	localparam DRAM_NUM = 2'd2;

    wire                        app_wdf_wren;
    wire [16*DRAM_NUM-1:0]      app_wdf_mask;    //APP_MASK_WIDTH=16
    wire                        app_wdf_end; 
    wire [128*DRAM_NUM-1:0]     app_wdf_data;    //APP_DATA_WIDTH=128
    wire                        app_en;
    wire [2:0]                  app_cmd;
    wire [29-1:0]               app_addr;        //ADDR_WIDTH=28
    wire                        app_sre_req;
    wire                        app_ref_req;
    wire                        app_burst;
    wire                        app_sre_act;
    wire                        app_ref_ack;
    wire                        app_wdf_rdy;
    wire                        app_rdy;
    wire                        app_rd_data_valid; 
    wire                        app_rd_data_end;
    wire [128*DRAM_NUM-1:0]     app_rd_data;     //APP_DATA_WIDTH=128

    wire                        pll_lock;
    wire                        memory_clk;
    wire                        err;
    wire                        clk_x1;
    wire                        pll_stop;
    wire                        rstni;
    wire                        init_calib_complete;

    reg [7:0]                   rst_n_cnt=8'h00;
    reg                         rst_n=1'b0;

    always @ (posedge clk)
        if (pll_lock) rst_n_cnt   <=  rst_n_cnt   +   1'b1;

    always @ (posedge clk)
        if (rst_n_cnt[7]) rst_n   <=  1'b1;

    key_debounce u_key_debounce (
    .clk(clk), 
    .rst_n(1'b1), 
    .key1_n(!key1_F4), 
    .key_1(rstni)
    );

    reg [31:0] led_cnt;
    reg        led_out;
    reg [7:0]  pwm_cnt;

    always @(posedge clk_x1 or negedge rst_n)
        if (!rst_n)
            pwm_cnt <= 'd0;
        else
            pwm_cnt <= pwm_cnt + 1'b1;

    wire pwm = (pwm_cnt < 8'd64); 

    assign led_V13 = led_out ? ~pwm : 1'b1;  

    wire test_okay  = init_calib_complete && !err;
    wire test_error = init_calib_complete && err;
    always@(posedge clk_x1 or negedge rst_n)
        if(!rst_n)
            led_out <= 1'b0;
        else if(test_okay)
            led_out <= led_cnt[20];
        else if(test_error)
            led_out <= 1'b1;
        else
            led_out <= 1'b0;

    always@(posedge clk_x1 or negedge rst_n)
        if(!rst_n)
            led_cnt <= 'd0;
        else if(init_calib_complete && app_rd_data_valid)begin
            if(led_cnt[21] == 1'b1)
                led_cnt <= 'd0;
            else
                led_cnt <= led_cnt + 1'b1;
        end

    Gowin_PLL Gowin_PLL_inst(
        .lock(pll_lock), 
        .clkout0(), 
        .clkout1(), 
        .clkout2(memory_clk),
        .clkin(clk), 
        .init_clk(clk),
        .reset(!rstni),
        .enclk0(1'b1),      //input enclk0
        .enclk1(1'b1),      //input enclk1
        .enclk2(pll_stop)   //input enclk2
    );

    ddr3_test1 #(
        .ADDR_WIDTH(29) ,                   //ADDR_WIDTH=28
        .APP_DATA_WIDTH(128*DRAM_NUM) ,     //APP_DATA_WIDTH=128
        .APP_MASK_WIDTH (16*DRAM_NUM),      //APP_MASK_WIDTH=16
        .USER_REFRESH("OFF")
        )u_rd(
        .clk                (clk_x1),
        .rst                (~init_calib_complete),  
        .app_rdy            (app_rdy),
        .app_en             (app_en),
        .app_cmd            (app_cmd),
        .app_addr           (app_addr),
        .app_wdf_data       (app_wdf_data),
        .app_wdf_wren       (app_wdf_wren),
        .app_wdf_end        (app_wdf_end),
        .app_wdf_mask       (app_wdf_mask),
        .app_burst          (app_burst),
        .app_rd_data_valid  (app_rd_data_valid),
        .app_rd_data        (app_rd_data), 
        .init_calib_complete(init_calib_complete),
        .wr_data_rdy        (app_wdf_rdy),
        .sr_req             (sr_req),
        .error              (err),
        .ref_req            (ref_req)
        );

    DDR3_Memory_Interface_Top u_ddr3 (
        .memory_clk      (memory_clk),
        .pll_stop        (pll_stop),
        .clk             (clk),
        .rst_n           (rstni),   //rst_n
        //.app_burst_number(0),
        .cmd_ready       (app_rdy),
        .cmd             (app_cmd),
        .cmd_en          (app_en),
        .addr            (app_addr),
        .wr_data_rdy     (app_wdf_rdy),
        .wr_data         (app_wdf_data),
        .wr_data_en      (app_wdf_wren),
        .wr_data_end     (app_wdf_end),
        .wr_data_mask    (app_wdf_mask),
        .rd_data         (app_rd_data),
        .rd_data_valid   (app_rd_data_valid),
        .rd_data_end     (app_rd_data_end),
        .sr_req          (1'b0),
        .ref_req         (1'b0),
        .sr_ack          (app_sre_act),
        .ref_ack         (app_ref_ack),
        .init_calib_complete(init_calib_complete),
        .clk_out         (clk_x1),
        .pll_lock        (pll_lock), 
        //.pll_lock        (1'b1), 
        //`ifdef ECC
        //.ecc_err         (ecc_err),
        //`endif
        .burst           (app_burst),
        // mem interface
        .ddr_rst         (ddr_rst),
        .O_ddr_addr      (ddr_addr),
        .O_ddr_ba        (ddr_bank),
        .O_ddr_cs_n      (ddr_cs),
        .O_ddr_ras_n     (ddr_ras),
        .O_ddr_cas_n     (ddr_cas),
        .O_ddr_we_n      (ddr_we),
        .O_ddr_clk       (ddr_ck),
        .O_ddr_clk_n     (ddr_ck_n),
        .O_ddr_cke       (ddr_cke),
        .O_ddr_odt       (ddr_odt),
        .O_ddr_reset_n   (ddr_reset_n),
        .O_ddr_dqm       (ddr_dm),
        .IO_ddr_dq       (ddr_dq),
        .IO_ddr_dqs      (ddr_dqs),
        .IO_ddr_dqs_n    (ddr_dqs_n)
    );

    wire uart_rstn = rstni & test_okay;
    UART_Top #(
        .SEND_DELAY (1      ),
        .FIFO_DEPTH (64     ),
        .CLK_FRE    (50     ),
        .BAUD_RATE  (115200 )
    )u_uart(
        .clk        (clk        ),
        .rst_n      (uart_rstn  ),
        .uart_tx    (uart_tx    ),
        .uart_rx    (uart_rx    )
    );
    

endmodule

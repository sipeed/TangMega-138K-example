`include "top_define.v"

module top(   
    input           sys_clk_p,
    input           pcie_rstn,
    input           rst_n,

    output [3:0]    led
);

    localparam PCIE_DLY = 8;//25~500ms
    localparam PERST_DLY = 25;
    localparam RUN_DLY = 23;
    localparam SYS_RST_DLY = 20;


/* Clocks & Reset */
    // Clocks
    wire        sys_clk;
    /* synthesis syn_keep = 1 */
    wire        cfg_clk;   
    /* synthesis syn_keep = 1 */      
    wire        div_clk;         
    wire        tlp_clk;
    wire        pll_100m_clk, pll_200m_clk, o_pll_lock;

    // CLOCK input
    Gowin_PLL u_pll (
        .lock      ( o_pll_lock    ),
        .clkout0   ( pll_100m_clk  ),
        .clkout1   ( pll_200m_clk  ),
        .clkin     ( sys_clk_p     )
    );
    assign sys_clk = pll_200m_clk;
    
    CLKDIV #(
        .DIV_MODE("2")
    ) uut_div2 (
        div_clk, 
        'b0, 
        sys_clk, 
        'b1
    );

    assign cfg_clk = div_clk;
    assign tlp_clk = div_clk;

    // Reset generate
    reg [26:0]  pcie_st_cnt = 0;
    reg [26:0]  run_cnt     = 0;
    reg [26:0]  perst_cnt   = 0;
    reg [SYS_RST_DLY:0] sys_rst_cnt = 0;

    wire w_rst_n = rst_n & pcie_rstn;
    wire pcie_start;
    wire tlp_rst = !pcie_start;

    
    // PCIE Start Delay 
    always @ (posedge cfg_clk or negedge w_rst_n)
        if (!w_rst_n)                       
            sys_rst_cnt <= 0;
        else if (!sys_rst_cnt[SYS_RST_DLY]) 
            sys_rst_cnt <= sys_rst_cnt + 2'd1;

    wire rstn = sys_rst_cnt[SYS_RST_DLY];
    
    wire rstn = pcie_rstn;

    always @ (posedge cfg_clk or negedge rstn)
        if (!rstn)                      
            perst_cnt   <= 0;
        else if (!perst_cnt[PERST_DLY]) 
            perst_cnt   <= perst_cnt+2'd1;

    //
    always @ (posedge cfg_clk or negedge rstn)
        if (!rstn)              
            pcie_st_cnt <= 0;
        else if (!pcie_start)   
            pcie_st_cnt <= pcie_st_cnt+2'd1;

    assign pcie_start = pcie_st_cnt[PCIE_DLY]?1'b1:1'b0;

    // for Led blink
    always @ (posedge cfg_clk or negedge w_rst_n)
        if (!w_rst_n)   
            run_cnt <= 0;
        else            
            run_cnt <= run_cnt+2'd1;

/* Status Output */
    // Status 
    wire        pcie_linkup;
    wire [4:0]  ltssm_status;
    reg         pcie_linkup_r;
    /* synthesis syn_keep = 1 */
    reg  [4:0]  ltssm_status_r;  
    reg  [4:0]  ltssm_status_rr;
    // reg  [7:0]  pmac_linkup_r;

    //Sync to TLP clk
    always @ (posedge tlp_clk)
        pcie_linkup_r <= pcie_linkup;

//leds
    assign  led[0]  = ~run_cnt[RUN_DLY];
    assign  led[1]  = ~perst_cnt[PERST_DLY];
    assign  led[2]  = ~pcie_start;
    assign  led[3]  = ~pcie_linkup_r;



/****************** PCIE IP TLP **********************/

    // PCIE IP Main RX TLP
    wire                tl_rx_sop           /* synthesis syn_preserve = 1 */;
    wire                tl_rx_eop           /* synthesis syn_preserve = 1 */;
    wire    [7:0]       tl_rx_valid         /* synthesis syn_preserve = 1 */;
    wire    [255:0]     tl_rx_data          /* synthesis syn_preserve = 1 */;
    wire    [5:0]       tl_bardec           /* synthesis syn_preserve = 1 */;
    // PCIE IP Main TX TLP
    wire                tl_tx_sop           /* synthesis syn_keep = 1 */;
    wire                tl_tx_eop           /* synthesis syn_keep = 1 */;
    wire    [7:0]       tl_tx_valid         /* synthesis syn_keep = 1 */;
    wire    [255:0]     tl_tx_data          /* synthesis syn_keep = 1 */;
    // PCIE IP Main MSI TLP
    wire                tl_int_status       /* synthesis syn_keep = 1 */;
    wire                tl_int_req          /* synthesis syn_keep = 1 */;
    wire    [ 4:0]      tl_int_msinum       /* synthesis syn_keep = 1 */;
    wire    [ 6:0]      tl_int_vfnum        /* synthesis syn_keep = 1 */;
    wire                tl_int_ack          /* synthesis syn_keep = 1 */;
    // PCIE FlowControl
    wire                tl_tx_wait          /* synthesis syn_keep = 1 */;
    // reg                 tl_tx_normal        ;
    // wire                tx_wait             ;
    wire [31:0]         tl_tx_p_credits     /* synthesis syn_keep = 1 */;
    wire [31:0]         tl_tx_np_credits    /* synthesis syn_keep = 1 */;
    wire [31:0]         tl_tx_cpl_credits   /* synthesis syn_keep = 1 */;
    reg  [31:0]         tl_tx_p_credits_r   ;
    reg  [31:0]         tl_tx_np_credits_r  ;
    reg  [31:0]         tl_tx_cpl_credits_r ;
    wire                tx_p_halt   = !tl_tx_p_credits[31]   /* synthesis syn_keep = 1 */;
    wire                tx_np_halt  = !tl_tx_np_credits[31]  /* synthesis syn_keep = 1 */;
    wire                tx_cpl_halt = !tl_tx_cpl_credits[31] /* synthesis syn_keep = 1 */;
    //
    wire [12:0]         tl_cfg_busdev       /* synthesis syn_keep = 1 */;
    wire [15:0]         tl_cfg_devctrl      /* synthesis syn_keep = 1 */;


/******************** PCIE MAIN Logic *****************/
    // BAR 0 ---- Not BAR,  DMA DATA TLP(CPL)
    wire                rx_dma_data_sop          ;
    wire                rx_dma_data_eop          ;
    wire [7:0]          rx_dma_data_valid        ;
    wire [255:0]        rx_dma_data_tlp_data     ;

    // BAR 1 ---- DMA Ctrl TLP
    wire				rx_dma_ctrl_sop			   /* synthesis syn_keep = 1 */;
    wire				rx_dma_ctrl_eop            /* synthesis syn_keep = 1 */;
    wire	[7:0]   	rx_dma_ctrl_valid          /* synthesis syn_keep = 1 */;
    wire	[255:0] 	rx_dma_ctrl_tlp_data       /* synthesis syn_keep = 1 */;
        // DMA ctrl tlp decode data(HEADER)
    wire	[2:0]		rx_dma_ctrl_tlp_fmt         ;
    wire	[4:0]		rx_dma_ctrl_tlp_typ         ;
    wire	[9:0]		rx_dma_ctrl_tlp_len         ;
    wire	[29:0]		rx_dma_ctrl_tlp_addr_l      ;
    wire	[31:0]		rx_dma_ctrl_tlp_addr_h      ;
    wire	[15:0]		rx_dma_ctrl_tlp_req_id      ;
    wire	[7:0]		rx_dma_ctrl_tlp_tag_id      ;
    wire	[31:0]		rx_dma_ctrl_tlp_reg_data    ;
    wire				rx_dma_ctrl_tlp_reg_data_en ;
    wire	[3:0]		rx_dma_ctrl_tlp_cmd         /* synthesis syn_keep = 1 */;
    wire				rx_dma_ctrl_tlp_cmd_en      /* synthesis syn_keep = 1 */;
        // Reply of BAR 1 Memory Read
    wire                cc_dma_ctrl_req             /* synthesis syn_keep = 1 */;
    wire                cc_dma_ctrl_req_end         /* synthesis syn_keep = 1 */;
    wire                cc_dma_ctrl_rd_en           /* synthesis syn_keep = 1 */;
    wire                cc_dma_ctrl_sop             /* synthesis syn_keep = 1 */;
    wire                cc_dma_ctrl_eop             /* synthesis syn_keep = 1 */;
    wire [7:0]          cc_dma_ctrl_rd_valid        /* synthesis syn_keep = 1 */;
    wire [255:0]        cc_dma_ctrl_rd_data         /* synthesis syn_keep = 1 */;

    // BAR 3 ---- Memory Ctrl TLP
    wire				rx_mem_ctrl_sop			   /* synthesis syn_keep = 1 */;
    wire				rx_mem_ctrl_eop            /* synthesis syn_keep = 1 */;
    wire	[7:0]   	rx_mem_ctrl_valid          /* synthesis syn_keep = 1 */;
    wire	[255:0] 	rx_mem_ctrl_tlp_data       /* synthesis syn_keep = 1 */;
        // Memory ctrl tlp decode data(HEADER)
    wire	[2:0]		rx_mem_ctrl_tlp_fmt          ;
    wire	[4:0]		rx_mem_ctrl_tlp_typ          ;
    wire	[9:0]		rx_mem_ctrl_tlp_len          ;
    wire	[29:0]		rx_mem_ctrl_tlp_addr_l       ;
    wire	[31:0]		rx_mem_ctrl_tlp_addr_h       ;
    wire	[15:0]		rx_mem_ctrl_tlp_req_id       ;
    wire	[7:0]		rx_mem_ctrl_tlp_tag_id       ;
    wire	[31:0]		rx_mem_ctrl_tlp_reg_data     ;
    wire				rx_mem_ctrl_tlp_reg_data_en  ;
    wire	[3:0]		rx_mem_ctrl_tlp_cmd          /* synthesis syn_keep = 1 */;
    wire				rx_mem_ctrl_tlp_cmd_en       /* synthesis syn_keep = 1 */;
        // Reply of BAR 3 Memory Read
    wire				cc_mem_req              /* synthesis syn_keep = 1 */;
    wire				cc_mem_req_end          /* synthesis syn_keep = 1 */;
    wire				cc_mem_rd_en            /* synthesis syn_keep = 1 */;
    wire				cc_mem_sop              /* synthesis syn_keep = 1 */;
    wire				cc_mem_eop              /* synthesis syn_keep = 1 */;
    wire	[7:0]   	cc_mem_rd_valid         /* synthesis syn_keep = 1 */;
    wire	[255:0] 	cc_mem_rd_data          /* synthesis syn_keep = 1 */;
    

    
    // Host to Card, BAR Setting Decoded data
    wire [`rq_ch_num-1:0]        req_dma_rd_en;
    wire [`rq_ch_num*32-1:0]     req_dma_rd_addr_l	    /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num*32-1:0]     req_dma_rd_addr_h	    /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num*32-1:0]     req_dma_rd_len		    /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num*8-1:0]      req_dma_rd_tag		    /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num-1:0]        req_dma_rd_valid	    /* synthesis syn_keep = 1 */;
        // TLP of Memory Read Request
    wire [`rq_ch_num-1:0]        rq_req                  /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num-1:0]        rq_rd_en                /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num-1:0]        rq_req_end              /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num-1:0]        rq_sop                  /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num-1:0]        rq_eop                  /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num*8-1:0]      rq_rd_valid             /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num*256-1:0]    rq_rd_data              /* synthesis syn_keep = 1 */;
        // Current DMA request param, used to determin CPLD is needed
    wire [`rq_ch_num-1:0]        rq_cpld_en          /* synthesis syn_keep = 1 */; // 22/1227
    wire [`rq_ch_num*64-1:0]     rq_cpld_addr        /* synthesis syn_keep = 1 */;
    wire [`rq_ch_num*8-1:0]      rq_cpld_tag         ;
    wire [`rq_ch_num*16-1:0]     rq_cpld_req_id      ;
    wire [`rq_ch_num*11-1:0]     rq_cpld_len         /* synthesis syn_keep = 1 */;
        // Decoded CPLD HEADER
    wire [2:0]          rx_cpld_fmt         ;
    wire [4:0]          rx_cpld_typ         ;
    wire [10:0]         rx_cpld_len         ;
    wire [31:0]         rx_cpld_addr_offset ;
    wire [15:0]         rx_cpld_req_id      ;
    wire [7:0]          rx_cpld_tag_id      ;
    wire [255:0]        rx_cpld_data_pld    ;
    wire [7:0]          rx_cpld_data_valid  ;
    
    
    // Card to Host, BAR Setting Decoded data
    wire [`rc_ch_num-1:0]        req_dma_wr_en;
    wire [`rc_ch_num*32-1:0]     req_dma_wr_addr_l       /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num*32-1:0]     req_dma_wr_addr_h       /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num*32-1:0]     req_dma_wr_len          /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num*8-1:0]      req_dma_wr_tag          /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num-1:0]        req_dma_wr_valid        /* synthesis syn_keep = 1 */;
        //	TLP of Memory Write Request
    wire [`rc_ch_num-1:0]        rc_req                  /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num-1:0]        rc_req_end              /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num-1:0]        rc_rd_en                /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num-1:0]        rc_sop                  /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num-1:0]        rc_eop                  /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num*8-1:0]      rc_rd_valid             /* synthesis syn_keep = 1 */;
    wire [`rc_ch_num*256-1:0]    rc_rd_data              /* synthesis syn_keep = 1 */;
    
    
    // DMA In out RAM(CPLD decode data is stored in RAM)
        //Request RAM Read(Start to Read Card RAM and Write to Host RAM)
    wire [`rc_ch_num-1:0]        rc_wr_req_en        /* synthesis syn_keep = 1 */;
        //Address of Card RAM to Read
    wire [`rc_ch_num*64-1:0]     rc_wr_req_addr      /* synthesis syn_keep = 1 */;
        //Length of Card RAM to Read
    wire [`rc_ch_num*12-1:0]     rc_wr_req_len       /* synthesis syn_keep = 1 */;
        //DATA of Card RAM to Read(256b)
    wire [`rc_ch_num*256-1:0]    rc_wr_data_in       /* synthesis syn_keep = 1 */;
        //Data Valid of Card RAM to Read
    wire [`rc_ch_num-1:0]        rc_wr_data_valid    /* synthesis syn_keep = 1 */;
        //Card RAM status
    wire [`rq_ch_num-1:0]        rq_pool_full        /* synthesis syn_keep = 1 */; // 23/0508
    wire [`rq_ch_num-1:0]        rq_pool_empty       /* synthesis syn_keep = 1 */; // 23/0508

    
    //
    //************************************************************//

    // wire [8:0]          dbg_level_max_p     /* synthesis syn_keep = 1 */;
    // wire [4 :0]         dbg_level_max_np    /* synthesis syn_keep = 1 */;

    //******************************************************************************************
    // assign tl_cfg_devctrl = 32'h0001_5930; //Faked. Need te be obtained from IP like tl_cfg_busdev
    // assign tl_cfg_devctrl = { 16'h0000  //! Device Status Register
    //                                     //! Device Control Register
    //                         , 1'b0      // RSV
    //                         , 3'b101    // Max Read Request Size. 000:128 Byte ~ 101:4096 Byte
    //                         , 1'b1      // ENS
    //                         , 1'b0      // APPME
    //                         , 1'b0      // PFE
    //                         , 1'b1      // ETFE
    //                         , 3'b001    // Max Payload Size. 000:128 Byte ~ 101:4096 Byte
    //                         , 1'b1      // ERO
    //                         , 4'b0000   // XRE
    //                         };



/* TLP Rrocess */
    /* RX TLP BAR Decode */
    tlp_bar_demux u_tlp_bar_demux(      // mux tlp packet by bardec
        .clk					(tlp_clk            ),
        .rst					(tlp_rst            ),
    //input tlp(From PCIE Hard Core)
        .rx_sop				    (tl_rx_sop          ),
        .rx_eop				    (tl_rx_eop          ),
        .rx_valid				(tl_rx_valid        ),
        .rx_tlp_data			(tl_rx_data         ),
        .rx_tlp_bardec			(tl_bardec[5:0]     ),
    //output -bar000    dma data(CPLD)
        .rx_dma_sop			    (rx_dma_data_sop         ),
        .rx_dma_eop			    (rx_dma_data_eop         ),
        .rx_dma_valid			(rx_dma_data_valid       ),
        .rx_dma_tlp_data		(rx_dma_data_tlp_data    ),
    //output -bar001(1) 	dma ctrl
        .rx_ctrl_sop			(rx_dma_ctrl_sop        ),
        .rx_ctrl_eop			(rx_dma_ctrl_eop        ),
        .rx_ctrl_valid			(rx_dma_ctrl_valid      ),
        .rx_ctrl_tlp_data		(rx_dma_ctrl_tlp_data   ),
    //output -bar100(3)    mem ctrl
        .rx_mem_sop			    (rx_mem_ctrl_sop         ),
        .rx_mem_eop			    (rx_mem_ctrl_eop         ),
        .rx_mem_valid			(rx_mem_ctrl_valid       ),
        .rx_mem_tlp_data		(rx_mem_ctrl_tlp_data    )
    );
    //


/*********************** BAR 3, just a RAM for MMIO Test *******************/
    // Decode BAR3 TLP
    tlp_dec u_mem_ctrl_tlp_decode(
        .clk				   (tlp_clk				        ),
        .rst                   (tlp_rst				        ),
    // raw tlp input
        .rx_sop                (rx_mem_ctrl_sop				),
        .rx_eop                (rx_mem_ctrl_eop				),
        .rx_valid              (rx_mem_ctrl_valid			),
        .rx_tlp_data           (rx_mem_ctrl_tlp_data		),
    // decode tlp data
        .rx_tlp_fmt            (rx_mem_ctrl_tlp_fmt			),
        .rx_tlp_typ            (rx_mem_ctrl_tlp_typ			),
        .rx_tlp_len            (rx_mem_ctrl_tlp_len			),
        .rx_tlp_addr_l         (rx_mem_ctrl_tlp_addr_l 		),
        .rx_tlp_addr_h         (rx_mem_ctrl_tlp_addr_h		),
        .rx_tlp_req_id         (rx_mem_ctrl_tlp_req_id		),
        .rx_tlp_tag_id         (rx_mem_ctrl_tlp_tag_id		),
        .rx_tlp_reg_data       (rx_mem_ctrl_tlp_reg_data	),
        .rx_tlp_reg_data_en    (rx_mem_ctrl_tlp_reg_data_en	),
        .rx_tlp_cmd            (rx_mem_ctrl_tlp_cmd			),
        .rx_tlp_cmd_en         (rx_mem_ctrl_tlp_cmd_en		)
    );

    // Process BAR MEMORY Write & MEMORY Read
    // Internal is a RAM, When Memory Write, Data is write to RAM
    // When Memory Read, Read RAM and generate a CPLD to Host
    // Only Support 4Byte Read(Complete TLP only 128b)
    cc_ctrl u_cc_ctrl (
        .clk					(tlp_clk                ),
        .rst                    (tlp_rst                ),
        .tl_cfg_busdev			(tl_cfg_busdev          ),
    // Input Request data
        .req_tlp_fmt            (rx_mem_ctrl_tlp_fmt         ),
        .req_tlp_typ            (rx_mem_ctrl_tlp_typ         ),
        .req_tlp_len            (rx_mem_ctrl_tlp_len         ),
        .req_tlp_addr_l         (rx_mem_ctrl_tlp_addr_l      ),
        .req_tlp_addr_h         (rx_mem_ctrl_tlp_addr_h      ),
        .req_tlp_reg_data       (rx_mem_ctrl_tlp_reg_data    ),
        .req_req_id             (rx_mem_ctrl_tlp_req_id      ),
        .req_tag_id             (rx_mem_ctrl_tlp_tag_id      ),
        .req_tlp_reg_data_en    (rx_mem_ctrl_tlp_reg_data_en ),
    //  .req_tlp_data_pld       (rx_mem_ctrl_tlp_data_pld    ),
        .req_tlp_cmd            (rx_mem_ctrl_tlp_cmd         ),
        .req_tlp_cmd_en         (rx_mem_ctrl_tlp_cmd_en      ),
    // Return TX TLP
        .cc_req			        (cc_mem_req             ),
        .cc_req_end		        (cc_mem_req_end         ),
        .cc_rd_en		        (cc_mem_rd_en           ),
        .cc_sop			        (cc_mem_sop             ),
        .cc_eop			        (cc_mem_eop             ),
        .cc_rd_valid	        (cc_mem_rd_valid        ),
        .cc_rd_data		        (cc_mem_rd_data	        )
    );



//*************************   DMA   **************************//
    // RQ: DMA RX,  Host -> FPGA(FPGA Generate Memory Read Request and Receive a CPLD)
    // RC: DMA TX,  FPGA -> Host(FPGA Generate Memory Write to write Host RAM)
    // CC: BAR Memory Read Reply(CPLD)

    // RQ_CC_NUM: number of Complete TLP the CC Buffer can Store
    localparam	RQ_CC_NUM   = 4;
    localparam	RQ_CC_BW    = $clog2(RQ_CC_NUM);

    // Buffer Size of the DMA Command list
    // DMA Can Accept not one DMA Request
    localparam  RQ_DEP      = 4096;
    localparam  RQ_BW       = $clog2(RQ_DEP);
    localparam  RC_DEP      = 4096;
    localparam  RC_BW       = $clog2(RC_DEP);


    /***********  BAR1, DMA Control Register ***************/
        // DMA Ctrl TLP Decode
    tlp_dec u_dma_ctrl_tlp_dec(
        .clk				   (tlp_clk                   ),
        .rst                   (tlp_rst                    ),
            // input DMA Ctrl TLP
        .rx_sop                (rx_dma_ctrl_sop            ),
        .rx_eop                (rx_dma_ctrl_eop            ),
        .rx_valid              (rx_dma_ctrl_valid          ),
        .rx_tlp_data           (rx_dma_ctrl_tlp_data       ),
            // output DMA Ctrl TLP data
        .rx_tlp_fmt            (rx_dma_ctrl_tlp_fmt        ),
        .rx_tlp_typ            (rx_dma_ctrl_tlp_typ        ),
        .rx_tlp_len            (rx_dma_ctrl_tlp_len        ),
        .rx_tlp_addr_l         (rx_dma_ctrl_tlp_addr_l     ),
        .rx_tlp_addr_h         (rx_dma_ctrl_tlp_addr_h     ),
        .rx_tlp_req_id         (rx_dma_ctrl_tlp_req_id     ),
        .rx_tlp_tag_id         (rx_dma_ctrl_tlp_tag_id     ),
        .rx_tlp_reg_data       (rx_dma_ctrl_tlp_reg_data   ),
        .rx_tlp_reg_data_en    (rx_dma_ctrl_tlp_reg_data_en),
        .rx_tlp_cmd            (rx_dma_ctrl_tlp_cmd        ),
        .rx_tlp_cmd_en         (rx_dma_ctrl_tlp_cmd_en     )
    );

    // DMA RX Queue status
    wire [`rq_ch_num-1:0]   rq_idle         = rq_pool_empty[`rq_ch_num-1:0];
    wire [`rq_ch_num-1:0]   rq_queue_empty  ;
    wire [`rq_ch_num-1:0]   rq_queue_full   ;
    wire [(RQ_BW+1)*`rq_ch_num-1:0]  rq_queue_level  ;
    // DMA TX Queue status
    wire [`rc_ch_num-1:0]   rc_idle         ;
    wire [`rc_ch_num-1:0]   rc_queue_empty  ;
    wire [`rc_ch_num-1:0]   rc_queue_full   ;
    wire [(RC_BW+1)*`rq_ch_num-1:0]  rc_queue_level  ;

    // BAR1 Register & DMA Control
    tlp_cmd_if_mult_chn #(
        .RC_CHN_NUM            (`rc_ch_num ),
        .RC_DEP                (RC_DEP     ),
        .RQ_CHN_NUM            (`rq_ch_num ),
        .RQ_DEP                (RQ_DEP     )
    ) u_cmd_if (
        .clk					(tlp_clk                ),
        .rst					(tlp_rst                ),
        .tl_cfg_busdev			(tl_cfg_busdev          ),
    // Register Interface
            //Decoded TLP Header
        .req_tlp_fmt			(rx_dma_ctrl_tlp_fmt		),
        .req_tlp_typ			(rx_dma_ctrl_tlp_typ		),
        .req_tlp_len			(rx_dma_ctrl_tlp_len		),
        .req_tlp_addr_l		    (rx_dma_ctrl_tlp_addr_l 	),
        .req_tlp_addr_h		    (rx_dma_ctrl_tlp_addr_h		),
        .req_req_id			    (rx_dma_ctrl_tlp_req_id		),
        .req_tag_id			    (rx_dma_ctrl_tlp_tag_id		),
        .req_tlp_reg_data		(rx_dma_ctrl_tlp_reg_data	),
        .req_tlp_reg_data_en	(rx_dma_ctrl_tlp_reg_data_en),
        .req_tlp_cmd            (rx_dma_ctrl_tlp_cmd		),
        .req_tlp_cmd_en         (rx_dma_ctrl_tlp_cmd_en		),
            //Reply for Memory Read(Complete)
        .cc_req				    (cc_dma_ctrl_req		),
        .cc_req_end			    (cc_dma_ctrl_req_end	),
        .cc_rd_en				(cc_dma_ctrl_rd_en		),
        .cc_sop				    (cc_dma_ctrl_sop		),
        .cc_eop				    (cc_dma_ctrl_eop		),
        .cc_rd_valid			(cc_dma_ctrl_rd_valid	),
        .cc_rd_data			    (cc_dma_ctrl_rd_data	),
            //MSI TLP
        .tl_int_status		    (tl_int_status          ),
        .tl_int_req		        (tl_int_req             ),
        .tl_int_msinum		    (tl_int_msinum          ),
        .tl_int_vfnum		    (tl_int_vfnum           ),
        .tl_int_ack		        (tl_int_ack             ),
    // DMA Interface
        // DMA Config data(to Control DMA)(all output)
            //Host -> Card
        .req_dma_rd_en          (req_dma_rd_en          ),
        .req_dma_rd_addr_l      (req_dma_rd_addr_l		),
        .req_dma_rd_addr_h      (req_dma_rd_addr_h		),
        .req_dma_rd_len         (req_dma_rd_len			),
        .req_dma_rd_tag         (req_dma_rd_tag			),
        .req_dma_rd_valid       (req_dma_rd_valid		),
            // Card -> Host
        .req_dma_wr_en          (req_dma_wr_en          ),
        .req_dma_wr_addr_l      (req_dma_wr_addr_l		),
        .req_dma_wr_addr_h      (req_dma_wr_addr_h		),
        .req_dma_wr_len         (req_dma_wr_len			),
        .req_dma_wr_tag         (req_dma_wr_tag			),
        .req_dma_wr_valid       (req_dma_wr_valid		),
    //DMA Status IN(Used for internal DMA queue advance & act as a Register)
        //Host -> Card
        .rq_idle                (rq_idle                ),
        .rq_queue_empty         (rq_queue_empty         ),
        .rq_queue_full          (rq_queue_full          ),
        .rq_queue_level         (rq_queue_level         ),
        // Card -> Host
        .rc_idle                (rc_idle                ),
        .rc_queue_empty         (rc_queue_empty         ),
        .rc_queue_full          (rc_queue_full          ),
        .rc_queue_level         (rc_queue_level         ),
    //Current PCIE Bus number, used to generate complete TLP
        .cfg_devctrl            (tl_cfg_devctrl         )
    );


    /****************  Host -> FPGA ******************/
    genvar i;
    generate
    for (i = 0; i < `rq_ch_num; i = i + 1) begin: chn_loop_i
        // Generate TLP Memory Read Request, 
        // and tell cpld decoder requested address, len, tag and so on
        tlp_rq_ctrl # ( 
            .INDEX  (i          ),
            .CC_NUM (RQ_CC_NUM  ),
            .RQ_DEP (RQ_DEP     )
        ) u_tlp_rq (
            .clk                   (tlp_clk                    ),
            .rst                   (tlp_rst                    ),
            .tl_cfg_busdev         (tl_cfg_busdev              ),
            .tl_cfg_devctrl        (tl_cfg_devctrl             ),
                // DMA Config data(to Control DMA)(all input)
            .rq_dma_en             (req_dma_rd_en[i]            ),
            .req_dma_rd_addr_l     (req_dma_rd_addr_l[i*32+:32] ),
            .req_dma_rd_addr_h     (req_dma_rd_addr_h[i*32+:32] ),
            .req_dma_rd_len        (req_dma_rd_len[i*32+:32]    ),
            .req_dma_rd_tag        (req_dma_rd_tag[i*8+:8]      ),
            .req_dma_rd_valid      (req_dma_rd_valid [i]        ),
                // Memory Read TLP(Output to TX TLP MUX)
            .rq_req                (rq_req         [i]         ),   // => Request to send TLP(to TX TLP MUX)
            .rq_req_end            (rq_req_end	   [i]         ),   // => Request end
            .rq_rd_en              (rq_rd_en       [i]         ),   // <= TX TLP MUX is start to receive TLP
            .rq_sop                (rq_sop         [i]         ),   // TLP START OF PACKET
            .rq_eop                (rq_eop         [i]         ),   // TLP END OF PACKET
            .rq_rd_data            (rq_rd_data	[i*256+:256]   ),   // TLP DATA
            .rq_rd_valid           (rq_rd_valid [i*8 +:8]      ),   // TLP DATA DW valid
                //  Flow control
                    // Cmd queue
            .rq_queue_empty        (rq_queue_empty [i]          ),  // Status output, indicate DMA idle
            .rq_queue_full         (rq_queue_full  [i]          ),  // Status output, indicate DMA busy
            .rq_queue_level        (rq_queue_level[i*(RQ_BW+1)+:(RQ_BW+1)] ),   // Status output, indicate Current Command depth
                    // Receive RAM status
            .rq_pool_empty         (rq_pool_empty  [i]         ),   // Not used(empty is not useful for Read)
            .rq_pool_full          (rq_pool_full   [i]         ),   // Stop Generate Request
                // expected CPLD Param
            .rq_req_en             (rq_cpld_en  [i]            ),	// =>
            .rq_req_addr           (rq_cpld_addr[i*64+:64]     ),   // =>
            .rq_req_len            (rq_cpld_len [i*11+:11]     ),   // =>
            .rq_req_tag            (rq_cpld_tag [i*8 +:8 ]     )    // =>
        );

        // Parse Memory Read Complete TLP
        // Check TLP is This DMA, and Receive data into a internal RAM
        // Other Module can read RAM with Address & Length
        tlp_cpld_dec #(
            .INDEX  (i          ),
            .CC_NUM (RQ_CC_NUM  )
        ) u_tlp_cpld_dec(
            .clk                   (tlp_clk                    ),
            .rst                   (tlp_rst                    ),
                // TLP of CPLD
            .rx_sop                (rx_dma_data_sop		       ),
            .rx_eop                (rx_dma_data_eop		       ),
            .rx_valid              (rx_dma_data_valid	       ),
            .rx_tlp_data           (rx_dma_data_tlp_data       ),
                // Current DMA Channel Config, used for check Current TLP is expected
            .rq_cpld_en            (rq_cpld_en     [i]         ),   // <=
            .rq_cpld_addr          (rq_cpld_addr   [i*64+:64]  ),   // <=
            .rq_cpld_tag           (rq_cpld_tag    [i*8 +:8 ]  ),   // <=
            .rq_cpld_req_len       (rq_cpld_len    [i*11+:11]  ),   // <=
            .rq_rd_en              (rq_rd_en       [i]         ),   // <=
                //Current FiFo state
            .rq_pool_empty         (rq_pool_empty  [i]         ),   // => 23/0510
            .rq_pool_full          (rq_pool_full   [i]         ),   // => 23/0510
                //RAM Interface
            .rc_wr_req_en          (rc_wr_req_en   [i]         ),   //<=  RAM RD EN, one time trigger
            .rc_wr_req_addr        (rc_wr_req_addr [i*64+:64]  ),   //<=  RAM RD Address
            .rc_wr_req_len         (rc_wr_req_len  [i*12+:12]  ),   //<=  RAM RD LEN
            .rc_wr_data_out        (rc_wr_data_in  [i*256+:256]),   //=>  RAM RD DATA
            .rc_wr_data_valid      (rc_wr_data_valid[i]        )    //=>  RAM Output DATA valid
        );
    end
    endgenerate


    /********************  FPGA -> Host ************************/
    genvar j;
    generate
    for (j = 0; j < `rc_ch_num; j = j + 1) begin: chn_loop_j
    // Generate TLP Memory Write Request to write data to host
        tlp_rc_ctrl # ( 
            .RC_DEP (RC_DEP)
        )  u_tlp_rc (
            .clk					(tlp_clk        ),
            .rst					(tlp_rst        ),
            .tl_cfg_busdev			(tl_cfg_busdev  ),
            .tl_cfg_devctrl		    (tl_cfg_devctrl ),
                // DMA Config data(to Control DMA)(all input)
            .rc_dma_en              (req_dma_wr_en      [j]         ),
            .req_dma_wr_addr_l		(req_dma_wr_addr_l	[j*32+:32]	),
            .req_dma_wr_addr_h		(req_dma_wr_addr_h	[j*32+:32]	),
            .req_dma_wr_len		    (req_dma_wr_len		[j*32+:32]	),
            .req_dma_wr_tag		    (req_dma_wr_tag		[j*8+:8]	),
            .req_dma_wr_valid		(req_dma_wr_valid	[j]		    ),
                // Memory Write TLP(Output to TX TLP MUX)
            .rc_req				    (rc_req			    [j]		    ),   // =>Request to send TLP(to TX TLP MUX)
            .rc_req_end			    (rc_req_end		    [j]		    ),   // =>Request end
            .rc_rd_en				(rc_rd_en		    [j]		    ),   // <=TX TLP MUX is start to receive TLP
            .rc_sop				    (rc_sop		        [j]			),   // TLP START OF PACKET
            .rc_eop				    (rc_eop		        [j]			),   // TLP END OF PACKET
            .rc_rd_data			    (rc_rd_data	        [j*256+:256]),   // TLP DATA
            .rc_rd_valid			(rc_rd_valid        [j*8 +:8]	),   // TLP DATA DW valid
                // DMA Data Input
            .rc_wr_req_en           (rc_wr_req_en       [j]         ),  // Start to read from RAM
            .rc_wr_req_addr         (rc_wr_req_addr     [j*64+:64]  ),  // RAM Address to read
            .rc_wr_req_len          (rc_wr_req_len      [j*12+:12]  ),  // RAM Length to read
            .rc_wr_data_in          (rc_wr_data_in      [j*256+:256]),
            .rc_wr_data_valid       (rc_wr_data_valid   [j]         ),
                // DMA Status
            .rc_idle                (rc_idle            [j]         ),  // DMA is idle
            .rc_queue_empty         (rc_queue_empty     [j]         ),  // DMA queue is idle
            .rc_queue_full          (rc_queue_full      [j]         ),  // DMA queue is full
            .rc_queue_level         (rc_queue_level[j*(RC_BW+1)+:(RC_BW+1)] )   // 230511   =>
        );
    end
    endgenerate


    /************************* TX TLP MUX *********************************/
    // TX Posted tlp, FPGA -> Host, Memory Write
    wire [`rc_ch_num-1:0]       tx_p_grant          ;
    wire [`rc_ch_num-1:0]       tx_p_req            = {rc_req       [`rc_ch_num-1:0]        };
    wire [`rc_ch_num-1:0]       tx_p_req_end        = {rc_req_end   [`rc_ch_num-1:0]        };
    wire [`rc_ch_num-1:0]       tx_p_req_sop        = {rc_sop       [`rc_ch_num-1:0]        };
    wire [`rc_ch_num-1:0]       tx_p_req_eop        = {rc_eop       [`rc_ch_num-1:0]        };
    wire [`rc_ch_num*8-1:0]     tx_p_req_valid      = {rc_rd_valid  [`rc_ch_num*8-1:0]      };
    wire [`rc_ch_num*256-1:0]   tx_p_req_data       = {rc_rd_data   [`rc_ch_num*256-1:0]    };
    assign rc_rd_en = {{8-`rc_ch_num{1'b0}}, tx_p_grant};   // TLP Send Accept

    // TX Non-Posted TlP, Memory Read Request
    wire [`rq_ch_num-1:0]       tx_np_grant         ;
    wire [`rq_ch_num-1:0]       tx_np_req           = {rq_req       [`rq_ch_num-1:0]        };
    wire [`rq_ch_num-1:0]       tx_np_req_end       = {rq_req_end   [`rq_ch_num-1:0]        };
    wire [`rq_ch_num-1:0]       tx_np_req_sop       = {rq_sop       [`rq_ch_num-1:0]        };
    wire [`rq_ch_num-1:0]       tx_np_req_eop       = {rq_eop       [`rq_ch_num-1:0]        };
    wire [`rq_ch_num*8-1:0]     tx_np_req_valid     = {rq_rd_valid  [`rq_ch_num*8-1:0]      };
    wire [`rq_ch_num*256-1:0]   tx_np_req_data      = {rq_rd_data   [`rq_ch_num*256-1:0]    };
    assign rq_rd_en = {{8-`rq_ch_num{1'b0}}, tx_np_grant};  // TLP Send Accept
    
    // TX Completion TLP, MMIO(BAR MEMORY) READ
    wire [1:0]                  tx_cpl_grant        ;
    wire [1:0]                  tx_cpl_req          = {cc_mem_req       , cc_dma_ctrl_req       };
    wire [1:0]                  tx_cpl_req_end      = {cc_mem_req_end   , cc_dma_ctrl_req_end   };
    wire [1:0]                  tx_cpl_req_sop      = {cc_mem_sop       , cc_dma_ctrl_sop       };
    wire [1:0]                  tx_cpl_req_eop      = {cc_mem_eop       , cc_dma_ctrl_eop       };
    wire [8*2-1:0]              tx_cpl_req_valid    = {cc_mem_rd_valid  , cc_dma_ctrl_rd_valid  };
    wire [256*2-1:0]            tx_cpl_req_data     = {cc_mem_rd_data   , cc_dma_ctrl_rd_data   };
    assign	{cc_mem_rd_en, cc_dma_ctrl_rd_en}   = tx_cpl_grant; // TLP Send Accept


    tl_tx_mux_if#(
        .CPL_NUM       (2                  ),
        .NP_NUM        (`rq_ch_num         ),
        .P_NUM         (`rc_ch_num         )
    ) u_tl_tx (
        .clk           (tlp_clk            ),
        .rst           (tlp_rst            ),
    //
        .pcie_linkup   (pcie_linkup        ),
        .tl_tx_wait    (tl_tx_wait         ),
        .tx_p_halt     (tx_p_halt          ),
        .tx_np_halt    (tx_np_halt         ),
        .tx_cpl_halt   (tx_cpl_halt        ),
    //
        .tx_p_req      (tx_p_req           ),
        .tx_p_grant    (tx_p_grant         ),
        .tx_p_sop      (tx_p_req_sop       ),
        .tx_p_eop      (tx_p_req_eop       ),
        .tx_p_valid    (tx_p_req_valid     ),
        .tx_p_data     (tx_p_req_data      ),
    //
        .tx_np_req     (tx_np_req          ),
        .tx_np_grant   (tx_np_grant        ),
        .tx_np_sop     (tx_np_req_sop      ),
        .tx_np_eop     (tx_np_req_eop      ),
        .tx_np_valid   (tx_np_req_valid    ),
        .tx_np_data    (tx_np_req_data     ),
    //Complete TLP
        .tx_cpl_req    (tx_cpl_req         ),
        .tx_cpl_grant  (tx_cpl_grant       ),
        .tx_cpl_sop    (tx_cpl_req_sop     ),
        .tx_cpl_eop    (tx_cpl_req_eop     ),
        .tx_cpl_valid  (tx_cpl_req_valid   ),
        .tx_cpl_data   (tx_cpl_req_data    ),
    //To PCIE TLP
        .tl_tx_sop     (tl_tx_sop          ),
        .tl_tx_eop     (tl_tx_eop          ),
        .tl_tx_valid   (tl_tx_valid        ),
        .tl_tx_data    (tl_tx_data         )
    );


    wire [7:0] nc_rx_err;
    SerDes_Top	u_pcie_ctrl(
        .PCIE_Controller_Top_pcie_rstn_i               (rst_n          ),
        .PCIE_Controller_Top_pcie_tl_clk_i             (tlp_clk        ),
        //RX TLP
        .PCIE_Controller_Top_pcie_tl_rx_sop_o	       (tl_rx_sop          ),
        .PCIE_Controller_Top_pcie_tl_rx_eop_o	       (tl_rx_eop          ),
        .PCIE_Controller_Top_pcie_tl_rx_data_o	       (tl_rx_data         ),
        .PCIE_Controller_Top_pcie_tl_rx_valid_o        (tl_rx_valid        ),
        .PCIE_Controller_Top_pcie_tl_rx_bardec_o       (tl_bardec          ),
        .PCIE_Controller_Top_pcie_tl_rx_err_o          (nc_rx_err          ),
        .PCIE_Controller_Top_pcie_tl_rx_wait_i         (1'b0               ),
        .PCIE_Controller_Top_pcie_tl_rx_masknp_i       (1'b0               ),
        //TX TLP											,
        .PCIE_Controller_Top_pcie_tl_tx_sop_i          (tl_tx_sop          ),
        .PCIE_Controller_Top_pcie_tl_tx_eop_i          (tl_tx_eop          ),
        .PCIE_Controller_Top_pcie_tl_tx_data_i         (tl_tx_data         ),
        .PCIE_Controller_Top_pcie_tl_tx_valid_i        (tl_tx_valid        ),
        .PCIE_Controller_Top_pcie_tl_tx_wait_o         (tl_tx_wait         ),
        //MSI												
        .PCIE_Controller_Top_pcie_tl_int_status_i      (tl_int_status      ),
        .PCIE_Controller_Top_pcie_tl_int_req_i         (tl_int_req         ),
        .PCIE_Controller_Top_pcie_tl_int_msinum_i      (tl_int_msinum      ),
        .PCIE_Controller_Top_pcie_tl_int_ack_o         (tl_int_ack         ),
        //PCIE Status										
        .PCIE_Controller_Top_pcie_ltssm_o              (ltssm_status       ),
        .PCIE_Controller_Top_pcie_tl_tx_creditsp_o     (tl_tx_p_credits    ),
        .PCIE_Controller_Top_pcie_tl_tx_creditsnp_o    (tl_tx_np_credits   ),
        .PCIE_Controller_Top_pcie_tl_tx_creditscpl_o   (tl_tx_cpl_credits  ),
        .PCIE_Controller_Top_pcie_tl_cfg_busdev_o      (tl_cfg_busdev      ),   //bus number & Device Number
        .PCIE_Controller_Top_pcie_linkup_o             (pcie_linkup        )		
    );

endmodule
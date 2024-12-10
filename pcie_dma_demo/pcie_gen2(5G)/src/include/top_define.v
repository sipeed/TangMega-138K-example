
//`define csr_byp
//`define upar_ctrl
// `define spi_ctrl
// `define GTR12_QUAD_DB
//`define GTR12_PMAC
//`define pmac_settings

`define dvk_brd

// rc rq chnl define
`define rc_ch0
`define rq_ch0
// `define rc_ch1
// `define rq_ch1

`ifdef	rq_ch1
    `define	rq_ch_num 2
`endif

`ifdef	rq_ch0
    `define	rq_ch_num 1
`endif 

`ifdef	rc_ch1
    `define	rc_ch_num 2
`endif

`ifdef	rc_ch0
    `define	rc_ch_num 1
`endif 

`define	TX_TLP_LEN				4096
`define RQ_CH0_REG0_ADDR     	13'h120
`define RC_CH0_REG0_ADDR     	13'h220
`define RQ_CH1_REG0_ADDR     	13'h320
`define RC_CH1_REG0_ADDR     	13'h420
module top(
    input clk_50M,
    input rst_n, //press S1 to start

    output        sdclk,
    inout         sdcmd,
    inout         sddat0,

    output txp
);
`include "print.svh"
defparam tx.uart_freq = 115200;
defparam tx.clk_freq = 50_000_000;

assign txp = uart_txp;
assign print_clk = rst_n? clk_50M : 1'b0;

logic sd_op;
logic sd_done;
logic sd_list_avail;
logic [1:0] sd_type;
logic [12:0] sd_file_number_last;
logic [12:0] sd_file_number;
logic [7:0] file_name[0:52];
logic [11:0] file_num;
logic [7:0] file_name_len;

sd_file_list_reader sd_ctl(
    .rstn(rst_n),
    .clk(clk_50M),
    .sdclk(sdclk),
    .sdcmd(sdcmd),
    .sddat0(sddat0),
    .op(sd_op),
    .done(sd_done),
    .list_file_num(sd_file_number),
    .list_namelen(file_name_len),
    .card_type(sd_type),
    .list_name(file_name[0:51]),
    .list_en(sd_list_avail)
);
integer  i;
enum {IDLE, WAIT_FOR_LIST, RECEIVED, FINAL, HALT} status_next,status_curr;
always @(posedge clk_50M ) begin
    status_curr <= status_next;
end
always@(negedge clk_50M or negedge rst_n) begin
    if(!rst_n) begin
        `print("\nSD Card Application.\n",STR);
        status_next <= IDLE;
    end else case(status_curr)
    IDLE: begin
        if(sd_type != 0) begin
            `print("SD Card Detected.       \n",STR);
            status_next <= WAIT_FOR_LIST;
        end
    end
    WAIT_FOR_LIST: begin
        sd_op <= 0;
        if(sd_list_avail) status_next <= RECEIVED;
    end
    RECEIVED:  begin
        `print(file_name,file_name_len);
        status_next <= FINAL;
    end
    FINAL: begin
        status_next <= HALT;
    end
    HALT: begin
    end
    endcase
end
endmodule

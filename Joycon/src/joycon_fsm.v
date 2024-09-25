module Joycon_fsm # (
    parameter CLK_FREQ_HZ = 50_000_000,
    parameter JOYCON_IS_LEFT = "true"
) (
   input clk,
   input rst_n,

    /* UART Stream Interface */
    output reg [7:0] tx_data,
    output reg       tx_data_valid,
    input            tx_data_ready,

    input [7:0] rx_data,
    input       rx_data_valid,
    output reg  rx_data_ready,

    /* Fault Recovery */
    output reg  uart_core_rst_n_o,

    /* State_output */
    output reg Joycon_Detected,
        // Joycon states
    // LEFT:
    // [13]:"ScreenShot" [11]:"Left Stick BTN" [8]:"-" [7]:"ZL" [6]:"L" [5]:"SL" [4]:"SR" [3]:"LEFT" [2]:"RIGHT" [1]:"UP" [0]:"DOWN"
    // RIGHT: --[15]:"Indicate JoyCon is Right"
    // [12]:"Home"      [10]:"Right Stick BTN" [9]:"+" [7]:"ZR" [6]:"R" [5]:"SL" [4]:"SR" [3]:"A" [2]:"B" [1]:"X" [0]:"Y" 
    output reg [15:0] Botton_Value,
    output reg [7:0]  Stick_X,
    output reg [7:0]  Stick_Y,
    output reg [15:0] GYRO_X,
    output reg [15:0] GYRO_Y,
    output reg [15:0] GYRO_Z,
    output reg [15:0] ACC_X,
    output reg [15:0] ACC_Y,
    output reg [15:0] ACC_Z,

    output reg Joycon_State_update
 );

    // Joycon Commands
    localparam cmd_initial_len = 16;
    localparam cmd_mac_addr_len = 12;
    localparam cmd_baudrate_switch_len = 20;
    localparam cmd_cmd4_unknow_len = 12;
    localparam cmd_cmd5_unknow_len = 12;
    localparam cmd_cmd6_unknow_len = 16;
    localparam cmd_request_states_len = 13;

    localparam cmd_initial_reply_len = 12;
    localparam cmd_mac_addr_reply_len = 20;
    localparam cmd_baudrate_switch_reply_len = 12;
    localparam cmd_cmd4_unknow_reply_len = 12;
    localparam cmd_cmd5_unknow_reply_len = 12;
    localparam cmd_cmd6_unknow_reply_len = 12;
    localparam cmd_request_states_reply_len = 61;
    localparam cmd_reply_header_1 = 8'h19;
    localparam cmd_reply_header_2 = 8'h81;

    reg [7:0] cmd_joycon_initial[cmd_initial_len-1:0];                  //A1 A2 A3 A4 19 01 03 07 00 A5 02 01 7E 00 00 00
    reg [7:0] cmd_joycon_mac_addr[cmd_mac_addr_len-1:0];                //19 01 03 07 00 91 01 00 00 00 00 24
    reg [7:0] cmd_joycon_baudrate_switch[cmd_baudrate_switch_len-1:0];  //19 01 03 0F 00 91 20 08 00 00 BD B1 C0 C6 2D 00 00 00 00 00
    reg [7:0] cmd_joycon_cmd4_unknow[cmd_cmd4_unknow_len-1:0];          //19 01 03 07 00 91 11 00 00 00 00 0E
    reg [7:0] cmd_joycon_cmd5_unknow[cmd_cmd5_unknow_len-1:0];          //19 01 03 07 00 91 10 00 00 00 00 3D
    reg [7:0] cmd_joycon_cmd6_unknow[cmd_cmd6_unknow_len-1:0];          //19 01 03 0B 00 91 12 04 00 00 12 A6 0F 00 00 00
    reg [7:0] cmd_joycon_request_states[cmd_request_states_len-1:0];    //19 01 03 08 00 92 00 01 00 00 69 2D 1F
                        
    initial begin
        $readmemh("./joycon_cmds/cmd_joycon_init.txt",            cmd_joycon_initial);
        $readmemh("./joycon_cmds/cmd_joycon_mac_addr.txt",        cmd_joycon_mac_addr);
        $readmemh("./joycon_cmds/cmd_joycon_baudrate_switch.txt", cmd_joycon_baudrate_switch);
        $readmemh("./joycon_cmds/cmd_joycon_cmd4_unknow.txt",     cmd_joycon_cmd4_unknow);
        $readmemh("./joycon_cmds/cmd_joycon_cmd5_unknow.txt",     cmd_joycon_cmd5_unknow);
        $readmemh("./joycon_cmds/cmd_joycon_cmd6_unknow.txt",     cmd_joycon_cmd6_unknow);
        $readmemh("./joycon_cmds/cmd_joycon_request_states.txt",  cmd_joycon_request_states);
    end

    /*    Timeout Alarm   */
    /* 
        Set request_alarm=xx to Trigger a Alarm start(Override)
            when timeout, Alarm will trigger |timeout_alarm| with 1 clock period High
    */

    // Other Process to Trigger
    localparam ALARM_TYPE_20MS  = 2'b01;
    localparam ALARM_TYPE_250MS = 2'b10;
    localparam ALARM_TYPE_500MS = 2'b11;
    reg [1:0] request_alarm;    //00: No Alarm, 01:20ms, 10: 100ms, 11: 200mS

    localparam CNT_500ms = CLK_FREQ_HZ / 2;
    localparam CNT_250ms = CLK_FREQ_HZ / 4;
    localparam CNT_20ms  = CLK_FREQ_HZ / 50;
    reg [31:0] time_cnt;
    reg [31:0] timeout_cnt;
    reg alarm_set;   
    reg timeout_alarm;

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            alarm_set <= 0;
            time_cnt <= 0;
            timeout_cnt <= 0;
            timeout_alarm <= 0;
        end else begin
            case(request_alarm)
            ALARM_TYPE_20MS:
            begin
                alarm_set <= 1;
                time_cnt <= 0;
                timeout_cnt <= CNT_20ms;
                timeout_alarm <= 0;
            end
            ALARM_TYPE_250MS:
            begin
                alarm_set <= 1;
                time_cnt <= 0;
                timeout_cnt <= CNT_250ms;
                timeout_alarm <= 0;
            end
            ALARM_TYPE_500MS:
            begin
                alarm_set <= 1;
                time_cnt <= 0;
                timeout_cnt <= CNT_500ms;
                timeout_alarm <= 0;
            end
            default:
            begin
                if(alarm_set)  
                begin
                    if(time_cnt >= timeout_cnt)   //Timeout
                    begin
                        alarm_set <= 0;
                        time_cnt <= 0;
                        timeout_cnt <= 0;
                        timeout_alarm <= 1;
                    end else begin
                        alarm_set <= 1;
                        time_cnt <= time_cnt + 1;
                        timeout_cnt <= timeout_cnt;
                        timeout_alarm <= 0;
                    end
                end else begin
                    alarm_set <= 0;
                    time_cnt <= 0;
                    timeout_cnt <= 0;
                    timeout_alarm <= 0;
                end
            end
            endcase
        end
    end

    /* BUFFER */
    /*
    reg [5:0] buffer_addr;
    reg [15:0] buffer_w_data;
    reg buffer_we;
    wire [15:0] buffer_rd_data;
    reg buffer_rd;
    Single_port_RAM RW_Buffer(
        .clk(clk),
        .ce(1'b1),
        .reset(~rst_n),
        .ad(buffer_addr),
        .din(buffer_w_data),
        .wre(buffer_we),
        .dout(buffer_rd_data), 
        .oce(buffer_rd)
    );
    */

    /* FSM Start */
    reg [7:0] step;
    reg [3:0] fsm_state;
    reg [3:0] next_state;

    reg [7:0] uart_read_out[63:0];
    reg [7:0] uart_to_write[24:0];
    reg [4:0] Write_len;            // max 25 Bytes
    reg [5:0] Read_len;             // max 64 Bytes

    reg [1:0] time_out_mode;              // 00: 20mS, 01: 100mS, 11: 200mS

        /* FSM States */
    localparam JOYCON_TIMEOUT       = 4'h0;
    localparam JOYCON_WRITE         = 4'h1;
    localparam JOYCON_READ          = 4'h2;
    localparam JOYCON_CHK_HEADER    = 4'h3;
    localparam JOYCON_CMD_INIT      = 4'h4;
    localparam JOYCON_CMD_MAC       = 4'h5;
    localparam JOYCON_CMD_BR_SW     = 4'h6;
    localparam JOYCON_CMD_UNKNOW4   = 4'h7;
    localparam JOYCON_CMD_UNKNOW5   = 4'h8;
    localparam JOYCON_CMD_UNKNOW6   = 4'h9;
    localparam JOYCON_CMD_REQ       = 4'hA;
    localparam JOYCON_CHK_STATUS    = 4'hB;
    localparam JOYCON_IDLE          = 4'hC;

generate
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
                // UART SRAM Interface
            tx_data <= 0;
            tx_data_valid <= 0;
            rx_data_ready <= 0;
                // Joycon_FSM
            step <= 0;
            fsm_state <= JOYCON_CMD_INIT;
            next_state <= JOYCON_WRITE;
                // Buffer
            Write_len <= 0;
            Read_len <= 0;
                // Alarm
            time_out_mode <= 0;
            request_alarm <= 0;
                // States output
            uart_core_rst_n_o <= 1;
            Joycon_Detected <= 0;

            Botton_Value <= 0;
            Stick_X <= 0;
            Stick_Y <= 0;
            GYRO_X  <= 0;
            GYRO_Y  <= 0;
            GYRO_Z  <= 0;
            ACC_X   <= 0;
            ACC_Y   <= 0;
            ACC_Z   <= 0;
            Joycon_State_update <= 0;
        end else begin
            case(fsm_state)
            JOYCON_TIMEOUT:
            begin
                uart_core_rst_n_o <= 0;
                    // Data Stream Stop
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                    //Joycon ReInit
                step <= 0;
                fsm_state <= JOYCON_CMD_INIT;
                next_state <= JOYCON_WRITE;
                    //Buffer Reset
                Write_len <= 0;
                Read_len <= 0;
                    //Alarm Not Request
                time_out_mode <= 0;
                request_alarm <= 0;
                    //Joycon Lost Connect
                Joycon_Detected <= 0;

                Botton_Value <= 0;
                Stick_X <= 0;
                Stick_Y <= 0;
                GYRO_X  <= 0;
                GYRO_Y  <= 0;
                GYRO_Z  <= 0;
                ACC_X   <= 0;
                ACC_Y   <= 0;
                ACC_Z   <= 0;
                Joycon_State_update <= 0;
            end
            JOYCON_WRITE:
            begin
                rx_data_ready <= 0;
                Write_len <= Write_len;
                Read_len <= Read_len;
                time_out_mode <= time_out_mode;
                
                next_state <= next_state;   // The State After JOYCON_READ

                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 0;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                tx_data <= uart_to_write[step];
                tx_data_valid <= 1;

                if(tx_data_ready && tx_data_valid)  // 1 Byte Write Done
                begin
                    if(step == Write_len - 1)   //Write End
                    begin
                        step <= 0;
                        fsm_state <= JOYCON_READ;

                        //Start Read Alarm
                        request_alarm <= time_out_mode;
                    end else begin      //Remain Write
                        step <= step + 1;
                        fsm_state <= fsm_state;

                        request_alarm <= 2'b00;
                    end
                end else begin
                    step <= step;
                    fsm_state <= fsm_state;

                    request_alarm <= 0;
                end
            end
            JOYCON_READ:
            begin
                tx_data <= 0;
                tx_data_valid <= 0;
                Write_len <= Write_len;

                next_state <= next_state;
                request_alarm <= 0;
                time_out_mode <= time_out_mode;

                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 0;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                if(timeout_alarm)   //TimeOut
                begin
                    rx_data_ready <= 0;

                    Read_len <= Read_len;
                    step <= step;
                    fsm_state <= JOYCON_TIMEOUT;    //Jump to TimeOut State to Reset UartCore
                end else begin
                    if(rx_data_valid && rx_data_ready)  //1 Byte Read Done
                    begin
                        if(step == Read_len - 1)   //Read End
                        begin
                            rx_data_ready <= 0;

                            Read_len <= 0;
                            step <= 0;
                            fsm_state <= JOYCON_CHK_HEADER;
                        end else begin      //Remain Read
                            rx_data_ready <= 1;

                            Read_len <= Read_len;
                            step <= step + 1;
                            fsm_state <= fsm_state;
                        end
                        uart_read_out[step] <= rx_data;
                    end else begin
                        rx_data_ready <= 1;

                        Read_len <= Read_len;
                        step <= step;
                        fsm_state <= fsm_state;
                    end
                end
            end
            JOYCON_IDLE:
            begin
                // Not Need Send&Receive any data
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                Write_len <= Write_len;
                Read_len <= Read_len;
                // Unused flasgs
                step <= 0;
                next_state <= next_state;
                // No need trigger Alarm, only wait for 20mS timer expired
                time_out_mode <= 0;
                request_alarm <= 0;
                // keep Joycon in Detected mode
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 1;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                if(timeout_alarm)   //TimeOut, Request Joycon Status
                begin
                    fsm_state <= JOYCON_CMD_REQ;    //Jump to Request States
                end else begin
                    fsm_state <= fsm_state;
                end
            end
            JOYCON_CHK_HEADER:
            begin
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                Write_len <= Write_len;
                Read_len <= Read_len;

                next_state <= next_state;

                time_out_mode <= 0;
                request_alarm <= 0;

                uart_core_rst_n_o <= 1;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                //if( uart_read_out[0] != cmd_reply_header_1 || 
                //    uart_read_out[1] != cmd_reply_header_2)   //Receive Data Not valid
                if( uart_read_out[0] != cmd_reply_header_1)   //Receive Data Not valid
                begin
                    step <= 0;
                    Joycon_Detected <= 0;
                    fsm_state <= JOYCON_TIMEOUT;    //Jump to TimeOut State to Reset UartCore
                end else begin
                    step <= 0;
                    Joycon_Detected <= 1;
                    fsm_state <= next_state; 
                end
            end
            JOYCON_CMD_INIT:
            begin
                //Only Fill TX Buffer, In JOYCON_WRITE, Buffer Will write to UART Core
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                // Alarm will Set in Write Done
                request_alarm <= 0;
                // Misc Signals
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 0;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                // Fill TX Buffer
                uart_to_write[step] <= cmd_joycon_initial[step];
                if(step == cmd_initial_len - 1)     //Fill buffer done, Ready to Send
                begin
                        //W, R Length
                    Write_len <= cmd_initial_len;
                    Read_len  <= cmd_initial_reply_len;
                        // States
                    step <= 0;
                    fsm_state <= JOYCON_WRITE;      // Next time is write and read joycon
                    next_state <= JOYCON_CMD_MAC;  // after Read Done, check Whether Joycon reply valid
                    time_out_mode <= ALARM_TYPE_250MS;             // if joycon not return after 100mS, reInit Joycon
                end else begin
                    //Not Fill Done
                    Write_len <= 0;
                    Read_len  <= 0;
                    step <= step + 1;               // Update TX Buffer Point
                    fsm_state <= fsm_state;  
                    next_state <= next_state;
                    time_out_mode <= time_out_mode;
                end
            end
            JOYCON_CMD_MAC:
            begin
                //Only Fill TX Buffer, In JOYCON_WRITE, Buffer Will write to UART Core
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                // Alarm will Set in Write Done
                request_alarm <= 0;
                // Misc Signals
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 1;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                // Fill TX Buffer
                uart_to_write[step] <= cmd_joycon_mac_addr[step];
                if(step == cmd_mac_addr_len - 1)     //Fill buffer done, Ready to Send
                begin
                        //W, R Length
                    Write_len <= cmd_mac_addr_len;
                    Read_len  <= cmd_mac_addr_reply_len;
                        // States
                    step <= 0;
                    fsm_state <= JOYCON_WRITE;      // Next time is write and read joycon
                    next_state <= JOYCON_CMD_UNKNOW4;  // after Read Done, check Whether Joycon reply valid
                    time_out_mode <= ALARM_TYPE_500MS;             // if joycon not return after 100mS, reInit Joycon
                end else begin
                    //Not Fill Done
                    Write_len <= 0;
                    Read_len  <= 0;
                    step <= step + 1;               // Update TX Buffer Point
                    fsm_state <= fsm_state;  
                    next_state <= next_state;
                    time_out_mode <= time_out_mode;
                end
            end
            JOYCON_CMD_BR_SW:
            begin
                //Only Fill TX Buffer, In JOYCON_WRITE, Buffer Will write to UART Core
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                // Alarm will Set in Write Done
                request_alarm <= 0;
                // Misc Signals
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 1;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                // Fill TX Buffer
                uart_to_write[step] <= cmd_joycon_baudrate_switch[step];
                if(step == cmd_baudrate_switch_len - 1)     //Fill buffer done, Ready to Send
                begin
                        //W, R Length
                    Write_len <= cmd_baudrate_switch_len;
                    Read_len  <= cmd_baudrate_switch_reply_len;
                        // States
                    step <= 0;
                    fsm_state <= JOYCON_WRITE;      // Next time is write and read joycon
                    next_state <= JOYCON_CMD_UNKNOW4;  // after Read Done, check Whether Joycon reply valid
                    time_out_mode <= ALARM_TYPE_500MS;             // if joycon not return after 100mS, reInit Joycon
                end else begin
                    //Not Fill Done
                    Write_len <= 0;
                    Read_len  <= 0;
                    step <= step + 1;               // Update TX Buffer Point
                    fsm_state <= fsm_state;  
                    next_state <= next_state;
                    time_out_mode <= time_out_mode;
                end
            end
            JOYCON_CMD_UNKNOW4:
            begin
                //Only Fill TX Buffer, In JOYCON_WRITE, Buffer Will write to UART Core
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                // Alarm will Set in Write Done
                request_alarm <= 0;
                // Misc Signals
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 1;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                // Fill TX Buffer
                uart_to_write[step] <= cmd_joycon_cmd4_unknow[step];
                if(step == cmd_cmd4_unknow_len - 1)     //Fill buffer done, Ready to Send
                begin
                        //W, R Length
                    Write_len <= cmd_cmd4_unknow_len;
                    Read_len  <= cmd_cmd4_unknow_reply_len;
                        // States
                    step <= 0;
                    fsm_state <= JOYCON_WRITE;      // Next time is write and read joycon
                    next_state <= JOYCON_CMD_UNKNOW5;  // after Read Done, check Whether Joycon reply valid
                    time_out_mode <= ALARM_TYPE_500MS;             // if joycon not return after 100mS, reInit Joycon
                end else begin
                    //Not Fill Done
                    Write_len <= 0;
                    Read_len  <= 0;
                    step <= step + 1;               // Update TX Buffer Point
                    fsm_state <= fsm_state;  
                    next_state <= next_state;
                    time_out_mode <= time_out_mode;
                end
            end
            JOYCON_CMD_UNKNOW5:
            begin
                //Only Fill TX Buffer, In JOYCON_WRITE, Buffer Will write to UART Core
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                // Alarm will Set in Write Done
                request_alarm <= 0;
                // Misc Signals
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 1;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                // Fill TX Buffer
                uart_to_write[step] <= cmd_joycon_cmd5_unknow[step];
                if(step == cmd_cmd5_unknow_len - 1)     //Fill buffer done, Ready to Send
                begin
                        //W, R Length
                    Write_len <= cmd_cmd5_unknow_len;
                    Read_len  <= cmd_cmd5_unknow_reply_len;
                        // States
                    step <= 0;
                    fsm_state <= JOYCON_WRITE;      // Next time is write and read joycon
                    next_state <= JOYCON_CMD_UNKNOW6;  // after Read Done, check Whether Joycon reply valid
                    time_out_mode <= ALARM_TYPE_500MS; // if joycon not return after 100mS, reInit Joycon
                end else begin
                    //Not Fill Done
                    Write_len <= 0;
                    Read_len  <= 0;
                    step <= step + 1;               // Update TX Buffer Point
                    fsm_state <= fsm_state;  
                    next_state <= next_state;
                    time_out_mode <= time_out_mode;
                end
            end
            JOYCON_CMD_UNKNOW6:
            begin
                //Only Fill TX Buffer, In JOYCON_WRITE, Buffer Will write to UART Core
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                // Alarm will Set in Write Done
                request_alarm <= 0;
                // Misc Signals
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 1;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                // Fill TX Buffer
                uart_to_write[step] <= cmd_joycon_cmd6_unknow[step];
                if(step == cmd_cmd6_unknow_len - 1)     //Fill buffer done, Ready to Send
                begin
                        //W, R Length
                    Write_len <= cmd_cmd6_unknow_len;
                    Read_len  <= cmd_cmd6_unknow_reply_len;
                        // States
                    step <= 0;
                    fsm_state <= JOYCON_WRITE;      // Next time is write and read joycon
                    next_state <= JOYCON_CMD_REQ;  // after Read Done, check Whether Joycon reply valid
                    time_out_mode <= ALARM_TYPE_500MS;             // if joycon not return after 100mS, reInit Joycon
                end else begin
                    //Not Fill Done
                    Write_len <= 0;
                    Read_len  <= 0;
                    step <= step + 1;               // Update TX Buffer Point
                    fsm_state <= fsm_state;  
                    next_state <= next_state;
                    time_out_mode <= time_out_mode;
                end
            end
            JOYCON_CMD_REQ:
            begin
                //Only Fill TX Buffer, In JOYCON_WRITE, Buffer Will write to UART Core
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                // Alarm will Set in Write Done
                request_alarm <= 0;
                // Misc Signals
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 1;

                Botton_Value <= Botton_Value;
                Stick_X <= Stick_X;
                Stick_Y <= Stick_Y;
                GYRO_X  <= GYRO_X ;
                GYRO_Y  <= GYRO_Y ;
                GYRO_Z  <= GYRO_Z ;
                ACC_X   <= ACC_X  ;
                ACC_Y   <= ACC_Y  ;
                ACC_Z   <= ACC_Z  ;
                Joycon_State_update <= 0;

                // Fill TX Buffer
                uart_to_write[step] <= cmd_joycon_request_states[step];
                if(step == cmd_request_states_len - 1)     //Fill buffer done, Ready to Send
                begin
                        //W, R Length
                    Write_len <= cmd_request_states_len;
                    Read_len  <= cmd_request_states_reply_len;
                        // States
                    step <= 0;
                    fsm_state <= JOYCON_WRITE;      // Next time is write and read joycon
                    next_state <= JOYCON_CHK_STATUS;  // after Read Done, check Whether Joycon reply valid
                    time_out_mode <= ALARM_TYPE_20MS;             // if joycon not return after 20mS, reInit Joycon
                end else begin
                    //Not Fill Done
                    Write_len <= 0;
                    Read_len  <= 0;
                    step <= step + 1;               // Update TX Buffer Point
                    fsm_state <= fsm_state;  
                    next_state <= next_state;
                    time_out_mode <= time_out_mode;
                end
            end
            JOYCON_CHK_STATUS:
            begin
                // UART SRAM Interface
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                Write_len <= Write_len;
                Read_len <= Read_len;

                next_state <= next_state;

                time_out_mode <= 0;
                request_alarm <= 0;

                uart_core_rst_n_o <= 1;

                if(step == 7) //end
                begin
                    step <= 0;
                    Joycon_Detected <= 1;
                    fsm_state <= JOYCON_IDLE;
                    Joycon_State_update <= 1;
                end else begin
                    step <= step + 1;
                    Joycon_Detected <= 1;
                    fsm_state <= fsm_state;
                    Joycon_State_update <= 0;
                end

                // Value Update
                if(JOYCON_IS_LEFT == "true")
                begin
                    Botton_Value <= (step == 0) ? {uart_read_out[16], uart_read_out[17]} : Botton_Value;

                    Stick_X <= (step == 1) ? {uart_read_out[19][3:0], uart_read_out[19][7:4]} : Stick_X; //X is nibble Reversed
                    Stick_Y <= (step == 1) ? uart_read_out[20] : Stick_Y;

                    GYRO_X  <= (step == 2) ? {uart_read_out[31], uart_read_out[32]} : GYRO_X ;
                    GYRO_Y  <= (step == 3) ? {uart_read_out[33], uart_read_out[34]} : GYRO_Y ;
                    GYRO_Z  <= (step == 4) ? {uart_read_out[35], uart_read_out[36]} : GYRO_Z ;
                    ACC_X   <= (step == 5) ? {uart_read_out[37], uart_read_out[38]} : ACC_X  ;
                    ACC_Y   <= (step == 6) ? {uart_read_out[39], uart_read_out[40]} : ACC_Y  ;
                    ACC_Z   <= (step == 7) ? {uart_read_out[41], uart_read_out[42]} : ACC_Z  ;
                end else begin
                    Botton_Value <= (step == 0) ? {uart_read_out[16], uart_read_out[15]} : Botton_Value;

                    Stick_X <= (step == 1) ? {uart_read_out[22][3:0], uart_read_out[22][7:4]} : Stick_X; //X is nibble Reversed
                    Stick_Y <= (step == 1) ? uart_read_out[23] : Stick_Y;

                    GYRO_X  <= (step == 2) ? {uart_read_out[31], uart_read_out[32]} : GYRO_X ;
                    GYRO_Y  <= (step == 3) ? {uart_read_out[33], uart_read_out[34]} : GYRO_Y ;
                    GYRO_Z  <= (step == 4) ? {uart_read_out[35], uart_read_out[36]} : GYRO_Z ;
                    ACC_X   <= (step == 5) ? {uart_read_out[37], uart_read_out[38]} : ACC_X  ;
                    ACC_Y   <= (step == 6) ? {uart_read_out[39], uart_read_out[40]} : ACC_Y  ;
                    ACC_Z   <= (step == 7) ? {uart_read_out[41], uart_read_out[42]} : ACC_Z  ;
                end
            end
            default:
            begin
                    // UART SRAM Interface
                tx_data <= 0;
                tx_data_valid <= 0;
                rx_data_ready <= 0;
                    // Joycon_FSM
                step <= 0;
                fsm_state <= JOYCON_CMD_INIT;
                next_state <= JOYCON_WRITE;
                    // Buffer
                Write_len <= 0;
                Read_len <= 0;
                    // Alarm
                time_out_mode <= 0;
                request_alarm <= 0;
                    // States output
                uart_core_rst_n_o <= 1;
                Joycon_Detected <= 0;

                Joycon_State_update <= 0;
            end
            endcase
        end
    end
endgenerate
  
endmodule



/* 
    Note:
    Status Packet:
    Byte 15-17(3Byte) is Key State&Controllor Dir
    Byte15:
        [7]:"ZR"
        [6]:"R"
        [5]:"SL"
        [4]:"SR"
        [3]:"A"
        [2]:"B"
        [1]:"X"
        [0]:"Y"
    Byte16:
        [7]:"Indicate JoyCon is Right"
        [6]:Unknow
        [5]:"ScreenShot"
        [4]:"Home"
        [3]:"Left Stick BTN"
        [2]:"Right Stick BTN"
        [1]:"+"
        [0]:"-"
    Byte17:
        [7]:"ZL"
        [6]:"L"
        [5]:"SL"
        [4]:"SR"
        [3]:"LEFT"
        [2]:"RIGHT"
        [1]:"UP"
        [0]:"DOWN"

    Byte19: LEFT STICK-X(Nibble Reversed)
    Byte20: LEFT STICK-Y
    Byte22: RIGHT STICK-X(Nibble Reversed)
    Byte23: RIGHT STICK-Y
 */



## part 1: new lib
vlib work
vmap work work

## part 2: load design
vlog -sv ../../tb/prim_sim.v
vlog -sv ../../uart_core.vo
vlog -sv ../../tb/UART_MASTER_tb.v


vlog +incdir+ ../../temp/UART_MASTER/top_define.vh

## part 3: sim design
vsim  -novopt work.tb

## part 4: add signals
add wave -noupdate /tb/I_CLK
add wave -noupdate /tb/rst_n
add wave -noupdate /tb/I_TX_EN
add wave -noupdate /tb/I_WADDR
add wave -noupdate /tb/I_WDATA
add wave -noupdate /tb/I_RX_EN
add wave -noupdate /tb/I_RADDR
add wave -noupdate /tb/O_RDATA
add wave -noupdate /tb/rx_o 
add wave -noupdate /tb/RxRDYn
add wave -noupdate /tb/tx_o
add wave -noupdate /tb/TxRDYn
add wave -noupdate /tb/DDIS
add wave -noupdate /tb/INTR
add wave -noupdate /tb/CTSn
add wave -noupdate /tb/DSRn
add wave -noupdate /tb/RIn
add wave -noupdate /tb/DTRn
add wave -noupdate /tb/RTSn
add wave -noupdate /tb/DCDn
## part 5: show ui 
view wave
view structure
view signals

## part 6: run 
run -all
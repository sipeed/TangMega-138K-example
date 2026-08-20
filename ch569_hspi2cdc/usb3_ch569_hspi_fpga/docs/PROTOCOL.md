# 数据通路与协议

## 固定参数

- CH569 与 FPGA 共用 `HD[15:0]` 数据总线，两个方向使用各自独立的四线控制组。
- CH569 与 FPGA 逻辑时钟均为 120 MHz。
- HSPI 帧和 RAMX 环形槽固定为 4096 字节。
- USB SuperSpeed bulk 最大包为 1024 字节，每次 burst 为控制器上限 4 包。
- CH569 的 96 KiB RAMX 中使用 16×4 KiB（64 KiB）作为数据环。

## FPGA 到 PC

FPGA 的 forward 位流持续产生可预测的 16-bit pattern。CH569 HSPI 使用
`RX_ADDR0/RX_ADDR1` double-DMA ping-pong 接收；每次 `R_DONE` 后，固件将刚完成
的槽号发布到描述符队列，并把对应 DMA 地址改指向下一个空闲槽。USB EP2 IN
只消费已发布的完整槽。

生产者 `g_h2u_produced` 和消费者 `g_h2u_consumed` 是单调递增计数器，它们的差
表示队列深度。深度达到高水位后，固件只在完整帧边界撤销 HSPI ready；降到低
水位后恢复。任何一侧都不得访问另一侧仍拥有的槽。

FPGA 帧间固定等待 384 个周期，为 CH569 `R_DONE` 中断更新 double-DMA 地址
保留余量。较短间隔在长时间压力测试中会导致偶发的完整槽错序，因此交付版本
不得在没有重新进行长测的情况下修改。

## PC 到 FPGA

USB EP1 OUT 的 DMA 地址直接指向 16 槽环形缓冲，避免额外 memcpy。USB 完成一个
4 KiB 槽后发布给 HSPI TX；HSPI `T_DONE` 后释放该槽供 USB 重用。FPGA 对所有
16-bit payload 字进行 pattern 比较，并通过反向 HSPI 报告 64 字节统计结构。

CH569 normal-mode HSPI TX 的尾部 CRC 周期在当前芯片上输出 `0x0000`，而 FPGA
参考接收器按 CRC-16/USB trailer 检查，因此报告中的硬件 CRC 计数非零，并连带
使参考 sequence checker 非零。`pattern=0` 是本模式实际采用的端到端 payload
完整性判据。若产品需要独立于 pattern 的通用校验，应在应用帧中加入软件 CRC，
不要把当前硬件 trailer 计数误作 payload 损坏。

## 二次开发边界

- 可以替换 FPGA pattern RAM 为业务 FIFO，但必须保持“完整 4 KiB 后发布”。
- 可以更换 USB VID/PID 和控制命令，但不要在 USBSS/LINK/HSPI ISR 内打印串口；
  115200 baud 阻塞打印会破坏 USB3 枚举与实时性。
- CH569 BOOT 必须保持 PA13。任何烧录命令都不得使用 `-b` 修改 BOOT 引脚。
- 若修改环形槽数，RAMX 总占用必须小于 96 KiB，并同步调整高低水位。
- forward/reverse 位流仅用于清晰、可复现的单向吞吐测试；协议逻辑本身包含两个
  方向，业务工程可在 FPGA 内以运行时命令替代构建时模式选择。

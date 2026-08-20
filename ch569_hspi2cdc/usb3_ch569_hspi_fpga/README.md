# usb3_ch569_hspi_fpga

CH569 USB 3.0 与 FPGA 通过 16-bit HSPI 进行高速、稳定双向传输的开源例程。

数据通路：

```text
FPGA -> HSPI16 -> CH569 -> USB3 bulk IN  -> PC
PC   -> USB3 bulk OUT -> CH569 -> HSPI16 -> FPGA
```

工程以 4096 字节作为 HSPI 与 USB 环形缓冲的完整生产/消费单位。CH569
使用 16 个 4 KiB 槽（共 64 KiB RAMX），USB SuperSpeed bulk 端点使用控制器
支持的最大 4×1024 B burst。USB DMA 与 HSPI DMA 并行运行，但不会读取或覆盖
另一侧正在使用的槽。

## 目录

- `firmware/`：CH569 固件，基于 slogic_ch569_hspi2usb3 的开源源码开发。
- `scripts/usb3_bulk_in_benchmark.c`：FPGA 到 PC 的异步 bulk-IN 吞吐与数据校验。
- `scripts/usb3_bulk_out_hspi_benchmark.c`：PC 到 FPGA 的 bulk-OUT/HSPI 吞吐与报告校验。
- `fpga/`：可独立构建的 Gowin FPGA 工程，构建后生成正向和反向两个位流。
- `docs/PROTOCOL.md`：4 KiB 帧、环形缓冲所有权及二次开发说明。

## 当前实测结果

补齐官方 double-DMA 配置后，FPGA→PC 完成 30 秒连续测试：
`1602.744 Mbit/s（200.343 MB/s）`，共 6,031,409,152 字节；主机 USB/pattern
错误与 CH569 CRC/sequence/FIFO 错误均为 0。PC→FPGA 完成 16 MiB 数据内容
校验：`1209.722 Mbit/s（151.215 MB/s）`，逐字 pattern 错误为 0。

当前 normal-mode HSPI 每个完整 4 KiB 帧保留 384 个 FPGA 系统时钟的帧间隔。
较短间隔虽能提高瞬时吞吐，但在长时间压力测试中会出现偶发完整帧槽错位，因此
不作为稳定配置。本交付版本固定使用 384 周期，不以牺牲稳定性换取峰值数字。

### 实测环境与原始结果

测试板为 Tang Mega Neo，CH569 与 FPGA 均运行在 120 MHz，HSPI 为 16-bit，
帧长 4096 字节；USB 设备以 5 Gbit/s SuperSpeed 枚举，bulk 最大包为 1024 字节，
burst 为 4 包。测试主机使用 Linux + xHCI + libusb-1.0。

FPGA → HSPI16 → CH569 → USB3 bulk IN → PC，连续 30 秒：

```text
bytes=6031409152 completions=23008 usb_errors=0 pattern_errors=0
elapsed=30.105418 s
rate=1602.744 Mbit/s (200.343 MB/s)
CH569: crc=0 seq=0 fifo=0 depth_max=3 pauses=0
```

PC → USB3 bulk OUT → CH569 → HSPI16 → FPGA，16 MiB：

```text
bytes=16777216 elapsed=0.110949 s
rate=1209.722 Mbit/s (151.215 MB/s)
report: total=16777216 frames=4096 pattern_errors=0
```

反向报告还会显示 `hspi_crc_trailer` 和 `hspi_seq_diag`。它们记录下文说明的
normal-mode 硬件 CRC trailer 兼容性，不代表 payload 错误；端到端 payload 的
通过条件是 `pattern_errors=0`。

## 构建

`prebuilt/` 包含本页实测使用的 CH569 固件以及 forward/reverse 位流，建议客户
先用预编译产物确认硬件，再从源码构建。FPGA 位流使用 gzip 压缩，
`flash_fpga.sh` 会自动解压：

```text
4b5cf85190aacf7a5df847d83453df0ab26a28380beda97477e855be9d386e8c  prebuilt/ch569_usb3_hspi.bin
614d5b06f290cf5dd79b5d6c8141f647eff183ed712884410dba9d88355e5624  prebuilt/fpga_forward.fs.gz
6c9d75c4bf90fe81d4f7d4701f4b8032e181aa330db45eb6ac763194982cc4f7  prebuilt/fpga_reverse.fs.gz
```

依赖：Gowin EDA（`gw_sh`）、RISC-V Embedded GCC、libusb-1.0 开发包、
openFPGALoader 和 `wch-ch56x-isp`。如果烧录器不在 `PATH`，可通过
`WCH_CH56X_ISP=/path/to/wch-ch56x-isp` 指定。进入工程根目录后运行：

```bash
scripts/build_all.sh
```

生成：

- `firmware/output/firmware.bin`
- `fpga/impl/pnr/usb3_ch569_hspi_fpga_forward.fs`
- `fpga/impl/pnr/usb3_ch569_hspi_fpga_reverse.fs`

CH569 BOOT 配置必须保持 PA13；烧录时不要传入 `-b`：

```bash
scripts/flash_ch569.sh
```

该脚本要求 CH569 已进入 USB bootloader；它不会传入 `-b`，不会改变 PA13 BOOT
配置。FPGA 位流加载与测试：

```bash
# FPGA -> PC
scripts/flash_fpga.sh forward
scripts/usb3_bulk_in_benchmark 10

# PC -> FPGA；切换位流后复位一次 CH569，再执行测试
scripts/flash_fpga.sh reverse
scripts/usb3_bulk_out_hspi_benchmark 16
```

反向测试的 `pattern=0` 表示全部 payload 逐字匹配。CH569 normal-mode HSPI TX
在 CRC 尾周期输出零，因此 FPGA 报告中的 `crc`/`seq` 是硬件 trailer 兼容性诊断，
不作为该模式的 payload 成功条件；详见协议文档。

本工程保留并注明上游开源来源，后续新增的环形缓冲、双向桥接、FPGA 协议和主机
测试程序均以此独立工程名称维护。

---

## English

This is an open-source, high-throughput bidirectional example connecting the
CH569 USB 3.0 controller to an FPGA over a 16-bit HSPI bus.

```text
FPGA -> HSPI16 -> CH569 -> USB3 bulk IN  -> PC
PC   -> USB3 bulk OUT -> CH569 -> HSPI16 -> FPGA
```

The design uses complete 4096-byte units for both HSPI frames and ring-buffer
slots. CH569 allocates 16 × 4 KiB slots (64 KiB of its 96 KiB RAMX), while the
SuperSpeed bulk endpoints use the controller maximum burst of four 1024-byte
packets. HSPI DMA and USB DMA run concurrently, with explicit slot ownership
preventing either side from accessing a slot still owned by the other side.

### Directory layout

- `firmware/`: fully buildable CH569 firmware derived from the open-source
  `slogic_ch569_hspi2usb3` project.
- `fpga/`: standalone Gowin project producing forward and reverse bitstreams.
- `scripts/usb3_bulk_in_benchmark.c`: asynchronous FPGA-to-PC throughput and
  payload verifier.
- `scripts/usb3_bulk_out_hspi_benchmark.c`: PC-to-FPGA throughput, payload,
  and FPGA-report verifier.
- `docs/PROTOCOL.md`: 4 KiB framing, ring ownership, and development notes.
- `prebuilt/`: verified CH569 firmware and compressed forward/reverse FPGA
  bitstreams for a quick hardware test.

### Measured stable throughput

Test platform: Tang Mega Neo; CH569 and FPGA at 120 MHz; 16-bit HSPI; 4096-byte
frames; USB enumerated at 5 Gbit/s SuperSpeed; Linux xHCI host with libusb-1.0.

FPGA → HSPI16 → CH569 → USB3 bulk IN → PC, continuous 30-second run:

```text
bytes=6031409152 completions=23008 usb_errors=0 pattern_errors=0
elapsed=30.105418 s
rate=1602.744 Mbit/s (200.343 MB/s)
CH569: crc=0 seq=0 fifo=0 depth_max=3 pauses=0
```

PC → USB3 bulk OUT → CH569 → HSPI16 → FPGA, 16 MiB run:

```text
bytes=16777216 elapsed=0.110949 s
rate=1209.722 Mbit/s (151.215 MB/s)
report: total=16777216 frames=4096 pattern_errors=0
```

The normal-mode FPGA-to-PC build deliberately keeps a 384-clock gap between
complete 4 KiB frames. Shorter gaps increase peak throughput but caused rare
whole-slot ordering errors during extended stress tests. The delivery build
therefore favors repeatable operation over the highest headline number.

### Build

Requirements: Gowin EDA (`gw_sh`), RISC-V Embedded GCC, libusb-1.0 development
files, openFPGALoader, and `wch-ch56x-isp`. If the CH569 programmer is not in
`PATH`, set `WCH_CH56X_ISP=/path/to/wch-ch56x-isp`.

```bash
scripts/build_all.sh
```

Generated files:

- `firmware/output/firmware.bin`
- `fpga/impl/pnr/usb3_ch569_hspi_fpga_forward.fs`
- `fpga/impl/pnr/usb3_ch569_hspi_fpga_reverse.fs`
- both libusb benchmark executables under `scripts/`

The SHA-256 sums for the supplied prebuilt images are listed in the Chinese
section above. `flash_fpga.sh` automatically decompresses a prebuilt FPGA image
when no locally built image is present.

### Flash and run

The CH569 BOOT configuration must remain on PA13. Put CH569 into its USB
bootloader, then run the following command. The script intentionally does not
pass `-b`, so it does not alter the BOOT-pin configuration.

```bash
scripts/flash_ch569.sh
```

Run the two directions independently:

```bash
# FPGA -> PC
scripts/flash_fpga.sh forward
scripts/usb3_bulk_in_benchmark 10

# PC -> FPGA; reset CH569 normally after changing the FPGA image
scripts/flash_fpga.sh reverse
scripts/usb3_bulk_out_hspi_benchmark 16
```

For the reverse test, `pattern_errors=0` means that every payload word matched.
CH569 normal-mode HSPI TX emits zero during its CRC trailer cycle, so the
reported `hspi_crc_trailer` and dependent `hspi_seq_diag` values are retained
as hardware-compatibility diagnostics and are not treated as payload failures.
See `docs/PROTOCOL.md` for details and secondary-development constraints.

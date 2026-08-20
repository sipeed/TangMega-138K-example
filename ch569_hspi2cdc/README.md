# USB3 + HSPI16 高速双向传输例程

推荐使用 [`usb3_ch569_hspi_fpga`](usb3_ch569_hspi_fpga/) 子工程。它提供：

- FPGA → HSPI16 → CH569 → USB3 bulk IN → PC：实测约 200.3 MB/s；
- PC → USB3 bulk OUT → CH569 → HSPI16 → FPGA：实测约 151.2 MB/s；
- CH569、FPGA 和 libusb 主机测试程序的完整开源源码；
- 4 KiB/16 槽环形缓冲、数据完整性校验以及详细二次开发说明；
- 可直接验证硬件的预编译固件和 forward/reverse FPGA 位流。

快速开始、构建依赖、烧录方式和已知 HSPI normal-mode CRC trailer 限制见
[`usb3_ch569_hspi_fpga/README.md`](usb3_ch569_hspi_fpga/README.md)。CH569 的
Download CFG Pin 必须保持为 **PA13**，烧录时不要修改 BOOT 配置。

## USB3 + HSPI16 high-speed bidirectional example

The recommended project is
[`usb3_ch569_hspi_fpga`](usb3_ch569_hspi_fpga/). It provides:

- FPGA → HSPI16 → CH569 → USB3 bulk IN → PC: approximately **200.3 MB/s**;
- PC → USB3 bulk OUT → CH569 → HSPI16 → FPGA: approximately **151.2 MB/s**;
- complete open-source CH569 firmware, FPGA RTL, and libusb host benchmarks;
- a 16-slot × 4 KiB ring buffer, end-to-end payload verification, and detailed
  secondary-development notes;
- prebuilt CH569 firmware and forward/reverse FPGA bitstreams for immediate
  hardware verification.

See the [project README](usb3_ch569_hspi_fpga/README.md) for prerequisites,
build and flashing commands, raw benchmark results, and the known HSPI
normal-mode CRC-trailer limitation. The CH569 Download CFG pin must remain
configured as **PA13**; do not alter the BOOT-pin configuration while flashing.

以下为原始单向基础例程说明。

# CH569_HSPI_USB

> All **Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html)** boards have been pre-burned with this firmware before leaving the factory.
> 
> ⚠ Unless you need secondary development or verification of the burning process, please do not try to burn this firmware at will.

WCHISPStudio is used to flash `CH569_HSPI_USB/obj/CH569_HSPI_USB.hex` to your CH569 onboard.

NOTE: Do **NOT** use the regular port designated for FPGA flashing and UART communication. The correct port is located on the top left of the board and belongs to the `WCH569`.

NOTE: **MUST** change these settings below

- Chip Memory Allocation: `RAMX 96KB` + `ROM 32KB`
- Download CFG Pin: `PA13`

You can also use MounRiver Studio import this project and build by yourself.

# CH569_HSPI_FPGA

Gowin Programmer is used to program `CH569_HSPI_FPGA/impl/pnr/CH569_HSPI_FPGA.fs` to your 138k.

The botton `S1` on SOM board is used to reset.

NOTE: must boot FPGA first to avoid affect `HSPI` on CH569.


Please confirm that you have the following conditions:
- GOWIN IDE Version ≥ 1.9.9
- **DO NOT** use GOWIN Programmer version **1.9.10.02**, for this version contains many issues with on **board debugger**

- A **USB3.0** USB-A to USB-C cable, **DO NOT** use the cable which is USB2.0 ONLY

Phenomenon after programming: 
- The **READY** and **DONE** LEDs on the **SOM** board flash alternately to indicate that the FPGA logic is executing normally.

# DDR3 DRAM TEST
  **ddr_memory_test_uart_Ver..fs.7z*** is the prebuilt bitstream, select according to the device version.
  
  If you don't know how to determine the device version, please refer [**HERE**](wiki.sipeed.com/hardware/en/tang/common-doc/questions.html#How-to-Identify-Device-Version).

  The source code is for device version C, if you want to use it on device version B. Please modify the device model yourself and then regenerate **ALL** GOWIN-specific IPs.

  [**Click HERE**](../.asserts/docs/how_to_regenerate_IP.md) too see how to regenerate IP.
  
## Test Condition
  - GOWIN EDA Version **V1.9.12.02_SP1** (64-bit) **build(84852)**.
  - Onboard debugger or an additional FT2232 debugger, USB2TLL, whatever you like.
  - UART: buad 115200, 8N1

## Applicable Models
  - Tang Mega 138k SOM  *standalone* (Version 30153 or later, both VerB & VerC)
  - Tang Mega 138k Dock (Version 31004 or later)
  - Tang Console 138k  (Version 33001C or later)

## Tang Console 138K Notes
  - The Console design feeds the 50 MHz `clk` input on V22 into `gowin_pll`. Keep the project clock constraint at 50 MHz when rebuilding the example.
  - Match the prebuilt bitstream to the FPGA device version. The checked-in source targets device version C. When retargeting it for version B, regenerate every Gowin IP, including `ddr3_memory_interface` and `gowin_pll` (`PLL_INIT`).
  - An independent test on 2026-08-16 used a Tang Console 138K with a 30354 1 GB Hynix SOM and `GW5AST-LV138PG484AC1/I0` device version C. The supplied version C bitstream and a clean source build with Gowin EDA V1.9.12.03 both repeatedly reported `DDR3 TEST OKAY!`. A later exact-version diagnostic retained distinct patterns at zero, every usable 1 GiB address-line position and the final aligned 32-byte beat. See the [hardware report in issue #6](https://github.com/sipeed/TangMega-138K-example/issues/6#issuecomment-5310590604) and [NextTang commit `61ebd07`](https://github.com/jattree/NextTang/commit/61ebd075b46a0f5eeb49dcd853aa7e511c558046). This verifies address-line and endpoint mapping, not exhaustive every-cell or sustained-load coverage.

## 

## Phenomenon Description
  After the corresponding bitstream has been successfully downloaded and programmed into the system, connect to the device via the UART interface. Upon successful initialization, the system will output the message “DDR3 TEST OKAY!” in the serial terminal.


  This message indicates that both onboard DDR3 memory devices (labeled W and R) have completed the initialization and memory test procedures successfully.


  During the test process, the system performs read/write verification on the DDR3 memory and checks the resulting counter value. A returned value of 16,777,215 (0xFF FF FF) confirms that the memory test has passed and that data integrity is correct. If the value is less than 0xFF FF FF, the test is considered to have failed, indicating a potential DDR3 memory access or hardware error.


  The test result can be verified using either of the following methods:

  - By monitoring the UART output through the onboard debugger’s Virtual COM Port (VCP) using a serial terminal, usually the one with the higher number.
  - By observing the green LED connected to IO pin V13 on the Console Dock Board. When the LED is illuminated, it typically indicates that the DDR3 test has completed successfully.


  In addition, the system supports UART input echo functionality. Any characters entered via the keyboard will be echoed back and displayed in the terminal, allowing users to verify basic UART communication and interaction.

# DDR3 DRAM TEST
  *ddr_memory_test_uart_Ver.*.fs.7z* is the prebuilt bitstream, select according to the device version.
  
  If you don't know how to determine the device version, please refer [**HERE**](wiki.sipeed.com/hardware/en/tang/common-doc/questions.html#How-to-Identify-Device-Version).
## Test Condition
  - GOWIN EDA Version **V1.9.12.02_SP1** (64-bit) **build(84852)**.
  - Onboard debugger or an additional FT2232 debugger, USB2TLL, whatever you like.
  - UART: buad 115200, 8N1

## Applicable Models
  - Tang Mega 138k SOM  *standalone* (Version 30153 or later, both VerB & VerC)
  - Tang Mega 138k Dock (Version 31004 or later)
  - Tang Console 138k  (Version 33001C or later)

## 

## Phenomenon Description
  After the corresponding bitstream has been successfully downloaded and programmed into the system, connect to the device via the UART interface. Upon successful initialization, the system will output the message “DDR3 TEST OKAY!” in the serial terminal.


  This message indicates that both onboard DDR3 memory devices (labeled W and R) have completed the initialization and memory test procedures successfully.


  During the test process, the system performs read/write verification on the DDR3 memory and checks the resulting counter value. A returned value of 16,777,215 (0xFF FF FF) confirms that the memory test has passed and that data integrity is correct. If the value is less than 0xFF FF FF, the test is considered to have failed, indicating a potential DDR3 memory access or hardware error.


  The test result can be verified using either of the following methods:

  - By monitoring the UART output through the onboard debugger’s Virtual COM Port (VCP) using a serial terminal, usually the one with the higher number.
  - By observing the green LED connected to IO pin V13 on the Console Dock Board. When the LED is illuminated, it typically indicates that the DDR3 test has completed successfully.


  In addition, the system supports UART input echo functionality. Any characters entered via the keyboard will be echoed back and displayed in the terminal, allowing users to verify basic UART communication and interaction.

# DDR3 DRAM TEST
Test condition: No addtion.

## Applicable models
  - Tang Mega 138k(SOM)
  - Tang Mega 138k Dock
  - Tang Console 138k

## Phenomenon Description
  After the corresponding bitstream has been successfully downloaded and programmed into the system, connect to the device via the UART interface using a baud rate of 115200 on the RX pin. Upon successful initialization, the system will output the message “DDR3 TEST OKAY!” in the serial terminal.


  This message indicates that both onboard DDR3 memory devices (labeled W and R) have completed the initialization and memory test procedures successfully.


  During the test process, the system performs read/write verification on the DDR3 memory and checks the resulting counter value. A returned value of 16,777,215 (0xFF FF FF) confirms that the memory test has passed and that data integrity is correct. If the value is less than 0xFF FF FF, the test is considered to have failed, indicating a potential DDR3 memory access or hardware error.


  The test result can be verified using either of the following methods:

  - By monitoring the UART output through the onboard debugger’s Virtual COM Port (VCP) using a serial terminal, usually the one with the higher number.
  - By observing the green LED connected to IO pin V13 on the Console Dock Board. When the LED is illuminated, it typically indicates that the DDR3 test has completed successfully.


  In addition, the system supports UART input echo functionality. Any characters entered via the keyboard will be echoed back and displayed in the terminal, allowing users to verify basic UART communication and interaction.
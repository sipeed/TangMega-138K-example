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

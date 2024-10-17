# CH569_HSPI_USB

WCHISPStudio is used to flash `CH569_HSPI_USB/obj/CH569_HSPI_USB.hex` to your CH569 onboard.


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
- **DO NOT** use GOWIN Programmer version **1.9.10.02**, for this version contains many issues
- You can get a windows GOWIN Programmer version **1.9.10.03** Alpha for [HERE](https://api.dl.sipeed.com/shareURL/TANG/programmer)

# pcie_dma_demo - a SERDES demo for Sipeed Tang MEGA 138K FPGA Boards


This project is a demo to test the Serdes on GOWIN GW5AST-138K, it base on Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html), and uses the PCIe x4 AIC interfaces on the board for transceiver testing.

## Main features

- x1, x2 or x4 PCIe bus transmission
- Support PCIe Gen2 or Gen3(Gen 3 for defulate)
- speed testing with GOWIN linux pcie driver and demo application

This demo is forked from the pcie demo of Sipeed [Tang MEGA 138K Pro](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k-pro.html), which mainchip is **GW5AST-LV138FPG676AC1/10** or **GW5AST-LV138FPG676AES**.   
And it now is tested on Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html), which mainchip is **GW5AST-LV138PGG464AC1/10** or **GW5AST-LV138PG484AES**.   

In theory, other GW5AST & GW5AT models can also use this demo, such as Sipeed [Tang MEGA 60k](https://wiki.sipeed.com/hardware/en/tang/tang-mega-60k/mega-60k.html), which mainchip is **GW5AT-LV60PGG464AC1/10** or **GW5AT-LV60PG484AES**. However, the relevant IP needs to wait for the release of updates from ***GOWIN SEMI***.


## Directory structure

```
| -- docs                         --> manuals and documentation
|    |`-- PCIe_demo_guide_en.pdf  --> official guide（en） 
|    |`-- PCIe_demo_guide_zh.pdf  --> official guide(zh) 
|     `-- images                  --> picture resources                           
|-- src                           --> project sources
|-- impl                          --> project config & implementation  
|
|`-- gowin_pcie_demo.7z           --> drivers & app for test(zipped)
|`-- pcie_dma_demo.fs.7z          --> prbuild bitstream(zipped)
|`-- pcie_dma_demo.gprj           --> demo project
|`-- pcie_dma_demo.gprj.user      --> project conf.

```

## Getting start

- See official guide first.
- For Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html) & [Tang MEGA 60k](https://wiki.sipeed.com/hardware/en/tang/tang-mega-60k/mega-60k) before **version 31005**:
   
   - The version number is on the back of the board, just below the DIP switch.
   - For facilitate testing, the board needs to be modified to automatically turn on after power-on.
   - In order to achieve the above modifications, you need to solder the R190 or R191 by yourself, or just short the two pads by a tin.
   - You could refer [the ibom](https://dl.sipeed.com/shareURL/TANG/Mega_138K_60K/03_Designator_drawing/) for Sipeed download station.

## Important notes

   - You need to compile the kernel module and the demo app for your system and load the kernel module yourself. 
   - The demo requires PCIe Gen3. Although it can be modified to Gen2 mode. However, the demo's compatibility with PCIe Gen2 was very poor in previous testing.
   - It's recommend to programming your board to flash before start test.
   - If you want to compile the demo yourself, don't forget to set the flash loading rate to 105MHz in *Project-Configuration-sysControl*. Otherwise, there will be some compatibility issues when using PCie on the computer motherboard for testing.

## How to use

- See GOWIN [official guide](./doc/) first.
- Prepare the system and environment for testing and ensure that the kernel module is loaded correctly.
- Assemble your board with a PC motherboard with PCIe Slot(x4 or longer), or use a USB4/Thunderbolt PCIe dock instead.
- Use the `lspci` to check whether there is a new `**memory controller**` in the system, and its ID is `22C2:1100`.Otherwise, please troubleshoot the problem according to the LED table below.
- Starting test according to the instructions in the [official guide](./doc/PCIe_demo_guide_en.pdf).

## LEDs & button

This demo uses 4 LEDs to indicate status
You need a PMOD_LED module to get the indicator LEDs, just plug the module into the **LEFT** connector near the board edge.   
Here are the details for LEDs: 
(LED0 is on the far right, next to the HDMI connector)

| LEDs      | Description                     | Expected situation|
| ----------| --------------------------------|-------------------|
| LED0      |  RUNNING INDICATOR              | BLINK             |
| LED1      |  PCIe RESET                     | *OFF(SEE NOTE)    |
| LED2      |  PCIe LOGIC START               | ON                |
| LED3      |  PCIe LINK UP                   | ON                |

*NOTE: During the computer startup self-test or after plug USB4/Thunderbolt cable to the computer, the LED will light up briefly. 
But this LED should not be always on, otherwise please check whether the relevant **PIN(W11)** in the project is constrained to **PULL_UP** mode.

1 button **KEY.1(AB13)** use to reset the transmission.  

## Troubleshoot

- If the board is installed on the motherboard for testing, please ensure that the board is programmed and then powered on while the host computer is completely powered off.
- If you find that the board is not recognized after entering the system, you need to perform the above process again.

## Development

Please refer to the comments in the top file, those comments help understand how the entire demo works.

The brief working principle of the demo:
1. Analyze the tlp written to the BAR to obtain the dma configuration.
2. Then the fpga starts the dma to send the tlp for memory reading and writing, and at the same time reports the interrupt through the MSI.



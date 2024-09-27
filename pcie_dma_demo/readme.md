# pcie_dma_demo - a SERDES demo for Sipeed Tang MEGA 138K FPGA Boards


This project is a demo to test the Serdes on GOWIN GW5AST-138K, it base on Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html), and uses the PCIe x4 AIC interfaces on the board for transceiver testing.

Main features,

- x1, x2 or x4 PCIe bus transmission
- Support PCIe Gen2 or Gen3(Gen 3 for defulate)
- speed testing with GOWIN linux pcie driver and demo application

This demo is forked from the pcie demo of Sipeed [Tang MEGA 138K Pro](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k-pro.html), which mainchip is **GW5AST-LV138FPG676AC1/10** or **GW5AST-LV138FPG676AES**.   
And it now is tested on Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html), which mainchip is **GW5AST-LV138PGG464AC1/10** or **GW5AST-LV138PG484AES**.   

In theory, other GW5AST & GW5AT models can also use this demo, such as Sipeed [Tang MEGA 60k](https://wiki.sipeed.com/hardware/en/tang/tang-mega-60k/mega-60k.html), which mainchip is **GW5AT-LV60PGG464AC1/10** or **GW5AT-LV60PG484AES**. However, the relevant IP needs to wait for the release of updates from ***GOWIN DEMI***.


## Directory structure

```
| -- docs
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

## How to use

- See official guide first.

## LEDs & button
TBD

## Development
TBD

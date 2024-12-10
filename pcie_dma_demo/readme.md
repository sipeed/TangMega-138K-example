# pcie_dma_demo - a SERDES demo for Sipeed Tang MEGA 138K FPGA Boards


This project is a demo to test the Serdes on GOWIN GW5AST-138K, it base on Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html), and uses the PCIe x4 **AIC interfaces** on the board for transceiver testing.

## Main features

- x1, x2 or x4 PCIe bus transmission
- Support both PCIe Gen2 or Gen3
- Speed testing with **GOWIN** Linux PCIe Driver and Demo Application
- Up to 6 configurable PCIe bar

This demo is forked from the pcie demo of Sipeed [Tang MEGA 138K Pro](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k-pro.html), which mainchip is **GW5AST-LV138FPG676AC1/10** or **GW5AST-LV138FPG676AES**.   
And it now is tested on Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html), which mainchip is **GW5AST-LV138PGG484AC1/10** or **GW5AST-LV138PG484AES**.   

In theory, other GW5AST & GW5AT models can also use this demo, such as Sipeed [Tang MEGA 60k](https://wiki.sipeed.com/hardware/en/tang/tang-mega-60k/mega-60k.html), which mainchip is **GW5AT-LV60PGG484AC1/10** or **GW5AT-LV60PG484AES**. However, the relevant IP needs to wait for the release of updates from ***GOWIN SEMI***.


## Directory structure

```
| -- docs                         --> manuals and documentation
|    |`-- PCIe_demo_guide_en.pdf  --> official guide（en） 
|    |`-- PCIe_demo_guide_zh.pdf  --> official guide(zh) 
|     `-- images                  --> picture resources
|    
| -- pcie_gen2(5G)                --> pcie_gen2 demo 
|    |`-- src                     --> project sources
|    |`-- impl                    --> project config & implementation  
|    |`-- pcie_dma_demo.fs.7z     --> prbuild bitstream(zipped)
|     `-- pcie_dma_demo.gprj      --> demo project
|    
| -- pcie_gen3(8G)                --> pcie_gen3 demo 
|    |`-- src                     --> project sources
|    ...
|
| -- gowin_pcie_demo.7z           --> drivers & app for test(zipped)    
|   
```

***
## Implementation report

### Timing report
![Timing_Summaries](./docs/images/Timing_Summaries.png)
As shown, the design meets all timing constraints.

### Resource report
![Resource_rpt](./docs/images/Resource_rpt.png)
The resource usage of this design is shown in the figure aboce.

***

## Getting start

- See official guide first.
- For Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html) & [Tang MEGA 60k](https://wiki.sipeed.com/hardware/en/tang/tang-mega-60k/mega-60k) before **version 31005**:
   
   - The version number is on the back of the board, just below the DIP switch.
   - For facilitate testing, the board needs to be modified to automatically turn on after power-on.
   - In order to achieve the above modifications, you need to solder the R190 or R191 by yourself, or just short the two pads by a tin.
   - You could refer [the ibom](https://dl.sipeed.com/shareURL/TANG/Mega_138K_60K/03_Designator_drawing/) for Sipeed download station.
- Please **DO NOT** :
   - Delete the **`impl`** folder.
   - Try to change the FPGA model in the project yourself.
   - Rename the project. 
   
   Otherwise you may lose important configuration information about your project. This leads to a series of problems such as implementation failure or unsatisfied timing.

   If you unfortunately have encountered a problem, please refer to the [Troubleshoot](#troubleshoot) section for solutions.


## Important notes

   - You need to compile the kernel module and the demo app for your system and load the kernel module yourself.
   - The recommended operating system distribution is Ubuntu20.04, but Ubuntu22.04 or newer is also available (you need to solve the dependency problem by yourself). 
   - It's recommend to programming your board to flash before start test.
   - If you want to compile the demo yourself, don't forget to set the flash loading rate to 105MHz in *Project-Configuration-sysControl*. Otherwise, there will be some compatibility issues when using PCie on the computer motherboard for testing.

## How to use

- See GOWIN [official guide](./docs/) first.
- Prepare the system and environment for testing and ensure that the kernel module is loaded correctly.
- Assemble your board with a PC motherboard with PCIe Slot(x4 or longer), or use a USB4/Thunderbolt PCIe dock instead.
- Use the `lspci` to check whether there is a new `**memory controller**` in the system, and its ID is `22C2:1100`.Otherwise, please troubleshoot the problem according to the LED table below.
- Starting test according to the instructions in the [official guide](./docs/PCIe_demo_guide_en.pdf).

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

### Building the progject
- **WARN  (PR1014) :** Generic routing resource will be used to clock signal 'sys_clk_p_d' by the specified constraint.
  - This is due to the oscillator clock input pin **`V22`** on the SOM which is not the GCLK pin.
  - Since this design does not involve complex cross-clock domain synchronization processing, it can be ignored.

- **ERROR  (PR2028) :** The constrained location is useless in current package. & **ERROR  (PR2017) :** 'led[x]' cannot be placed according to constraint, for the location is a dedicated pin (CPU/SSPI).
  - This is usually caused by missing project configuration. As the error message says, led[x] is a dedicated pin (CPU/SSPI).
  - The solution is as follows:
    - In top bar menu, go to ***`Project-Configuration`***, than selet ***`Dual-Purpose Pin`***. Check the corresponding options according to the error message. 
    - For example, you need to check ***`Use SSPI as regular IO` & `Use CPU as regular IO`*** here.
    ![Dual-Purpose_pin](./docs/images/Dual-Purpose_Pin.png)
    - Then try to re-Implementation it.
- The timing report shows that timing constraints are not met (contains **RED ITEMS**)
![timing_error](./docs/images/Timing_error.png)
  - This is also caused by missing project configuration. In order to solve the problem, you need to confirm the following settings:
     - In top bar menu, go to ***`Project-Configuration`***, than selet ***`Place`***. Change the `Place Option` to `2`. 
     - *(optional)* Change `Place input registers to IOB`, `Place output registers to IOB`, `Place inout registers to IOB` to `Ture`,
     - *(optional)* In ***`Route`*** page, Change the `Clock Route Order` to `1` & `Route Option` to `1`.
     - Then try to re-Implementation it.

### Testing the borad
#### On PC motherboard:
- Please ensure that the board is programmed while the host computer is completely powered off, and then powered on your computer.
- If you find that the FPGA board is not recognized after entering the system, you need to reboot, or perform the above process again.

#### On USB4/Thunderbolt dock:
- Please ensure that the board is programmed, then plug it into your dock, the dock need to power-off first.
- Makesure that the dock is properly connected to power (if needed), then connect the dock to your PC. If you find that the FPGA board is not recognized, just re-plug your dock.
- If your dock cannot provide 12V power supply or does not have PCIe 3V3, you can use additional USB to power the FPGA board.

#### On Raspberry Pi:
- CM4/5 or 5b is needed.
- It seems that GOWIN's official PCIe driver has some problems on aarch64 Linux.

## Test environment
These environments have been verified and the demo can be used normally.

On PC motherboard:
- Motherboard: GIGABYTE **B365 M AORUS ELITE**
- CPU: Genuine Intel **i5-8400**
- System: Ubuntu **20.04**(Secure Boot disabled)

  Note: On this motherboard, if the demo is in **Gen3** mode, `copy_to_host` seems to have some problems, especially when the block size is 4096. The test will take a long time and look like it is frozen.Perhaps if you wait patiently for a while, the results will come out.
***
On USB4/Thunderbolt dock:
- Barebone computer: Genuine Intel **NUC13ANHi7**
- System: Ubuntu **22.04**(Secure Boot disabled)
- PCIe dock: **ADT UT3G** (ASM2464)
  
  Note: This dock seems to be **incompatible** with PCIe Gen2. During my testing, the dock did not recognize the Gen2 mode demo. Perhaps the **JHL** series(JHL7/8xxx) is more suitable for this test?
***
On Raspberry Pi:
- Raspberry Pi 5b(4GB RAM).
- Sipeed Tang Console NEO(Coming soon, Can be used as a PCIe HAT for the RPi).
- Necessary FPC wires and copper pillars.

## Development

Please refer to the comments in the top file, those comments help understand how the entire demo works.

The brief working principle of the demo:
1. Analyze the tlp written to the BAR to obtain the dma configuration.
2. Then the fpga starts the dma to send the tlp for memory reading and writing, and at the same time reports the interrupt through the MSI.



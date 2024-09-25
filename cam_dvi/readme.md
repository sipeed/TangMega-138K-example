# Cam2DVI - a DVP Camera DVI(HDMI) demo for Sipeed Tang MEGA 138K FPGA Boards

This project is a demo to test the DVP Camera, DDR3 memory & HDMI on GOWIN GW5AST-138K, it base on Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html), it uses the DDR3 memory as framebuffer on the board for video capture & output testing.

Main features,

- 720P@60/30Hz TMDS video output via HDMI connector.
- 720P@60/30Hz RGB565 video capture via DVP Camera OV5640.
- Use on board DDR3 memory as framebuffer .

This demo now is only test on Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html), which mainchip is **GW5AST-LV138PGG464AC1/10** or **GW5AST-LV138PG484AES**.   

## Directory structure

```
| -- docs  
|    |`-- images				  --> picture resources  
| -- cam2dvi 
|    |	`-- cam2dvi.fs.zst		  --> prbuild bitstream(zipped)                       
|    |	`-- cam2dvi.gprj		  --> demo project
|    |	`-- cam2dvi.gprj.user	  --> project conf.
|    |-- src                      --> project sources 

```

## Getting start
Please confirm that you have the following conditions:
- GOWIN IDE Version ≥ 1.9.10
- **DO NOT** use GOWIN Programmer version **1.9.10.02**, for this version contains many issues
- Sipeed [Tang MEGA 138K](https://wiki.sipeed.com/hardware/en/tang/tang-mega-138k/mega-138k.html)
- An OV5640 Sensor, a HDMI/DVI Monitor and a HDMI cable
- USB-C date cable, use to connect the board to  PC  

## How to use

Here are quick instructions for the more experienced,
- Assemble your sensor and board, then connect it to your monitor with an HDMI cable.
- Download & Complie the project, then downloading the bitstream to you board.
- You can also try using the prebuilt bitstream, but remember to unzip it before downloading.
- Observe whether the monitor is show the screen captured by the sensor correctly.

## LEDs & button

This demo uses 4 LEDs to indicate status
You need a PMOD_LED module to get the indicator LEDs, just plug the module into the outer connector.   
Here are the details for LEDs:(LED0 is on the far right)
| LEDs      | Description                     | Expected situation|
| ----------| --------------------------------|-------------------|
| LED0      |  DDR3 initialization            | ON                |
| LED1      |  DDR3_pll_lock                  | ON                |
| LED2      |  TMDS_DDR_pll_lock              | ON                |
| LED3      |  cmos_vs_cnt                    | Blink             |
| LED4      |  cmos_i2c_done                  | ON                |

1 button **(S0)** use to reset the transmission.  

## Development
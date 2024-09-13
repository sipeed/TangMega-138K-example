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
|    |`-- images					      --> picture resources  
| -- cam2dvi                          
|    |	`-- cam2dvi.gprj		  --> demo project
|    |	`-- cam2dvi.gprj.user	  --> project conf.
|    |-- src

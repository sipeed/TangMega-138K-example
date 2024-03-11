//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.9.01 (64-bit)
//Part Number: GW5A-LV25MG121NC2/I1
//Device: GW5A-25
//Device Version: A
//Created Time: Sun Mar 10 13:44:10 2024

module Gowin_OSC (oscout, oscen);

output oscout;
input oscen;

OSC osc_inst (
    .OSCOUT(oscout)
);

defparam osc_inst.FREQ_DIV = 2;

endmodule //Gowin_OSC

# Practical information

## How to generate a bitstream using your top architecture ?

To do so, you first need to specify the location of your used tools in the Makefile.

Following this, you just need to use the script vhdl2bitstream : 

`vhdl2bitstream xdc_name top_module source [phony]`

`xdc_name : ZYBO_Master, Zedboard-Master, zedboard_bis`

`top_module : name of your top module name architecture`

`source : directory of your source code`

`phony : ghdl, yosys, nextpnr, frames, bitstream (DEFAULT : bitstream)`

Note : please make sure your source code is in .vhd or in .v (and not .vhdl)



Exemple : `vhdl2bitstream.sh Zedboard-Master original_aes_top source_zybo/aes`
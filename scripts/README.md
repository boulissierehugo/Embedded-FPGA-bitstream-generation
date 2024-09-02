# What does aes_script.sh do ?

It communicates with some adresses using the IP described in the file VHDL/source_zybo/aes/simple_slave_axi4_aes.vhd to use the AES block.

It uses the devmem command which is already installed on Petalinux to communicate through the AXI interface.

For some reason, you have to execute two times the command to make sure the value is taken into account by the architecture.

/!\ If you don't have the devmem command on your OS, please refer to the other script using C code to communicate through the AXI interface /!\

(Please compile prior com_axi.c using the command : `gcc com_axi.c -o com_axi`)
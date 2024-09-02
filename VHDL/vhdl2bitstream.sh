# Generate a bitsream from vhdl and verilog code using the toolchain
# /!\ To use on the VHDL folder /!\
# input 1 : name of the xdc file 
# input 2 : top module name
# input 3 : source code
# DON'T FORGET TO MAKE CLEAN BEFORE LAUNCHING THE SCRIPT !

# Check if a board name was provided
if [ -z "$1" ]; then
    echo "Please provide a xdc file name as an argument (ZYBO_Master or Zedboard-Master or zedboard_bis)"
    exit 1
fi

# Check if a top module name was provided
if [ -z "$2" ]; then
    echo "Please provide a top module name as an argument."
    exit 1
fi

if [ -z "$3" ]; then
    SOURCE="source_zybo"
else
    SOURCE=$3
fi

if [ -z "$4" ]; then
    PHONY="bitstream"
else
    PHONY=$4
fi

XDC_NAME=$1
TOPmodule=$2

if [ "$XDC_NAME" == "ZYBO_Master" ]; then
    make TOP=${TOPmodule} SOURCE=${SOURCE} XDC_FILE=${XDC_NAME}.xdc 
elif [ "$XDC_NAME" == "Zedboard-Master" ] || [ "$XDC_NAME" == "zedboard_bis" ]; then
    make XDC_FILE=${XDC_NAME}.xdc YAML_DIR=xc7z020clg484-1 BIN_FILE=xc7z020.bin TOP=${TOPmodule} SOURCE=${SOURCE} ${PHONY}
else
    echo "Please provide an implemented board name (ZYBO_Master or Zedboard-Master or zedboard_bis)"
    exit 1
fi

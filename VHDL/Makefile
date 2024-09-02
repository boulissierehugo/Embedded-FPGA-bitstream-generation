### LOCATION OF THE USER'S TOOLS  ###
# PLEASE CHANGE ACCORDING TO YOUR OWN NEEDS #
GHDL_DIR = ../../ghdl/ghdl/bin
NEXTPNR_DIR = ../nextpnr-xilinx
PRJXRAY_DIR = ../prjxray
YOSYS_DIR = 
#####################################
###PNR###
XDC_DIR := ../XDC
XDC_FILE = ZYBO_Master.xdc #Zedboard-Master.xdc for the zedboard (write make XDC_FILE=your_xdc_file)
CHIPDB_DIR := ../CHIPDB
BIN_FILE = xc7z010.bin #xc7z020.bin pour la zedboard
YAML_DIR = xc7z010clg400-1
#xc7z020clg484-1
# à changer pour la zedboard par xc7z020clg484-1 (fait dans le cript vhdl2bitstream.sh)
#########
### OUTPUT ###
OUTPUT_DIR = output
##############
### SOURCE + TOP ###
SOURCE = source
TOP = original_aes_top
TOP_SOURCE := ${SOURCE}/${TOP}.vhd
TOP_ARCH := ${TOP}
FICHIER_VHDL := ${SOURCE}/*.vhd
####################


# Définir les dépendances
ALL: fichier_ghdl.v NETLIST.json FASM.fasm FRAMES.frames ${TOP}.bit

### Here we define the rules to generate all the temporary files ###

fichier_ghdl.v: $(TOP_SOURCE)
	${GHDL_DIR}/ghdl -a -fsynopsys $(FICHIER_VHDL) $(TOP_SOURCE)
	${GHDL_DIR}/ghdl synth -fsynopsys --out=verilog $(TOP_ARCH) > $@

FICHIER_V := ${SOURCE}/*.v fichier_ghdl.v

NETLIST.json: fichier_ghdl.v
	${YOSYS_DIR}yosys -p "synth_xilinx -arch xc7 -top $(TOP_ARCH); write_json $@" ${FICHIER_V} | tee log/info.log

FASM.fasm: NETLIST.json
	${NEXTPNR_DIR}/nextpnr-xilinx --chipdb ${CHIPDB_DIR}/${BIN_FILE} --xdc ${XDC_DIR}/${XDC_FILE} --json $< --write NETLISTROUTED.json --fasm $@ --router router1 --no-tmdriv --tmg-ripup -l log/nextpnr.log


FRAMES.frames: FASM.fasm
	bash -c "source ${PRJXRAY_DIR}/env/bin/activate && ${PRJXRAY_DIR}/utils/fasm2frames.py --part ${YAML_DIR} --db-root ${PRJXRAY_DIR}/utils/../database/zynq7 FASM.fasm > FRAMES.frames"
${TOP}.bit: FRAMES.frames
	bash -c "source ${PRJXRAY_DIR}/env/bin/activate && ${PRJXRAY_DIR}/build/tools/xc7frames2bit --part_file ${PRJXRAY_DIR}/database/zynq7/${YAML_DIR}/part.yaml --part_name ${YAML_DIR} --frm_file $< --output_file $(OUTPUT_DIR)/$@"

# Remove all the temporary files
clean:
	rm fichier_ghdl.v FASM.fasm FRAMES.frames NETLIST.json NETLISTROUTED.json work-obj93.cf 



# Convenient targets
.PHONY : ghdl yosys nextpnr frames bitstream
ghdl      : fichier_ghdl.v
yosys     : NETLIST.json
nextpnr   : FASM.fasm
frames    : FRAMES.frames
bitstream : ${TOP}.bit

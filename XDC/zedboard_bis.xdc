# This file is a general .xdc for the Zedboard board
# To use it in a project:
# - uncomment the lines corresponding to used pins
# - rename the used signals according to the project

# The on-board Vadj jumper (J18) enables to change the voltage of IO banks 34 and 35
# Possible voltages are 1.8V, 2.5V and 3.3V, default is normally 1.8V
# The IOSTANDARD property of the corresponding pins must be set to respectively LVCMOS18, LVCMOS25 or LVCMOS33

# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN Y9 [get_ports {gclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {gclk}]

#create_clock -add -name gclk_clock -period 10.00 -waveform {0 5} [get_ports gclk]

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN T22 [get_ports {led[0]}]
set_property PACKAGE_PIN T21 [get_ports {led[1]}]
set_property PACKAGE_PIN U22 [get_ports {led[2]}]
set_property PACKAGE_PIN U21 [get_ports {led[3]}]
set_property PACKAGE_PIN V22 [get_ports {led[4]}]
set_property PACKAGE_PIN W22 [get_ports {led[5]}]
set_property PACKAGE_PIN U19 [get_ports {led[6]}]
set_property PACKAGE_PIN U14 [get_ports {led[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN P16 [get_ports {btnc}]
set_property PACKAGE_PIN R16 [get_ports {btnd}]
set_property PACKAGE_PIN N15 [get_ports {btnl}]
set_property PACKAGE_PIN R18 [get_ports {btnr}]
set_property PACKAGE_PIN T18 [get_ports {btnu}]

set_property IOSTANDARD LVCMOS18 [get_ports {btnc}]
set_property IOSTANDARD LVCMOS18 [get_ports {btnd}]
set_property IOSTANDARD LVCMOS18 [get_ports {btnl}]
set_property IOSTANDARD LVCMOS18 [get_ports {btnr}]
set_property IOSTANDARD LVCMOS18 [get_ports {btnu}]

# ----------------------------------------------------------------------------
# User DIP Switches - Bank 35
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN F22 [get_ports {sw[0]}]
set_property PACKAGE_PIN G22 [get_ports {sw[1]}]
set_property PACKAGE_PIN H22 [get_ports {sw[2]}]
set_property PACKAGE_PIN F21 [get_ports {sw[3]}]
set_property PACKAGE_PIN H19 [get_ports {sw[4]}]
set_property PACKAGE_PIN H18 [get_ports {sw[5]}]
set_property PACKAGE_PIN H17 [get_ports {sw[6]}]
set_property PACKAGE_PIN M15 [get_ports {sw[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {sw[7]}]

# ----------------------------------------------------------------------------
# OLED Display - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN U10  [get_ports {OLED_DC}]
set_property PACKAGE_PIN U9   [get_ports {OLED_RES}]
set_property PACKAGE_PIN AB12 [get_ports {OLED_SCLK}]
set_property PACKAGE_PIN AA12 [get_ports {OLED_SDIN}]
set_property PACKAGE_PIN U11  [get_ports {OLED_VBAT}]
set_property PACKAGE_PIN U12  [get_ports {OLED_VDD}]

set_property IOSTANDARD LVCMOS33 [get_ports {OLED_DC}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_RES}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_SCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_SDIN}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_VBAT}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_VDD}]

# ----------------------------------------------------------------------------
# HDMI Output - Bank 33
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN W18  [get_ports {HD_CLK}]
set_property PACKAGE_PIN Y13  [get_ports {HD_D0}]
set_property PACKAGE_PIN AA13 [get_ports {HD_D1}]
set_property PACKAGE_PIN AA14 [get_ports {HD_D2}]
set_property PACKAGE_PIN Y14  [get_ports {HD_D3}]
set_property PACKAGE_PIN AB15 [get_ports {HD_D4}]
set_property PACKAGE_PIN AB16 [get_ports {HD_D5}]
set_property PACKAGE_PIN AA16 [get_ports {HD_D6}]
set_property PACKAGE_PIN AB17 [get_ports {HD_D7}]
set_property PACKAGE_PIN AA17 [get_ports {HD_D8}]
set_property PACKAGE_PIN Y15  [get_ports {HD_D9}]
set_property PACKAGE_PIN W13  [get_ports {HD_D10}]
set_property PACKAGE_PIN W15  [get_ports {HD_D11}]
set_property PACKAGE_PIN V15  [get_ports {HD_D12}]
set_property PACKAGE_PIN U17  [get_ports {HD_D13}]
set_property PACKAGE_PIN V14  [get_ports {HD_D14}]
set_property PACKAGE_PIN V13  [get_ports {HS_D15}]
set_property PACKAGE_PIN U16  [get_ports {HD_DE}]
set_property PACKAGE_PIN V17  [get_ports {HD_HSYNC}]
set_property PACKAGE_PIN W16  [get_ports {HD_INT}]
set_property PACKAGE_PIN AA18 [get_ports {HD_SCL}]
set_property PACKAGE_PIN Y16  [get_ports {HD_SDA}]
set_property PACKAGE_PIN U15  [get_ports {HD_SPDIF}]
set_property PACKAGE_PIN Y18  [get_ports {HD_SPDIFO}]
set_property PACKAGE_PIN W17  [get_ports {HD_VSYNC}]

set_property IOSTANDARD LVCMOS33 [get_ports {HD_CLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D0}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D1}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D2}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D3}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D4}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D5}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D6}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D7}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D8}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D9}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D10}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D11}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D12}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D13}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_D14}]
set_property IOSTANDARD LVCMOS33 [get_ports {HS_D15}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_DE}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_HSYNC}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_INT}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_SCL}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_SDA}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_SPDIF}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_SPDIFO}]
set_property IOSTANDARD LVCMOS33 [get_ports {HD_VSYNC}]

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN Y21  [get_ports {VGA_B1}]
set_property PACKAGE_PIN Y20  [get_ports {VGA_B2}]
set_property PACKAGE_PIN AB20 [get_ports {VGA_B3}]
set_property PACKAGE_PIN AB19 [get_ports {VGA_B4}]
set_property PACKAGE_PIN AB22 [get_ports {VGA_G1}]
set_property PACKAGE_PIN AA22 [get_ports {VGA_G2}]
set_property PACKAGE_PIN AB21 [get_ports {VGA_G3}]
set_property PACKAGE_PIN AA21 [get_ports {VGA_G4}]
set_property PACKAGE_PIN V20  [get_ports {VGA_R1}]
set_property PACKAGE_PIN U20  [get_ports {VGA_R2}]
set_property PACKAGE_PIN V19  [get_ports {VGA_R3}]
set_property PACKAGE_PIN V18  [get_ports {VGA_R4}]
set_property PACKAGE_PIN AA19 [get_ports {VGA_HS}]
set_property PACKAGE_PIN Y19  [get_ports {VGA_VS}]

set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B1}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B2}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B3}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B4}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G1}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G2}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G3}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G4}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R1}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R2}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R3}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R4}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_HS}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_VS}]

# ----------------------------------------------------------------------------
# Audio Codec - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN AB1 [get_ports {AC_ADR0}]
set_property PACKAGE_PIN Y5  [get_ports {AC_ADR1}]
set_property PACKAGE_PIN Y8  [get_ports {AC_GPIO0}]
set_property PACKAGE_PIN AA7 [get_ports {AC_GPIO1}]
set_property PACKAGE_PIN AA6 [get_ports {AC_GPIO2}]
set_property PACKAGE_PIN Y6  [get_ports {AC_GPIO3}]
set_property PACKAGE_PIN AB2 [get_ports {AC_MCLK}]
set_property PACKAGE_PIN AB4 [get_ports {AC_SCK}]
set_property PACKAGE_PIN AB5 [get_ports {AC_SDA}]

set_property IOSTANDARD LVCMOS33 [get_ports {AC_ADR0}]
set_property IOSTANDARD LVCMOS33 [get_ports {AC_ADR1}]
set_property IOSTANDARD LVCMOS33 [get_ports {AC_GPIO0}]
set_property IOSTANDARD LVCMOS33 [get_ports {AC_GPIO1}]
set_property IOSTANDARD LVCMOS33 [get_ports {AC_GPIO2}]
set_property IOSTANDARD LVCMOS33 [get_ports {AC_GPIO3}]
set_property IOSTANDARD LVCMOS33 [get_ports {AC_MCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {AC_SCK}]
set_property IOSTANDARD LVCMOS33 [get_ports {AC_SDA}]

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN Y11  [get_ports {JA1}]
set_property PACKAGE_PIN AA11 [get_ports {JA2}]
set_property PACKAGE_PIN Y10  [get_ports {JA3}]
set_property PACKAGE_PIN AA9  [get_ports {JA4}]
set_property PACKAGE_PIN AB11 [get_ports {JA7}]
set_property PACKAGE_PIN AB10 [get_ports {JA8}]
set_property PACKAGE_PIN AB9  [get_ports {JA9}]
set_property PACKAGE_PIN AA8  [get_ports {JA10}]

set_property IOSTANDARD LVCMOS33 [get_ports {JA1}]
set_property IOSTANDARD LVCMOS33 [get_ports {JA2}]
set_property IOSTANDARD LVCMOS33 [get_ports {JA3}]
set_property IOSTANDARD LVCMOS33 [get_ports {JA4}]
set_property IOSTANDARD LVCMOS33 [get_ports {JA7}]
set_property IOSTANDARD LVCMOS33 [get_ports {JA8}]
set_property IOSTANDARD LVCMOS33 [get_ports {JA9}]
set_property IOSTANDARD LVCMOS33 [get_ports {JA10}]

# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN W12 [get_ports {JB1}]
set_property PACKAGE_PIN W11 [get_ports {JB2}]
set_property PACKAGE_PIN V10 [get_ports {JB3}]
set_property PACKAGE_PIN W8  [get_ports {JB4}]
set_property PACKAGE_PIN V12 [get_ports {JB7}]
set_property PACKAGE_PIN W10 [get_ports {JB8}]
set_property PACKAGE_PIN V9  [get_ports {JB9}]
set_property PACKAGE_PIN V8  [get_ports {JB10}]

set_property IOSTANDARD LVCMOS33 [get_ports {JB1}]
set_property IOSTANDARD LVCMOS33 [get_ports {JB2}]
set_property IOSTANDARD LVCMOS33 [get_ports {JB3}]
set_property IOSTANDARD LVCMOS33 [get_ports {JB4}]
set_property IOSTANDARD LVCMOS33 [get_ports {JB7}]
set_property IOSTANDARD LVCMOS33 [get_ports {JB8}]
set_property IOSTANDARD LVCMOS33 [get_ports {JB9}]
set_property IOSTANDARD LVCMOS33 [get_ports {JB10}]

# ----------------------------------------------------------------------------
# JC Pmod - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN AB6 [get_ports {JC1_N}]
set_property PACKAGE_PIN AB7 [get_ports {JC1_P}]
set_property PACKAGE_PIN AA4 [get_ports {JC2_N}]
set_property PACKAGE_PIN Y4  [get_ports {JC2_P}]
set_property PACKAGE_PIN T6  [get_ports {JC3_N}]
set_property PACKAGE_PIN R6  [get_ports {JC3_P}]
set_property PACKAGE_PIN U4  [get_ports {JC4_N}]
set_property PACKAGE_PIN T4  [get_ports {JC4_P}]

set_property IOSTANDARD LVCMOS33 [get_ports {JC1_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {JC1_P}]
set_property IOSTANDARD LVCMOS33 [get_ports {JC2_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {JC2_P}]
set_property IOSTANDARD LVCMOS33 [get_ports {JC3_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {JC3_P}]
set_property IOSTANDARD LVCMOS33 [get_ports {JC4_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {JC4_P}]

# ----------------------------------------------------------------------------
# JD Pmod - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN W7 [get_ports {JD1_N}]
set_property PACKAGE_PIN V7 [get_ports {JD1_P}]
set_property PACKAGE_PIN V4 [get_ports {JD2_N}]
set_property PACKAGE_PIN V5 [get_ports {JD2_P}]
set_property PACKAGE_PIN W5 [get_ports {JD3_N}]
set_property PACKAGE_PIN W6 [get_ports {JD3_P}]
set_property PACKAGE_PIN U5 [get_ports {JD4_N}]
set_property PACKAGE_PIN U6 [get_ports {JD4_P}]

set_property IOSTANDARD LVCMOS33 [get_ports {JD1_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {JD1_P}]
set_property IOSTANDARD LVCMOS33 [get_ports {JD2_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {JD2_P}]
set_property IOSTANDARD LVCMOS33 [get_ports {JD3_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {JD3_P}]
set_property IOSTANDARD LVCMOS33 [get_ports {JD4_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {JD4_P}]

# ----------------------------------------------------------------------------
# OLED Display - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN U10  [get_ports {OLED_DC}]
set_property PACKAGE_PIN U9   [get_ports {OLED_RES}]
set_property PACKAGE_PIN AB12 [get_ports {OLED_SCLK}]
set_property PACKAGE_PIN AA12 [get_ports {OLED_SDIN}]
set_property PACKAGE_PIN U11  [get_ports {OLED_VBAT}]
set_property PACKAGE_PIN U12  [get_ports {OLED_VDD}]

set_property IOSTANDARD LVCMOS33 [get_ports {OLED_DC}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_RES}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_SCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_SDIN}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_VBAT}]
set_property IOSTANDARD LVCMOS33 [get_ports {OLED_VDD}]

# ----------------------------------------------------------------------------
# USB OTG Reset - Bank 34
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN L16 [get_ports {OTG_VBUSOC}]
set_property IOSTANDARD LVCMOS18 [get_ports {OTG_VBUSOC}]

# ----------------------------------------------------------------------------
# XADC GIO - Bank 34
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN H15 [get_ports {XADC_GIO0}]
set_property PACKAGE_PIN R15 [get_ports {XADC_GIO1}]
set_property PACKAGE_PIN K15 [get_ports {XADC_GIO2}]
set_property PACKAGE_PIN J15 [get_ports {XADC_GIO3}]

set_property IOSTANDARD LVCMOS18 [get_ports {XADC_GIO0}]
set_property IOSTANDARD LVCMOS18 [get_ports {XADC_GIO1}]
set_property IOSTANDARD LVCMOS18 [get_ports {XADC_GIO2}]
set_property IOSTANDARD LVCMOS18 [get_ports {XADC_GIO3}]

# ----------------------------------------------------------------------------
# Miscellaneous - Bank 34
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN K16 [get_ports {PUDC_B}]
set_property IOSTANDARD LVCMOS18 [get_ports {PUDC_B}]

# ----------------------------------------------------------------------------
# USB OTG Reset - Bank 35
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN G17 [get_ports {OTG_RESETN}]
set_property IOSTANDARD LVCMOS18 [get_ports {OTG_RESETN}]

# ----------------------------------------------------------------------------
# XADC AD Channels - Bank 35
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN E16 [get_ports {AD0N_R}]
set_property PACKAGE_PIN F16 [get_ports {AD0P_R}]
set_property PACKAGE_PIN D17 [get_ports {AD8N_N}]
set_property PACKAGE_PIN D16 [get_ports {AD8P_R}]

set_property IOSTANDARD LVCMOS18 [get_ports {AD0N_R}]
set_property IOSTANDARD LVCMOS18 [get_ports {AD0P_R}]
set_property IOSTANDARD LVCMOS18 [get_ports {AD8N_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {AD8P_R}]

# ----------------------------------------------------------------------------
# FMC Expansion Connector - Bank 13
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN R7 [get_ports {FMC_SCL}]
set_property PACKAGE_PIN U7 [get_ports {FMC_SDA}]

set_property IOSTANDARD LVCMOS33 [get_ports {FMC_SCL}]
set_property IOSTANDARD LVCMOS33 [get_ports {FMC_SDA}]

# ----------------------------------------------------------------------------
# FMC Expansion Connector - Bank 33
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN AB14 [get_ports {FMC_PRSNT}]
set_property IOSTANDARD LVCMOS33 [get_ports {FMC_PRSNT}]

# ----------------------------------------------------------------------------
# FMC Expansion Connector - Bank 34
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN L19 [get_ports {FMC_CLK0_N}]
set_property PACKAGE_PIN L18 [get_ports {FMC_CLK0_P}]
set_property PACKAGE_PIN M20 [get_ports {FMC_LA00_CC_N}]
set_property PACKAGE_PIN M19 [get_ports {FMC_LA00_CC_P}]
set_property PACKAGE_PIN N20 [get_ports {FMC_LA01_CC_N}]
set_property PACKAGE_PIN N19 [get_ports {FMC_LA00_CC_P}]
set_property PACKAGE_PIN P18 [get_ports {FMC_LA02_N}]
set_property PACKAGE_PIN P17 [get_ports {FMC_LA02_P}]
set_property PACKAGE_PIN P22 [get_ports {FMC_LA03_N}]
set_property PACKAGE_PIN N22 [get_ports {FMC_LA03_P}]
set_property PACKAGE_PIN M22 [get_ports {FMC_LA04_N}]
set_property PACKAGE_PIN M21 [get_ports {FMC_LA04_P}]
set_property PACKAGE_PIN K18 [get_ports {FMC_LA05_N}]
set_property PACKAGE_PIN J18 [get_ports {FMC_LA05_P}]
set_property PACKAGE_PIN L22 [get_ports {FMC_LA06_N}]
set_property PACKAGE_PIN L21 [get_ports {FMC_LA06_P}]
set_property PACKAGE_PIN T17 [get_ports {FMC_LA07_N}]
set_property PACKAGE_PIN T16 [get_ports {FMC_LA07_P}]
set_property PACKAGE_PIN J22 [get_ports {FMC_LA08_N}]
set_property PACKAGE_PIN J21 [get_ports {FMC_LA08_P}]
set_property PACKAGE_PIN R21 [get_ports {FMC_LA09_N}]
set_property PACKAGE_PIN R20 [get_ports {FMC_LA09_P}]
set_property PACKAGE_PIN T19 [get_ports {FMC_LA10_N}]
set_property PACKAGE_PIN R19 [get_ports {FMC_LA10_P}]
set_property PACKAGE_PIN N18 [get_ports {FMC_LA11_N}]
set_property PACKAGE_PIN N17 [get_ports {FMC_LA11_P}]
set_property PACKAGE_PIN P21 [get_ports {FMC_LA12_N}]
set_property PACKAGE_PIN P20 [get_ports {FMC_LA12_P}]
set_property PACKAGE_PIN M17 [get_ports {FMC_LA13_N}]
set_property PACKAGE_PIN L17 [get_ports {FMC_LA13_P}]
set_property PACKAGE_PIN K20 [get_ports {FMC_LA14_N}]
set_property PACKAGE_PIN K19 [get_ports {FMC_LA14_P}]
set_property PACKAGE_PIN J17 [get_ports {FMC_LA15_N}]
set_property PACKAGE_PIN J16 [get_ports {FMC_LA15_P}]
set_property PACKAGE_PIN K21 [get_ports {FMC_LA16_N}]
set_property PACKAGE_PIN J20 [get_ports {FMC_LA16_P}]

set_property IOSTANDARD LVCMOS18 [get_ports {FMC_CLK0_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_CLK0_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA00_CC_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA00_CC_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA01_CC_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA00_CC_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA02_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA02_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA03_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA03_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA04_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA04_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA05_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA05_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA06_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA06_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA07_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA07_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA08_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA08_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA09_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA09_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA10_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA10_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA11_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA11_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA12_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA12_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA13_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA13_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA14_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA14_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA15_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA15_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA16_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA16_P}]

# ----------------------------------------------------------------------------
# FMC Expansion Connector - Bank 35
# ----------------------------------------------------------------------------

set_property PACKAGE_PIN C19 [get_ports {FMC_CLK1_N}]
set_property PACKAGE_PIN D18 [get_ports {FMC_CLK1_P}]
set_property PACKAGE_PIN B20 [get_ports {FMC_LA17_CC_N}]
set_property PACKAGE_PIN B19 [get_ports {FMC_LA17_CC_P}]
set_property PACKAGE_PIN C20 [get_ports {FMC_LA18_CC_N}]
set_property PACKAGE_PIN D20 [get_ports {FMC_LA18_CC_P}]
set_property PACKAGE_PIN G16 [get_ports {FMC_LA19_N}]
set_property PACKAGE_PIN G15 [get_ports {FMC_LA19_P}]
set_property PACKAGE_PIN G21 [get_ports {FMC_LA20_N}]
set_property PACKAGE_PIN G20 [get_ports {FMC_LA20_P}]
set_property PACKAGE_PIN E20 [get_ports {FMC_LA21_N}]
set_property PACKAGE_PIN E19 [get_ports {FMC_LA21_P}]
set_property PACKAGE_PIN F19 [get_ports {FMC_LA22_N}]
set_property PACKAGE_PIN G19 [get_ports {FMC_LA22_P}]
set_property PACKAGE_PIN D15 [get_ports {FMC_LA23_N}]
set_property PACKAGE_PIN E15 [get_ports {FMC_LA23_P}]
set_property PACKAGE_PIN A19 [get_ports {FMC_LA24_N}]
set_property PACKAGE_PIN A18 [get_ports {FMC_LA24_P}]
set_property PACKAGE_PIN C22 [get_ports {FMC_LA25_N}]
set_property PACKAGE_PIN D22 [get_ports {FMC_LA25_P}]
set_property PACKAGE_PIN E18 [get_ports {FMC_LA26_N}]
set_property PACKAGE_PIN F18 [get_ports {FMC_LA26_P}]
set_property PACKAGE_PIN D21 [get_ports {FMC_LA27_N}]
set_property PACKAGE_PIN E21 [get_ports {FMC_LA27_P}]
set_property PACKAGE_PIN A17 [get_ports {FMC_LA28_N}]
set_property PACKAGE_PIN A16 [get_ports {FMC_LA28_P}]
set_property PACKAGE_PIN C18 [get_ports {FMC_LA29_N}]
set_property PACKAGE_PIN C17 [get_ports {FMC_LA29_P}]
set_property PACKAGE_PIN B15 [get_ports {FMC_LA30_N}]
set_property PACKAGE_PIN C15 [get_ports {FMC_LA30_P}]
set_property PACKAGE_PIN B17 [get_ports {FMC_LA31_N}]
set_property PACKAGE_PIN B16 [get_ports {FMC_LA31_P}]
set_property PACKAGE_PIN A22 [get_ports {FMC_LA32_N}]
set_property PACKAGE_PIN A21 [get_ports {FMC_LA32_P}]
set_property PACKAGE_PIN B22 [get_ports {FMC_LA33_N}]
set_property PACKAGE_PIN B21 [get_ports {FMC_LA33_P}]

set_property IOSTANDARD LVCMOS18 [get_ports {FMC_CLK1_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_CLK1_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA17_CC_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA17_CC_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA18_CC_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA18_CC_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA19_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA19_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA20_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA20_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA21_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA21_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA22_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA22_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA23_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA23_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA24_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA24_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA25_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA25_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA26_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA26_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA27_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA27_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA28_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA28_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA29_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA29_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA30_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA30_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA31_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA31_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA32_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA32_P}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA33_N}]
set_property IOSTANDARD LVCMOS18 [get_ports {FMC_LA33_P}]


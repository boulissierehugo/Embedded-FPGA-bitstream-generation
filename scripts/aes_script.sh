#!/bin/bash
########	UTILISATION		##########
#aes_script.sh no_plaintext 
########	UTILISATION		##########
########	SORTIE		##########
# Print of the input and the output of the aes
########	SORTIE		##########

# Check if an argument was provided
if [ $# -eq 0 ]; then
    echo "Please provide a number as an argument."
    exit 1
fi

# On reset l'aes
echo "Reset de l'AES :"
devmem 0x41200004 32 0x0001
devmem 0x41200004 32 0x0001
devmem 0x41200004 32 0x0000
devmem 0x41200004 32 0x0000

NO_PLAINTEXT=$1
input=""
echo "Selection de l'input :"
if [ $NO_PLAINTEXT -eq 0 ]; then
    devmem 0x41200000 32 0x1
    input="01001111001000110100111100100101100000010010001101000100010001000100111100100011010011110010010110000001001000110100010001000100"
elif [ $NO_PLAINTEXT -eq 1 ]; then
    devmem 0x41200000 32 0x2
    input="01010010101101000101110111000000110100110101101101010100101000111000000111111101110100001011101110111001001100010101011110000100"
elif [ $NO_PLAINTEXT -eq 2 ]; then
    devmem 0x41200000 32 0x4
    input="01100001101111101111110000110010010011100101111001111000101111000101010000111001111110111111010110101100100110001000011000000000"
elif [ $NO_PLAINTEXT -eq 3 ]; then
    devmem 0x41200000 32 0x8
    input="00010001100100001000011000011010100000001001100001111100110000100010111111000100110011110001000000111101100101011010100011101111"
else
    devmem 0x41200000 32 0x0
    input="00100001001100110101110011010100000011000101011111101101010100101100101111110000010111100101110001101110110000010010100010001101"
fi


# on démarre le chiffrement

echo "Chiffrement de l'input :"
devmem 0x41200008 32 0x0001
devmem 0x41200008 32 0x0001
# Lecture de l'output
echo "Lecture de l'input et l'output :"

echo "input : ${input}"

echo "output :"
devmem 0x4120000C 32 
devmem 0x41200010 32 
devmem 0x41200014 32 
devmem 0x41200018 32 



# Fin chiffrement
devmem 0x41200008 32 0x0000
devmem 0x41200008 32 0x0000
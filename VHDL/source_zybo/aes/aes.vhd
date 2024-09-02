LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE work.ALL;

ENTITY aes IS
PORT(
    plaintext	:   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    user_key	:   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    ciphertext	:   OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    encrypt	:   IN	STD_LOGIC;
    clk		:   IN	STD_LOGIC;
    reset	:   IN	STD_LOGIC
    );
END aes;

ARCHITECTURE aes OF aes IS
--component instantiation
COMPONENT round 
PORT(
    e_in	:   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    key		:   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    last_mux_sel:   IN STD_LOGIC;
    d_out	:   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;
COMPONENT key_schedule 
PORT(
    clk		    :   IN  STD_LOGIC;
    reset	    :   IN  STD_LOGIC;
    key_in	    :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    key_out	    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    key_reg_mux_sel :   IN  STD_LOGIC;
    round_constant  :	IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    load_key_reg    :	IN  STD_LOGIC
    );
END COMPONENT;
COMPONENT control
PORT(
    reset	    :   IN  STD_LOGIC;
    clk		    :   IN  STD_LOGIC;
    encrypt	    :   IN  STD_LOGIC;
    data_reg_mux_sel:   OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    load_data_reg   :   OUT STD_LOGIC;
    key_reg_mux_sel :   OUT STD_LOGIC;
    round_const	    :   OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    last_mux_sel    :	OUT STD_LOGIC;
    load_key_reg    :	OUT STD_LOGIC
   );
END COMPONENT;
--internal signal instantiation
SIGNAL data_reg_in, data_reg_out, round0_out, round1_10_out, 
       key: STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL key_reg_mux_sel : std_logic;
SIGNAL round_constant : std_logic_vector(7 downto 0);
SIGNAL data_reg_mux_sel : std_logic_vector(1 downto 0);
SIGNAL load_data_reg, load_key_reg, last_mux_sel : std_logic;
--------------------------------------------
BEGIN
--mux to the register input
WITH data_reg_mux_sel SELECT
data_reg_in <=  round0_out WHEN "00",
		round1_10_out WHEN "01",
		plaintext WHEN OTHERS;
--1st Round
round0_out <= data_reg_out XOR key;
--2nd to 10th Rounds, where same hareware gets reused
layers: round
PORT MAP(
	e_in	    =>  data_reg_out, 
	key	    =>  key,
	last_mux_sel=>  last_mux_sel,
	d_out	    =>  round1_10_out  
	);
--register to store values after each rounds	
data_register:
PROCESS(clk, reset, load_data_reg, data_reg_in)
BEGIN
    IF(reset='1') THEN
	data_reg_out <= "0000000000000000000000000000000000000000000"&
			"0000000000000000000000000000000000000000000"&
			"000000000000000000000000000000000000000000"; 
    ELSIF(clk'event AND clk='1') THEN
	    IF(load_data_reg='1') THEN
		data_reg_out <= data_reg_in;
	    END IF;
    END IF;	
END PROCESS data_register;
--key generator for each rounds -- TO MODIFY
key_generator: key_schedule
PORT MAP(
	clk		=>  clk,
	reset		=>  reset,
	key_in		=>  user_key,	
	key_out		=>  key,
	key_reg_mux_sel	=>  key_reg_mux_sel,
	round_constant	=>  round_constant,
	load_key_reg	=>  load_key_reg
	);
--system control	
contrl: control
PORT MAP(
	reset		=> reset,   
	clk		=> clk,
	encrypt		=> encrypt,
	data_reg_mux_sel=> data_reg_mux_sel,
	load_data_reg   => load_data_reg,
	key_reg_mux_sel	=> key_reg_mux_sel,
	round_const	=> round_constant,
	last_mux_sel	=> last_mux_sel,
	load_key_reg	=> load_key_reg
	);
--encryption output
ciphertext <= data_reg_out;

END aes;

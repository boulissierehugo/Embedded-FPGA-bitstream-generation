LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ALL;

ENTITY round IS
PORT(
    e_in    :	IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    key	    :	IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    last_mux_sel:	IN  STD_LOGIC;
    d_out   :	OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END round;

ARCHITECTURE une OF round IS
--component instantiation
COMPONENT s_box 
PORT(
    s_in    :	IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_out   :	OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END COMPONENT;
COMPONENT shift_row 
PORT(
    shiftrow_in     :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    shiftrow_out    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;
COMPONENT mix_column 
PORT(
    mixcolumn_in     :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    mixcolumn_out    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END COMPONENT;
--internal signal instantiation
SIGNAL bytesub_out, shiftrow_out, mixcolumn_out, mux_out : STD_LOGIC_VECTOR(127 DOWNTO 0);

--description of a Rijndael round
-- PLAINTEXT ==> |S_BOX --> SHIFT_ROW --> MIX_COLUMN --> ADD_ROUND_KEY| ==> CIPHERTEXT
BEGIN
--16 replica of 8-bit S-box is generated 
sboxes: FOR i IN 15 DOWNTO 0 GENERATE
    sbox_map:	s_box
    PORT MAP(
	    s_in => e_in(8*i+7 downto 8*i),
	    s_out => bytesub_out(8*i+7 downto 8*i)
	    );
END GENERATE sboxes;	    
ShiftRow:  shift_row
PORT MAP(
	shiftrow_in => bytesub_out,
	shiftrow_out => shiftrow_out
	);
MixColumn: mix_column
PORT MAP(   
	mixcolumn_in => shiftrow_out,
	mixcolumn_out => mixcolumn_out
	);
--mux to skip mix column operation
WITH last_mux_sel SELECT
mux_out <= mixcolumn_out WHEN '0',
	   shiftrow_out WHEN OTHERS;
--round key addition 	
d_out <= mux_out XOR key;

END une;			

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ALL;

ENTITY s_box_4 IS
PORT(
    s_word_in    :	IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_word_out   :	OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END s_box_4;

ARCHITECTURE ss OF s_box_4 IS
--component instantiation
COMPONENT s_box 
PORT(
    s_in    :	IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_out   :	OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END COMPONENT;

BEGIN
--generating 4 s-boxes 
sboxes: FOR i IN 3 DOWNTO 0 GENERATE
    sbox_map:	s_box
    PORT MAP(
	    s_in => s_word_in(8*i+7 downto 8*i),
	    s_out => s_word_out(8*i+7 downto 8*i)
	    );
END GENERATE sboxes;	    

END ss;			    
	

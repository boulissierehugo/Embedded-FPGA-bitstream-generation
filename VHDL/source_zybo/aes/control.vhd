LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ALL;

ENTITY control IS
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
END control;

ARCHITECTURE cont OF control IS
--state declaration
TYPE control_type IS (init, load_inputs, round1, round2, round3, round4, round5,
		      round6, round7, round8, round9, round10, round0);  
SIGNAL control_ps, control_ns : control_type;			     

BEGIN
--finite state machine for control
control_FSM:
PROCESS (clk, encrypt, reset, control_ns, control_ps) 
BEGIN
    IF(reset='1') THEN
	control_ps <= init;
    ELSIF (clk'event AND clk='1') THEN
	control_ps <= control_ns;
    END IF;	
    
    key_reg_mux_sel  <= '1';			--default outputs
    data_reg_mux_sel <= "01";
    round_const <= "00000000";
    load_key_reg <= '1';
    load_data_reg <= '1';
    last_mux_sel <= '0';
    
    --combinatorial part
    CASE control_ps IS
	WHEN init =>	    
		    key_reg_mux_sel <= '0';
		    load_key_reg <= '0';
		    load_data_reg <= '0';
		    IF (encrypt='1') THEN 
			control_ns <= load_inputs;
		    ELSE	 
			control_ns <= init;
		    END IF;
	WHEN load_inputs =>
			data_reg_mux_sel <= "11";
			key_reg_mux_sel <= '0';
			control_ns <= round0;
	--key0 loaded, XOR key0 and plaintext	
	WHEN round0 =>	
			round_const <= "00000001";
			data_reg_mux_sel <= "00";
			control_ns <= round1;
	--key1, start of normal rounds		
	WHEN round1 =>	
			round_const <= "00000010";
			control_ns <= round2;
	--key2	    
	WHEN round2 =>	    
			round_const <= "00000100";
			control_ns <= round3;
	--key3	    
	WHEN round3 =>	    
			round_const <= "00001000";
			control_ns <= round4;
	--key4	    
	WHEN round4 =>	    
			round_const <= "00010000";
			control_ns <= round5;
	--key5	    
	WHEN round5 =>	    
			round_const <= "00100000";
			control_ns <= round6;
	--key6	    
	WHEN round6 =>	    
			round_const <= "01000000";
			control_ns <= round7;
	--key7	    
	WHEN round7 =>	    
			round_const <= "10000000";
			control_ns <= round8;
	--key8	    
	WHEN round8 =>	    
			round_const <= "00011011";
			control_ns <= round9;
	--key9	    
	WHEN round9 =>	    
			round_const <= "00110110";
			control_ns <= round10;
	--key10, last round excludes the mix column step	    
	WHEN round10 =>	    
			last_mux_sel <= '1';
			load_key_reg <= '0';
			control_ns <= init;
	END CASE;
END PROCESS control_FSM;    

END cont;

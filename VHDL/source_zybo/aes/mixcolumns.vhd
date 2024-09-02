LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.ALL;

ENTITY mix_column IS
PORT(
    mixcolumn_in     :   IN  STD_LOGIC_VECTOR(127 DOWNTO 0);
    mixcolumn_out    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0)
    );
END mix_column;

ARCHITECTURE mC OF mix_column IS
--signal declearation
    TYPE matrix_index is array (15 downto 0) of std_logic_vector(7 downto 0); 
    TYPE shift_index is array (15 downto 0) of std_logic_vector(8 downto 0); 
    SIGNAL shifted_2, shifted_3, xored : shift_index;
    SIGNAL  c, c_out, mult_2, mult_3 : matrix_index;


BEGIN
-- mapping input to a 4X4 matrix
-- mixcolumn_in(127 downto 0)  -->  | c(0) c(4)  c(8)  c(12) |
--				    | c(1) c(5)  c(9)  c(13) |
--				    | c(2) c(6) c(10)  c(14) |
--				    | c(3) c(7) c(11)  c(15) |
input_matrix_mapping:
PROCESS(mixcolumn_in)
BEGIN
    FOR i IN 15 DOWNTO 0 LOOP
	c(15-i) <= mixcolumn_in(8*i+7 DOWNTO 8*i);
    END LOOP;
END PROCESS input_matrix_mapping;
--all elements in the matrix is multiplied by 2 
multiplication_by_2:
PROCESS(c, shifted_2)
BEGIN
    FOR i IN  15 DOWNTO 0 LOOP
	shifted_2(i) <= c(i) & '0';	-- shift which is multiplying by 2
	IF (shifted_2(i)(8)='1') THEN	-- for result exceeding finite field of 7
	    mult_2(i) <= shifted_2(i)(7 downto 0) XOR "00011011";
	ELSE
	    mult_2(i) <= shifted_2(i)(7 downto 0);
	END IF;
    END LOOP;
END PROCESS multiplication_by_2;
--all elements in the matrix is multiplied by 3
--which is equivalent to 3*Z = 2*Z xor Z
multiplication_by_3:
PROCESS(c, shifted_3, xored)
BEGIN
    FOR i IN  15 DOWNTO 0 LOOP
	shifted_3(i) <= c(i) & '0';	    -- 2*Z
	xored(i) <= shifted_3(i) XOR '0' & c(i);  -- (2*Z) xor Z
	IF (xored(i)(8)='1') THEN	    -- if finite field exceed 7 
	    mult_3(i) <= xored(i)(7 downto 0) XOR "00011011";
	ELSE
	    mult_3(i) <= xored(i)(7 downto 0);
	END IF;
    END LOOP;
END PROCESS multiplication_by_3;
--mix column transformation
--row one
c_out(0)  <= mult_2(0) XOR mult_3(1) XOR c(2) XOR c(3);
c_out(4)  <= mult_2(4) XOR mult_3(5) XOR c(6) XOR c(7);
c_out(8)  <= mult_2(8) XOR mult_3(9) XOR c(10) XOR c(11);
c_out(12) <= mult_2(12) XOR mult_3(13) XOR c(14) XOR c(15);
--row two
c_out(1)  <= c(0) XOR mult_2(1) XOR mult_3(2) XOR c(3); 
c_out(5)  <= c(4) XOR mult_2(5) XOR mult_3(6) XOR c(7); 
c_out(9)  <= c(8) XOR mult_2(9) XOR mult_3(10) XOR c(11); 
c_out(13) <= c(12) XOR mult_2(13) XOR mult_3(14) XOR c(15); 
--row three
c_out(2)  <= c(0) XOR c(1) XOR mult_2(2) XOR mult_3(3);
c_out(6)  <= c(4) XOR c(5) XOR mult_2(6) XOR mult_3(7);
c_out(10) <= c(8) XOR c(9) XOR mult_2(10) XOR mult_3(11);
c_out(14) <= c(12) XOR c(13) XOR mult_2(14) XOR mult_3(15);
--row four
c_out(3)  <= mult_3(0) XOR c(1) XOR c(2) XOR mult_2(3);
c_out(7)  <= mult_3(4) XOR c(5) XOR c(6) XOR mult_2(7);
c_out(11) <= mult_3(8) XOR c(9) XOR c(10) XOR mult_2(11);
c_out(15) <= mult_3(12) XOR c(13) XOR c(14) XOR mult_2(15);

--mapping back to a vector
map_to_vector:
PROCESS(c_out)
BEGIN
    FOR i IN 15 DOWNTO 0 LOOP
	mixcolumn_out(8*i+7 DOWNTO 8*i) <= c_out(15-i);
    END LOOP;
END PROCESS map_to_vector;

END mC;	

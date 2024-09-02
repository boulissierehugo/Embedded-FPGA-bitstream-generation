library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity shift_row is 
port (
	shiftRow_in : in std_logic_vector (127 downto 0);
	shiftRow_out : out std_logic_vector (127 downto 0)
);
end shift_row;

architecture sR of shift_row is
type matrix_index is array (15 downto 0) of std_logic_vector (7 downto 0);
signal c,b :matrix_index;

begin
matrix_mapping:
PROCESS(shiftrow_in)
BEGIN
    FOR i IN 15 DOWNTO 0 LOOP
	b(15-i) <= shiftrow_in(8*i+7 DOWNTO 8*i);
    END LOOP;
END PROCESS matrix_mapping;
--shift row transformation
--	 b(i)	    -->		c(i)
--
--  | 0 4  8 12 |          |  0  4  8 12 |    (no shift)             
--  | 1 5  9 13 |   ==>    |  5  9 13  1 |    ( 1 left shift)     
--  | 2 6 10 14 |          | 10 14  2  6 |    ( 2 left shift)    
--  | 3 7 11 15 |          | 15  3  7 11 |    ( 3 left shift)  

--shifted first column
c(0)  <=  b(0);
c(1)  <=  b(5);
c(2)  <=  b(10);
c(3)  <=  b(15);
--shifted second column
c(4)  <=  b(4);
c(5)  <=  b(9);
c(6)  <=  b(14);
c(7)  <=  b(3);
--shfited third column
c(8)  <=  b(8);
c(9)  <=  b(13);
c(10) <=  b(2);
c(11) <=  b(7);
--shifted forth column
c(12) <=  b(12);
c(13) <=  b(1);
c(14) <=  b(6);
c(15) <=  b(11);

--mapping temporary c vector into shiftedrow output
matrix_mapping_back:
PROCESS(c)
BEGIN
    FOR i IN 15 DOWNTO 0 LOOP
	shiftrow_out(8*i+7 DOWNTO 8*i) <= c(15-i);
    END LOOP;
END PROCESS matrix_mapping_back;

END sR;			

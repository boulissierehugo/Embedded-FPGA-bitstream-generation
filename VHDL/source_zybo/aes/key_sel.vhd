LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY key_sel IS
PORT(
    clk		    :   IN  STD_LOGIC;
    reset	    :   IN  STD_LOGIC;
    key	    :   OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
    key_reg_mux_sel : in STD_LOGIC;
    load_key_reg    :	IN  STD_LOGIC
    );
END key_sel;

ARCHITECTURE key_selector_arch OF key_sel IS

constant initial_key : STD_LOGIC_VECTOR(127 DOWNTO 0) := "00010101010000000011001100010010001000000011000000000101001000000000001000010001000010000010000000000001011100001001000001100111";


type key_array_t is array (0 to 9) of std_logic_vector(127 downto 0);
-- Multiplexor for the keys
constant keys : key_array_t := (
    0 => "01000101001000001011011001101110011001010001000010110011010011100110011100000001101110110110111001100110011100010010101100001001",
    1 => "11100100110100011011011101011101100000011100000100000100000100111110011011000000101111110111110110000000101100011001010001110100",
    2 => "00101000111100110010010110010000101010010011001000100001100000110100111111110010100111101111111011001111010000110000101010001010",
    3 => "00111010100101000101101100011010100100111010011001111010100110011101110001010100111001000110011100010011000101111110111011101101",
    4 => "11011010101111000000111001100111010010010001101001110100111111101001010101001110100100001001100110000110010110010111111001110100",
    5 => "00110001010011111001110000100011011110000101010111101000110111011110110100011011011110000100010001101011010000100000011000110000",
    6 => "01011101001000001001100001011100001001010111010101110000100000011100100001101110000010001100010110100011001011000000111011110101",
    7 => "10101100100010110111111001010110100010011111111000001110110101110100000110010000000001100001001011100010101111000000100011100111",
    8 => "11010010101110111110101011001110010110110100010111100100000110010001101011010101111000100000101111111000011010011110101011101100",
    9 => "00011101001111000010010010001111010001100111100111000000100101100101110010101100001000101001110110100100110001011100100001110001"
);


-- signals
signal key_reg_out : STD_LOGIC_VECTOR(127 DOWNTO 0) := initial_key;
signal next_counter : natural := 0;
signal counter : natural := 0;

begin

    -- Combinational part: next-state logic
    process(counter, load_key_reg, reset)
    begin
        if (counter = 9 and load_key_reg = '1' and reset = '0') then
            next_counter <= 0;
        elsif (load_key_reg = '1' and reset = '0') then
            next_counter <= counter + 1;
        elsif (reset = '1') then
            next_counter <= 0;
        else
            next_counter <= counter;
        end if;
    end process;


    -- Sequential part: state update
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                key_reg_out <= (others => '0');
                counter <= 0;
            elsif load_key_reg = '1' then -- changement de clé
                if key_reg_mux_sel = '0' then -- chargement de la clé initiale
                    key_reg_out <= initial_key;
                else
                    key_reg_out <= keys(counter);
                end if;
                counter <= next_counter;
            else 
                key_reg_out <= key_reg_out;
                counter <= next_counter;
            end if;
        end if;
    end process;

    key <= key_reg_out;


end key_selector_arch;
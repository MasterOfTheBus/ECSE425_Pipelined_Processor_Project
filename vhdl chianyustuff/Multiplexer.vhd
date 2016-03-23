LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY mux IS
    GENERIC(num_of_bits : integer);
    PORT (
		input0	: IN std_logic_vector(num_of_bits-1 DOWNTO 0);
		input1	: IN std_logic_vector(num_of_bits-1 DOWNTO 0);
        sel   	: IN std_logic;
        output	: OUT std_logic_vector(num_of_bits-1 DOWNTO 0)
		);
    END;

ARCHITECTURE behavior OF mux IS
	BEGIN
		CASE sel IS
			WHEN '0' => output <= input0;
			WHEN '1' => output <= input1;
			WHEN OTHERS => output <= (OTHERS => 'X'); 
    END;

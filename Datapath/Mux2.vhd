LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Mux2 IS
    GENERIC(n : integer);
    PORT (
		input0	: IN std_logic_vector(n-1 DOWNTO 0);
		input1	: IN std_logic_vector(n-1 DOWNTO 0);
      sel   	: IN std_logic;
      output	: OUT std_logic_vector(n-1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE behavior OF Mux2 IS
BEGIN
	PROCESS(sel, input0, input1)
	BEGIN
		CASE sel IS
			WHEN '1' => output <= input1;
			WHEN OTHERS => output <= input0; 
		END CASE;
	END PROCESS;
END behavior;
		
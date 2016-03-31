LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Mux3 IS
    GENERIC(n : integer);
    PORT (
		input00	: IN std_logic_vector(n-1 DOWNTO 0);
		input01	: IN std_logic_vector(n-1 DOWNTO 0);
		input10	: IN std_logic_vector(n-1 DOWNTO 0);		
      sel   	: IN std_logic_vector(1 DOWNTO 0);
      output	: OUT std_logic_vector(n-1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE behavior OF Mux3 IS
BEGIN
	PROCESS(sel, input00, input01, input10)
	BEGIN
	CASE sel IS
		WHEN "10" => output <= input10;
		WHEN "01" => output <= input01;
		WHEN OTHERS => output <= input00;
	END CASE;
	END PROCESS;
END behavior;
		
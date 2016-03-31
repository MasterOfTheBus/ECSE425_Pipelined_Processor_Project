-- Sign Extension
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Sign_Extension IS
    PORT (
		A : IN std_logic_vector(15 DOWNTO 0);
        Y : OUT std_logic_vector(31 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE behavior OF Sign_Extension IS
	BEGIN
	PROCESS(A(15))
	BEGIN
		CASE A(15) IS
			WHEN '0' => Y <= "0000000000000000" & A;
			WHEN '1' => Y <= "1111111111111111" & A;
			WHEN OTHERS => 
				Y <= (OTHERS => 'X');
		END CASE;
	END PROCESS;
END behavior;
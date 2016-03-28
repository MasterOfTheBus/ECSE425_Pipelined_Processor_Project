LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Comparator IS
	PORT(	
		A		: IN std_logic_vector(31 downto 0);
		B		: IN std_logic_vector(31 downto 0);
		equal	: OUT std_logic
		);
END Comparator;

ARCHITECTURE behavior OF Comparator IS
BEGIN   
    PROCESS(A,B)
		BEGIN
			IF (A=B) THEN   
				equal <= '1';
			ELSE
				equal <= '0';
			END IF;
	END PROCESS;
END behavior;
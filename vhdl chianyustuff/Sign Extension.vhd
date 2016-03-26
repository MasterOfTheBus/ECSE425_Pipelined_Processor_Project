-- Sign Extension
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sign_extension IS
    PORT (
		A : IN std_logic_vector(15 DOWNTO 0);
        Y : OUT std_logic_vector(31 DOWNTO 0)
		);
END sign_extension;

ARCHITECTURE behavior OF sign_extension IS
	BEGIN
		CASE A(15) IS
			WHEN '0' => Y <= "0000000000000000" & A;
			WHEN '1' => Y <= "1111111111111111" & A;
			WHEN OTHERS => 
				Y <= (OTHERS <= 'X');
		END CASE;
END behavior;
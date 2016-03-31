-- Sign Extension
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Sign_Extension IS
    PORT (
		A : IN std_logic_vector(15 DOWNTO 0);
        Y : OUT std_logic_vector(31 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE behavior OF Sign_Extension IS
	SIGNAL i 	: INTEGER;
	SIGNAL v	: std_logic_vector(31 DOWNTO 0);
	
	BEGIN
	
	i <= to_integer(signed(A));
	Y <= std_logic_vector(to_signed(i, 32));
	
END behavior;
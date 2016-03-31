LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ShiftL2 IS
	PORT (
		A : IN std_logic_vector(31 DOWNTO 0);
        Y : OUT std_logic_vector(31 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE behavior OF ShiftL2 IS
BEGIN
    Y <= A(29 DOWNTO 0) & "00";
END;

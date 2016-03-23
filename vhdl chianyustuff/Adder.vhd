LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY adder IS
    Port (
		input1 : IN std_logic_vector(31 DOWNTO 0);
		input2 : IN std_logic_vector(31 DOWNTO 0);
        output : OUT std_logic_vector(31 DOWNTO 0)
	);
End;

ARCHITECTURE behavior OF adder IS
	BEGIN
		output <= input1 + input2;
END behavior;

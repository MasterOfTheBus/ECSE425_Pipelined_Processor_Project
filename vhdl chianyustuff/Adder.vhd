LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Adder IS
    Port (
		input1 	: IN std_logic_vector(31 DOWNTO 0);
		input2 	: IN std_logic_vector(31 DOWNTO 0);
        sum 	: OUT std_logic_vector(31 DOWNTO 0)
	);
End ENTITY;

ARCHITECTURE behavior OF Adder IS
SIGNAL result: std_logic_vector(32 DOWNTO 0);
BEGIN					  
	result <= ('0' & A)+('0' & B);
	sum <= result(31 DOWNTO 0);
END behavior;
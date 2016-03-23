LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Auxiliar register 1 - IF stage to ID stage

ENTITY reg_if2id IS
    PORT (
		clk         : IN std_logic;
		reset		: IN std_logic;
		instr_in	: IN std_logic_vector(31 DOWNTO 0);
        pc_in		: IN std_logic_vector(31 DOWNTO 0);        
        instr_out   : OUT std_logic_vector(31 DOWNTO 0);
		pc_out      : OUT std_logic_vector(31 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE behavior OF reg_if2id IS
	BEGIN
		PROCESS(clk, reset)
			BEGIN
			IF reset = '1' THEN 
				pc_out <= (OTHERS <= '0');
				instr_out <= (OTHERS <= '0');
			ELSIF rising_edge(clk) THEN
				instr_out <= instruction;
				pc_out <= pcplus4;
			END IF;
		END PROCESS;
	END behavior;
		
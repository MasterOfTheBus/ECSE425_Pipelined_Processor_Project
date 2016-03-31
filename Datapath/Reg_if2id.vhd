LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Auxiliar register 1 - IF stage to ID stage

ENTITY Reg_if2id IS
    PORT (
		clk, reset, enable	: IN std_logic;
		if_pc		: IN std_logic_vector(31 DOWNTO 0);
        if_instr	: IN std_logic_vector(31 DOWNTO 0);        
        id_pc   	: OUT std_logic_vector(31 DOWNTO 0);
		id_instr   	: OUT std_logic_vector(31 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE behavior OF Reg_if2id IS
BEGIN
	PROCESS(clk, reset)
		BEGIN
		
		IF reset = '1' THEN 
			id_pc 		<= (OTHERS => '0');
			id_instr 	<= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			IF enable = '1'  THEN
				id_pc 		<= if_pc;
				id_instr 	<= if_instr;
			END IF;
		END IF;
		
	END PROCESS;
END behavior;
		
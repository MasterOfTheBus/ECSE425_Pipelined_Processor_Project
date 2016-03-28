LIBRARY IEEE; 
USE IEEE.std_logic_1164.ALL; 

ENTITY Instr_Mem IS 
	PORT ( 
		clk 		: IN std_logic; 
		reset 		: IN std_logic; 
		ReadAddr	: IN std_logic_vector(31 DOWNTO 0); 
		Instr		: OUT std_logic_vector(31 DOWNTO 0); -- whole instruction
		Instr_31_26 : OUT std_logic_vector(5 DOWNTO 0);	-- opcode	
		Instr_25_21 : OUT std_logic_vector(4 DOWNTO 0);	-- rs	
		Instr_20_16 : OUT std_logic_vector(4 DOWNTO 0);	-- rt
		Instr_15_0 	: OUT std_logic_vector(15 DOWNTO 0)	-- immediate
		); 
END ENTITY;

ARCHITECTURE behavior OF Instr_Mem IS 
	SIGNAL tempInstr : std_logic_vector(31 DOWNTO 0);
	BEGIN 
	PROCESS(clk, reset) 
		BEGIN 
		IF reset = '1' THEN 
			tempInstr <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN 
			-- write the output of the memory into the instruction register 
			IF(IRWrite = '1') THEN 
				tempInstr <= ReadAddr;
			END IF; 
		END IF; 
		Instr <= tempInstr;
		Instr_31_26 <= tempInstr(31 DOWNTO 26);
		Instr_25_21 <= tempInstr(25 DOWNTO 21);
		Instr_20_16 <= tempInstr(20 DOWNTO 16);
		Instr_15_0 	<= tempInstr(15 DOWNTO 0 );
	END PROCESS; 
END behavior;		
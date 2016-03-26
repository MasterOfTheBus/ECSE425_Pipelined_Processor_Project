LIBRARY IEEE; 
USE IEEE.std_logic_1164.ALL; 
USE IEEE.numeric_std.ALL; 

ENTITY ir IS 
	PORT ( 
		clk 	: IN std_logic; 
		reset 	: IN std_logic; 
		memdata	: IN std_logic_vector(31 DOWNTO 0); 
		IRWrite	: IN std_logic; 
		instr_31_26 : OUT std_logic_vector(5 DOWNTO 0);	-- opcode	
		instr_25_21 : OUT std_logic_vector(4 DOWNTO 0);	-- rs	
		instr_20_16 : OUT std_logic_vector(4 DOWNTO 0);	-- rt
		instr_15_0 	: OUT std_logic_vector(15 DOWNTO 0)	-- immediate
		); 
END ir;

ARCHITECTURE behavior OF ir IS 
	BEGIN 
	proc_instreg : PROCESS(clk, reset) 
		BEGIN 
		IF reset = '1' THEN 
			instr_31_26 <= (OTHERS => '0'); 
			instr_25_21 <= (OTHERS => '0'); 
			instr_20_16 <= (OTHERS => '0'); 
			instr_15_0 	<= (OTHERS => '0'); 
		ELSIF rising_edge(clk) THEN 
			-- write the output of the memory into the instruction register 
			IF(IRWrite = '1') THEN 
				instr_31_26 <= memdata(31 DOWNTO 26); 
				instr_25_21 <= memdata(25 DOWNTO 21); 
				instr_20_16 <= memdata(20 DOWNTO 16); 
				instr_15_0 	<= memdata(15 DOWNTO 0); 
			END IF; 
		END IF; 
	END PROCESS; 
END behavior;		
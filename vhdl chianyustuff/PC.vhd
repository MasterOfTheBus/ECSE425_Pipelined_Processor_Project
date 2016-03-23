-- PC
LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.numeric_std.ALL; 

ENTITY pc IS 
	PORT ( 
		clk 	: IN std_logic; 
		reset 	: IN std_logic;
		pc_en 	: IN std_logic; 
		pc_in 	: IN std_logic_vector(31 DOWNTO 0); 		
		pc_out 	: OUT std_logic_vector(31 DOWNTO 0)
		);
END pc;

ARCHITECTURE behavior OF pc IS 
	BEGIN 
	PROCESS(clk, reset) 
		VARIABLE pc_temp : std_logic_vector(31 DOWNTO 0); 
		BEGIN 
		IF reset = '1' THEN 
			pc_temp := (OTHERS => '0'); 
		ELSIF rising_edge(clk) THEN 
			IF pc_en = '1' THEN 
				pc_temp := pc_in; 
			END IF; 
		END IF; 
		pc_out <= pc_temp; 
	END PROCESS; 
END behavior;		
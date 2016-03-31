-- PC
LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.numeric_std.ALL; 

ENTITY PC IS 
	PORT ( 
		clk, reset, enable 	: IN std_logic; 
		pc_in 	: IN std_logic_vector(31 DOWNTO 0); 		
		pc_out 	: OUT std_logic_vector(31 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE behavior OF PC IS 
	SIGNAL pc_temp : std_logic_vector(31 DOWNTO 0); 
BEGIN 	
	PROCESS(clk, reset, pc_temp, pc_in) 
		BEGIN 
		
		IF reset = '1' THEN 
			pc_temp <= (OTHERS => '0');	
		ELSIF enable = '1' THEN
			IF rising_edge(clk) THEN
				pc_temp <= pc_in; 
			END IF; 
		END IF;
		
		pc_out <= pc_temp; 
		
	END PROCESS; 
END behavior;		
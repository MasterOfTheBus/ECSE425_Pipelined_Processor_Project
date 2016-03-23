-- The ALU 
LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.numeric_std.ALL; 

ENTITY alu IS 
	PORT ( 
		a		: IN  std_logic_vector(31 DOWNTO 0); 
		b		: IN  std_logic_vector(31 DOWNTO 0); 
		opcode 	: IN  std_logic_vector(1 DOWNTO 0); 
		result 	: OUT std_logic_vector(31 DOWNTO 0); 
		zero 	: OUT std_logic
		); 
END alu; 

ARCHITECTURE behavior OF alu IS 
	
	SIGNAL a_uns : unsigned(31 DOWNTO 0) := unsigned(a); 
	SIGNAL b_uns : unsigned(31 DOWNTO 0) := unsigned(b); 
	SIGNAL r_uns : unsigned(31 DOWNTO 0) := (OTHERS => '0'); 
	SIGNAL z_uns : unsigned(0 DOWNTO 0) := '0'; 
	
	BEGIN 
	PROCESS(a, b, opcode) 		
		BEGIN 
		-- Select operation 
		CASE opcode IS 
			-- ADD 
			WHEN "00" => r_uns <= a_uns + b_uns; 
			-- SUB             
			WHEN "01" => r_uns <= a_uns - b_uns; 
			-- AND             
			WHEN "10" => r_uns <= a_uns AND b_uns; 
			-- OR              
			WHEN "11" => r_uns <= a_uns OR b_uns; 
			-- Others 
			WHEN OTHERS => r_uns <= (OTHERS => 'X'); 
		END CASE; 
		
		-- Set zero bit if result equals zero 
		IF to_integer(r_uns) = 0 THEN 
			z_uns(0) := '1'; 
		ELSE 
			z_uns(0) := '0'; 
		END IF; 
		
		-- Final result
		result <= std_logic_vector(r_uns); 
		zero <= z_uns(0); 
	END PROCESS; 
END behavior;					
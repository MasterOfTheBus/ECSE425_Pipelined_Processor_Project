LIBRARY IEEE; 
USE IEEE.std_logic_1164.ALL; 

ENTITY reg_file IS 
	PORT (
		clk, reset 	: IN std_logic; 
		RegWrite 	: IN std_logic;	
		
		WriteAddr	: IN std_logic_vector(4 DOWNTO 0);
		ReadAddr1	: IN std_logic_vector(4 DOWNTO 0); 		
		ReadAddr2	: IN std_logic_vector(4 DOWNTO 0); 		
		WriteData	: IN std_logic_vector(31 DOWNTO 0);				
		
		ReadData1	: OUT std_logic_vector(31 DOWNTO 0); 
		ReadData2	: OUT std_logic_vector(31 DOWNTO 0) 
	); 
END ENTITY; 

ARCHITECTURE behavior OF reg_file IS 
	SUBTYPE WordT IS std_logic_vector(31 DOWNTO 0); -- reg word TYPE 
	TYPE StorageT IS ARRAY(0 TO 31) OF WordT; -- reg array TYPE 
	SIGNAL registerfile : StorageT; -- reg file contents 
	
	BEGIN 
	-- Write to register 
	PROCESS(reset, clk) 
		BEGIN 
		-- Reset register file
		IF reset = '1' THEN 
			FOR i IN 0 TO 31 LOOP 
				registerfile(i) <= (OTHERS => '0'); 
			END LOOP;
		ELSIF rising_edge(clk) THEN 
			IF RegWrite = '1' THEN 
				registerfile(to_integer(unsigned(WriteAddr))) <= WriteData; 
			END IF; 
		END IF; 
	END PROCESS; 
	
	-- Read from register
	ReadData1 <= registerfile(to_integer(unsigned(ReadAddr1))); 
	ReadData2 <= registerfile(to_integer(unsigned(ReadAddr2))); 
END behavior;
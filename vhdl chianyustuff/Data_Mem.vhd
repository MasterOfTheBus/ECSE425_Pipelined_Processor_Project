LIBRARY IEEE; 
USE IEEE.std_logic_1164.ALL; 

ENTITY Data_Mem IS 
	PORT ( 
		clk, reset	: IN std_logic; 
		MemRead		: IN std_logic;
		MemWrite	: IN std_logic_vector(31 DOWNTO 0);		
		Address		: IN std_logic_vector(31 DOWNTO 0);
		WriteData	: IN std_logic_vector(31 DOWNTO 0);
		ReadData	: OUT std_logic_vector(31 DOWNTO 0);
	); 
END ENTITY;

ARCHITECTURE behavior OF Data_Mem IS
	SIGNAL RW : std_logic_vector(1 DOWNTO 0);
BEGIN
	PROCESS(clk, reset) 
		BEGIN 
		RW <= MemRead & MemWrite;
		IF reset = '1' THEN 
			ReadData <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN 
			CASE RW IS
				WHEN "01" => ReadData
			
END behavior;
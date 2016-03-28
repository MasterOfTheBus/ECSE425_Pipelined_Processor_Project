LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Reg_id2ex IS
    PORT (
		clk, reset		: IN std_logic;
		id_EX	    	: IN std_logic_vector(3 DOWNTO 0);
		id_ME	    	: IN std_logic_vector(2 DOWNTO 0);
		id_WB	    	: IN std_logic_vector(1 DOWNTO 0);
		id_ReadData1	: IN std_logic_vector(31 DOWNTO 0);	
		id_ReadData2	: IN std_logic_vector(31 DOWNTO 0);	
		id_ext	    	: IN std_logic_vector(31 DOWNTO 0);
		id_rs	    	: IN std_logic_vector(4 DOWNTO 0);
		id_rt	    	: IN std_logic_vector(4 DOWNTO 0);
		id_rd	    	: IN std_logic_vector(4 DOWNTO 0);
			
		ex_EX			: OUT std_logic_vector(3 DOWNTO 0);
		ex_ME			: OUT std_logic_vector(2 DOWNTO 0);
		ex_WB			: OUT std_logic_vector(1 DOWNTO 0);
		ex_ReadData1	: OUT std_logic_vector(31 DOWNTO 0);
		ex_ReadData2	: OUT std_logic_vector(31 DOWNTO 0);
		ex_ext			: OUT std_logic_vector(31 DOWNTO 0);
		ex_rs			: OUT std_logic_vector(4 DOWNTO 0);
		ex_rt			: OUT std_logic_vector(4 DOWNTO 0);
		ex_rd			: OUT std_logic_vector(4 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE behavior OF Reg_id2ex IS
BEGIN
	PROCESS(clk, reset)
	BEGIN
		IF (reset = '1') THEN
			ex_EX	    	<= (OTHERS => '0');
			ex_ME	    	<= (OTHERS => '0');
			ex_WB	    	<= (OTHERS => '0');
			ex_ReadData1	<= (OTHERS => '0');
			ex_ReadData2	<= (OTHERS => '0');
			ex_ext	    	<= (OTHERS => '0');
			ex_rs	    	<= (OTHERS => '0');
			ex_rt	    	<= (OTHERS => '0');
			ex_rd	    	<= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			ex_EX	    	<= id_EX;
			ex_ME	    	<= id_ME;
			ex_WB	    	<= id_WB;
			ex_ReadData1	<= id_ReadData1;
			ex_ReadData2	<= id_ReadData2;
			ex_ext	    	<= id_ext;
			ex_rs	    	<= id_rs;
			ex_rt	    	<= id_rt;
			ex_rd	    	<= id_rd;
		END IF;
	END PROCESS;
END behavior;
	
	    
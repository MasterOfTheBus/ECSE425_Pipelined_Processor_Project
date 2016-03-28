LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Reg_me2wb IS
    PORT (
		clk, reset	: IN std_logic;
		me_WB		: IN std_logic_vector(1 DOWNTO 0);
		me_ReadData	: IN std_logic_vector(31 DOWNTO 0);
		me_Addr		: IN std_logic_vector(4 DOWNTO 0);
		me_WriteReg	: IN std_logic_vector(4 DOWNTO 0);
		
		wb_WB		: OUT std_logic_vector(1 DOWNTO 0);
		wb_ReadData	: OUT std_logic_vector(31 DOWNTO 0);
		wb_Addr		: OUT std_logic_vector(4 DOWNTO 0);
		wb_WriteReg	: OUT std_logic_vector(4 DOWNTO 0);
		);
END ENTITY;

ARCHITECTURE behavior OF Reg_me2wb IS
BEGIN
	PROCESS(clk, reset)
	BEGIN
		IF (reset = '1') THEN
			wb_WB		<= (OTHERS => '0');
			wb_ReadData	<= (OTHERS => '0');
			wb_Addr		<= (OTHERS => '0');
			wb_WriteReg	<= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			wb_WB		<= me_WB;
			wb_ReadData	<= me_ReadData;
			wb_Addr		<= me_Addr;
			wb_WriteReg	<= me_WriteReg;
		END IF;
	END PROCESS;
END behavior;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Reg_ex2me IS
    PORT (
		clk, reset		: IN std_logic;
		ex_ME			: IN std_logic_vector(2 DOWNTO 0);
		ex_WB           : IN std_logic_vector(1 DOWNTO 0);
		ex_Addr         : IN std_logic_vector(4 DOWNTO 0);
		ex_WriteData	: IN std_logic_vector(31 DOWNTO 0);
		ex_WriteReg     : IN std_logic_vector(4 DOWNTO 0);
		
		me_ME			: OUT std_logic_vector(2 DOWNTO 0);
		me_WB			: OUT std_logic_vector(1 DOWNTO 0);
		me_Addr			: OUT std_logic_vector(4 DOWNTO 0);
		me_WriteData	: OUT std_logic_vector(31 DOWNTO 0);
		me_WriteReg		: OUT std_logic_vector(4 DOWNTO 0);
	);
END ENTITY;

ARCHITECTURE behavior OF Reg_ex2me IS
BEGIN
	PROCESS(clk, reset)
		BEGIN
		IF (reset = '1') THEN
			me_ME			<= (OTHERS => '0');
			me_WB           <= (OTHERS => '0');
			me_Addr         <= (OTHERS => '0');
			me_WriteData    <= (OTHERS => '0');
			me_WriteReg     <= (OTHERS => '0');
		ELSIF rising_edge(clk) THEN
			me_ME			<= ex_ME;			
            me_WB           <= ex_WB;           
            me_Addr         <= ex_Addr;        
            me_WriteData    <= ex_WriteData;
            me_WriteReg     <= ex_WriteReg;
		END IF;
	END PROCESS;
END behavior;					
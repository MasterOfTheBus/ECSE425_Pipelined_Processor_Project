LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_Processor IS
END tb_Processor;

ARCHITECTURE behavior OF tb_Processor IS

COMPONENT Processor IS 
	PORT(
		clk, reset		: IN std_logic;
		Instruction		: IN std_logic_vector(31 DOWNTO 0);
		ReadData			: IN std_logic_vector(31 DOWNTO 0);
		
		PC				: OUT std_logic_vector(31 DOWNTO 0);
		ALUOut		: OUT std_logic_vector(31 DOWNTO 0);
		MemRead		: OUT std_logic;
		MemWrite		: OUT std_logic;
		WriteData	: OUT std_logic_vector(31 DOWNTO 0)		
	);
END COMPONENT;

-- The input signals with their initial values
CONSTANT clk_period : time := 1 ns;
SIGNAL clk : std_logic := '0';
SIGNAL reset : std_logic := '0';
SIGNAL PC, System_Instr, ReadData : std_logic_vector(31 DOWNTO 0);
SIGNAL MemRead, MemWrite : std_logic;
SIGNAL ALUOut, WriteData : std_logic_vector(31 DOWNTO 0);

BEGIN
	pro : Processor 
		PORT MAP (clk, reset, System_Instr, ReadData, PC, ALUOut, MemRead, MemWrite, WriteData);

-- Clock process
clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
	END PROCESS;

-- Stimulus process
stim_process: PROCESS
BEGIN   
	
	reset <= '1';
	wait for 1 * clk_period; 
	reset <= '0';
	-- fib.asm
	System_Instr <= "00100000000010100000000000000100"; 
	wait for 1 * clk_period; 
	System_Instr <= "00100000000000010000000000000001";
	wait for 1 * clk_period; 
	System_Instr <= "00100000000000100000000000000001";
	wait for 1 * clk_period; 
	System_Instr <= "00100000000010110000011111010000";
	wait for 1 * clk_period; 
	System_Instr <= "00100000000011110000000000000100";
	wait for 1 * clk_period; 
	System_Instr <= "00100000010000110000000000000000";
	wait for 1 * clk_period; 
	System_Instr <= "00000000010000010001000000100000";
	wait for 1 * clk_period; 
	System_Instr <= "00100000011000010000000000000000";
	wait for 1 * clk_period; 
	System_Instr <= "00000001010011110000000000011000";
	wait for 1 * clk_period; 
	System_Instr <= "00000000000000000110000000010010";
	wait for 1 * clk_period; 
	System_Instr <= "00000001011011000110100000100000";
	wait for 1 * clk_period; 
	System_Instr <= "10101101101000100000000000000000";
	wait for 1 * clk_period; 
	System_Instr <= "00100001010010101111111111111111";
	wait for 1 * clk_period; 
	System_Instr <= "00010101010000001111111111110111";
	wait for 1 * clk_period; 
	System_Instr <= "00010001011010111111111111111111";
	wait for 1 * clk_period; 
	



	WAIT;
END PROCESS stim_process;
END behavior;

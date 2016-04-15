-- Tester for branch history
-- Test if branch history works
-- Authors: Sheng Hao Liu  260585377

Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tester5 IS
END tester5;

ARCHITECTURE behaviour OF tester5 IS
  
COMPONENT two_bit_branch_history IS
PORT (
	clk, reset, TableWrite	: IN std_logic;
	ReadAddr1	: IN std_logic_vector(4 DOWNTO 0);
	ReadAddr2	: IN std_logic_vector(4 DOWNTO 0); 
	WriteAddr 	: IN std_logic_vector(4 DOWNTO 0);
	WriteData 	: IN std_logic_vector(1 DOWNTO 0);
	ReadData1	: OUT std_logic_vector(1 DOWNTO 0);
	ReadData2	: OUT std_logic_vector(1 DOWNTO 0) 
	);END COMPONENT;

-- input signals
SIGNAL clk: std_logic := '0';
SIGNAL reset: std_logic := '0';
SIGNAL TableWrite: std_logic := '0'; -- write enable 
SIGNAL ReadAddr1	: std_logic_vector(4 DOWNTO 0); -- 5bit 32index 
SIGNAL ReadAddr2	: std_logic_vector(4 DOWNTO 0); -- 5bit 32index 
SIGNAL WriteAddr : std_logic_vector(4 DOWNTO 0); -- 5bit 32index
SIGNAL WriteData : std_logic_vector(1 DOWNTO 0); -- state written (index element)
SIGNAL ReadData1: std_logic_vector (1 downto 0); -- state output (index element) don't mess with this
SIGNAL ReadData2: std_logic_vector (1 downto 0);

CONSTANT clk_period : time := 1 ns;

BEGIN
  BPH: two_bit_branch_history
  PORT MAP(clk,reset, TableWrite, ReadAddr1, ReadAddr2, WriteAddr, WriteData, ReadData1, ReadData2);

--clock process
clk_process : PROCESS
BEGIN
	CLK <= '0';
	WAIT FOR clk_period/2;
	CLK <= '1';
	WAIT FOR clk_period/2;
END PROCESS;
stim_process: PROCESS

BEGIN  
  REPORT "Starting test: ";
  
  -- wait a bit before reset
  WAIT FOR 1 * clk_period;
  
  reset <= '1';
  WAIT FOR 1 * clk_period;
  
  reset <= '0';
  ReadAddr1 <= "10000"; -- nothing initialized, should be 00 or UU
  WAIT FOR 1 * clk_period;
  
  TableWrite <= '0';
  WriteAddr <= "10000";
  WriteData <= "11";
  WAIT FOR 1 * clk_period;
  
  ReadAddr1 <= "10000"; -- shouldnt have any change
  TableWrite <= '1'; -- should write in 11 as data from last cycle
  WAIT FOR 1 * clk_period;
  
  ReadAddr1 <= "10000"; -- should have changed now to 11
  WAIT FOR 1 * clk_period;
  
  ReadAddr1 <= "10001"; -- change and it should be 00 or UU
  TableWrite <= '1';
  WriteAddr <= "10001"; -- same cycle = should be no change
  WriteData <= "10";
  WAIT FOR 1 * clk_period;
  
  ReadAddr1 <= "10001"; -- should change now to 10
  WAIT FOR 1 * clk_period;
  
  WAIT FOR 1 * clk_period;
  
  WAIT;

END PROCESS stim_process;
END;


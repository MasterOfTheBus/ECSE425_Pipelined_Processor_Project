-- Tester for Bit Tester
-- Test 2 bit branch predictor T/N
-- Authors: Sheng Hao Liu  260585377

Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tester4 IS
END tester4;

ARCHITECTURE behaviour OF tester4 IS
  
COMPONENT BP2bit IS
port (
      clk: in std_logic;
      intaken: in std_logic;
      outstate: out std_logic_vector (1 downto 0);
      outtaken: out std_logic
      );
END COMPONENT;

-- input signals
SIGNAL clk: std_logic := '0';
SIGNAL intaken: std_logic := '0';
SIGNAL outtaken: std_logic := '0';
SIGNAL outstate: std_logic_vector (1 downto 0);

CONSTANT clk_period : time := 1 ns;

BEGIN
  BPB: BP2bit
  PORT MAP(clk,intaken,outstate, outtaken);

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
  intaken <= '0';
  WAIT FOR 1 * clk_period;
  intaken <= '1';
  WAIT FOR 1 * clk_period;
  intaken <= '1';
  WAIT FOR 1 * clk_period;
  intaken <= '0';
  WAIT FOR 1 * clk_period;
  intaken <= '0';
  WAIT FOR 1 * clk_period;
  intaken <= '1';
  WAIT FOR 1 * clk_period;
  intaken <= '0';
  WAIT FOR 1 * clk_period;
  intaken <= '1';
  WAIT FOR 1 * clk_period;
  
  WAIT;

END PROCESS stim_process;
END;

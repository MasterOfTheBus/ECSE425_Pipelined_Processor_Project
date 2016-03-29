-- Tester for opCodeManager
-- Didn't go through all tests, but it's good enough 
-- WORKS!
-- Authors: Sheng Hao Liu  260585377

Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tester1 IS
END tester1;

ARCHITECTURE behaviour OF tester1 IS

COMPONENT opCodeManager IS
port (wordinstruction: in std_logic_vector(31 downto 0);
      wordclass: out std_logic_vector(2 downto 0);
      opCodeWord: out std_logic_vector(5 downto 0);
      opCodeFunc: out std_logic_vector(5 downto 0);
      wordformat: out std_logic_vector(1 downto 0);
      shamt: out std_logic_vector (4 downto 0)
      );
END COMPONENT;

--The input signals with their initial values
SIGNAL wordinstruction: std_logic_vector(31 downto 0) := (others => '0');
SIGNAL wordclass : std_logic_vector(2 downto 0) := (others => '0');
SIGNAL wordformat: std_logic_vector(1 downto 0) := (others => '0');
SIGNAL opCodeWord: std_logic_vector(5 downto 0) := (others => '0');
SIGNAL opCodeFunc: std_logic_vector(5 downto 0) := (others => '0');
SIGNAL shamt: std_logic_vector(4 downto 0) := (others => '0');

CONSTANT clk_period : time := 1 ns;

BEGIN
  OCM: opCodeManager
  PORT MAP(wordinstruction, wordclass, opCodeWord, opCodeFunc, wordformat, shamt);

stim_process: PROCESS

BEGIN  
  REPORT "Starting test: ";
  wordinstruction <= "00000000000000000000001100000000";
  WAIT FOR 1 * clk_period;
  wordinstruction <= "00000000000000000000000000100000";
  WAIT FOR 1 * clk_period;
  wordinstruction <= "10000000000000000000000000100000";
  WAIT FOR 1 * clk_period;
  wordinstruction <= "00100000000000000000000110100010";
  WAIT FOR 1 * clk_period;
  wordinstruction <= "00000000000000000000000000100000";
  WAIT FOR 1 * clk_period;
  wordinstruction <= "00101000000000000000001100100010";
  WAIT FOR 1 * clk_period;
  wordinstruction <= "00000000000000000000001100100000";
  WAIT FOR 1 * clk_period;
  
  WAIT;

END PROCESS stim_process;
END;

-- Tester for arithclass
-- WORKS! 
-- Authors: Sheng Hao Liu  260585377

Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tester3 IS
END tester3;

ARCHITECTURE behaviour OF tester3 IS

COMPONENT arithClass IS
port (wordformat: in std_logic_vector(1 downto 0);
    opcode: in std_logic_vector(5 downto 0);
    funct: in std_logic_vector(5 downto 0);
    regElementRS: in std_logic_vector(31 downto 0);
    regElementRT: in std_logic_vector(31 downto 0);
    regElementRD: in std_logic_vector(31 downto 0); -- i dont think we need this
    shamt: in std_logic_vector(4 downto 0);
    immediate: in std_logic_vector(15 downto 0);
    wordoutput: out std_logic_vector(31 downto 0); -- this is rd/rt/whereever output goes
    wordoutputHI: out std_logic_vector(31 downto 0); -- these are linked directly to HI/LO registers
    wordoutputLO: out std_logic_vector(31 downto 0)
      );
END COMPONENT;

--The input signals with their initial values
SIGNAL wordformat: std_logic_vector(1 downto 0) := (others => '0');
SIGNAL opcode : std_logic_vector(5 downto 0) := (others => '0');
SIGNAL funct: std_logic_vector(5 downto 0) := (others => '0');
SIGNAL regElementRS: std_logic_vector(31 downto 0) := (others => '0');
SIGNAL regElementRT: std_logic_vector(31 downto 0) := (others => '0');
SIGNAL regElementRD: std_logic_vector(31 downto 0) := (others => '0');
SIGNAL shamt: std_logic_vector(4 downto 0) := (others => '0');
SIGNAL immediate: std_logic_vector(15 downto 0) := (others => '0');
SIGNAL wordoutput: std_logic_vector(31 downto 0) := (others => '0');
SIGNAL wordoutputHI: std_logic_vector(31 downto 0) := (others => '0');
SIGNAL wordoutputLO: std_logic_vector(31 downto 0) := (others => '0');

CONSTANT clk_period : time := 1 ns;

BEGIN
  OCM: arithClass
  PORT MAP(wordformat, opcode, funct, regElementRS, regElementRT, regElementRD, shamt, immediate, 
  wordoutput, wordoutputHI, wordoutputLO);

stim_process: PROCESS

BEGIN  
  REPORT "Starting test: ";
  wordformat <= "01";
  opcode <= "000000"; funct <= "100000";
  regElementRS <= "00000000000000000000000000000001";
  regElementRT <= "00000000000000000000000000000001";
  WAIT FOR 1 * clk_period;
  wordformat <= "01";
  opcode <= "000000"; funct <= "100000";
  regElementRS <= "00000000000000000000000000000011";
  regElementRT <= "00000000000000000000000000000011";
  WAIT FOR 1 * clk_period;
  wordformat <= "01";
  opcode <= "000000"; funct <= "100000";
  regElementRS <= "11111111111111111111111111111111";
  regElementRT <= "00000000000000000000000000000001";
  WAIT FOR 1 * clk_period;
  wordformat <= "10";
  opcode <= "001000"; funct <= "000000";
  regElementRS <= "11111111111111111111111111111100";
  immediate <= "0000000000000001";
  WAIT FOR 1 * clk_period;
  wordformat <= "10";
  opcode <= "001000"; funct <= "100000";
  regElementRS <= "11111111111111111111111111111100";
  immediate <= "0000000000000001";
  WAIT FOR 1 * clk_period;
  WAIT FOR 1 * clk_period;
  WAIT FOR 1 * clk_period;
  
  WAIT;

END PROCESS stim_process;
END;



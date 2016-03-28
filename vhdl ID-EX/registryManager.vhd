---- registry controller for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This controller with take in an instruction (32 bits) and the Format (from opCode)
-- This controller will output the Rd/Rt/Rs etc signals 
-- This controller will output the immediate or address if needed
-- Error checking: INDEX of registries should never be 32

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- all reg are 5 bits (32 total)
entity registryManager is
  port (
    wordinstruction: in std_logic_vector(31 downto 0);
    wordformat: in std_logic_vector (1 downto 0); -- get this from opCode
    regRD: out std_logic_vector (4 downto 0); -- in 5bit
    regRT: out std_logic_vector (4 downto 0);
    regRS: out std_logic_vector (4 downto 0);
    INDregRD: out natural; -- in integer
    INDregRT: out natural;
    INDregRS: out natural;
    immediate: out std_logic_vector (15 downto 0);
    address: out std_logic_vector (25 downto 0)
  );
end entity;

architecture behavior of registryManager is
  -- SIGNALS
  -- have intermediate signals for all outputs
  SIGNAL RegistryRD: std_logic_vector (4 downto 0);
  SIGNAL RegistryRT: std_logic_vector (4 downto 0);
  SIGNAL RegistryRS: std_logic_vector (4 downto 0);
  SIGNAL IMMEDIATEIN: std_logic_vector (15 downto 0);
  SIGNAL ADDRESSIN: std_logic_vector (25 downto 0);
  -- INDEX outputs 
  SIGNAL INDREGISTRYRD: NATURAL := 0;
  SIGNAL INDREGISTRYRT: NATURAL := 0;
  SIGNAL INDREGISTRYRS: NATURAL := 0;
  -- Format
  SIGNAL FORMAT: std_logic_vector (1 downto 0);
  
  begin
    -- format
    FORMAT <= wordformat;
    
    -- for RS
    RegistryRS <= 
      wordinstruction (25 downto 21) when (FORMAT = "01") else 
      wordinstruction (25 downto 21) when (FORMAT = "10") else 
      "00000";
      
    -- for RT
    RegistryRT <= 
      wordinstruction (20 downto 16) when (FORMAT = "01") else 
      wordinstruction (20 downto 16) when (FORMAT = "10") else 
      "00000";  
      
    -- for RD
    RegistryRD <= 
      wordinstruction (15 downto 11) when (FORMAT = "01") else 
      "00000";  
      
    -- for Immediate
    IMMEDIATEIN <= 
      wordinstruction (15 downto 0) when (FORMAT = "10") else
      "ZZZZZZZZZZZZZZZZ";
      
    -- for Address
    ADDRESSIN <= 
      wordinstruction (25 downto 0) when (FORMAT = "11") else
      "ZZZZZZZZZZZZZZZZZZZZZZZZZZ";
      
    -- change registry to integer indexes
    INDREGISTRYRS <= to_integer(unsigned(RegistryRS));
    INDREGISTRYRT <= to_integer(unsigned(RegistryRT));
    INDREGISTRYRD <= to_integer(unsigned(RegistryRD));
    
    -- outputs 
    regRS <= RegistryRS;
    regRT <= RegistryRT;
    regRD <= RegistryRD;
    INDregRS <= INDREGISTRYRS;
    INDregRT <= INDREGISTRYRT;
    INDregRD <= INDREGISTRYRD;
    immediate <= IMMEDIATEIN;
    address <= ADDRESSIN;
    
end behavior;
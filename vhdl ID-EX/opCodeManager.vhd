---- op code controller for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This controller with take in an instruction (32 bits)
-- This controller outputs a signal type/format to an instantiation of proper ALU
-- I'm assuming MIPS binary code inputed is correct

Library ieee;
Use ieee.std_logic_1164.all;

-- 32 bit instruction input
-- 3 bit "type" output
-- 2 bit format output
-- opCodeXXXX for debug, can ignore when wiring everything
entity opCodeManager is
  port (
    wordinstruction: in std_logic_vector(31 downto 0);
    wordclass: out std_logic_vector(2 downto 0);
    opCodeWord: out std_logic_vector(5 downto 0);
    opCodeFunc: out std_logic_vector(5 downto 0);
    wordformat: out std_logic_vector(1 downto 0)
  );
end entity;

architecture behavior of opCodeManager is
  -- SIGNALS
  -- intermediate signal for opcode instruction itself
  SIGNAL opCodeWordi: std_logic_vector(5 downto 0);
  SIGNAL opCodeFunci: std_logic_vector(5 downto 0);
  
  -- types: Arith, Logic, Transfer, Shift, Mem, Cont.Flow in order 1-6
  -- 0 = no type/error, 7 = maybe other case
  SIGNAL opCodeType: std_logic_vector(2 downto 0);
  -- formats: R, I, J in order 1-3
  -- 0 = no type/error
  SIGNAL opCodeFormat: std_logic_vector(1 downto 0);
  
  -- signal concatonation for easier select statements
  SIGNAL opCodeConcat: std_logic_vector(4 downto 0);
  
  begin
    -- this code will now only be combinational circuits
    -- i.e. it will not take any clock cycles to give an output
      
    -- op code
    opCodeWordi <= wordinstruction (31 downto 26);        
    opCodeFunci <= wordinstruction (5 downto 0);   
    
    -- signal assignment in one huge when/else statement (no clk cycles needed)
    opCodeConcat <= 
      -- funct usage
      -- arith (1)
      "00101" when (opCodeWordi = "000000") and (opCodeFunci = "100000") else
      "00101" when (opCodeWordi = "000000") and (opCodeFunci = "100010") else
      "00101" when (opCodeWordi = "000000") and (opCodeFunci = "011000") else
      "00101" when (opCodeWordi = "000000") and (opCodeFunci = "011010") else
      "00101" when (opCodeWordi = "000000") and (opCodeFunci = "101010") else
      -- logical (2)
      "01001" when (opCodeWordi = "000000") and (opCodeFunci = "100100") else
      "01001" when (opCodeWordi = "000000") and (opCodeFunci = "100101") else
      "01001" when (opCodeWordi = "000000") and (opCodeFunci = "100111") else
      "01001" when (opCodeWordi = "000000") and (opCodeFunci = "100110") else
      -- transfer (3)
      "01101" when (opCodeWordi = "000000") and (opCodeFunci = "010000") else
      "01101" when (opCodeWordi = "000000") and (opCodeFunci = "010010") else
      -- shift (4)
      "10001" when (opCodeWordi = "000000") and (opCodeFunci = "000000") else
      "10001" when (opCodeWordi = "000000") and (opCodeFunci = "000010") else
      "10001" when (opCodeWordi = "000000") and (opCodeFunci = "000011") else
      -- memory (5)
      -- control (6)
      "11001" when (opCodeWordi = "000000") and (opCodeFunci = "001000") else
      
      -- opcode usage
      -- arith (1)   
      "00110" when (opCodeWordi = "001000") else
      "00110" when (opCodeWordi = "001010") else
      -- logical (2)
      "01010" when (opCodeWordi = "001100") else
      "01010" when (opCodeWordi = "001101") else
      "01010" when (opCodeWordi = "001110") else
      -- transfer (3)
      "01110" when (opCodeWordi = "001111") else
      -- shift (4)
      -- memory (5)
      "10110" when (opCodeWordi = "100011") else
      "10110" when (opCodeWordi = "100000") else
      "10110" when (opCodeWordi = "101011") else
      "10110" when (opCodeWordi = "101000") else
      -- control (6)
      "11010" when (opCodeWordi = "000100") else
      "11010" when (opCodeWordi = "000101") else
      "11011" when (opCodeWordi = "000010") else
      "11011" when (opCodeWordi = "000011") else
            
      "00000";      
      
    -- unconcatonate for op class/format
    opCodeType <= opCodeConcat (4 downto 2);
    opCodeFormat <= opCodeConcat (1 downto 0);
    
    -- intermediate signals for debug
    opCodeWord <= opCodeWordi;        
    opCodeFunc <= opCodeFunci;        
    
    -- output        
    wordclass <= opCodeType;
    wordformat <= opCodeFormat;  
end behavior;
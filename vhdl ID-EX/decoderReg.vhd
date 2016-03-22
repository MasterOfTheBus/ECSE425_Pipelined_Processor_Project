---- 32 registers for 5 bit address
-- Authors: Sheng Hao Liu  260585377
--
-- This will work similar to an array

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- 5 bit index
-- 32 registers total
-- 1 extra register for Program Counter (PC)
-- each reg has 16 bit unsigned int >> check for overflow in Classes of functions
entity decoderReg is
  port(
    CLK: in std_logic;
    regIndex: in std_logic_vector(4 downto 0);
    regElementIn: in std_logic_vector(15 downto 0);
    regElementOut: out std_logic_vector(15 downto 0)
  );
end entity;

architecture behavior of decoderReg is 
  -- ARRAY of REG of 16 bits
  TYPE REG32ARRAY is array (0 to 32) of std_logic_vector(15 downto 0);
  SIGNAL REG : REG32ARRAY;
  -- ARRAY INDEX REF
  SIGNAL IND : NATURAL := 0; -- init to 0?
  
  begin
    IND <= to_integer(unsigned(regIndex)); 

    process(CLK, regElementIn, IND)
      begin
        if (rising_edge(CLK)) then 
             if (IND = 0) then
            REG(0) <= regElementIn;
          elsif (IND = 1) then
            REG(1) <= regElementIn;
          elsif (IND = 2) then
            REG(2) <= regElementIn;
          elsif (IND = 3) then
            REG(3) <= regElementIn;
          elsif (IND = 4) then
            REG(4) <= regElementIn;
          elsif (IND = 5) then
            REG(5) <= regElementIn;
          elsif (IND = 6) then
            REG(6) <= regElementIn;
          elsif (IND = 7) then
            REG(7) <= regElementIn;
          elsif (IND = 8) then
            REG(8) <= regElementIn;
          elsif (IND = 9) then
            REG(9) <= regElementIn;
          elsif (IND = 10) then
            REG(10) <= regElementIn;
          elsif (IND = 11) then
            REG(11) <= regElementIn;
          elsif (IND = 12) then
            REG(12) <= regElementIn;
          elsif (IND = 13) then
            REG(13) <= regElementIn;
          elsif (IND = 14) then
            REG(14) <= regElementIn;
          elsif (IND = 15) then
            REG(15) <= regElementIn;
          elsif (IND = 16) then
            REG(16) <= regElementIn;
          elsif (IND = 17) then
            REG(17) <= regElementIn;
          elsif (IND = 18) then
            REG(18) <= regElementIn;
          elsif (IND = 19) then
            REG(19) <= regElementIn;
          elsif (IND = 20) then
            REG(20) <= regElementIn;
          elsif (IND = 21) then
            REG(21) <= regElementIn;
          elsif (IND = 22) then
            REG(22) <= regElementIn;
          elsif (IND = 23) then
            REG(23) <= regElementIn;
          elsif (IND = 24) then
            REG(24) <= regElementIn;
          elsif (IND = 25) then
            REG(25) <= regElementIn;
          elsif (IND = 26) then
            REG(26) <= regElementIn;
          elsif (IND = 27) then
            REG(27) <= regElementIn;
          elsif (IND = 28) then
            REG(28) <= regElementIn;
          elsif (IND = 29) then
            REG(29) <= regElementIn;
          elsif (IND = 30) then
            REG(30) <= regElementIn;
          elsif (IND = 31) then
            REG(31) <= regElementIn;
          elsif (IND = 32) then
            REG(32) <= regElementIn;
          end if;
        end if;
      end process;
    
    process(CLK, IND)
      begin
        if (rising_edge(CLK)) then 
          if (IND = 0) then
            regElementOut <= REG(0);
          end if;
        end if;
      end process;
    
end behavior;
---- 32 registers for 5 bit address
-- Authors: Sheng Hao Liu  260585377
--
-- This will work similar to an array
-- can only input into 1 registry at a time (Rd/Rt)
-- can read from all registry elements at the same time

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- 5 bit index
-- 32 general use registers total
-- 1 extra register for Program Counter (PC)
-- each reg has 16 bit unsigned int >> check for overflow in Classes of functions
entity decoderReg is
  port(
    CLK: in std_logic;
    WR_EN: in std_logic;
    regIndex: in std_logic_vector(4 downto 0);
    regElementIn: in std_logic_vector(31 downto 0);
    regElement0Out: out std_logic_vector(31 downto 0);
    regElement1Out: out std_logic_vector(31 downto 0);
    regElement2Out: out std_logic_vector(31 downto 0);
    regElement3Out: out std_logic_vector(31 downto 0);
    regElement4Out: out std_logic_vector(31 downto 0);
    regElement5Out: out std_logic_vector(31 downto 0);
    regElement6Out: out std_logic_vector(31 downto 0);
    regElement7Out: out std_logic_vector(31 downto 0);
    regElement8Out: out std_logic_vector(31 downto 0);
    regElement9Out: out std_logic_vector(31 downto 0);
    regElement10Out: out std_logic_vector(31 downto 0);
    regElement11Out: out std_logic_vector(31 downto 0);
    regElement12Out: out std_logic_vector(31 downto 0);
    regElement13Out: out std_logic_vector(31 downto 0);
    regElement14Out: out std_logic_vector(31 downto 0);
    regElement15Out: out std_logic_vector(31 downto 0);
    regElement16Out: out std_logic_vector(31 downto 0);
    regElement17Out: out std_logic_vector(31 downto 0);
    regElement18Out: out std_logic_vector(31 downto 0);
    regElement19Out: out std_logic_vector(31 downto 0);
    regElement20Out: out std_logic_vector(31 downto 0);
    regElement21Out: out std_logic_vector(31 downto 0);
    regElement22Out: out std_logic_vector(31 downto 0);
    regElement23Out: out std_logic_vector(31 downto 0);
    regElement24Out: out std_logic_vector(31 downto 0);
    regElement25Out: out std_logic_vector(31 downto 0);
    regElement26Out: out std_logic_vector(31 downto 0);
    regElement27Out: out std_logic_vector(31 downto 0);
    regElement28Out: out std_logic_vector(31 downto 0);
    regElement29Out: out std_logic_vector(31 downto 0);
    regElement30Out: out std_logic_vector(31 downto 0);
    regElement31Out: out std_logic_vector(31 downto 0);
    regElement32Out: out std_logic_vector(31 downto 0) -- registry for PC
  );
end entity;

architecture behavior of decoderReg is 
  -- ARRAY of REG of 32 bits
  TYPE REG32ARRAY is array (0 to 32) of std_logic_vector(31 downto 0);
  SIGNAL REG : REG32ARRAY;
  -- ARRAY INDEX REF
  SIGNAL IND : NATURAL := 0; -- init to 0?
  
  begin
    IND <= to_integer(unsigned(regIndex)); 

    process(CLK, regElementIn, IND, WR_EN)
      begin
        if (rising_edge(CLK) and WR_EN = '1') then 
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
    
    regElement0Out <= REG(0);
    regElement1Out <= REG(1);
    regElement2Out <= REG(2);
    regElement3Out <= REG(3);
    regElement4Out <= REG(4);
    regElement5Out <= REG(5);
    regElement6Out <= REG(6);
    regElement7Out <= REG(7);
    regElement8Out <= REG(8);
    regElement9Out <= REG(9);
    regElement10Out <= REG(10);
    regElement11Out <= REG(11);
    regElement12Out <= REG(12);
    regElement13Out <= REG(13);
    regElement14Out <= REG(14);
    regElement15Out <= REG(15);
    regElement16Out <= REG(16);
    regElement17Out <= REG(17);
    regElement18Out <= REG(18);
    regElement19Out <= REG(19);
    regElement20Out <= REG(20);
    regElement21Out <= REG(21);
    regElement22Out <= REG(22);
    regElement23Out <= REG(23);
    regElement24Out <= REG(24);
    regElement25Out <= REG(25);
    regElement26Out <= REG(26);
    regElement27Out <= REG(27);
    regElement28Out <= REG(28);
    regElement29Out <= REG(29);
    regElement30Out <= REG(30);
    regElement31Out <= REG(31);
    regElement32Out <= REG(32);
        
end behavior;
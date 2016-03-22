---- ONE register of 16 bit unsigned int
-- Authors: Sheng Hao Liu  260585377
--
-- This needs to work in conjunction with decoderReg

Library ieee;
Use ieee.std_logic_1164.all;

-- register has 16 bit unsigned int >> check for overflow in Classes of functions
entity oneReg is
  port(
    CLK: in std_logic;
    regElementIn: in std_logic_vector(15 downto 0);
    regElementOut: out std_logic_vector(15 downto 0)
  );
end entity;

architecture behavior of oneReg is 
  -- REG of 16 bits 
  SIGNAL REG : std_logic_vector(15 downto 0);
  
  begin
    process(CLK, regElementIn)
    begin
      if (rising_edge(CLK)) then 
        REG <= regElementIn;
      end if;
    end process;

    regElementout <= REG;
end behavior;
---- arithmetic unit for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This will do simple arithmetics
-- it will take registers and use them to do arithmetic
-- ONLY R & I formats

Library ieee;
Use ieee.std_logic_1164.all;

-- 32 bit instruction input
-- 32 bit arithmetic result output
entity arithClass is
  port (
    wordinstruction: in std_logic_vector(31 downto 0);
    wordformat: in std_logic_vector(1 downto 0);
    wordoutput: out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of arithClass is 
  -- SIGNALS
  begin
    
end behavior;
---- arithmetic unit for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This will do simple arithmetics
-- The ports are mostly to be a template for all classes
-- This will need a bigger component to be composed of classes with a 6mux to choose the correct ALU
-- ONLY R & I formats

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- 32 bit instruction input decoded into RS/T/D + Shamt + funct + immediate + address (not used here)
-- 32 bit arithmetic result output
entity arithClass is
  port (
    wordformat: in std_logic_vector(1 downto 0);
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
end entity;

architecture behavior of arithClass is 
  -- SIGNALS
  -- for multiplications
  SIGNAL INTMUL: std_logic_vector (63 downto 0);
  begin
    
    process (wordformat, opcode, funct, regElementRS, regElementRT, regElementRD, shamt, immediate)
    begin 
      -- add instruction rd=rs+rt
      if (opcode = "000000" and funct = "100000" and wordformat = "01") then 
        wordoutput <= std_logic_vector(signed(regElementRS) + signed(regElementRT));       
      -- sub instruction rd=rs-rt
      elsif (opcode = "000000" and funct = "100010" and wordformat = "01") then
        wordoutput <= std_logic_vector(signed(regElementRS) - signed(regElementRT));   
      -- add immediate rt=rs+imm
      elsif (opcode = "001000" and wordformat = "10") then
        wordoutput <= std_logic_vector(signed(regElementRS) + signed(immediate));
      -- multiply hi,lo = rs*rt
      elsif (opcode = "000000" and funct = "011000" and wordformat = "01") then
        INTMUL <= std_logic_vector(signed(regElementRS) * signed(regElementRT));
        wordoutputHI <= INTMUL(63 downto 32);
        wordoutputLO <= INTMUL(31 downto 0);
      -- divide lo = rs/rt; hi = rs%rt
      elsif (opcode = "000000" and funct = "011010" and wordformat = "01") then
        wordoutputLO <= std_logic_vector(signed(regElementRS) / signed(regElementRT));
        wordoutputHI <= std_logic_vector(signed(regElementRS) mod signed(regElementRT));
      -- set less than rd=1 if rs<rt
      elsif (opcode = "000000" and funct = "101010" and wordformat = "01") then
        if (signed(regElementRS) < signed(regElementRT)) then
          wordoutput <= std_logic_vector(to_signed(1, 32));
        else 
          wordoutput <= std_logic_vector(to_signed(0, 32));
        end if;
      -- set less than imm
      elsif (opcode = "000000" and funct = "101010" and wordformat = "01") then
        if (signed(regElementRS) < signed(immediate)) then
          wordoutput <= std_logic_vector(to_signed(1, 32));
        else 
          wordoutput <= std_logic_vector(to_signed(0, 32));
        end if;
      end if;
    end process;

end behavior;
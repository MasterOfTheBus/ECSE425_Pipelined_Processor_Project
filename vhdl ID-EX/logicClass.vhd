---- logical unit for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This will do logical arithmetics
-- ONLY R & I formats

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- 32 bit instruction input decoded into RS/T/D + Shamt + funct + immediate + address (not used here)
-- 32 bit logical result output
entity logicClass is
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

architecture behavior of logicClass is 
  -- SIGNALS
  begin
    
    process (wordformat, opcode, funct, regElementRS, regElementRT, regElementRD, shamt, immediate)
    begin 
      -- and instruction rd=rs&rt
      if (opcode = "000000" and funct = "100100" and wordformat = "01") then 
        wordoutput <= std_logic_vector((regElementRS) and (regElementRT));
      -- or instruction rd=rs|rt
      elsif (opcode = "000000" and funct = "100101" and wordformat = "01") then
        wordoutput <= std_logic_vector((regElementRS) or (regElementRT));  
      -- nor instruction rd=!(rs|rt)
      elsif (opcode = "000000" and funct = "100111" and wordformat = "01") then
        wordoutput <= std_logic_vector((regElementRS) nor (regElementRT));  
      -- xor instruction rd=ex(rs|rt)
      elsif (opcode = "000000" and funct = "100110" and wordformat = "01") then
        wordoutput <= std_logic_vector((regElementRS) xor (regElementRT));  
      -- and immediate rd=rs&extend imm
      elsif (opcode = "001100" and wordformat = "10") then
        wordoutput <= std_logic_vector((regElementRS) and ("0000000000000000"&immediate));  
      -- or immediate rd=rs|extend imm
      elsif (opcode = "001101" and wordformat = "10") then
        wordoutput <= std_logic_vector((regElementRS) or ("0000000000000000"&immediate)); 
      -- xor immediate rd=rs|extend imm
      elsif (opcode = "001110" and wordformat = "10") then
        wordoutput <= std_logic_vector((regElementRS) xor ("0000000000000000"&immediate));           
      end if;
    end process;

end behavior;

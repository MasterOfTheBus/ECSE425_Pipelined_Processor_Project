---- memory unit for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This will do memory loading/storing 
-- ONLY I formats

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- 32 bit instruction input decoded into RS/T/D + Shamt + funct + immediate + address (not used here)
-- 32 bit logical result output
entity memClass is
  port (
    wordformat: in std_logic_vector(1 downto 0);
    opcode: in std_logic_vector(5 downto 0);
    funct: in std_logic_vector(5 downto 0);
    regElementRS: in std_logic_vector(31 downto 0);
    regElementRT: in std_logic_vector(31 downto 0);
    regElementRD: in std_logic_vector(31 downto 0); -- i dont think we need this
    shamt: in std_logic_vector(4 downto 0);
    immediate: in std_logic_vector(15 downto 0);
    address: in std_logic_vector (25 downto 0); -- not sure how to use this
    wordoutput: out std_logic_vector(31 downto 0); -- this is rd/rt/whereever output goes
    wordoutputHI: out std_logic_vector(31 downto 0); -- these are linked directly to HI/LO registers
    wordoutputLO: out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of memClass is 
  -- SIGNALS
  begin
    
    process (wordformat, opcode, funct, regElementRS, regElementRT, regElementRD, shamt, immediate)
    begin 
      -- load word(32) rt=M[rs+imm]
      if (opcode = "100011" and wordformat = "10") then 
        wordoutput <= std_logic_vector(signed(regElementRS) + signed(immediate));
      -- load byte(8) rt=M[rs+imm]
      elsif (opcode = "100000" and wordformat = "10") then 
        wordoutput <= std_logic_vector(signed(regElementRS) + signed(immediate));
      -- store word(32) M[rs+imm]=rt
      elsif (opcode = "101011" and wordformat = "10") then 
        wordoutput <= std_logic_vector(signed(regElementRS) + signed(immediate));
      -- store byte(8) M[rs+imm]=rt
      elsif (opcode = "101000" and wordformat = "10") then 
        wordoutput <= std_logic_vector(signed(regElementRS) + signed(immediate));
      end if;
    end process;

end behavior;



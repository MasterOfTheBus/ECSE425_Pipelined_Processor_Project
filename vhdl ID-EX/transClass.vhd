---- transfer unit for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This will do tranferring of registries
-- ONLY R & I formats

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- 32 bit instruction input decoded into RS/T/D + Shamt + funct + immediate + address (not used here)
-- 32 bit logical result output
entity transClass is
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

architecture behavior of transClass is 
  -- SIGNALS
  begin
    
    process (wordformat, opcode, funct, regElementRS, regElementRT, regElementRD, shamt, immediate)
    begin 
      -- move from high instruction rd = HI (rs in secret)
      if (opcode = "000000" and funct = "010000" and wordformat = "01") then 
        wordoutput <= regElementRS;
      -- move from low instruction rd = HI (rt in secret)
      elsif (opcode = "000000" and funct = "010010" and wordformat = "01") then 
        wordoutput <= regElementRT;
      -- load upper immediate rt = immediate&0s
      elsif (opcode = "001111" and wordformat = "10") then 
        wordoutput <= immediate&"0000000000000000";
      end if;
    end process;

end behavior;

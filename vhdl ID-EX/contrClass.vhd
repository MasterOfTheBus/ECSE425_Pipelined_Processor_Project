---- control-flow unit for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This will do branches and jumps
-- This is a coding mess right now, I don't know how to fix it properly
-- ALL formats

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- 32 bit instruction input decoded into RS/T/D + Shamt + funct + immediate + address
-- 32 bit logical result output
entity contrClass is
  port (
    wordformat: in std_logic_vector(1 downto 0);
    opcode: in std_logic_vector(5 downto 0);
    funct: in std_logic_vector(5 downto 0);
    regElementRS: in std_logic_vector(31 downto 0);
    regElementRT: in std_logic_vector(31 downto 0);
    regElementRD: in std_logic_vector(31 downto 0); -- let RD be PC previous here
    shamt: in std_logic_vector(4 downto 0);
    immediate: in std_logic_vector(15 downto 0);
    address: in std_logic_vector (25 downto 0); -- not sure how to use this
    wordoutput: out std_logic_vector(31 downto 0); -- this is rd/rt/whereever output goes
    wordoutputHI: out std_logic_vector(31 downto 0); -- this is for R31 and PC here
    wordoutputLO: out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of contrClass is 
  -- SIGNALS
  
  begin
    
    process (wordformat, opcode, funct, regElementRS, regElementRT, regElementRD, shamt, immediate)
    begin 
      -- branch on equal if rs=rt then PC = PC+4+BRANCH ADDR
      if (opcode = "000100" and wordformat = "10") then 
        if (regElementRS = regElementRT) then
          wordoutput <= std_logic_vector(unsigned(regElementRD) + "100" + unsigned(address));
        end if;
      -- branch not equal std_logic_vector(signed(regElementRS) + signed(immediate));
      elsif (opcode = "000101" and wordformat = "10") then 
        if (regElementRS /= regElementRT) then
          wordoutput <= std_logic_vector(unsigned(regElementRD) + "100" + unsigned(address));
        end if;
      -- jump address / let LO be the PC for now
      elsif (opcode = "000010" and wordformat = "11") then 
        wordoutputLO <= address; 
      -- jump register
      elsif (opcode = "000100" and funct = "001000" and wordformat = "01") then 
        wordoutput <= regElementRS;
      -- jump and link
      elsif (opcode = "000011" and wordformat = "11") then 
        wordoutputHI <= std_logic_vector(unsigned(regElementRD) + "1000");
        wordoutputLO <= address;
      end if;
    end process;

end behavior;


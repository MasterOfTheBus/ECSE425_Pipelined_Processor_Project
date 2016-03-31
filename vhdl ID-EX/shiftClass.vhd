---- shifting unit for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This will do shifting of register elements
-- ONLY R formats

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- 32 bit instruction input decoded into RS/T/D + Shamt + funct + immediate + address (not used here)
-- 32 bit logical result output
entity shiftClass is
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

architecture behavior of shiftClass is 
  -- SIGNALS
  begin
    
    process (wordformat, opcode, funct, regElementRS, regElementRT, regElementRD, shamt, immediate)
    begin 
      -- shift left logical rd=rt<<shamt
      if (opcode = "000000" and funct = "000000" and wordformat = "01") then 
        wordoutput <= to_stdlogicvector(to_bitvector(regElementRT) sll to_integer(unsigned(shamt)));
      -- shift right logical rd=rt>>shamt
      elsif (opcode = "000000" and funct = "000010" and wordformat = "01") then 
        wordoutput <= to_stdlogicvector(to_bitvector(regElementRT) srl to_integer(unsigned(shamt)));
      -- shift right arithmetic rd=rt>>>shamt
      elsif (opcode = "000000" and funct = "000011" and wordformat = "01") then 
        wordoutput <= to_stdlogicvector(to_bitvector(regElementRT) sra to_integer(unsigned(shamt)));
      end if;
    end process;

end behavior;



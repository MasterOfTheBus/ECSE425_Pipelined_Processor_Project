---- op code controller for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This controller with take in an instruction (32 bits)
-- This controller outputs a signal type/format to an instantiation of proper ALU
-- I'm assuming MIPS binary code inputed is correct

Library ieee;
Use ieee.std_logic_1164.all;

-- 32 bit instruction input
-- 3 bit "type" output
-- 2 bit format output
entity opCodeManager is
  port (
    wordinstruction: in std_logic_vector(31 downto 0);
    wordclass: out std_logic_vector(2 downto 0);
    wordformat: out std_logic_vector(1 downto 0)
  );
end entity;

architecture behavior of opCodeManager is
  -- SIGNALS
  -- intermediate signal for opcode instruction itself
  SIGNAL opCodeWord: std_logic_vector(5 downto 0);
  SIGNAL opCodeFunc: std_logic_vector(5 downto 0);
  
  -- types: Arith, Logic, Transfer, Shift, Mem, Cont.Flow in order 1-6
  -- 0 = no type/error, 7 = maybe other case
  SIGNAL opCodeType: std_logic_vector(2 downto 0);
  -- formats: R, I, J in order 1-3
  -- 0 = no type/error
  SIGNAL opCodeFormat: std_logic_vector(1 downto 0);
  
  begin
    -- try to keep ID at 1 cycle  
    process (wordinstruction)
      begin
        -- op code
        opCodeWord <= wordinstruction (31 downto 26);
        
        -- know if op code or function
        if (opCodeWord = "000000") then
          opCodeFunc <= wordinstruction (5 downto 0);
        else 
          opCodeFunc <= "XXXXXX";
        end if;
        
        -- decoding of the 32 bit signal
        
        case opCodeWord is
          -- arith signals (1)
          when "001000" => opCodeType <= "001"; opCodeFormat <= "10";
          when "001010" => opCodeType <= "001"; opCodeFormat <= "10";
          -- logical signals (2)
          when "001100" => opCodeType <= "010"; opCodeFormat <= "10";
          when "001101" => opCodeType <= "010"; opCodeFormat <= "10";
          when "001110" => opCodeType <= "010"; opCodeFormat <= "10";
          -- transfer signals (3)
          when "001111" => opCodeType <= "011"; opCodeFormat <= "10";
          -- shift signals (4)
          -- memory signals (5)
          when "100011" => opCodeType <= "101"; opCodeFormat <= "10";
          when "100000" => opCodeType <= "101"; opCodeFormat <= "10";
          when "101011" => opCodeType <= "101"; opCodeFormat <= "10";
          when "101000" => opCodeType <= "101"; opCodeFormat <= "10";
          -- control flow signals (6)
          when "000100" => opCodeType <= "110"; opCodeFormat <= "10";
          when "000101" => opCodeType <= "110"; opCodeFormat <= "10";
          when "000010" => opCodeType <= "110"; opCodeFormat <= "11";
          when "000011" => opCodeType <= "110"; opCodeFormat <= "11";
          -- no type / error
          when OTHERS => opCodeType <= "000"; opCodeFormat <= "00";
        end case;
        
        case opCodeFunc is
          -- arith signals (1)
          when "100000" => opCodeType <= "001"; opCodeFormat <= "01";
          when "100010" => opCodeType <= "001"; opCodeFormat <= "01";
          when "011000" => opCodeType <= "001"; opCodeFormat <= "01";
          when "011010" => opCodeType <= "001"; opCodeFormat <= "01";
          when "101010" => opCodeType <= "001"; opCodeFormat <= "01";
          -- logical signals (2)
          when "100100" => opCodeType <= "010"; opCodeFormat <= "01";
          when "100101" => opCodeType <= "010"; opCodeFormat <= "01";
          when "100111" => opCodeType <= "010"; opCodeFormat <= "01";
          when "100110" => opCodeType <= "010"; opCodeFormat <= "01";
          -- transfer signals (3)
          when "010000" => opCodeType <= "011"; opCodeFormat <= "01";
          when "010010" => opCodeType <= "011"; opCodeFormat <= "01";
          -- shift signals (4)
          when "000000" => opCodeType <= "100"; opCodeFormat <= "01";
          when "000010" => opCodeType <= "100"; opCodeFormat <= "01";
          when "000011" => opCodeType <= "100"; opCodeFormat <= "01";
          -- memory signals (5)
          -- control flow signals (6)
          when "001000" => opCodeType <= "110"; opCodeFormat <= "01";
          -- no type / error  
          when OTHERS => opCodeType <= "000"; opCodeFormat <= "00";
        end case;
    end process;
    
    wordclass <= opCodeType;
    wordformat <= opCodeFormat;
end behavior;
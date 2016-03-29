---- instruction decoder full path for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This file is the ID part of the pipeline (whole thing)
-- This controller with take everything and output all to execution
-- 4 inputs: CLK, Write Enable, Registry Index, Instruction
-- 10 outputs: Elements of RS/T/D, Exec Class, OpCode, Funct, Format RIJ, Shamt, Immediate, Address
-- Some outputs will be 0s depending on instruction given
-- Error checking:
-- If Class = 0 or 7, then error
-- If Format = 0, then error
-- If RS/T/D = "Z", then error in indexing
-- If immediate/address = "Z" when the format is correct, then error
-- If regIndex = 32 somehow, then error

Library ieee;
Use ieee.std_logic_1164.all;

entity insDec is
  port (
    -- decoderReg
    CLK: in std_logic;
    WR_EN: in std_logic;
    regIndex: in std_logic_vector(4 downto 0);
    regElementIn: in std_logic_vector(31 downto 0);
    regElementRS: out std_logic_vector(31 downto 0); -- give element of RS/T/D to exec
    regElementRT: out std_logic_vector(31 downto 0);
    regElementRD: out std_logic_vector(31 downto 0); 
    -- opCodeManager
    wordinstruction: in std_logic_vector(31 downto 0);
    wordclass: out std_logic_vector(2 downto 0);
    opCodeWord: out std_logic_vector(5 downto 0); -- give opcode to exec
    opCodeFunc: out std_logic_vector(5 downto 0); -- give funct to exec
    wordformat: out std_logic_vector(1 downto 0); -- give format RIJ to exec
    shamt: out std_logic_vector (4 downto 0); -- give shamt to exec
    -- registryManager
    -- wordinstruction: in std_logic_vector(31 downto 0); -- already there
    -- wordformat: in std_logic_vector (1 downto 0); -- already there
    --regRD: out std_logic_vector (4 downto 0); -- this is not really useful anywhere
    --regRT: out std_logic_vector (4 downto 0);
    --regRS: out std_logic_vector (4 downto 0);
    --INDregRD: out natural; -- these are intermediate for element
    --INDregRT: out natural;
    --INDregRS: out natural;
    immediate: out std_logic_vector (15 downto 0); -- give immediate to exec
    address: out std_logic_vector (25 downto 0) -- give address to exec
  );
end entity;

architecture behavior of insDec is
  -- COMPONENTS
  COMPONENT decoderReg IS
  port (CLK: in std_logic;
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
  END COMPONENT;
  COMPONENT opCodeManager IS
  port (wordinstruction: in std_logic_vector(31 downto 0);
      wordclass: out std_logic_vector(2 downto 0);
      opCodeWord: out std_logic_vector(5 downto 0);
      opCodeFunc: out std_logic_vector(5 downto 0);
      wordformat: out std_logic_vector(1 downto 0);
      shamt: out std_logic_vector (4 downto 0)
      );
  END COMPONENT;
  COMPONENT registryManager IS
  port (wordinstruction: in std_logic_vector(31 downto 0);
      wordformat: in std_logic_vector (1 downto 0); -- get this from opCode
      regRD: out std_logic_vector (4 downto 0);
      regRT: out std_logic_vector (4 downto 0);
      regRS: out std_logic_vector (4 downto 0);
      INDregRD: out natural;
      INDregRT: out natural;
      INDregRS: out natural;
      immediate: out std_logic_vector (15 downto 0);
      address: out std_logic_vector (25 downto 0)
      );
  END COMPONENT;
  -- SIGNALS
  -- FOR REGISTRIES
  SIGNAL regElement0Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement1Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement2Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement3Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement4Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement5Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement6Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement7Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement8Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement9Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement10Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement11Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement12Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement13Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement14Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement15Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement16Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement17Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement18Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement19Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement20Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement21Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement22Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement23Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement24Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement25Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement26Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement27Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement28Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement29Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement30Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement31Out: std_logic_vector(31 downto 0) := (others => '0');
  SIGNAL regElement32Out: std_logic_vector(31 downto 0) := (others => '0');
  -- for WORDFORMAT
  SIGNAL wordformatin: std_logic_vector (1 downto 0) := (others => '0');
  -- for REGISTRYMANAGER
  SIGNAL regRD: std_logic_vector (4 downto 0) := (others => '0');
  SIGNAL regRT: std_logic_vector (4 downto 0) := (others => '0');
  SIGNAL regRS: std_logic_vector (4 downto 0) := (others => '0');
  -- transform regRD/RT/RS to actual index that can be used (INDregRD/S/T) -- done in registryManager
  SIGNAL INDregRD: natural := 0;
  SIGNAL INDregRT: natural := 0;
  SIGNAL INDregRS: natural := 0;
  -- take the appropriate element from decoderReg
  -- combinational SIGNAL WHEN LOGIC;
  begin
    -- INSTANTIATION
    DREG: decoderReg
    PORT MAP(CLK, WR_EN, regIndex, regElementIn, 
    regElement0Out, regElement1Out, regElement2Out, regElement3Out, regElement4Out, regElement5Out, regElement6Out, regElement7Out, regElement8Out, regElement9Out,
    regElement10Out, regElement11Out, regElement12Out, regElement13Out, regElement14Out, regElement15Out, regElement16Out, regElement17Out, regElement18Out, regElement19Out,
    regElement20Out, regElement21Out, regElement22Out, regElement23Out, regElement24Out, regElement25Out, regElement26Out, regElement27Out, regElement28Out, regElement29Out,
    regElement30Out, regElement31Out, regElement32Out
    );
    OCM: opCodeManager
    PORT MAP(wordinstruction => wordinstruction, wordclass => wordclass, 
    opCodeWord => opCodeWord, opCodeFunc => opCodeFunc, wordformat => wordformatin, shamt => shamt);
    RM: registryManager
    PORT MAP(wordinstruction => wordinstruction, wordformat => wordformatin, 
    regRD => regRD, regRT => regRT, regRS => regRT, 
    INDregRD => INDregRD, INDregRT => INDregRT, INDregRS => INDregRS,
    immediate => immediate, address => address);

    -- output elements RS/T/D combinational logic
    regElementRS <= 
      regElement0Out when INDregRS = 0 else
      regElement1Out when INDregRS = 1 else
      regElement2Out when INDregRS = 2 else
      regElement3Out when INDregRS = 3 else
      regElement4Out when INDregRS = 4 else
      regElement5Out when INDregRS = 5 else
      regElement6Out when INDregRS = 6 else
      regElement7Out when INDregRS = 7 else
      regElement8Out when INDregRS = 8 else
      regElement9Out when INDregRS = 9 else
      regElement10Out when INDregRS = 10 else
      regElement11Out when INDregRS = 11 else
      regElement12Out when INDregRS = 12 else
      regElement13Out when INDregRS = 13 else
      regElement14Out when INDregRS = 14 else
      regElement15Out when INDregRS = 15 else
      regElement16Out when INDregRS = 16 else
      regElement17Out when INDregRS = 17 else
      regElement18Out when INDregRS = 18 else
      regElement19Out when INDregRS = 19 else
      regElement20Out when INDregRS = 20 else
      regElement21Out when INDregRS = 21 else
      regElement22Out when INDregRS = 22 else
      regElement23Out when INDregRS = 23 else
      regElement24Out when INDregRS = 24 else
      regElement25Out when INDregRS = 25 else
      regElement26Out when INDregRS = 26 else
      regElement27Out when INDregRS = 27 else
      regElement28Out when INDregRS = 28 else
      regElement29Out when INDregRS = 29 else
      regElement30Out when INDregRS = 30 else
      regElement31Out when INDregRS = 31 else
      regElement32Out when INDregRS = 32 else
      -- error as Zs
      "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    
    regElementRT <= 
      regElement0Out when INDregRT = 0 else
      regElement1Out when INDregRT = 1 else
      regElement2Out when INDregRT = 2 else
      regElement3Out when INDregRT = 3 else
      regElement4Out when INDregRT = 4 else
      regElement5Out when INDregRT = 5 else
      regElement6Out when INDregRT = 6 else
      regElement7Out when INDregRT = 7 else
      regElement8Out when INDregRT = 8 else
      regElement9Out when INDregRT = 9 else
      regElement10Out when INDregRT = 10 else
      regElement11Out when INDregRT = 11 else
      regElement12Out when INDregRT = 12 else
      regElement13Out when INDregRT = 13 else
      regElement14Out when INDregRT = 14 else
      regElement15Out when INDregRT = 15 else
      regElement16Out when INDregRT = 16 else
      regElement17Out when INDregRT = 17 else
      regElement18Out when INDregRT = 18 else
      regElement19Out when INDregRT = 19 else
      regElement20Out when INDregRT = 20 else
      regElement21Out when INDregRT = 21 else
      regElement22Out when INDregRT = 22 else
      regElement23Out when INDregRT = 23 else
      regElement24Out when INDregRT = 24 else
      regElement25Out when INDregRT = 25 else
      regElement26Out when INDregRT = 26 else
      regElement27Out when INDregRT = 27 else
      regElement28Out when INDregRT = 28 else
      regElement29Out when INDregRT = 29 else
      regElement30Out when INDregRT = 30 else
      regElement31Out when INDregRT = 31 else
      regElement32Out when INDregRT = 32 else
      -- error as Zs
      "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
      
    regElementRD <= 
      regElement0Out when INDregRD = 0 else
      regElement1Out when INDregRD = 1 else
      regElement2Out when INDregRD = 2 else
      regElement3Out when INDregRD = 3 else
      regElement4Out when INDregRD = 4 else
      regElement5Out when INDregRD = 5 else
      regElement6Out when INDregRD = 6 else
      regElement7Out when INDregRD = 7 else
      regElement8Out when INDregRD = 8 else
      regElement9Out when INDregRD = 9 else
      regElement10Out when INDregRD = 10 else
      regElement11Out when INDregRD = 11 else
      regElement12Out when INDregRD = 12 else
      regElement13Out when INDregRD = 13 else
      regElement14Out when INDregRD = 14 else
      regElement15Out when INDregRD = 15 else
      regElement16Out when INDregRD = 16 else
      regElement17Out when INDregRD = 17 else
      regElement18Out when INDregRD = 18 else
      regElement19Out when INDregRD = 19 else
      regElement20Out when INDregRD = 20 else
      regElement21Out when INDregRD = 21 else
      regElement22Out when INDregRD = 22 else
      regElement23Out when INDregRD = 23 else
      regElement24Out when INDregRD = 24 else
      regElement25Out when INDregRD = 25 else
      regElement26Out when INDregRD = 26 else
      regElement27Out when INDregRD = 27 else
      regElement28Out when INDregRD = 28 else
      regElement29Out when INDregRD = 29 else
      regElement30Out when INDregRD = 30 else
      regElement31Out when INDregRD = 31 else
      regElement32Out when INDregRD = 32 else
      -- error as Zs
      "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    
    
    -- output format
    wordformat <= wordformatin;
end behavior;

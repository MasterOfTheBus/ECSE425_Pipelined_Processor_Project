---- ALU "chooser" for 32 bit input
-- Authors: Sheng Hao Liu  260585377
--
-- This will choose the correct arithmetic class to do the instruction
-- This EX pipeline does not actually take in account the registry index of RS/T/D
-- Thus, you will have to get index RS/T/D from ID 
-- 

Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

-- word class is most important here, all others are just in=>in/out=>out
-- can have memory as inputs too, but im not sure how it works (Class5:memClass)
-- Class6:contrClass also needs looking at
entity ALUmux is
  port (
    wordclass: in std_logic_vector(2 downto 0);
    wordformat: in std_logic_vector(1 downto 0);   
    opcode: in std_logic_vector(5 downto 0);
    funct: in std_logic_vector(5 downto 0);
    regElementRS: in std_logic_vector(31 downto 0);
    regElementRT: in std_logic_vector(31 downto 0);
    regElementRD: in std_logic_vector(31 downto 0); -- i dont think we need this
    shamt: in std_logic_vector(4 downto 0);
    immediate: in std_logic_vector(15 downto 0);
    address: in std_logic_vector (25 downto 0); 
    -- can add memory locations as inputs as well, I'm just not sure how
    wordoutput: out std_logic_vector(31 downto 0); -- this is rd/rt/whereever output goes use with index RS/T/D from ID 
    wordoutputHI: out std_logic_vector(31 downto 0); -- these are linked directly to HI/LO registers
    wordoutputLO: out std_logic_vector(31 downto 0)
  );
end entity;

architecture behavior of ALUmux is 
  -- SIGNALS
  -- will need signals for output/HI/LO
  SIGNAL output1: std_logic_vector(31 downto 0);
  SIGNAL output2: std_logic_vector(31 downto 0);
  SIGNAL output3: std_logic_vector(31 downto 0);
  SIGNAL output4: std_logic_vector(31 downto 0);
  SIGNAL output5: std_logic_vector(31 downto 0);
  SIGNAL output6: std_logic_vector(31 downto 0);
  SIGNAL outputHI1: std_logic_vector(31 downto 0);
  SIGNAL outputHI2: std_logic_vector(31 downto 0);
  SIGNAL outputHI3: std_logic_vector(31 downto 0);
  SIGNAL outputHI4: std_logic_vector(31 downto 0);
  SIGNAL outputHI5: std_logic_vector(31 downto 0);
  SIGNAL outputHI6: std_logic_vector(31 downto 0);
  SIGNAL outputLO1: std_logic_vector(31 downto 0);
  SIGNAL outputLO2: std_logic_vector(31 downto 0);
  SIGNAL outputLO3: std_logic_vector(31 downto 0);
  SIGNAL outputLO4: std_logic_vector(31 downto 0);
  SIGNAL outputLO5: std_logic_vector(31 downto 0);
  SIGNAL outputLO6: std_logic_vector(31 downto 0);
  -- COMPONENTS
  COMPONENT arithClass IS
    port (wordformat: in std_logic_vector(1 downto 0);
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
  END COMPONENT;
  COMPONENT logicClass IS
    port (wordformat: in std_logic_vector(1 downto 0);
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
  END COMPONENT;
  COMPONENT transClass IS
    port (wordformat: in std_logic_vector(1 downto 0);
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
  END COMPONENT;
  COMPONENT shiftClass IS
    port (wordformat: in std_logic_vector(1 downto 0);
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
  END COMPONENT;
  COMPONENT memClass IS
    port (wordformat: in std_logic_vector(1 downto 0);
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
  END COMPONENT;
  COMPONENT contrClass IS
    port (wordformat: in std_logic_vector(1 downto 0);
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
  END COMPONENT;
  
  begin
    -- instantiate all 6 classes
    ARC: arithClass
    PORT MAP (wordformat => wordformat, opcode => opcode, funct => funct,
    regElementRS => regElementRS, regElementRT => regElementRT, regElementRD => regElementRD, 
    shamt => shamt, immediate => immediate,
    wordoutput => output1, wordoutputHI => outputHI1, wordoutputLO => outputLO1);
    LOC: logicClass
    PORT MAP (wordformat => wordformat, opcode => opcode, funct => funct,
    regElementRS => regElementRS, regElementRT => regElementRT, regElementRD => regElementRD, 
    shamt => shamt, immediate => immediate,
    wordoutput => output2, wordoutputHI => outputHI2, wordoutputLO => outputLO2);
    TRC: transClass
    PORT MAP (wordformat => wordformat, opcode => opcode, funct => funct,
    regElementRS => regElementRS, regElementRT => regElementRT, regElementRD => regElementRD, 
    shamt => shamt, immediate => immediate,
    wordoutput => output3, wordoutputHI => outputHI3, wordoutputLO => outputLO3);
    SHC: shiftClass
    PORT MAP (wordformat => wordformat, opcode => opcode, funct => funct,
    regElementRS => regElementRS, regElementRT => regElementRT, regElementRD => regElementRD, 
    shamt => shamt, immediate => immediate,
    wordoutput => output4, wordoutputHI => outputHI4, wordoutputLO => outputLO4);
    MEC: memClass
    PORT MAP (wordformat => wordformat, opcode => opcode, funct => funct,
    regElementRS => regElementRS, regElementRT => regElementRT, regElementRD => regElementRD, 
    shamt => shamt, immediate => immediate, address => address,
    wordoutput => output5, wordoutputHI => outputHI5, wordoutputLO => outputLO5);
    COC: contrClass
    PORT MAP (wordformat => wordformat, opcode => opcode, funct => funct,
    regElementRS => regElementRS, regElementRT => regElementRT, regElementRD => regElementRD, 
    shamt => shamt, immediate => immediate, address => address,
    wordoutput => output6, wordoutputHI => outputHI6, wordoutputLO => outputLO6);
    
    -- the wordclass will be the multiplexer selecting the output from the correct unit
    with wordclass select
      wordoutput <= output1 when "001",
                    output2 when "010",
                    output3 when "011",
                    output4 when "100",
                    output5 when "101",
                    output6 when "110",
                    "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;
                    
    with wordclass select
      wordoutputHI <= outputHI1 when "001",
                    outputHI2 when "010",
                    outputHI3 when "011",
                    outputHI4 when "100",
                    outputHI5 when "101",
                    outputHI6 when "110",
                    "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;
                    
    with wordclass select
      wordoutputLO <= outputLO1 when "001",
                    outputLO2 when "010",
                    outputLO3 when "011",
                    outputLO4 when "100",
                    outputLO5 when "101",
                    outputLO6 when "110",
                    "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;
    
end behavior;
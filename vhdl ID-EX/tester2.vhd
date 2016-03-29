-- Tester for decoderReg
-- If nothing goes in, it's 32U as output
-- WORKS!
-- Authors: Sheng Hao Liu  260585377

Library ieee;
Use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tester2 IS
END tester2;

ARCHITECTURE behaviour OF tester2 IS

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

--The input signals with their initial values
SIGNAL CLK: std_logic := '0';
SIGNAL WR_EN: std_logic := '0';
SIGNAL regIndex: std_logic_vector(4 downto 0) := (others => '0');
SIGNAL regElementIn: std_logic_vector(31 downto 0) := (others => '0');
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

CONSTANT clk_period : time := 1 ns;

BEGIN
  OCM: decoderReg
  PORT MAP(CLK, WR_EN, regIndex, regElementIn, 
  regElement0Out, regElement1Out, regElement2Out, regElement3Out, regElement4Out, regElement5Out, regElement6Out, regElement7Out, regElement8Out, regElement9Out,
  regElement10Out, regElement11Out, regElement12Out, regElement13Out, regElement14Out, regElement15Out, regElement16Out, regElement17Out, regElement18Out, regElement19Out,
  regElement20Out, regElement21Out, regElement22Out, regElement23Out, regElement24Out, regElement25Out, regElement26Out, regElement27Out, regElement28Out, regElement29Out,
  regElement30Out, regElement31Out, regElement32Out
  );

--clock process
clk_process : PROCESS
BEGIN
	CLK <= '0';
	WAIT FOR clk_period/2;
	CLK <= '1';
	WAIT FOR clk_period/2;
END PROCESS;

stim_process: PROCESS

BEGIN  
  REPORT "Starting test: ";
  WR_EN <= '0';
  regIndex <= "00001";
  regElementIn <= "00000000000001111000000000000000";
  WAIT FOR 1 * clk_period;
  
  WR_EN <= '1';
  regIndex <= "00001";
  regElementIn <= "00000000000000000000000000111111";
  WAIT FOR 1 * clk_period;
  
  WR_EN <= '0';
  regIndex <= "00001";
  regElementIn <= "10000000000000000000000000100000";
  WAIT FOR 1 * clk_period;
  
  WR_EN <= '1';
  regIndex <= "00001";
  regElementIn <= "00100000000000000000000000100010";
  WAIT FOR 1 * clk_period;
  
  WR_EN <= '1';
  regIndex <= "00101";
  regElementIn <= "00000000000000000000000000100000";
  WAIT FOR 1 * clk_period;
  
  WR_EN <= '1';
  regIndex <= "00101";
  regElementIn <= "00101000000000000000000000100010";
  WAIT FOR 1 * clk_period;
  
  WR_EN <= '1';
  regIndex <= "10001";
  regElementIn <= "00000000000000000000000000100000";
  WAIT FOR 1 * clk_period;
  
  WAIT;

END PROCESS stim_process;
END;


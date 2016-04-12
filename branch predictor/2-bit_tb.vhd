LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;

ENTITY two_bit_tb IS
END two_bit_tb;

ARCHITECTURE behaviour OF two_bit_tb IS

COMPONENT two_bit IS
PORT (clk : in std_logic;
      reset : in std_logic;
      input : in std_logic_vector(7 downto 0);
	  state	: out std_logic_vector(3 downto 0); -- debug purposes
      output : out std_logic
  );
END COMPONENT;

--The input signals with their initial values
SIGNAL clk, s_reset, s_output: STD_LOGIC := '0';
SIGNAL s_input: std_logic_vector(7 downto 0) := (others => '0');
SIGNAL s_state: std_logic_vector(3 downto 0) := (others => '0'); -- debug purposes

CONSTANT clk_period : time := 1 ns;

BEGIN
dut: two_bit
PORT MAP(clk, s_reset, s_input, s_state, s_output);

 --clock process
clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS;
 
--TODO: Thoroughly test your two_bit
stim_process: PROCESS
BEGIN    
	REPORT "Example case, reading a meaningless character";
	s_input <= "01011000";
	WAIT FOR 1 * clk_period;
	ASSERT (s_output = '0') REPORT "When reading a meaningless character, the output should be '0'" SEVERITY ERROR;
	REPORT "_______________________";
	
	-- A sequence of 
	
	WAIT;
END PROCESS stim_process;
END;

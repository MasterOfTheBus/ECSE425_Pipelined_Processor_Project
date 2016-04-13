LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;

ENTITY two_bit_tb IS
END two_bit_tb;

ARCHITECTURE behaviour OF two_bit_tb IS

COMPONENT two_bit IS
port (clk : in std_logic;
      reset : in std_logic;
      branchLSB : in std_logic_vector(4 downto 0);
	  updateBits : in std_logic_vector(1 downto 0);
	  enable : in std_logic;
	  update : in std_logic;
      output : out std_logic
  );
END COMPONENT;

	-- include the branch history table as a component
	COMPONENT branch_history_table IS
    PORT (
			clk, reset, TableWrite	: IN std_logic;
			ReadAddr1		: IN std_logic_vector(4 DOWNTO 0);
			WriteAddr   	: IN std_logic_vector(4 DOWNTO 0);
			WriteData   	: IN std_logic_vector(1 DOWNTO 0);
			ReadData1		: OUT std_logic_vector(1 DOWNTO 0)
		);
	END COMPONENT;

--The input signals with their initial values
SIGNAL clk, s_reset, s_enable, s_update, s_output: STD_LOGIC := '0';
SIGNAL s_branchLSB: std_logic_vector(4 downto 0) := (others => '0');
SIGNAL s_updateBits: std_logic_vector(1 downto 0) := (others => '0');

CONSTANT clk_period : time := 1 ns;

BEGIN
PORT MAP(clk, s_reset, s_branchLSB, s_updateBits, s_enable, s_update, s_output);
dut: two_bit

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
	
	-- A sequence to test writing and reading from the branch history
	
	REPORT "read";
	s_TableWrite <= '0';
	s_enable <= '1';
	s_branchLSB <= "10010";
	wait for 1 * clk_period;
	assert (s_output = "00") REPORT "Initial is taken when it should be not taken";
	
	REPORT "write";
	s_enable <= '0';
	s_TableWrite <= '1';
	s_writeAddr <= "10110";
	s_WriteData <= "10";
	wait for 1 * clk_period;
	
	REPORT "read";
	s_TableWrite <= '0';
	s_enable <= '1';
	s_branchLSB <= "10110";
	wait for 1 * clk_period;
	assert (s_output = "10") REPORT "Initial is taken when it should be not taken";
	
	
	WAIT;
END PROCESS stim_process;
END;

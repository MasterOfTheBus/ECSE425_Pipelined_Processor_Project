library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

-- Do not modify the port map of this structure
entity two_bit_branch_predictor is
	port (clk : in std_logic; -- used in table
      reset : in std_logic; -- used in table
      branchLSB : in std_logic_vector(4 downto 0); -- read/write address of table
	  updateBits : in std_logic_vector(1 downto 0); -- WriteData in table: updating the branch with new state
	  enable : in std_logic; -- enable read from table
	  update : in std_logic; -- enable write from table
      output : out std_logic -- output logic
	);
end two_bit_branch_predictor;

architecture behavioral of two_bit_branch_predictor is

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
	
	signal writeToTable : std_logic;
	signal predictBits : std_logic_vector(1 downto 0);
	
begin

	hist_table : branch_history_table
		PORT MAP(clk => clk, reset => reset, TableWrite => writeToTable, ReadAddr1 => branchLSB, WriteAddr => branchLSB, WriteData => updateBits, ReadData1 => predictBits);

comb_logic: process(enable, update, branchLSB, predictBits)
begin

	if enable = '1' then
		-- read from the branch history table
		if predictBits = "00" then
			output <= '0';
		elsif predictBits = "01" then
			output <= '0';
		elsif predictBits = "10" then
			output <= '1';
		elsif predictBits = "11" then
			output <= '1';
		-- don't take/take when nothing is initialized, either is fine, we just can't have nothing happening
		-- another way to fix this is to have reset = 1 before anything happens
		else output <= '0';
		end if;
	elsif update = '1' then
		-- update the table
		writeToTable <= '1';
	end if;

end process;

end behavioral;
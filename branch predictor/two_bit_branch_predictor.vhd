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
	-- remember to have all inputs written, outputs dont matter
	COMPONENT two_bit_branch_history IS
    PORT (
			clk, reset, TableWrite	: IN std_logic;
			ReadAddr1		: IN std_logic_vector(4 DOWNTO 0);
			ReadAddr2		: IN std_logic_vector(4 DOWNTO 0); -- this is needed 
			WriteAddr   	: IN std_logic_vector(4 DOWNTO 0);
			WriteData   	: IN std_logic_vector(1 DOWNTO 0);
			ReadData1		: OUT std_logic_vector(1 DOWNTO 0)
		);
	END COMPONENT;
	
	signal writeToTable : std_logic;
	signal predictBits : std_logic_vector(1 downto 0);
	
	-- dummy signals that don't really do anything
	SIGNAL DUMMYRA2 : std_logic_vector(4 DOWNTO 0) := (others => '0');
	
begin

	hist_table : two_bit_branch_history
		PORT MAP(clk => clk, reset => reset, TableWrite => writeToTable, 
		ReadAddr1 => branchLSB, ReadAddr2 => DUMMYRA2, WriteAddr => branchLSB, 
		WriteData => updateBits, ReadData1 => predictBits);

comb_logic_enable: process(enable, branchLSB, predictBits)
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
		end if;
		
		-- When nothing is initialized, output should be UU
		-- Normally, we dont want U as output anywhere so:
		-- if you stop enabling, the output is 0
	elsif enable = '0' then
		output <= '0';	
		
	end if;

end process;

comb_logic_update: process(update, branchLSB, predictBits)
begin
  if update = '1' then
		-- update the table
		writeToTable <= '1';
		
	elsif update = '0' then
	  -- stop updating, remember that signals will keep their last value
	  writeToTable <= '0';
	end if;
end process;

end behavioral;
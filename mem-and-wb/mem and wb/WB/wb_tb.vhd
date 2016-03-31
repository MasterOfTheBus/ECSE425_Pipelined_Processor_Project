library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_tb is
end wb_tb;

architecture behaviour of wb_tb is
	component wb is
	port(
		clk				: in STD_LOGIC;							-- Common clock input
		reset			: in STD_LOGIC;							-- Common reset input
		wb_memtoReg		: in STD_LOGIC;							-- Control value, designates whether alu output or data read from memory is written to registers
		wb_regWrite_in	: in STD_LOGIC;							-- Control value, is passed to decode stage
		wb_wraddr_in	: in STD_LOGIC_VECTOR(31 downto 0);		-- Write address, is passed to decode stage
		wb_rdata		: in STD_LOGIC_VECTOR(31 downto 0);		-- Input containing data read from memory 
		wb_aluResult	: in STD_LOGIC_VECTOR(31 downto 0);		-- Input containing alu output
		
		wb_regWrite_out	: out STD_LOGIC;						-- Control value, is passed to decode stage
		wb_wraddr_out	: out STD_LOGIC_VECTOR(31 downto 0);	-- Control value, is passed to decode stage
		wb_writedata	: out STD_LOGIC_VECTOR(31 downto 0)		-- Output containing data to be written back to registers
	);
	end component;
	
	signal clk			: std_logic := '0';
	signal s_reset		: std_logic := '0';
	signal s_memtoReg	: std_logic := '0';
	signal s_regWrite_in	: std_logic := '0';
	signal s_wraddr_in		: std_logic_vector(31 downto 0) := (others => '0');
	signal s_rdata			: std_logic_vector(31 downto 0) := (others => '0');
	signal s_aluResult		: std_logic_vector(31 downto 0) := (others => '0');
	signal s_regWrite_out		: std_logic := '0';
	signal s_wraddr_out		: std_logic_vector(31 downto 0) := (others => '0');
	signal s_writedata		: std_logic_vector(31 downto 0) := (others => '0');
	
	constant clk_period		: time := 1 ns;
	
begin

	dut : wb
	port map(clk, s_reset, s_memtoReg, s_regWrite_in, s_wraddr_in, s_rdata, s_aluResult, s_regWrite_out, s_wraddr_out, s_writedata);
	
	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	stim_process : process
	begin
		report "Begin Test: Write Back...";
		s_memtoReg <= '0';
		s_regWrite_in <= '1';
		s_wraddr_in <= x"0F0F0F0F";
		s_rdata <= x"FFFFFFFF";
		s_aluResult <= x"0000000F";
		
		wait for 3*clk_period;
		
		if(s_regWrite_out = s_regWrite_in and s_wraddr_out = s_wraddr_in) then
			report "Carry Over: PASS";
		else
			report "Carry Over: FAIL";
		end if;
		
		if(s_writedata = s_aluResult) then
			s_memtoReg <= '1';
			wait for 3*clk_period;
			if(s_writedata = s_rdata) then
				report "Write Data: PASS";
			else
				report "Write Data: FAIL";
			end if;
		else
			report "Write Data: FAIL";
			wait for 3*clk_period;
		end if;
		s_reset <= '1';
		wait for 3*clk_period;
		if(s_regWrite_out = '0' and s_wraddr_out = x"00000000" and s_writedata = x"00000000") then
			report "Reset: PASS";
		else
			report "Reset: FAIL";
		end if;
		s_reset <= '0';
		wait for 3*clk_period;
	end process;
end behaviour;
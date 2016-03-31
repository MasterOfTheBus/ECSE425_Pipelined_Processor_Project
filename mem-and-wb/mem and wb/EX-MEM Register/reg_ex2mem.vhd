-- EX/MEM Register
library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_ex2mem is
port(
	clk				: in STD_LOGIC;							-- Common clock input
	reset			: in STD_LOGIC;							-- Common reset input
	memWrite_in		: in STD_LOGIC;							-- Control value for the memory stage
	memRead_in		: in STD_LOGIC;							-- Control value for the memory stage
	Branch_in		: in STD_LOGIC;							-- Control value for the memory stage
	MemtoReg_in		: in STD_LOGIC;							-- Control value to be passed through to the write back stage
	regWrite_in		: in STD_LOGIC;							-- Control value to be passed through to the write back stage
	alu0_in			: in STD_LOGIC;							-- 0 value from the ALU
	aluOutput		: in STD_LOGIC_VECTOR(31 downto 0);		-- Output of the ALU 
	wrData_in		: in STD_LOGIC_VECTOR(31 downto 0);		-- Data to be written to memory
	writeAddr_in	: in STD_LOGIC_VECTOR(31 downto 0);		-- Address of data to be read from of written to
	
	memWrite_out	: out STD_LOGIC;
	memRead_out		: out STD_LOGIC;
	Branch_out		: out STD_LOGIC;
	MemtoReg_out	: out STD_LOGIC;
	regWrite_out	: out STD_LOGIC;
	alu0_out		: out STD_LOGIC;
	Addr			: out STD_LOGIC_VECTOR(31 downto 0);
	wrData_out		: out STD_LOGIC_VECTOR(31 downto 0);
	writeAddr_out	: out STD_LOGIC_VECTOR(31 downto 0)
);
end reg_ex2mem;

architecture behaviour of reg_ex2mem is
begin
	process(clk, reset)
	begin
		-- If there is a reset, set all the register outputs to 0
		if(reset = '1') then
			memWrite_out <= '0';
			memRead_out <= '0';
			Branch_out <= '0';
			MemtoReg_out <= '0';
			regWrite_out <= '0';
			alu0_out <= '0';
			Addr <= (others => '0');
			wrData_out <= (others => '0');
			writeAddr_out <= (others => '0');
		-- On a rising clock edge pass the values to the next stage
		elsif(rising_edge(clk)) then
			memWrite_out <= memWrite_in;
			memRead_out <= memRead_in;
			Branch_out <= Branch_in;
			MemtoReg_out <= MemtoReg_in;
			regWrite_out <= regWrite_in;
			alu0_out <= alu0_in;
			Addr <= aluOutput;
			wrData_out <= wrData_in;
			writeAddr_out <= writeAddr_in;
		end if;
	end process;
end behaviour;
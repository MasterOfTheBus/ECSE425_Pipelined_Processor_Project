-- MEM/WB Register
library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_mem2wb is
port(
	clk				: in STD_LOGIC;							-- Common clock input
	reset			: in STD_LOGIC;							-- Common reset input
	memtoReg_in		: in STD_LOGIC;							-- Control value for the write back stage
	regWrite_in		: in STD_LOGIC;							-- Control value for the write back stage 
	wraddr_in		: in STD_LOGIC_VECTOR(31 downto 0);		-- Address of register to be written to in the write back stage
	rdata_in		: in STD_LOGIC_VECTOR(31 downto 0);		-- Data to be written to memory
	aluResult_in	: in STD_LOGIC_VECTOR(31 downto 0);		-- Output of the ALU
	
	memtoReg_out	: out STD_LOGIC;
	regWrite_out	: out STD_LOGIC;
	wraddr_out		: out STD_LOGIC_VECTOR(31 downto 0);
	rdata_out		: out STD_LOGIC_VECTOR(31 downto 0);
	aluResult_out	: out STD_LOGIC_VECTOR(31 downto 0)
);
end reg_mem2wb;

architecture behaviour of reg_mem2wb is
begin
	process(clk, reset)
	begin
		-- If there is a reset, set all register outputs to 0
		if(reset = '1') then
			memtoReg_out <= '0';
			regWrite_out <= '0';
			wraddr_out <= (others => '0');
			rdata_out <= (others => '0');
			aluResult_out <= (others => '0');
		-- On rising clock edge pass the values to the next stage
		elsif(rising_edge(clk)) then
			memtoReg_out <= memtoReg_in;
			regWrite_out <= regWrite_in;
			wraddr_out <= wraddr_in;
			rdata_out <= rdata_in;
			aluResult_out <= aluResult_in;
		end if;
	end process;
end behaviour;
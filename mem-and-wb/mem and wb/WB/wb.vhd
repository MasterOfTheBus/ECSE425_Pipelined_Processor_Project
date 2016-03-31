-- Write Back stage for pipelined processor
-- Based off figure 4.51 on page 362 of Computer Organization and Design 
library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb is
port(	clk				: in STD_LOGIC;							-- Common clock input
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
end wb;

architecture behavioural of wb is
begin
	process(clk, reset)
	begin
		if(reset = '1') then
			wb_regWrite_out <= '0';
			wb_wraddr_out <= (others => '0');
			wb_writedata <= (others => '0');
		elsif(rising_edge(clk)) then
			wb_regWrite_out <= wb_regWrite_in;
			wb_wraddr_out <= wb_wraddr_in;
			
			-- When the wb_memtoReg control value is 0, write back the alu result. When it's 1, write back the data read from memory. Otherwise, output high impedance
			case wb_memtoReg is
				when '0' => wb_writedata <= wb_aluResult;
				when '1' => wb_writedata <= wb_rdata;
				when others => wb_writedata <= (others => 'Z');
			end case;
		end if;
	end process;
end behavioural;
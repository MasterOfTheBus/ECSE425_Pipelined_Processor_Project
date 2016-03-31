-- Memory block for pipelined processor
-- Based off figure 4.51 on page 362 of Computer Organization and Design 
library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is
port(	clk				: in STD_LOGIC;							-- Common clock input
		reset 			: in STD_LOGIC;							-- Common reset input
		me_memWrite		: in STD_LOGIC;							-- Control value, designates a write to memory operation
		me_memRead		: in STD_LOGIC;							-- Control value, designates a read from memory operation
		me_Branch		: in STD_LOGIC;							-- Control value, designates a branch
		me_MemtoReg_in 	: in STD_LOGIC;							-- Control value, is passed to write back stage
		me_regWrite_in	: in STD_LOGIC;							-- Control value, is passed to write back stage
		me_alu0			: in STD_LOGIC;							-- 0 value passed from the ALU
		me_Addr			: in STD_LOGIC_VECTOR(31 downto 0);		-- ALU output, either contains address for read/write or calculated value 
		me_wrData		: in STD_LOGIC_VECTOR(31 downto 0);		-- Data to be written to memory
		me_writeAddr_in	: in STD_LOGIC_VECTOR(31 downto 0);		-- Address of register to be written to in write back stage
		
		me_rdData		: out STD_LOGIC_VECTOR(31 downto 0);	-- Data read from memory
		me_ALUout		: out STD_LOGIC_VECTOR(31 downto 0);	-- Output of ALU, passed to write back stage
		me_writeAddr_out: out STD_LOGIC_VECTOR(31 downto 0);	-- Adress of register to be written to in write back stage
		me_MemtoReg_out	: out STD_LOGIC;						-- Control value, passed to write back stage
		me_regWrite_out	: out STD_LOGIC;						-- Control value, passed to write back stage 
		me_PCsrc		: out STD_LOGIC;						-- Program Counter source control
		
		-- Lines used for interfacing with the memory arbiter
		-- The Should be connected to port 1 of the arbiter for higher priority
		mem_busy		: in STD_LOGIC;							-- Indicates whether the memory port is busy
		mem_data		: inout STD_LOGIC_VECTOR(31 downto 0);	-- Data transfer line of arbiter 
		mem_address		: out NATURAL;							-- Register address for memory
		mem_we			: out STD_LOGIC;						-- Write enable line
		mem_re			: out STD_LOGIC							-- Read enable line
		

);
end mem;

architecture behavioural of mem is

	SIGNAL data_rdy		: STD_LOGIC := '0';						-- Indicates when data is ready to be read from memory
	
begin

	process (clk, reset)
	begin
		-- If reset line is enabled, clear all outputs and the data_rdy signal
		if(reset = '1') then
			data_rdy <= '0';
			me_rdData <= (others => '0');
			me_ALUout <= (others => '0');
			me_writeAddr_out <= (others => '0');
			me_MemtoReg_out <= '0';
			me_regWrite_out <= '0';
			me_PCsrc <= '0';
			mem_data <= (others => 'Z');
			mem_address <= 0;
			mem_we <= '0';
			mem_re <= '0';
		else
			-- When the clock goes high assign proper inputs and outputs
			if(rising_edge(clk)) then
				me_MemtoReg_out <= me_MemtoReg_in;
				me_regWrite_out <= me_regWrite_in;
				me_writeAddr_out <= me_writeAddr_in;
				me_PCsrc <= me_Branch or me_alu0;
				me_ALUout <= me_Addr;
				mem_address <= to_integer(unsigned(me_Addr));
				
				-- Only update memory commangs when the port is free
				if(mem_busy = '0') then
					if(me_memWrite = '1') then
						mem_we <= '1';
						mem_re <= '0';
						mem_data <= me_wrData;
					elsif(me_memRead = '1') then
						mem_re <= '1';
						mem_we <= '0';
						-- Only output the data when the read is complete
						if(data_rdy = '1') then
							me_rdData <= mem_data;
							data_rdy <= '0';
						end if;
					else
						mem_we <= '0';
						mem_re <= '0';
						mem_data <= (others => 'Z');
					end if;
				end if;
			end if;
		end if;
	end process;
	
	-- This process detects a falling edge of the memory arbiter's busy signal. During a read, this indicates that the data is ready to be read
	process(mem_busy)
	begin
		if(falling_edge(mem_busy) and me_memRead = '1') then
			data_rdy <= '1';
		end if;
	end process;
end behavioural;	
library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.memory_arbiter_lib.all;

-- Do not modify the port map of this structure
entity memory_arbiter is
port (clk 	: in STD_LOGIC;
      reset : in STD_LOGIC;
      
			--Memory port #1
			addr1	: in NATURAL;
			data1	:	inout STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0);
			re1		: in STD_LOGIC;
			we1		: in STD_LOGIC;
			busy1 : out STD_LOGIC;
			
			--Memory port #2
			addr2	: in NATURAL;
			data2	:	inout STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0);
			re2		: in STD_LOGIC;
			we2		: in STD_LOGIC;
			busy2 : out STD_LOGIC
  );
end memory_arbiter;

architecture behavioral of memory_arbiter is

	--Main memory signals
	--Use these internal signals to interact with the main memory
	SIGNAL mm_address       : NATURAL                                       := 0;
	SIGNAL mm_we            : STD_LOGIC                                     := '0';
	SIGNAL mm_wr_done       : STD_LOGIC                                     := '0';
	SIGNAL mm_re            : STD_LOGIC                                     := '0';
	SIGNAL mm_rd_ready      : STD_LOGIC                                     := '0';
	SIGNAL mm_data          : STD_LOGIC_VECTOR(MEM_DATA_WIDTH-1 downto 0)   := (others => 'Z');
	SIGNAL mm_initialize    : STD_LOGIC                                     := '0';

	SIGNAL r1r2w1w2 	: STD_LOGIC_VECTOR(3 DOWNTO 0);			
	SIGNAL b1, b2		: STD_LOGIC := '0';
	SIGNAL p2active	: STD_LOGIC := '0';
  
begin

	--Instantiation of the main memory component (DO NOT MODIFY)
	main_memory : ENTITY work.Main_Memory
      GENERIC MAP (
				Num_Bytes_in_Word	=> NUM_BYTES_IN_WORD,
				Num_Bits_in_Byte 	=> NUM_BITS_IN_BYTE,
        Read_Delay        => 3, 
        Write_Delay       => 3
      )
      PORT MAP (
        clk					=> clk,
        address     => mm_address,
        Word_Byte   => '1',
        we          => mm_we,
        wr_done     => mm_wr_done,
        re          => mm_re,
        rd_ready    => mm_rd_ready,
        data        => mm_data,
        initialize  => mm_initialize,
        dump        => '0'
      );
	
	busy1 <= b1;
	busy2 <= b2;
	r1r2w1w2 <=  re1 & re2 & we1 & we2;
	
logic: PROCESS (reset, clk)
BEGIN
	
	-- reset high
	if (reset = '1') then
		data1 <= (others => 'Z');
		data2 <= (others => 'Z');
		b1 <= '0';
		b2 <= '0';
	elsif rising_edge(clk) then
		
		-- assume the user will not read and write at the same time
		case r1r2w1w2 is
			-- writing to port 2
			when "0001" =>
				mm_re	<= 	'0';
				mm_we	<= 	'1';
				mm_data	<= 	data2;
				mm_address	<= addr2;
				b1 	<=	b1;
				b2	<=	'1';
				
				p2active <= '1';
				
				if mm_wr_done = '1' then
					p2active <= '0';
					b2 <= '0';
					mm_we <= '0';
				end if;
				
			-- writing to port 1
			when "0010" =>
				mm_re	<= 	'0';
				mm_we	<= 	'1';
				mm_data	<= 	data1;
				mm_address	<= addr1;	
				b1 	<=	'1';
				b2	<=	b2;
				
				if mm_wr_done = '1' then
					b1 <= '0';
					mm_we <= '0';
				end if;
				
			-- writing to port 1 with conclict in port 2
			when "0011" =>			
				if p2active = '0' then 
					mm_re	<= 	'0';
					mm_we	<= 	'1';
					mm_data	<= 	data1;
					mm_address	<= addr1;
					
					b2	<=	'1';
				else
					if mm_wr_done = '1' then
						p2active <= '0';
						b2 <= '0';
						
						mm_re	<= 	'0';
						mm_we	<= 	'1';
						mm_data	<= 	data1;
						mm_address	<= addr1;
					end if;
				end if;
		
				b1 	<=	'1';
		
				if mm_wr_done = '1' then
					b1 <= '0';
					mm_we <= '0';
				end if;
				
			-- reading to port 2 
			when "0100" =>
				mm_re	<= 	'1';
				mm_we	<= 	'0';
				mm_data	<= 	(others => 'Z');
				mm_address	<= addr2;	
				b1 	<=	b1;
				b2	<=	'1';
				
				p2active <= '1';
				
				if mm_rd_ready = '1' then
					p2active <= '0';
					b2 <= '0';
					mm_re <= '0';
				end if;
			
			-- writing to port 1 with conclict in port 2
			when "0110" =>
				if p2active = '0' then
					mm_re	<= 	'0';
					mm_we	<= 	'1';
					mm_data	<= 	data1;
					mm_address	<= addr1;
					
					b2	<=	'1';
				else 
					if mm_rd_ready = '1' then
						p2active <= '0';
						b2 <= '0';
						
						mm_re	<= 	'0';
						mm_we	<= 	'1';
						mm_data	<= 	data1;
						mm_address	<= addr1;
					end if;
				end if;

				b1 	<=	'1';
				
				if mm_wr_done = '1' then
					b1 <= '0';
					mm_we <= '0';
				end if;
				
			-- reading to port 1
			when "1000" =>
				mm_re	<= 	'1';
				mm_we	<= 	'0';
				mm_data	<= 	(others => 'Z');
				mm_address	<= addr1;	
				b1 	<=	'1';
				b2	<=	b2;
				
				if mm_rd_ready = '1' then
					b1 <= '0';
					mm_re <= '0';
				end if;
				
			-- reading to port 1 with conclict in port 2
			when "1001" =>
				if p2active = '0' then 
					mm_re	<= 	'1';
					mm_we	<= 	'0';
					mm_data	<= 	(others => 'Z');
					mm_address	<= addr1;
					
					b2	<=	'1';
				else 
					if mm_wr_done = '1' then
						p2active <= '0';
						b2 <= '0';
						
						mm_re	<= 	'1';
						mm_we	<= 	'0';
						mm_data	<= 	(others => 'Z');
						mm_address	<= addr1;
					end if;
				end if;
				
				b1 	<=	'1';
				
				if mm_rd_ready = '1' then
					b1 <= '0';
					mm_re <= '0';
				end if;
				
			-- reading to port 1 with conclict in port 2
			when "1100" =>
				if p2active = '0' then
					mm_re	<= 	'1';
					mm_we	<= 	'0';
					mm_data	<= 	(others => 'Z');
					mm_address	<= addr1;
					
					b2	<=	'1';
				else
					if mm_rd_ready = '1' then
						p2active <= '0';
						b2 <= '0';
						mm_re	<= 	'1';
						mm_we	<= 	'0';
						mm_data	<= 	(others => 'Z');
						mm_address	<= addr1;
					end if;
				end if;
				
				b1 	<=	'1';
				
				if mm_rd_ready = '1' then
					b1 <= '0';
					mm_re <= '0';
				end if;
			
			-- no pririty or invalid input
			when others =>	
				mm_re	<= 	'0';
				mm_we	<= 	'0';
				mm_data	<= 	(others => 'Z');
				mm_address	<= addr1;	
				b1 	<=	b1;
				b2	<=	b2;

		end case;
	end if;
END PROCESS;	
	
end behavioral;
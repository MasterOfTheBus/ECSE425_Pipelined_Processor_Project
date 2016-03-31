-- This file is a CPU skeleton
--
-- entity name: cpu


LIBRARY ieee;

USE ieee.std_logic_1164.ALL; -- ALLows USE of the std_logic_vector type
USE ieee.numeric_std.ALL; -- ALLows USE of the unsigned type
USE STD.textio.ALL;


--Basic CPU INterface.
--You may add your own signals, but do not remove the ones that are already there.
ENTITY cpu IS
   
   GENERIC (
      File_Address_Read    : STRING    := "Init.dat";
      File_Address_Write   : STRING    := "MemCon.dat";
      Mem_Size_in_Word     : INTEGER   := 256;
      Read_Delay           : INTEGER   := 0; 
      Write_Delay          : INTEGER   := 0
   );
   PORT (
      clk						: IN std_logic;
      reset						: IN std_logic := '0';
      
      --Signals required by the MIKA testing suite
      finished_prog			: OUT std_logic; --Set this to '1' when program execution is over
      assertion				: OUT std_logic; --Set this to '1' when an assertion occurs 
      assertion_pc			: OUT NATURAL;   --Set the assertion's program counter location
      
      mem_dump					: IN std_logic := '0'
   );
   
END cpu;

ARCHITECTURE rtl OF cpu IS
   
   --Main memory signals
   SIGNAL mm_address       : NATURAL								:= 0;
   SIGNAL mm_word_byte     : std_logic								:= '0';
   SIGNAL mm_we            : std_logic								:= '0';
   SIGNAL mm_wr_done       : std_logic								:= '0';
   SIGNAL mm_re            : std_logic								:= '0';
   SIGNAL mm_rd_ready      : std_logic								:= '0';
   SIGNAL mm_data          : std_logic_vector(31 DOWNTO 0)	:= (OTHERS => 'Z');
   SIGNAL mm_initialize    : std_logic								:= '0';
	SIGNAL mm_dump				: std_logic := '0';
	
	SIGNAL addr1	: NATURAL;
	SIGNAL data1	: std_logic_vector(31 DOWNTO 0);
	SIGNAL re1		: std_logic;
	SIGNAL we1		: std_logic;
	SIGNAL busy1 	: std_logic;	
	
	SIGNAL addr2	: NATURAL;
	SIGNAL data2	: std_logic_vector(31 DOWNTO 0);
	SIGNAL re2		: std_logic;
	SIGNAL we2		: std_logic;
	SIGNAL busy2 	: std_logic;
	
	SIGNAL addr1_32, addr2_32 : std_logic_vector(31 DOWNTO 0);
   
	COMPONENT memory_arbiter is
	port (clk 	: in STD_LOGIC;
			reset : in STD_LOGIC;
			
				--Memory port #1
				addr1	: in NATURAL;
				data1	:	inout STD_LOGIC_VECTOR(31 downto 0);
				re1		: in STD_LOGIC;
				we1		: in STD_LOGIC;
				busy1 : out STD_LOGIC;
				
				--Memory port #2
				addr2	: in NATURAL;
				data2	:	inout STD_LOGIC_VECTOR(31 downto 0);
				re2		: in STD_LOGIC;
				we2		: in STD_LOGIC;
				busy2 : out STD_LOGIC
	  );
	end COMPONENT;
	
	COMPONENT Processor IS 
		PORT(
			clk, reset		: IN std_logic;
			Instruction		: IN std_logic_vector(31 DOWNTO 0);
			ReadData			: IN std_logic_vector(31 DOWNTO 0);
			
			PC					: OUT std_logic_vector(31 DOWNTO 0);
			ALUOut			: OUT std_logic_vector(31 DOWNTO 0);
			MemRead			: OUT std_logic;
			MemWrite			: OUT std_logic;
			WriteData		: OUT std_logic_vector(31 DOWNTO 0)		
		);
	END COMPONENT;
	
	
BEGIN
   
   --Instantiation of the main memory component
   main_memory : ENTITY work.Main_Memory
      GENERIC MAP (
         File_Address_Read   => File_Address_Read,
         File_Address_Write  => File_Address_Write,
         Mem_Size_in_Word    => Mem_Size_in_Word,
         Read_Delay          => Read_Delay, 
         Write_Delay         => Write_Delay
      )
      PORT MAP (
         clk         => clk,
         address     => mm_address,
         Word_Byte   => mm_word_byte,
         we          => mm_we,
         wr_done     => mm_wr_done,
         re          => mm_re,
         rd_ready    => mm_rd_ready,
         data        => mm_data,
         initialize  => mm_initialize,
         dump        => mem_dump
      );
	  
	arbiter : memory_arbiter
	PORT MAP (clk, reset, 
		addr1, data1, re1, we1, busy1, 
		addr2, data2, re2, we2, busy2);
	
	addr1_32 <= std_logic_vector(to_unsigned(addr1, 32));
	addr2_32 <= std_logic_vector(to_unsigned(addr2, 32));
	
	-- PORT 1 is Data
	-- PORT 2 is Instruction
	
	we2 <= '0';
	
	pro : processor
	PORT MAP (clk, reset, 
		Instruction		=> data2,
		ReadData			=> data1,
		
		PC					=> addr2_32,
		
		ALUOut			=> addr1_32,
		MemRead			=> re1,
		MemWrite			=> we1,
		WriteData		=> data1
		);
   
END rtl;
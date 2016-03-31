LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Processor IS 
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
END ENTITY;

ARCHITECTURE behavior OF Processor IS

	COMPONENT Controller IS
		PORT (
			Opcode		: IN std_logic_vector(5 DOWNTO 0);
			Funct			: IN std_logic_vector(5 DOWNTO 0);
			
			RegDst		: OUT std_logic;
			ALUSrc		: OUT std_logic;
			Branch		: OUT std_logic;
			MemRead		: OUT std_logic;
			MemWrite		: OUT std_logic;
			RegWrite		: OUT std_logic;
			MemtoReg		: OUT std_logic;
			ALUControl	: OUT std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT Datapath IS
	PORT(
		clk, reset		: IN std_logic;
		Instruction		: IN std_logic_vector(31 DOWNTO 0);		
		ReadData			: IN std_logic_vector(31 DOWNTO 0);
		ALUControl		: IN std_logic_vector(3 DOWNTO 0);
		
		RegDst			: IN std_logic;
		ALUSrc			: IN std_logic;
		Branch			: IN std_logic;
		MemRead			: IN std_logic;
		MemWrite			: IN std_logic;
		RegWrite			: IN std_logic;
		MemtoReg			: IN std_logic;
		
		System_PC		: OUT std_logic_vector(31 DOWNTO 0);
		ALUResult		: OUT std_logic_vector(31 DOWNTO 0);
		WriteData		: OUT std_logic_vector(31 DOWNTO 0);
		mm_MemRead			: OUT std_logic;
		mm_MemWrite			: OUT std_logic
		);
	END COMPONENT;
	
	SIGNAL myRegDst		: std_logic;
	SIGNAL myALUSrc		: std_logic;
	SIGNAL myBranch		: std_logic;
	
	SIGNAL myMemRead		: std_logic;
	SIGNAL myMemWrite		: std_logic;
	SIGNAL myMemRead2		: std_logic;
	SIGNAL myMemWrite2	: std_logic;
	
	SIGNAL myRegWrite		: std_logic;
	SIGNAL myMemtoReg		: std_logic;
	SIGNAL myALUControl	: std_logic_vector(3 DOWNTO 0);
	SIGNAL myPC				: std_logic_vector(31 DOWNTO 0);
	SIGNAL myALUOut		: std_logic_vector(31 DOWNTO 0);
	SIGNAL myWriteData	: std_logic_vector(31 DOWNTO 0);
	
	BEGIN
	
	control : Controller PORT MAP (Instruction(31 DOWNTO 26), Instruction(5 DOWNTO 0), 
		myRegDst, myALUSrc, myBranch, myMemRead, myMemWrite, myRegWrite, myMemtoReg, myALUControl);
		
	path : Datapath PORT MAP(clk, reset, Instruction, ReadData, 
		myALUControl, myRegDst, myALUSrc, myBranch, myMemRead, myMemWrite, myRegWrite, myMemtoReg, myPC, myALUOut, myWriteData, myMemRead2, myMemWrite2);
	
	
	
	PC				<= myPC;			
	ALUOut		<= myALUOut;	
	MemRead		<= myMemRead2;	
	MemWrite		<= myMemWrite2;	
	WriteData	<= myWriteData;
	
	END behavior;


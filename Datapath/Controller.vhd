LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Controller IS
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
END ENTITY;

ARCHITECTURE behavior OF controller IS
	
	COMPONENT InstrController IS
	PORT(	
		opcode		: IN std_logic_vector(5 DOWNTO 0);
		
		-- EX Stage
		RegDst		: OUT std_logic;
		ALUOp			: OUT std_logic_vector(1 DOWNTO 0);
		ALUSrc		: OUT std_logic;
		-- MEM Stage
		Branch		: OUT std_logic;
		MemRead		: OUT std_logic;
		MemWrite		: OUT std_logic;
		-- WB Stage
		RegWrite		: OUT std_logic;
		MemtoReg		: OUT std_logic
	);
	END COMPONENT;

	COMPONENT ALUController IS
	PORT(
		ALUOp			: IN std_logic_vector(1 DOWNTO 0);
		Funct			: IN std_logic_vector(5 DOWNTO 0);
		ALUControl	: OUT std_logic_vector(3 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL myALUOp : std_logic_vector(1 DOWNTO 0);
		
	BEGIN
		instr 	: InstrController 
			PORT MAP (Opcode, RegDst, myALUOp, ALUSrc, Branch, MemRead, MemWrite, RegWrite, MemtoReg);
		alu		: ALUController 
			PORT MAP (myALUOp, Funct, ALUControl);		
	END behavior;
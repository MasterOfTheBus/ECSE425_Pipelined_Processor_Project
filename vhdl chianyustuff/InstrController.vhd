LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALUController
	PORT(	
		opcode		: IN std_logic_vector(5 DOWNTO 0);
		
		-- EX Stage
		RegDst		: IN std_logic;
		ALUOp		: IN std_logic_vector(1 DOWNTO 0);
		ALUSrc		: IN std_logic;
		-- MEM Stage
		Branch		: IN std_logic;
		MemRead		: IN std_logic;
		MemWrite	: IN std_logic;
		-- WB Stage
		RegWrite	: IN std_logic;
		MemtoReg	: IN std_logic;
	);
	END ENTITY;
	
ARCHITECTURE behavior OF ALUController IS
	SIGNAL ctrl_matrix: std_logic_vector(8 downto 0);
BEGIN
	PROCESS(opcode) 
		BEGIN
		CASE opcode IS
			WHEN "000000" => Control_vector <= "100100010"; -- R-type
            WHEN "100011" => Control_vector <= "011110000"; -- lw
            WHEN "101011" => Control_vector <= "010001000"; -- sw
            WHEN "000100" => Control_vector <= "000000101"; -- beq
            
			-- WHEN "001000" => Control_vector <= "011000000"; -- addi
            -- WHEN "000010" => Control_vector <= "000000100"; -- j
            -- WHEN "000011" => Control_vector <= "001000001"; -- jal
            -- WHEN "001001" => Control_vector <= "011000001"; -- subi
            WHEN OTHERS   => Control_vector <= "---------";
		END CASE;
	END PROCESS;
	
	RegDst		<= ctrl_matrix(8);
	ALUSrc		<= ctrl_matrix(7);
	MemtoReg	<= ctrl_matrix(6);
	RegWrite	<= ctrl_matrix(5);
	MemWrite	<= ctrl_matrix(4);
	MemRead		<= ctrl_matrix(3);
	Branch		<= ctrl_matrix(2);
	ALUOp		<= ctrl_matrix(1 DOWNTO 0);
END behavior;
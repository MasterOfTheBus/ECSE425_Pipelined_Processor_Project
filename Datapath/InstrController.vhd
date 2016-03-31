LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY InstrController IS
	PORT(	
		opcode		: IN std_logic_vector(5 DOWNTO 0);
		
		-- EX Stage
		RegDst		: OUT std_logic;
		ALUOp		: OUT std_logic_vector(1 DOWNTO 0);
		ALUSrc		: OUT std_logic;
		-- MEM Stage
		Branch		: OUT std_logic;
		MemRead		: OUT std_logic;
		MemWrite	: OUT std_logic;
		-- WB Stage
		RegWrite	: OUT std_logic;
		MemtoReg	: OUT std_logic
	);
	END ENTITY;
	
ARCHITECTURE behavior OF InstrController IS
	SIGNAL ctrl_matrix: std_logic_vector(8 downto 0);
BEGIN
	PROCESS(opcode, ctrl_matrix) 
		BEGIN
		CASE opcode IS
			-- R TYPE
			WHEN "000000" => ctrl_matrix <= "100100010";
			
			-- I TYPE
			WHEN "001000" => ctrl_matrix <= "010100000"; -- addi
			WHEN "001010" => ctrl_matrix <= "010100000"; -- slti
			WHEN "001100" => ctrl_matrix <= "010100000"; -- andi
			WHEN "001101" => ctrl_matrix <= "010100000"; -- ori
			WHEN "001110" => ctrl_matrix <= "010100000"; -- xori
			WHEN "001111" => ctrl_matrix <= "010100000"; -- lui
		
			-- LW OR LB
			WHEN "100011" => ctrl_matrix <= "011101000"; 
			WHEN "100000" => ctrl_matrix <= "011101000"; 
		
			-- SW OR SB
			WHEN "101011" => ctrl_matrix <= "010010000";
			WHEN "101000" => ctrl_matrix <= "010010000";
		
			-- BEQ OR BN
			WHEN "000100" => ctrl_matrix <= "000000101";
			WHEN "000101" => ctrl_matrix <= "000000101";
		
		
			-- Jumps	
			WHEN "000010" => ctrl_matrix <= "000000100"; -- j 
			WHEN "000011" => ctrl_matrix <= "000100001"; -- jal
			
			WHEN OTHERS   => ctrl_matrix <= "---------";
		END CASE;
		
		RegDst		<= ctrl_matrix(8);
		ALUSrc		<= ctrl_matrix(7);
		MemtoReg		<= ctrl_matrix(6);
		RegWrite		<= ctrl_matrix(5);
		MemWrite		<= ctrl_matrix(4);
		MemRead		<= ctrl_matrix(3);
		Branch		<= ctrl_matrix(2);
		ALUOp			<= ctrl_matrix(1 DOWNTO 0);
	END PROCESS;	
END behavior;
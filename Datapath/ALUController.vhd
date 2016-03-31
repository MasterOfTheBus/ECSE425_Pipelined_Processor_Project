LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALUController IS
	PORT(
		ALUOp	: IN std_logic_vector(1 DOWNTO 0);
		Funct	: IN std_logic_vector(5 DOWNTO 0);
		ALUControl	: OUT std_logic_vector(3 DOWNTO 0)
	);
	END ENTITY;
	
ARCHITECTURE behavior OF ALUController IS
BEGIN
	PROCESS(ALUop, Funct) 
		BEGIN
		CASE ALUOp IS
			WHEN "00" => -- Either LW or SW
				ALUControl <= "0010"; -- add
			WHEN "01" => -- Branch equal
				ALUControl <= "0110"; -- sub
			WHEN "10" => -- R-type
				CASE Funct IS 
				
					WHEN "100000" => ALUControl <= "0010"; -- add
					WHEN "100010" => ALUControl <= "0110"; -- sub
					WHEN "100100" => ALUControl <= "0000"; -- and
					WHEN "100101" => ALUControl <= "0001"; -- or
					WHEN "101010" => ALUControl <= "0111"; -- slt
					WHEN "100110" => ALUControl <= "0100"; -- xor
					WHEN "100111" => ALUControl <= "0101"; -- nor
					WHEN "011000" => ALUControl <= "1000"; -- mult
					WHEN "011010" => ALUControl <= "1001"; -- div
					WHEN "000000" => ALUControl <= "1010"; -- sll
					WHEN "000010" => ALUControl <= "1011"; -- srl
					WHEN "000011" => ALUControl <= "1100"; -- srl
					WHEN "010010" => ALUControl <= "1101"; -- mflo
					
					WHEN OTHERS => ALUControl <= "----";
				END CASE;
			WHEN OTHERS => ALUControl <= "----";
		END CASE;
	END PROCESS;
END behavior;
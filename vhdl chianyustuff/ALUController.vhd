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
	PROCESS(ALUop) 
		BEGIN
		CASE ALUOp IS
			WHEN "00" => -- Either LW or SW
				ALUControl <= "0010";
			WHEN "01" => -- Branch equal
				ALUControl <= "0110";
			WHEN "10" => -- R-type
				CASE Funct IS 
					WHEN "100000" => ALUControl <= "0010";
					WHEN "100010" => ALUControl <= "0110";
					WHEN "100100" => ALUControl <= "0000";
					WHEN "100101" => ALUControl <= "0001";
					WHEN "101010" => ALUControl <= "0111";
					-- WHEN "100110" => ALUControl <= "0100"; -- xor
					-- WHEN "101011" => ALUControl <= "0111"; -- sltu
					-- WHEN "100001" => ALUControl <= "0000"; -- addu
					-- WHEN "100011" => ALUControl <= "0110"; -- subu
					WHEN OTHERS => ALUControl <= "XXXX";
				END CASE;
			WHEN OTHERS => ALUControl <= "XXXX";
		END CASE;
	END PROCESS;
END behavior;
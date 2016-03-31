LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.numeric_std.ALL;
USE ieee.numeric_bit.ALL;

ENTITY ALU IS	
	PORT(	
		A	:	IN std_logic_vector(31 DOWNTO 0);
		B	:	IN std_logic_vector(31 DOWNTO 0);
		Sel	:	IN std_logic_vector(3 DOWNTO 0);
		Res	:	OUT std_logic_vector(31 DOWNTO 0)  
		);
END ENTITY;

ARCHITECTURE behavior OF ALU IS
	signal tempRes : std_logic_vector(63 DOWNTO 0);
	signal zero32 : std_logic_vector(31 DOWNTO 0);
	signal Asign, Bsign : std_logic_vector(31 DOWNTO 0);

	BEGIN					   		
		-- Asign <= to_integer(to_signed(A));
		-- Bsign <= to_integer(to_signed(B));
		
		zero32 <= "00000000000000000000000000000000";
		
		PROCESS(Sel, A, B)
			BEGIN			
			CASE Sel IS
				WHEN "0000" => tempRes <= zero32 & (A AND B);
            WHEN "0001" => tempRes <= zero32 & (A OR B);
            WHEN "0010" => tempRes <= (zero32 & A) + (zero32 & B);
				WHEN "0110" => tempRes <= zero32 & (A - B);
            
				WHEN "0100" => tempRes <= zero32 & (A XOR B);
				WHEN "0101" => tempRes <= zero32 & (A NOR B);
				WHEN "1000" => tempRes <= A*B;
				-- WHEN "1001" => tempRes <= std_logic_vector(to_signed(Asigned/Bsigned));
				-- WHEN "1010" => tempRes <= std_logic_vector(shift_left(to_unsigned(A); 2));
				-- WHEN "1011" => tempRes <= A >> 2;
				-- WHEN "1100" => tempRes <= A >> 2;
				WHEN "1101" => tempRes <= zero32 & B;
								
				WHEN "0111" => 
					IF (A < B) THEN 
						tempRes <= zero32 & "00000000000000000000000000000001"; -- 1
					ELSE 
						tempRes <= zero32 & "00000000000000000000000000000000"; -- 0
					END IF;
				WHEN OTHERS => tempRes <= (OTHERS => 'X');
			END CASE;		
		END PROCESS;		
		
		Res <= tempRes(31 downto 0);
		
	END behavior;

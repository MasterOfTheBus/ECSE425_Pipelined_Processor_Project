LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY ALU IS	
	PORT(	
		A	:	IN std_logic_vector(31 DOWNTO 0);
		B	:	IN std_logic_vector(31 DOWNTO 0);
		Sel	:	IN std_logic_vector(3 DOWNTO 0);
		Res	:	OUT std_logic_vector(31 DOWNTO 0)  
		);
END ENTITY;

ARCHITECTURE behavior OF ALU IS
	signal tempRes : std_logic_vector(32 DOWNTO 0);
	BEGIN					   		
		PROCESS(Sel)
			BEGIN			
			CASE Sel IS
				WHEN "0000" => tempRes <= '0' & (A AND B);
                WHEN "0001" => tempRes <= '0' & (A OR B);
                WHEN "0010" => tempRes <= ('0' & A) + ('0' & B);
				WHEN "0110" => tempRes <= '0' & (A - B);
                -- WHEN "0100" => tempRes <= '0' & (A AND NOT B);
                -- WHEN "0101" => tempRes <= '0' & (A OR NOT B);
				WHEN "0111" => 
                    IF (A < B) THEN 
                        tempRes <= "000000000000000000000000000000001"; -- 1
                    ELSE 
                        tempRes <= "000000000000000000000000000000000"; -- 0
                    END IF;
				WHEN OTHERS => tempRes <= (OTHERS => 'X');
			END CASE;		
		END PROCESS;		
		
		Res <= tempRes(31 downto 0);
		
	END behavior;

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
				WHEN "0000" => tempRes <= '0' & (SrcA AND SrcB);
                WHEN "0001" => tempRes <= '0' & (SrcA OR SrcB);
                WHEN "0010" => tempRes <= ('0' & SrcA) + ('0' & SrcB);
				WHEN "0110" => tempRes <= '0' & (SrcA - SrcB);
                -- WHEN "0100" => tempRes <= '0' & (SrcA AND NOT SrcB);
                -- WHEN "0101" => tempRes <= '0' & (SrcA OR NOT SrcB);
				WHEN "0111" => 
                    IF (SrcA < SrcB) THEN 
                        tempRes <= "000000000000000000000000000000001"; -- 1
                    ELSE 
                        tempRes <= "000000000000000000000000000000000"; -- 0
                    END IF;
			END CASE;		
		END PROCESS;		
		
		Res <= tempRes(31 downto 0);
		
	END behavior;

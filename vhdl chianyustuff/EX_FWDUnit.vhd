LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EX_ForwardUnit IS
	PORT(
		me_RegWrite		: IN std_logic;
		wb_RegWrite		: IN std_logic;
		me_RegisterRd	: IN std_logic_vector(4 DOWNTO 0);
		wb_RegisterRd	: IN std_logic_vector(4 DOWNTO 0);
		
		ex_RegisterRs	: IN std_logic_vector(4 DOWNTO 0);
		ex_RegisterRt	: IN std_logic_vector(4 DOWNTO 0);
		
		ForwardA 		: OUT std_logic_vector(1 DOWNTO 0);
		ForwardB 		: OUT std_logic_vector(1 DOWNTO 0)
		);
END ENTITY;
	
ARCHITECTURE behavior OF EX_ForwardUnit IS
	-- EX: forwards the result from previous instruction to either input of the ALU unit
	-- ME: forwards the result from the previous or second previous instruction to either input of the ALU	
	BEGIN
		PROCESS (me_RegWrite, wb_RegWrite)
			-- EX Forward Unit
			IF(me_RegWrite = '1') THEN
				IF((me_RegisterRd /= "00000") AND (me_RegisterRd = ex_RegisterRs)) THEN
					ForwardA <= "10";
				END IF;				
				IF((me_RegisterRd /= "00000") AND (me_RegisterRd = ex_RegisterRt)) THEN
					ForwardB <= "10";
				END IF;
			END IF;
			
			-- MEM Forward Unit
			IF (wb_RegWrite = '1') THEN
				IF ((wb_RegisterRd /= '0') AND (me_RegisterRd /= ex_RegisterRs) AND (wb_RegisterRd = ex_RegisterRs)) THEN
					ForwardA <= "01";
				END IF;
				IF ((wb_RegisterRd /= '0') AND (me_RegisterRd /= ex_RegisterRt) AND (wb_RegisterRd = ex_RegisterRt)) THEN
					ForwardB <= "01";
				END IF;
			END IF;
			
		END PROCESS;
	END behavior;
	
	
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ID_ForwardUnit IS
	PORT(
		ctrl_Branch		: IN std_logic;
		me_RegisterRd	: IN std_logic_vector(4 DOWNTO 0);
		id_RegisterRs	: IN std_logic_vector(4 DOWNTO 0);
		id_RegisterRt	: IN std_logic_vector(4 DOWNTO 0);
		ForwardC 		: OUT std_logic;
		ForwardD 		: OUT std_logic
		);
END ENTITY;
	
ARCHITECTURE behavior OF ID_ForwardUnit IS
	-- Forwards the result from 2nd previous instruction to either input of the compare
	BEGIN
		PROCESS(ctrl_Branch)
		BEGIN
			IF (ctrl_Branch = '1') THEN
				IF(me_RegisterRd /= "00000" AND me_RegisterRd = id_RegisterRs) THEN
					ForwardC <= '1';
				END IF;
				IF(me_RegisterRd /= "00000" AND me_RegisterRd = id_RegisterRt) THEN
					ForwardD <= '1';
				END IF;
			END IF;
		END PROCESS;
	END behavior;	
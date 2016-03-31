LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ID_HazardUnit IS
	PORT(
		ex_MemRead		: IN std_logic;
		ex_RegisterRt	: IN std_logic_vector(4 DOWNTO 0);
		id_RegisterRs	: IN std_logic_vector(4 DOWNTO 0);	
		id_RegisterRt	: IN std_logic_vector(4 DOWNTO 0);
		
		pc_Write 		: OUT std_logic;
		Flush			: OUT std_logic;
		if2id_Write 	: OUT std_logic;
		nop				: OUT std_logic
		);
END ENTITY;

ARCHITECTURE behavior OF ID_HazardUnit IS
	BEGIN
		PROCESS (ex_MemRead, ex_RegisterRt, id_RegisterRs, id_RegisterRt)
			BEGIN
			
			pc_Write	<= '1';
			Flush		<= '0';
			if2id_Write	<= '1';
			nop 		<= '0';
			
			-- Check if instruction in the EX stage now is a lw
			IF (ex_MemRead = '1') THEN
				-- Check if destination register of lw matches either source registers of the instruction in ID
				IF((ex_RegisterRt = id_RegisterRs) OR  (ex_RegisterRt = id_RegisterRt)) THEN
					-- Stall the pipeline;
					pc_Write	<= '0';
					Flush		<= '1';
					if2id_Write	<= '0';
					nop 		<= '1';
					-- After this one cycle stall, the forwarding logic can handle the remaining data hazards
				END IF;
			END IF;
		END PROCESS;
	END behavior;
		
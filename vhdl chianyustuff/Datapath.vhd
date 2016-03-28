LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY datapath IS
	PORT(
		clk, reset	: IN std_logic
		);
END ENTITY;
	
ARCHITECTURE behavior OF datapath IS
	-- Components
	
	-- Pipeline Registers
	COMPONENT Reg_if2id IS
    PORT (
		clk, reset	: IN std_logic;
		if_pc		: IN std_logic_vector(31 DOWNTO 0);
        if_instr	: IN std_logic_vector(31 DOWNTO 0);        
        id_pc   	: OUT std_logic_vector(31 DOWNTO 0);
		id_instr   	: OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT Reg_id2ex IS
    PORT (
		clk, reset		: IN std_logic;
		id_EX	    	: IN std_logic_vector(3 DOWNTO 0);
		id_ME	    	: IN std_logic_vector(2 DOWNTO 0);
		id_WB	    	: IN std_logic_vector(1 DOWNTO 0);
		id_ReadData1	: IN std_logic_vector(31 DOWNTO 0);	
		id_ReadData2	: IN std_logic_vector(31 DOWNTO 0);	
		id_ext	    	: IN std_logic_vector(31 DOWNTO 0);
		id_rs	    	: IN std_logic_vector(4 DOWNTO 0);
		id_rt	    	: IN std_logic_vector(4 DOWNTO 0);
		id_rd	    	: IN std_logic_vector(4 DOWNTO 0);
			
		ex_EX			: OUT std_logic_vector(3 DOWNTO 0);
		ex_ME			: OUT std_logic_vector(2 DOWNTO 0);
		ex_WB			: OUT std_logic_vector(1 DOWNTO 0);
		ex_ReadData1	: OUT std_logic_vector(31 DOWNTO 0);
		ex_ReadData2	: OUT std_logic_vector(31 DOWNTO 0);
		ex_ext			: OUT std_logic_vector(31 DOWNTO 0);
		ex_rs			: OUT std_logic_vector(4 DOWNTO 0);
		ex_rt			: OUT std_logic_vector(4 DOWNTO 0);
		ex_rd			: OUT std_logic_vector(4 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT Reg_ex2me IS
    PORT (
		clk, reset		: IN std_logic;
		ex_ME			: IN std_logic_vector(2 DOWNTO 0);
		ex_WB           : IN std_logic_vector(1 DOWNTO 0);
		ex_ALUResult    : IN std_logic_vector(31 DOWNTO 0);
		ex_WriteData	: IN std_logic_vector(31 DOWNTO 0);
		ex_WriteReg     : IN std_logic_vector(4 DOWNTO 0);
		
		me_ME			: OUT std_logic_vector(2 DOWNTO 0);
		me_WB			: OUT std_logic_vector(1 DOWNTO 0);
		me_ALUResult	: OUT std_logic_vector(31 DOWNTO 0);
		me_WriteData	: OUT std_logic_vector(31 DOWNTO 0);
		me_WriteReg		: OUT std_logic_vector(4 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT Reg_me2wb IS
    PORT (
		clk, reset		: IN std_logic;
		me_WB			: IN std_logic_vector(1 DOWNTO 0);
		me_ReadData		: IN std_logic_vector(31 DOWNTO 0);
		me_ALUResult	: IN std_logic_vector(31 DOWNTO 0);
		me_WriteReg		: IN std_logic_vector(4 DOWNTO 0);
			
		wb_WB			: OUT std_logic_vector(1 DOWNTO 0);
		wb_ReadData		: OUT std_logic_vector(31 DOWNTO 0);
		wb_ALUResult	: OUT std_logic_vector(31 DOWNTO 0);
		wb_WriteReg		: OUT std_logic_vector(4 DOWNTO 0)
		);
	END COMPONENT;

	-- Hazard Detection Unit
	COMPONENT ID_HazardUnit IS
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
	END COMPONENT;
	
	-- Forwarding Unit
	COMPONENT EX_ForwardUnit IS
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
	END COMPONENT;
	
	COMPONENT ID_ForwardUnit IS
	PORT(
		ctrl_Branch		: IN std_logic;
		me_RegisterRd	: IN std_logic_vector(4 DOWNTO 0);
		id_RegisterRs	: IN std_logic_vector(4 DOWNTO 0);
		id_RegisterRt	: IN std_logic_vector(4 DOWNTO 0);
		ForwardC 		: OUT std_logic;
		ForwardD 		: OUT std_logic
		);
	END COMPONENT;
	
	-- Controllers
	COMPONENT InstrController
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
		MemtoReg	: IN std_logic
	);
	END COMPONENT;
	
	COMPONENT ALUController
	PORT(
		ALUOp	: IN std_logic_vector(1 DOWNTO 0);
		Funct	: IN std_logic_vector(5 DOWNTO 0);
		ALUControl	: OUT std_logic_vector(3 DOWNTO 0)
	);
	END COMPONENT;
	
	-- Typical combinational components
	COMPONENT Mux2 IS
    GENERIC(n : integer);
    PORT (
		input0	: IN std_logic_vector(n-1 DOWNTO 0);
		input1	: IN std_logic_vector(n-1 DOWNTO 0);
        sel   	: IN std_logic;
        output	: OUT std_logic_vector(n-1 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT Mux3 IS
    GENERIC(n : integer);
    PORT (
		input00	: IN std_logic_vector(n-1 DOWNTO 0);
		input01	: IN std_logic_vector(n-1 DOWNTO 0);
		input10	: IN std_logic_vector(n-1 DOWNTO 0);		
        sel   	: IN std_logic_vector(1 DOWNTO 0);
        output	: OUT std_logic_vector(n-1 DOWNTO 0)
		);
	END COMPONENT;

	COMPONENT ShiftL2 IS
	PORT (
		A : IN std_logic_vector(31 DOWNTO 0);
        Y : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT ALU IS	
	PORT(	
		A	:	IN std_logic_vector(31 DOWNTO 0);
		B	:	IN std_logic_vector(31 DOWNTO 0);
		Sel	:	IN std_logic_vector(3 DOWNTO 0);
		Res	:	OUT std_logic_vector(31 DOWNTO 0)  
		);
	END COMPONENT;
	
	COMPONENT Adder IS
    Port (
		input1 	: IN std_logic_vector(31 DOWNTO 0);
		input2 	: IN std_logic_vector(31 DOWNTO 0);
        sum 	: OUT std_logic_vector(31 DOWNTO 0)
		);
	End COMPONENT;
	
	COMPONENT Comparator IS
	PORT(	
		A		: IN std_logic_vector(31 DOWNTO 0);
		B		: IN std_logic_vector(31 DOWNTO 0);
		equal	: OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT Sign_Extension IS
    PORT (
		A : IN std_logic_vector(15 DOWNTO 0);
        Y : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	-- Other components
	COMPONENT reg_file IS 
	PORT (
		clk, reset 	: IN std_logic; 
		RegWrite 	: IN std_logic;	
		
		WriteAddr	: IN std_logic_vector(4 DOWNTO 0);
		ReadAddr1	: IN std_logic_vector(4 DOWNTO 0); 		
		ReadAddr2	: IN std_logic_vector(4 DOWNTO 0); 		
		WriteData	: IN std_logic_vector(31 DOWNTO 0);				
		
		ReadData1	: OUT std_logic_vector(31 DOWNTO 0); 
		ReadData2	: OUT std_logic_vector(31 DOWNTO 0) 
	); 
	END COMPONENT; 
	
	COMPONENT PC IS 
	PORT ( 
		clk 	: IN std_logic; 
		reset 	: IN std_logic;
		pc_in 	: IN std_logic_vector(31 DOWNTO 0); 		
		pc_out 	: OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT Instr_Mem IS 
	PORT ( 
		clk 		: IN std_logic; 
		reset 		: IN std_logic; 
		ReadAddr	: IN std_logic_vector(31 DOWNTO 0); 
		Instr		: OUT std_logic_vector(31 DOWNTO 0); -- whole instruction
		Instr_31_26 : OUT std_logic_vector(5 DOWNTO 0);	-- opcode	
		Instr_25_21 : OUT std_logic_vector(4 DOWNTO 0);	-- rs	
		Instr_20_16 : OUT std_logic_vector(4 DOWNTO 0);	-- rt
		Instr_15_0 	: OUT std_logic_vector(15 DOWNTO 0)	-- immediate
		); 
	END COMPONENT;
	
	COMPONENT Data_Mem IS
	PORT (
		clk, reset	: IN std_logic;
		ALUResult	: IN std_logic_vector(31 DOWNTO 0);
		WriteData	: IN std_logic_vector(31 DOWNTO 0);
		MemRead, MemWrite	: IN std_logic;
		ReadData	: OUT std_logic_vector(31 DOWNTO 0)
	);
	END COMPONENT;
	
	-- Signals
	-- Constants
	SIGNAL four32 : std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000100"; 
	SIGNAL zero32 : std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000000";
	-- PC
	SIGNAL pc_prev, pc_curr, pc_add4, pc_addshft : std_logic_vector(31 DOWNTO 0);
	SIGNAL pc_Write : std_logic;

	-- IF
	SIGNAL if_pc, if_addr, if_instr : std_logic_vector(31 DOWNTO 0);
	SIGNAL instr : std_logic_vector(31 DOWNTO 0);
	SIGNAL if_Flush : std_logic;
	SIGNAL PCSrc : std_logic;
	SIGNAL if2id_Write : std_logic;
	
	-- ID
	SIGNAL id_opcode : std_logic_vector(5 DOWNTO 0);
	SIGNAL id_rs, id_rt, id_rd : std_logic_vector(4 DOWNTO 0);
	SIGNAL id_immediate : std_logic_vector(15 DOWNTO 0);
	
	SIGNAL id_pc, id_ext, id_shft, id_instr : std_logic_vector(31 DOWNTO 0);
	SIGNAL precomp1, precomp2 : std_logic_vector(31 DOWNTO 0);
	SIGNAL id_equal, id_fwd1, id_fwd2, id_nop : std_logic;
	SIGNAL id_ReadData1, id_ReadData2 : std_logic_vector(31 DOWNTO 0);	
	
	SIGNAL id_RegDst, id_ALUSrc, id_Branch, id_MemRead, id_MemWrite, id_RegWrite, id_MemtoReg : std_logic;
	SIGNAL id_ALUOp : std_logic_vector(1 DOWNTO 0);
	SIGNAL id_EXMEWB, ControlLines : std_logic_vector(8 DOWNTO 0);
	SIGNAL id_EX : std_logic_vector(3 DOWNTO 0);
	SIGNAL id_ME : std_logic_vector(2 DOWNTO 0);
	SIGNAL id_WB : std_logic_vector(1 DOWNTO 0);

	-- EX
	SIGNAL ex_EX : std_logic_vector(3 DOWNTO 0);
	SIGNAL ex_ME : std_logic_vector(2 DOWNTO 0);
	SIGNAL ex_WB : std_logic_vector(1 DOWNTO 0);
	SIGNAL ex_ReadData1, ex_ReadData2, ex_WriteData : std_logic_vector(31 DOWNTO 0);
	SIGNAL ex_ext : std_logic_vector(31 DOWNTO 0);
	SIGNAL ex_rs, ex_rt, ex_rd : std_logic_vector(4 DOWNTO 0);
	SIGNAL ex_ALUResult : std_logic_vector(31 DOWNTO 0);
	SIGNAL ex_WriteReg : std_logic_vector(4 DOWNTO 0);
	
	SIGNAL Funct : std_logic_vector(5 DOWNTO 0);
	SIGNAL ALUControl: std_logic_vector(3 DOWNTO 0);
	
	SIGNAL prealu1, prealu2 : std_logic_vector(31 DOWNTO 0);
	SIGNAL ex_fwd1, ex_fwd2 : std_logic_vector(1 DOWNTO 0);
	
	-- MEM
	SIGNAL me_ME : std_logic_vector(2 DOWNTO 0);
	SIGNAL me_WB : std_logic_vector(1 DOWNTO 0);
	SIGNAL me_ReadData, me_WriteData : std_logic_vector(31 DOWNTO 0);
	SIGNAL me_ALUResult : std_logic_vector(31 DOWNTO 0);
	SIGNAL me_WriteReg : std_logic_vector(4 DOWNTO 0);
	
	-- WB
	SIGNAL wb_WB : std_logic_vector(1 DOWNTO 0);
	SIGNAL wb_ALUResult : std_logic_vector(31 DOWNTO 0);
	SIGNAL wb_WriteReg : std_logic_vector(4 DOWNTO 0);
	SIGNAL wb_ReadData, wb_WriteData : std_logic_vector(31 DOWNTO 0);
	
BEGIN
	
	-- IF
	if_pcreg : pc
		PORT MAP(clk, reset, pc_prev, pc_curr);
	if_adder : Adder
		PORT MAP(pc_curr, four32, pc_add4);
	if_pcmux : Mux2
		GENERIC MAP (n => 32)
		PORT MAP(pc_add4, pc_addshft, PCSrc, pc_prev);
	if_instr_mem : Instr_Mem
		PORT MAP(clk, reset, if_addr, instr);
	if_flushmux : Mux2
		GENERIC MAP (n => 32)
		PORT MAP(instr, zero32, if_Flush, if_instr);
	
	pipeline1 : Reg_if2id
		PORT MAP(clk, reset, 
			if_pc, if_instr, 
			id_pc, id_instr);
		
	
	-- ID
	id_opcode		<= id_instr(31 DOWNTO 26);
	id_rs			<= id_instr(25 DOWNTO 21);
	id_rt			<= id_instr(20 DOWNTO 16);
	id_rd			<= id_instr(15 DOWNTO 11);
	id_immediate	<= id_instr(15 DOWNTO 0);
	
	id_adder1 : Adder 
		PORT MAP(id_pc, id_shft, pc_addshft);
	registerFile : Reg_File
		PORT MAP(clk, reset, wb_WB(1), id_rs, id_rt, wb_WriteReg, wb_WriteData, id_ReadData1, id_ReadData2); -- wb_RegWrite
	sign_ext : Sign_Extension
		PORT MAP(id_immediate, id_ext);
	shifting : ShiftL2
		PORT MAP(id_ext, id_shft);
	id_mux1 : Mux2
		GENERIC MAP (n => 32)
		PORT MAP(id_ReadData1, me_ALUResult, id_fwd1, precomp1);
	id_mux2 : Mux2
		GENERIC MAP (n => 32)
		PORT MAP(id_ReadData2, me_ALUResult, id_fwd2, precomp2);
	compare : Comparator
		PORT MAP(precomp1, precomp2, id_equal);
	
	PCSrc <= id_equal AND id_Branch;
	
	control : InstrController
		PORT MAP(id_opcode, id_RegDst, id_ALUOp, id_ALUSrc, id_Branch, id_MemRead, id_MemWrite, id_RegWrite, id_MemtoReg);
	ControlLines <= id_RegDst & id_ALUOp & id_ALUSrc & id_Branch & id_MemRead & id_MemWrite & id_RegWrite & id_MemtoReg;	
	
	id_controlmux : Mux2
		GENERIC MAP (n => 9)
		PORT MAP(ControlLines, "000000000", id_nop, id_EXMEWB);
	
	forward2 : ID_ForwardUnit
		PORT MAP(id_Branch, me_WriteReg, id_rs, id_rt, id_fwd1, id_fwd2);
		
	hazard : ID_HazardUnit
		PORT MAP(ex_ME(1), ex_rt, id_rs, id_rt, pc_Write, if_Flush, if2id_Write, id_nop); -- ex_MemRead
	
	id_EX <= id_EXMEWB(8 DOWNTO 5); -- RegDst[3], ALUOp[2-1], ALUSrc[0]
	id_ME <= id_EXMEWB(4 DOWNTO 2); -- Branch[2], MemRead[1], MemWrite[0]
	id_WB <= id_EXMEWB(1 DOWNTO 0); -- RegWrite[1], MemtoReg[0]
	
	pipeline2 : Reg_id2ex
		PORT MAP(clk, reset, 
			id_EX, id_ME, id_WB, id_ReadData1, id_ReadData2, id_ext, id_rs, id_rt, id_rd, 
			ex_EX, ex_ME, ex_WB, ex_ReadData1, ex_ReadData2, ex_ext, ex_rs, ex_rt, ex_rd);
	
	
	-- EX
	ex_mux1 : Mux3
		GENERIC MAP (n => 32)
		PORT MAP(ex_ReadData1, wb_WriteData, me_ALUResult, ex_fwd1, prealu1);
	ex_mux2 : Mux3
		GENERIC MAP (n => 32)
		PORT MAP(ex_ReadData2, wb_WriteData, me_ALUResult, ex_fwd2, ex_WriteData);
	
	ex_mux3 : Mux2
		GENERIC MAP (n => 32)
		PORT MAP(ex_WriteData, ex_ext, ex_EX(0), prealu2); -- ex_ALUSrc
	ex_mux4 : Mux2 
		GENERIC MAP (n => 5)
		PORT MAP(ex_rt, ex_rd, ex_EX(3), ex_WriteReg); -- ex_RegDst
	
	alu_ctrl : ALUController
		PORT MAP(ex_EX(2 DOWNTO 1), Funct, ALUControl); -- ex_ALUOp
	ex_alu : ALU 
		PORT MAP(prealu1, prealu2, ALUControl, ex_ALUResult);
	
	forward1 : EX_ForwardUnit
		PORT MAP(me_WB(1), wb_WB(1), me_WriteReg, wb_WriteReg, ex_rs, ex_rt, ex_fwd1, ex_fwd2); -- me_RegWrite, wb_RegWrite
	
	pipeline3 : Reg_ex2me
		PORT MAP(clk, reset, 
			ex_ME, ex_WB, ex_ALUResult, ex_WriteData, ex_WriteReg,
			me_ME, me_WB, me_ALUResult, me_WriteData, me_WriteReg);
	
	
	-- MEM
	memory : Data_Mem
		PORT MAP(clk, reset, me_ALUResult, me_WriteData, me_ME(1), me_ME(0), me_ReadData); -- me_MemRead, me_MemWrite
			
	pipeline4 : Reg_me2wb
		PORT MAP(clk, reset, 
			me_WB, me_ReadData, me_ALUResult, me_WriteReg, 
			wb_WB, wb_ReadData, wb_ALUResult, wb_WriteReg);
			
			
	-- WB
	wb_mux1 : Mux2
		GENERIC MAP (n => 32)
		PORT MAP(wb_ALUResult, wb_ReadData, wb_WB(0), wb_WriteData); -- wb_MemtoReg
	
END behavior;
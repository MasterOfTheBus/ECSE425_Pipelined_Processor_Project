LIBRARY ieee;
LIBRARY std;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_1164.all;

ENTITY datapath IS
	PORT ( 
		clk			: IN std_logic;
		reset		: IN std_logic;
        memtoreg   	: IN std_logic;
        pc_sel      : IN std_logic;
        alusrc     	: IN std_logic;
        regdst     	: IN std_logic;
        w_en   		: IN std_logic;
        jump       	: IN std_logic;
        alucontrol 	: IN std_logic_vector(2 downto 0);
        instruction	: IN std_logic_vector(31 downto 0);
        readdata   	: IN std_logic_vector(31 downto 0);
        pc         	: OUT std_logic_vector(31 downto 0);
        aluout     	: OUT std_logic_vector(31 downto 0);
        w_data  	: OUT std_logic_vector(31 downto 0);
        zero       	: OUT std_logic
		);
	END datapath;
	
ARCHITECTURE behavior OF datapath IS
	
	COMPONENT pc 
		PORT ( 
			clk 	: IN std_logic; 
			reset 	: IN std_logic;
			pc_en 	: IN std_logic; 
			pc_in 	: IN std_logic_vector(31 DOWNTO 0); 		
			pc_out 	: OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT adder
		Port (
			input1 : IN std_logic_vector(31 DOWNTO 0);
			input2 : IN std_logic_vector(31 DOWNTO 0);
			output : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT alu
		PORT ( 
			a		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
			b		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
			opcode 	: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
			result 	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0); 
			zero 	: OUT STD_LOGIC
			); 
	END COMPONENT;
	
	COMPONENT sign_extension
		PORT (
			A : IN std_logic_vector(15 DOWNTO 0);
			Y : OUT std_logic_vector(31 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT mux
		PORT (
			input0	: IN std_logic_vector(num_of_bits-1 DOWNTO 0);
			input1	: IN std_logic_vector(num_of_bits-1 DOWNTO 0);
			sel   	: IN std_logic;
			output	: OUT std_logic_vector(num_of_bits-1 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT register_file
		PORT (
			clk 	: IN std_logic;
			reset 	: IN std_logic; 
			w_en 	: IN std_logic; -- write enable		
			
			addr_w0	: IN std_logic_vector(4 DOWNTO 0);-- address write 
			addr_r0	: IN std_logic_vector(4 DOWNTO 0);-- address port 0 		
			addr_r1	: IN std_logic_vector(4 DOWNTO 0);-- address port 1 
			
			port_w0	: IN std_logic_vector(31 DOWNTO 0);				
			port_r0	: OUT std_logic_vector(31 DOWNTO 0); -- output port 0 
			port_r1	: OUT std_logic_vector(31 DOWNTO 0) -- output port 1 
			); 
	END COMPONENT;
	
	COMPONENT reg_if2id
		PORT (
			clk         : IN std_logic;
			reset		: IN std_logic;
			instr_in	: IN std_logic_vector(31 DOWNTO 0);
			pc_in		: IN std_logic_vector(31 DOWNTO 0);        
			instr_out   : OUT std_logic_vector(31 DOWNTO 0);
			pc_out      : OUT std_logic_vector(31 DOWNTO 0)
		);
	END COMPONENT;
	
	SIGNAL four : std_logic_vector(31 DOWNTO 0) := "00000000000000000000000000000100"; -- 4
	
	-- Program pointers
	SIGNAL pc_curr, pc_next, pc_add4 : std_logic_vector(31 DOWNTO 0);
	SIGNAL pc_jump : std_logic_vector(31 DOWNTO 0);
	
	BEGIN
	
	-- Instruction fetch	
	pc_increment : pc
		PORT MAP(clk, reset, '1', pc_next, pc_curr);
	pc_adder1 : adder
		PORT MAP(pc_curr, four, pc_add4);
	pc_mux_branching : mux
		PORT MAP(pc_add4, pc_branch, branch_taken, pc_mux0);
	pc_mux_jump : mux
		PORT MAP(pc_mux0, id_JumpAddr, jump, pc_next);
	
	id_JumpAddr <= pc_add4(31 DOWNTO 28) & instruction(25 DOWNTO 0) & "00"; -- From datasheet
	pc <= pc_curr;
			
	if2id : reg_if2id
		PORT MAP(clk, reset, instruction, pc_add4, id_instr, id_pc);
	
	
	-- Instruction decode
	id_rs <= id_instr(25 DOWNTO 21);
	id_rt <= id_instr(20 DOWNTO 16);
	id_im <= id_instr(15 DOWNTO 0);
	
	reg_file : register_file
		PORT MAP(clk, reset, w_en, addr_w0, id_rs, id_rt, port_w0, id_aluA, id_wdata);
	w_data <= id_wdata;
	sign_extending : sign_extension
		PORT MAP(id_im, id_SignExtImm);
	id_BranchAddr <= id_SignExtImm(29 DOWNTO 0) & "00"; -- From datasheet
	pc_adder2 : adder
		PORT MAP(pc_add4, id_BranchAddr, pc_branch);
	id2ex : reg_id2ex
		PORT MAP(clk, reset, regwrite, memtoreg, id_branch, id_alucontrol, id_alusrc, id_regdst, id_aluA, id_wdata, id_instr(20 DOWNTO 16), id_instr(15 DOWNTO 11), id_SignExtImm, id_pc, 
					   ex_regwrite, ex_memtoreg, ex_branch, ex_alucontrol, ex_alusrc, ex_regdst, ex_aluA, ex_wdata, ex_instr(20 DOWNTO 16), ex_instr(15 DOWNTO 11), ex_SignExtImm, ex_pc
		);
		
		
	-- Execute instruction
	alu0 : alu
	PORT MAP(ex_aluA, ex_aluB, alu_sel, alu_out, zero);
	
	
	
	
	
	END behavior;
	
	
	
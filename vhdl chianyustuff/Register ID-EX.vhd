Entity reg_id2ex is
    PORT (
		clk				: IN std_logic;
		reset			: IN std_logic;		
        RegWrite_in		: IN std_logic;
        MemtoReg_in		: IN std_logic;
        branch_in		: IN std_logic_vector(31 DOWNTO 0);
        alucontrol_in	: IN std_logic_vector(1 DOWNTO 0);
        alu_in			: IN std_logic;
        reg_in			: IN std_logic;		
        read1_in		: IN std_logic_vector(31 DOWNTO 0);
        read2_in		: IN std_logic_vector(31 DOWNTO 0);
        rt_in			: IN std_logic_vector(4 DOWNTO 0);
        rd_in			: IN std_logic_vector(4 DOWNTO 0);		
        SignExt			: IN std_logic_vector(31 DOWNTO 0);
        pc_in			: IN std_logic_vector(31 DOWNTO 0);		
		RegWrite_out	: OUT std_logic;
        MemtoReg_out	: OUT std_logic;
        branch_out		: OUT std_logic_vector(31 DOWNTO 0);
        alucontrol_out	: OUT std_logic_vector(1 DOWNTO 0);
        alu_out			: OUT std_logic;
        reg_out			: OUT std_logic;		
        read1_out		: OUT std_logic_vector(31 DOWNTO 0);
        read2_out		: OUT std_logic_vector(31 DOWNTO 0);
        rt_out			: OUT std_logic_vector(4 DOWNTO 0);
        rd_out			: OUT std_logic_vector(4 DOWNTO 0);		
        SignExt_out		: OUT std_logic_vector(31 DOWNTO 0);
        pc_out			: OUT std_logic_vector(31 DOWNTO 0));
    END;

ARCHITECTUE behavior OF reg_id2ex IS
	BEGIN
		PROCESS(clk, reset)
		BEGIN
			IF reset = '1' THEN
				RegWrite_out <= (OTHERS <= '0');
				MemtoReg_out <= (OTHERS <= '0');
				branch_out <= (OTHERS <= '0');
				alucontrol_out <= (OTHERS <= '0');
				alu_out <= (OTHERS <= '0');
				reg_out <= (OTHERS <= '0');
				read1_out <= (OTHERS <= '0');
				read2_out <= (OTHERS <= '0');
				rt_out <= (OTHERS <= '0');
				rd_out <= (OTHERS <= '0');
				SignExt_out <= (OTHERS <= '0');
				pc_out <= (OTHERS <= '0');
			ELSIF rising_edge(clk) THEN
				RegWrite_out <= RegWrite_in;	
				MemtoReg_out <= MemtoReg_in;	
				branch_out <= branch_in;	
				alucontrol_out <= alucontrol_in;
				alu_out <= alu_in;	
				reg_out <= reg_in;		
				read1_out <= read1_in;	
				read2_out <= read2_in;	
				rt_out <= rt_in;		
				rd_out <= rd_in;		
				SignExt_out <= SignExt_in;		
				pc_out <= pc_in;
			END IF;
		END PROCESS;
	END behavior;
	
	    
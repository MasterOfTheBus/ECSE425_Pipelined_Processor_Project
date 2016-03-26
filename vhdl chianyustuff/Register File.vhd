LIBRARY IEEE; 
USE IEEE.std_logic_1164.ALL; 

ENTITY register_file IS 
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
END register_file; 

ARCHITECTURE behavior OF register_file IS 
	SUBTYPE WordT IS std_logic_vector(31 DOWNTO 0); -- reg word TYPE 
	TYPE StorageT IS ARRAY(0 TO 31) OF WordT; -- reg array TYPE 
	SIGNAL registerfile : StorageT; -- reg file contents 
	
	BEGIN 
	-- Write to register 
	PROCESS(reset, clk) 
		BEGIN 
		-- Reset register file
		IF reset = '1' THEN 
			FOR i IN 0 TO 31 LOOP 
				registerfile(i) <= (OTHERS => '0'); 
			END LOOP;
		ELSIF rising_edge(clk) THEN 
			IF w_en = '1' THEN 
				registerfile(to_integer(unsigned(addr_w0))) <= port_w1; 
			END IF; 
		END IF; 
	END PROCESS; 
	
	-- Read from register
	port_r0 <= registerfile(to_integer(unsigned(addr_r0))); 
	port_r1 <= registerfile(to_integer(unsigned(addr_r1))); 
END behavior;
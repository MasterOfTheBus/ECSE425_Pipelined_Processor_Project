---- 2bit predictor using FSM
-- Authors: Sheng Hao Liu  260585377
--
-- This will do branch prediction with 1 input (T/N)
-- Taken is 1, Not Taken is 0 : as input and output
-- The FSM has 4 states TT/TN/NT/NN > Following L13 - Slide 17 
-- NOTE: They push the new input from the right
-- The output will be T/N accordingly

library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity BP2bit is 
  port (
    clk: in std_logic;
    intaken: in std_logic;
    outstate: out std_logic_vector(1 downto 0); -- sorely for debugging purposes
    outtaken: out std_logic
  );
end entity;

architecture behavior of BP2bit is
  -- SIGNALS
  -- define states
  TYPE State_type IS (TT, TN, NT, NN);
  -- signal that uses different states
  SIGNAL State : State_type; 
  
  begin 
    -- FSM here in process case statement following L13 - Slide 17 
    -- a state will go to another one if input T/N
    
    -- don't forget to put the clk in the process if using clk input
    process (intaken, clk)
      begin     
        -- We can put the reset here if needed
        -- The if clk becomes elsif
        if rising_edge(clk) then
        
        -- CASE FSM
        CASE State IS
          -- STATES ASSIGNMENTS
          -- OUTPUTS INSIDE STATES
          WHEN TT => 
            if (intaken = '1') then
              State <= TT;
            elsif (intaken = '0') then
              State <= TN;
            end if;
            
          WHEN TN => 
            if (intaken = '1') then
              State <= TT;
            elsif (intaken = '0') then
              State <= NN;
            end if;
            
          WHEN NN => 
            if (intaken = '1') then
              State <= NT;
            elsif (intaken = '0') then
              State <= NN;
            end if;
            
          WHEN NT =>
            if (intaken = '1') then
              State <= TT;
            elsif (intaken = '0') then
              State <= NN;
            end if;
            
          -- catch all case to reset to 11 should that ever happen
          WHEN others =>
            State <= TT;
                 
        end CASE;
        
        end if;
      end process;
      
    -- output from states
    process (State)
      begin
      -- same idea as FSM states
      CASE State is
        WHEN TT => 
            outtaken <= '1';
        WHEN TN => 
            outtaken <= '1';
        WHEN NN => 
            outtaken <= '0';
        WHEN NT =>
            outtaken <= '0';
        end CASE;
    end process;  
      
    -- sorely for debugging purposes
    outstate <= "11" when State = TT else
                "01" when State = NT else
                "10" when State = TN else
                "00" when State = NN;
                --"ZZ" when State = others;
  end behavior;

The predictor is in 2 components:
FSM & Branching History
both use a clk cycle to work
dont know if we should pipeline it to 2 clk cycles or do it in parallel

BP2Bit is FSM for the 4 states
two_bit_branch_predictor saves a branch in an array using two_bit_branch_history where it could come back to it later

The FSM needs to be linked: outstate > updateBits
outtaken is the same as output : both use same logic. 
Depends if you want the output from the FSM or the Branching history

NOTE: The FSM does not belong in the predictor since it takes as input either taken or not taken. The predictor needs the updateBits from the FSM or some other source.

Details:

BP2bit tested and working
No global variable, only "local" where it stores it as a state

tester4 tester file for BP2bit

tester5 tester file for branch history 

branch history tested and working
branch history had a small hiccup with declarations which made it output U all the time

two_bit_tb tester file for predictor with history

predictor had a small logic fallacy in update that Ive fixed
predictor will output 0 if enable is 0, we could change it later if needed


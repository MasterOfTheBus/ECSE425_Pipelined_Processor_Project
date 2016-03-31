-- vhd
opCodeManager Works!
arithClass Works!
decoderReg Works!
registryManager - untested but should work
insDec - this is the whole ID of pipeline 
ALUmux - this is the whole EX of pipeline
logicClass - untested
transClass - untested
shiftClass - untested
memClass - NEEDS WORK 
contrClass - untested

-- tests
tester1 - opcodeManager test, 6 cases going through some stuff
tester2 - decoderReg test, outputs are "U" if they are empty
tester3 - arithClass test, outputs are directly given (no clock cycles needed)

-- unused
oneReg 

-- TODO
test remaining stuff
get the memory class to work properly right now it's just adding RS to IMM

-- specifications
oneReg = 1 registry of 16 bit (unused)
decoderReg = 32 registers + 1 of 32 bit: representing signed values, but it can be other stuff
THE REGISTRY IN ID SHOULD NEVER BE ABLE TO ACCESS REG32 - IT'S ACTUALLY IMPOSSIBLE
can only write in one register at a time
can read from all registers at same time

the memory part afterwards needs the index, this index is not found in EX (ALUmux), but in ID (insDec)

Please check memClass and contrClass
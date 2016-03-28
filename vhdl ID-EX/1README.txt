-- vhd
opCodeManager Works!
arithClass - still just a stub
decoderReg Works!
registryManager - untested but should work

-- tests
tester1 - opcodeManager test, 6 cases going through some stuff
tester2 - decoderReg test, outputs are "U" if they are empty

-- unused
oneReg 

-- TODO
test remaining stuff
start some executions

-- specifications
oneReg = 1 registry of 16 bit (unused)
decoderReg = 32 registers + 1 of 32 bit either integer or whatever you want it to be
can only write in one register at a time
can read from all registers at a time

the insDec is the ID part of the pipeline, it should be complete
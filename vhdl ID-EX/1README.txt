-- vhd
opCodeManager Works!
arithClass - still just a stub
decoderReg - untested 

-- tests
tester1 - opcodemanager test, 6 cases going through some stuff

-- unused
oneReg 

-- TODO
I'm going to make a Registry Manager to take care of Rs/RD/RT
I'm going to need to know what shamt is -- used in shifting

-- specifications
oneReg = 1 registry of 16 bit
decoderReg = 32 registers + 1 of 32 bit either integer or whatever you want it to be
can only write in one register at a time
can read from all registers at a time

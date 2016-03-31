Datapath.vhdl lists the stage components each separated by the stage registers.

To run and compile the system:

1.	Compile the assembler using a C++ compiler. Using the provided Makefile should work.
	Just run 'make' in the root directory to create the binary named 'assembler'.
	To execute the assembler run './assembler <assembly file>'

2.	Create new project in Model Sim.
	Add all the vhdl files to the project and compile.
	To test the processor, run the tb_Processor.vhdl file.
	We manually modified the tb_Processor.vhdl file to test instructions.

What we have:
A pipelined processor that can handle R type and branch instructions.
The stages in the vhdl ID-EX haven't been integrated into the datapath,
so we can only execute on a limited number of instructions.

Incomplete / Unintegrated parts:
mult
sll
srl
sra
mflo
mfhi

Main memory not fully integrated.
Complete EX stage not integrated.
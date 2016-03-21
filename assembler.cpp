#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "ctype.h"

#include <map>
#include <string>
#include <iostream>

#define MAX_IN_LINE_LENGTH 150
#define MAX_OUT_LINE_LENGTH 32

using namespace std;

int assemble(char* filename);
int isBlank(char* line);
int comment_start(char* line);
int getLabel(char* line, char* label);
// Instruction_Format getInstrFormat(char* instr);
int getInstruction(int pos, char* line, char* outline);
int constructImmInstr(char* instr, char* line, char* outline);
int getRegisters(int pos, char* line, char* outline);

// enum class Instruction_Format {
// 	R,
// 	I,
// 	J,
// 	Unknown
// };

map<string, string> label_map;

int main(int argc, char* argv[]) {
	
	// Read an input MIPS assembly file
	if (argc != 2) {
		printf("usage: assembler [filename]\n");
		return -1;
	}

	assemble(argv[1]);
	
	return 0;
}

int assemble(char* filename) {
	FILE *infile;
	infile = fopen(filename, "r");
	
	// Parse line by line and write to file
	if (infile != NULL) {
		FILE *outfile;
		outfile = fopen("machine_code.txt", "w");
		
		// first pass for the labels
		char* line = (char*)malloc(MAX_IN_LINE_LENGTH);
		while(fgets(line, MAX_IN_LINE_LENGTH, infile) != NULL) {
			int commentPos = comment_start(line);
			if (isBlank(line) || commentPos == 1) {
				continue;
			}

			// check for label
			char *label;
			int pos = getLabel(line, label);
		}

		rewind(infile);

		// second pass for the instructions
		while (fgets(line, MAX_IN_LINE_LENGTH, infile) != NULL) {
			int commentPos = comment_start(line);
			if (isBlank(line) || commentPos == 1) {
				continue;
			}

			char* outline = (char*)malloc(MAX_OUT_LINE_LENGTH);

			// check for label
			int pos = getLabel(line, NULL);

			// check the instruction type
			pos = getInstruction(pos, line + pos, outline);
			
			// Make sure to output in ASCII
			fprintf(outfile, "%s", line);

			free(outline);
		}
	
		free(line);
		fclose(outfile);
		fclose(infile);
	}
}

int isBlank(char* line) {
	// check where the new line char is
	char *newline;
	newline = strchr(line, '\n');

	char keys[] = "abcdefghijklmnopqrstuvwxyz1234567890~!@#$%^&*()_+`-=[]{};':\",.<>/?\\";
	int i = 0;
	i = strcspn(line, keys);
	return (i == newline - line + 1);
}

int comment_start(char* line) {
	int pos = -1;
	char *comment;
	comment = strchr(line, '#');

	if (comment != NULL) {
		pos = comment - line + 1;
	}

	return pos;
}

// returns the position after the label
// store the label to the label_map if
int getLabel(char* line, char* label) {
	int pos = 0;

	char *colon;
	colon = strchr(line, ':');

	if (colon != NULL) {
		pos = colon - line + 1;
		if (label != NULL) {
			label = strtok(line, " :");
			label_map[label] = "0";
		}
	}

	return pos;
}

// Instruction_Format getInstrFormat(char* instr) {
// 	if (strcmp(instr, "add") || strcmp(instr, "sub") || strcmp(instr, "mult") ||
// 		strcmp(instr, "div") || strcmp(instr, "slt") || strcmp(instr, "and") ||
// 		strcmp(instr, "or") || strcmp(instr, "nor") || strcmp(instr, "xor") ||
// 		strcmp(instr, "mfhi") || strcmp(instr, "mflo") || strcmp(instr, "sll") ||
// 		strcmp(instr, "srl") || strcmp(instr, "sra") || strcmp(instr, "jr")) {
// 		return R;
// 	} else if (strcmp(instr, "addi") || strcmp(instr, "slti") || strcmp(instr, "andi") ||
// 			strcmp(instr, "ori") || strcmp(instr, "xori") || strcmp(instr, "lui") ||
// 			strcmp(instr, "lw") || strcmp(instr, "lb") || strcmp(instr, "sw") ||
// 			strcmp(instr, "sb") || strcmp(instr, "beq") || strcmp(instr, "bne")) {
// 		return I;
// 	} else if (strcmp(instr, "j") || strcmp(instr, "jal")) {
// 		return J;
// 	} else {
// 		return Unknown;
// 	}
// }

int getInstruction(int pos, char* line, char* outline) {
	int ret = 0;

	char orig_line[strlen(line)];
	strcpy(orig_line, line);
	char *instr = strtok(line, " \t");
	int length = strlen(instr);
	ret = pos + length;

	// check instruction format
	// Instruction_Format format = getInstrFormat(instr);

	// printf("%s\n", instr);
	// printf("%s\n", line);

	if (strcmp(instr, "addi") == 0) {
		constructImmInstr(instr, orig_line + length + 1, outline);
	}


	return ret;

}

int constructImmInstr(char* instr, char* line, char* outline) {
	int ret = 0;

	// get registers
	char* registers[2];
	registers[0] = strtok(line, " $,\t");
	registers[1] = strtok(NULL, " $,\t");

	// get immediate field
	char* imm;
	imm = strtok(NULL, " ,\t");

	if (strcmp(instr, "addi")) {
		char opcode[6];
		strcpy(opcode, "001000"); // 8_hex

	}

	return ret;
}

int getRegisters(int pos, char* line, char* outline) {
	int ret = 0;
	// while (!isalpha(line[pos])) {
	// 	pos++;
	// }
	return ret;
}

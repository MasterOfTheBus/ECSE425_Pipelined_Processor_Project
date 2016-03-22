#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "ctype.h"

#include <map>
#include <string>
#include <iostream>
#include <bitset>

#define MAX_IN_LINE_LENGTH 150
#define MAX_OUT_LINE_LENGTH 32

using namespace std;

int assemble(char* filename);
int isBlank(char* line);
int comment_start(char* line);
int getLabel(char* line, char* label, int line_num);
int getInstruction(int pos, char* line, char* outline);
int constructRegInstr(char* instr, char* line, char* outline);
int constructImmInstr(char* instr, char* line, char* outline);
string convertFunct(char* funct);
string convertReg(char* reg);
string convertImm(char* imm);
string convertAddr(char* addr);

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
		int line_num = 0;
		while(fgets(line, MAX_IN_LINE_LENGTH, infile) != NULL) {
			int commentPos = comment_start(line);
			if (isBlank(line) || commentPos == 1) {
				continue;
			}

			// check for label
			char *label;
			int pos = getLabel(line, label, line_num);
			line_num++;
		}

		rewind(infile);

		// second pass for the instructions
		line_num = 0;
		while (fgets(line, MAX_IN_LINE_LENGTH, infile) != NULL) {
			int commentPos = comment_start(line);
			if (isBlank(line) || commentPos == 1) {
				continue;
			}

			char* outline = (char*)malloc(MAX_OUT_LINE_LENGTH);

			// check for label
			int pos = getLabel(line, NULL, line_num);

			// check the instruction type
			pos = getInstruction(pos, line + pos, outline);
			if (pos == -1) {
				printf("ERROR at line %d\n\n", line_num + 1);
			}
			
			// Make sure to output in ASCII
			fprintf(outfile, "%s\n", outline);

			free(outline);
			line_num++;
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
int getLabel(char* line, char* label, int line_num) {
	int pos = 0;

	char *colon;
	colon = strchr(line, ':');

	if (colon != NULL) {
		pos = colon - line + 1;
		if (label != NULL) {
			label = strtok(line, " :");
			char lines[10];
			sprintf(lines, "%d", line_num * 4);
			label_map[label] = lines;
		}
	}

	return pos;
}

int getInstruction(int pos, char* line, char* outline) {
	int ret = 0;

	char orig_line[strlen(line)];
	strcpy(orig_line, line);
	char *instr = strtok(line, " \t");
	int length = strlen(instr);
	ret = pos + length;

	strcpy(outline, "\n");
	char pass[strlen(orig_line + length + 1)];
	strcpy(pass, orig_line + length + 1);
	if (strcmp(instr, "add") == 0 || strcmp(instr, "sub") == 0 || strcmp(instr, "mult") == 0 ||
		strcmp(instr, "div") == 0 || strcmp(instr, "slt") == 0 || strcmp(instr, "and") == 0 ||
		strcmp(instr, "or") == 0 || strcmp(instr, "nor") == 0 || strcmp(instr, "xor") == 0 ||
		strcmp(instr, "mfhi") == 0 || strcmp(instr, "mflo") == 0 || strcmp(instr, "sll") == 0 ||
		strcmp(instr, "srl") == 0 || strcmp(instr, "sra") == 0 || strcmp(instr, "jr") == 0) {

		constructRegInstr(instr, pass, outline);

	} else if (strcmp(instr, "addi") == 0 || strcmp(instr, "slti") == 0 || strcmp(instr, "andi") == 0 ||
			strcmp(instr, "ori") == 0 || strcmp(instr, "xori") == 0 || strcmp(instr, "lui") == 0 ||
			strcmp(instr, "lw") == 0 || strcmp(instr, "lb") == 0 || strcmp(instr, "sw") == 0 ||
			strcmp(instr, "sb") == 0 || strcmp(instr, "beq") == 0 || strcmp(instr, "bne") == 0) {

		constructImmInstr(instr, pass, outline);

	} else if (strcmp(instr, "j") == 0 || strcmp(instr, "jal") == 0) {

	} else {
		printf("Invalid Instruction: %s\n", instr);
		return -1;
	}

	return ret;

}

int constructRegInstr(char* instr, char* line, char* outline) {
	if (instr == NULL || line == NULL) {
		printf("Invalid NULL line\n");
		return -1;
	}

	int ret = 0;

	// get registers
	char* registers[3];
	registers[0] = strtok(line, " $,\t"); // $rd
	registers[1] = strtok(NULL, " $,\t"); // $rs
	registers[2] = strtok(NULL, " $,\t"); // $rt

	// shift amount - only applicable for srl, sra and sll
	char shamt[5];
	strcpy(shamt, "00000");

	// function field
	char funct[6];
	if (strcmp(instr, "add") == 0) {
		strcpy(funct, "100000"); // 20_hex
	} else if (strcmp(instr, "sub") == 0) {
		strcpy(funct, "100010"); // 22_hex
	} else if (strcmp(instr, "mult") == 0) {
		strcpy(funct, "011000"); // 18_hex
	} else if (strcmp(instr, "div") == 0) {
		strcpy(funct, "011010"); // 1a_hex
	} else if (strcmp(instr, "slt") == 0) {
		strcpy(funct, "101010"); // 2a_hex
	} else if (strcmp(instr, "and") == 0) {
		strcpy(funct, "100100"); // 24_hex
	} else if (strcmp(instr, "or") == 0) {
		strcpy(funct, "100101"); // 25_hex
	} else if (strcmp(instr, "nor") == 0) {
		strcpy(funct, "100111"); // 27_hex
	} else if (strcmp(instr, "xor") == 0) {
		strcpy(funct, "100110"); // 26_hex
	} else if (strcmp(instr, "mfhi") == 0) {
		strcpy(funct, "010000"); // 10_hex
	} else if (strcmp(instr, "mflo") == 0) {
		strcpy(funct, "010010"); // 12_hex
	} else if (strcmp(instr, "sll") == 0) {
		strcpy(funct, "000000"); // 00_hex
		// shamt is the 3rd operand: overwrite the register value
		strcpy(shamt, registers[2]);
		strcpy(registers[2], "00000");
	} else if (strcmp(instr, "srl") == 0) {
		strcpy(funct, "000010"); // 02_hex
		// shamt is the 3rd operand: overwrite the register value
		strcpy(shamt, registers[2]);
		strcpy(registers[2], "00000");
	} else if (strcmp(instr, "sra") == 0) {
		strcpy(funct, "000011"); // 03_hex
		// shamt is the 3rd operand: overwrite the register value
		strcpy(shamt, registers[2]);
		strcpy(registers[2], "00000");
	} else if (strcmp(instr, "jr") == 0) {
		strcpy(funct, "001000"); // 08_hex
	} else {
		printf("Invalid instruction: %s\n", instr);
		return -1;
	}

	// copy info into the line
	char opcode[6];
	strcpy(opcode, "000000");
	strcpy(outline, opcode);
	strcat(outline, convertReg(registers[1]).c_str()); // rs
	strcat(outline, convertReg(registers[2]).c_str()); // rt
	strcat(outline, convertReg(registers[0]).c_str()); // rd
	strcat(outline, convertReg(shamt).c_str()); // shamt
	strcat(outline, convertFunct(funct).c_str()); // funct

	return ret;
}

int constructImmInstr(char* instr, char* line, char* outline) {
	if (instr == NULL || line == NULL || outline == NULL) {
		printf("Inavlid NULL line\n");
		return -1;
	}

	int ret = 0;

	// get registers
	char* registers[2];
	registers[0] = strtok(line, " $,\t"); // $rt
	registers[1] = strtok(NULL, " $,\t"); // $rs

	// get immediate field
	char* imm;
	imm = strtok(NULL, " ,\t");

	char opcode[6];
	if (strcmp(instr, "addi") == 0) {
		strcpy(opcode, "001000"); // 8_hex
	} else if (strcmp(instr, "slti") == 0) {
		strcpy(opcode, "001010"); // a_hex
	} else if (strcmp(instr, "andi") == 0) {
		strcpy(opcode, "001100"); // c_hex
	} else if (strcmp(instr, "ori") == 0) {
		strcpy(opcode, "001101"); // d_hex
	} else if (strcmp(instr, "xori") == 0) {
		strcpy(opcode, "001110"); // e_hex
	} else if (strcmp(instr, "lui") == 0) {
		strcpy(opcode, "001111"); // f_hex
	} else if (strcmp(instr, "lw") == 0) {
		strcpy(opcode, "100011"); // 23_hex
	} else if (strcmp(instr, "lb") == 0) {
		strcpy(opcode, "100000"); // 20_hex
	} else if (strcmp(instr, "sw") == 0) {
		strcpy(opcode, "101011"); // 2b_hex
	} else if (strcmp(instr, "sb") == 0) {
		strcpy(opcode, "101000"); // 28_hex
	} else if (strcmp(instr, "beq") == 0) {
		strcpy(opcode, "000100"); // 4_hex
		// the immediate value needs to be converted from a label name
		strcpy(imm, label_map[imm].c_str());
	} else if (strcmp(instr, "bne") == 0) {
		strcpy(opcode, "000101"); // 5_hex
		// the immediate value needs to be converted from a label name
		strcpy(imm, label_map[imm].c_str());
	} else {
		printf("Invalid instruction: %s\n", instr);
		return -1;
	}

	// Copy the info into the line that will get written
	strcpy(outline, opcode);
	strcat(outline, convertReg(registers[1]).c_str()); // rs
	strcat(outline, convertReg(registers[0]).c_str()); // rt
	strcat(outline, convertImm(imm).c_str());

	// printf("%s\n", outline);

	return ret;
}

string convertFunct(char* funct) {
	int num = atoi(funct);
	string binary = bitset<6>(num).to_string();
	return binary;
}

string convertReg(char* reg) {
	int num = atoi(reg);
	string binary = bitset<5>(num).to_string();
	return binary;
}

string convertImm(char* imm) {
	int num = atoi(imm);
	string binary = bitset<16>(num).to_string();
	return binary;
}

string convertAddr(char* addr) {
	int num = atoi(addr);
	string binary = bitset<26>(num).to_string();
	return binary;
}

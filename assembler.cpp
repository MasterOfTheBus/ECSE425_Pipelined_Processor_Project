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
int getLabel(char* line, char* label);
int getInstruction(int pos, char* line, char* outline);
int constructImmInstr(char* instr, char* line, char* outline);
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
			fprintf(outfile, "%s\n", outline);

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

int getInstruction(int pos, char* line, char* outline) {
	int ret = 0;

	char orig_line[strlen(line)];
	strcpy(orig_line, line);
	char *instr = strtok(line, " \t");
	int length = strlen(instr);
	ret = pos + length;

	// printf("%s\n", instr);
	// printf("%s\n", line);
	strcpy(outline, "\n");

	if (strcmp(instr, "addi") == 0) {
		constructImmInstr(instr, orig_line + length + 1, outline);
	}


	return ret;

}

int constructRegInstr(char* instr, char* line, char* outline) {
	int ret = 0;

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

	char opcode[6];
	if (strcmp(instr, "addi") == 0) {
		strcpy(opcode, "001000"); // 8_hex
	}

	// Copy the info into the line that will get written
	strcpy(outline, opcode);
	strcat(outline, convertReg(registers[1]).c_str());
	strcat(outline, convertReg(registers[0]).c_str());
	strcat(outline, convertImm(imm).c_str());

	// printf("%s\n", outline);

	return ret;
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

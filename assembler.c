#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#define MAX_IN_LINE_LENGTH 150
#define MAX_OUT_LINE_LENGTH 32

int main(int argc, char* argv[]) {
	
	// Read an input MIPS assembly file
	if (argc != 2) {
		printf("assembler [filename]");
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
		
		char* line = malloc(MAX_IN_LINE_LENGTH);
		while(fgets(line, MAX_IN_LINE_LENGTH, infile) != NULL) {
			int commentPos = commentStart(line);
			if (isBlank(line) || commentPos == 1) {
				continue;
			}

			char* outline = malloc(MAX_OUT_LINE_LENGTH);

			// check for label
			int pos = getLabel(line);

			// check the instruction type
			pos = getInstruction(line, outline);

			// check the registers
			getRegisters(line, outline);
			
			// Make sure to output in ASCII
			fprintf(outfile, line);

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

int commentStart(char* line) {
	int pos = -1;
	char *comment;
	comment = strchr(line, '#');

	if (comment != NULL) {
		pos = comment - line + 1;
	}

	return pos;
}

// returns the position after the label
int getLabel(char* line) {
	int pos = 0;

	char *colon;
	colon = strchr(line, ':');

	if (colon != NULL) {
		pos = colon - line + 1;

		// TODO: save the label address
	}

	return pos;
}

int getInstruction(char* line, char* outline) {
	int pos = 0;

	return pos;

}

int getRegisters(char* line, char* outline) {

}

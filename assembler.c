#include "stdlib.h"
#include "stdio.h"
#include "string.h"

int main(int argc, char* argv[]) {
	
	// Read an input MIPS assembly file
	if (argc != 2) {
		printf("assembler [filename]");
		return -1;
	}
	
	FILE *infile;
	infile = fopen(argv[1], "r");
	
	// Parse line by line and write to file
	if (infile != NULL) {
		FILE *outfile;
		outfile = fopen("machine_code.txt", "w");
		
		char* line = malloc(100);
		while(fgets(line, 100, infile) != NULL) {
			if (isBlank(line)) {
				continue;
			}
			
			
			// Make sure to output in ASCII
			fprintf(outfile, line);
		}
	
		free(line);
		fclose(outfile);
		fclose(infile);
	}
	
	return 0;
}

int isBlank(char* line) {
	char keys[] = "abcdefghijklmnopqrstuvwxyz1234567890~!@#$%^&*()_+`-=[]{};':\",.<>/?\\";
	int i = 0;
	i = strcspn(line, keys);
	return (i != 0);
}

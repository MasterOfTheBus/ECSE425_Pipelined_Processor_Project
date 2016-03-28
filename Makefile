all: assembler

assembler: assembler.cpp
		g++ -g assembler.cpp -o assembler

clean:
		rm assembler

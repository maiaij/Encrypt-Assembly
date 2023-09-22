all: encrypt.asm
	yasm -a x86 -m amd64 -g dwarf2 -f elf64 -o encrypt.o encrypt.asm 
	gcc -m64 -no-pie -o encrypt.out encrypt.o

clean:
	rm *.out
	rm *.o
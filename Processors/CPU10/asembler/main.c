#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "asembler.h"


FILE *fileIn, *fileOut;
int prog_length;
unsigned char program[MEMORY_SIZE];



int main(int argc, char **argv){
	if(argc!=2){
		printf("Usage: asm10 input_file\n");
		exit(1);
	}
	
	fileIn=fopen(argv[1], "r");
	if(fileIn==NULL){
		printf("ERROR: fopen: Open input file error.\n");
		exit(2);
	}
	fileOut=fopen("prog.txt", "w");
	if(fileOut==NULL){
		printf("ERROR: fopen: Create output file error.\n");
		exit(3);
	}
	memset(program, 0, MEMORY_SIZE);

	asembler(fileIn, &prog_length, program);

	int i, j;
	char byte[9];
	for(i=0;i<prog_length;++i){
		for(j=7;j>=0;--j){
			if(program[i]&(1<<j)) byte[7-j]='1';
			else			byte[7-j]='0';
		}
		byte[8]='\n';
		fwrite(byte, 9, 1, fileOut);
	}
	printf("File write ok\n");

	printf("Program size: %d B\n", prog_length);
	if(prog_length>MEMORY_SIZE){
		printf("Warning: Program size to big.\n");
	}else{
		printf("Compile finish.\n");
	}

	fclose(fileIn);
	fclose(fileOut);
	return 0;
}


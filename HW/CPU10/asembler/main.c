#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "mlib.h"
#include "table.h"
#include "asembler.h"


int textOut=0;
char *inputFileName=NULL;
char *outputFileName=NULL;
unsigned char *program;
int prog_length;
FILE *fout;


void getArguments(int argc, char **argv);



int main(int argc, char **argv){
	getArguments(argc, argv);
	program=asembler(inputFileName, &prog_length);

	if(textOut){
		fout=fopen(outputFileName, "w");
		if(fout==NULL){
			printf("ERROR: fopen: Create output file fail.\n");
			exit(2);
		}
		int i, j;
		char byte[9];
		for(i=0;i<prog_length;++i){
			for(j=7;j>=0;--j){
				if(program[i]&(1<<j))	byte[7-j]='1';
				else			byte[7-j]='0';
			}
			byte[8]='\n';
			fwrite(byte, 9, 1, fout);
		}
	}else{
		fout=fopen(outputFileName, "wb");
		if(fout==NULL){
			printf("ERROR: fopen: Create output file fail.\n");
			exit(2);
		}
		fwrite(program, 1, prog_length, fout);
	}

	printf("Compile finish.\n");
	printf("Program size: %d B\n", prog_length);

	fclose(fout);
	return 0;
}

void getArguments(int argc, char **argv){
	int option;
	while((option=getopt(argc, argv, "ti:o:"))!=-1){
		switch(option){
			case 't':
				textOut=1;
				break;
			case 'i':
				inputFileName=optarg;
				break;
			case 'o': 
				outputFileName=optarg;
				break;
             default:
				printf("Usage: asm [-t] -i input_file [-o out_file]\n");
				printf("t: text output\n");
				exit(1);
        }
    }
	if(inputFileName==NULL){
		printf("Usage: asm [-t] -i input_file [-o out_file]\n");
		printf("t: text output\n");
		exit(1);
	}
	if(outputFileName==NULL){
		outputFileName=(char*)malloc(sizeof(char)*10);
		strcpy(outputFileName, "prog.out");
	}
}


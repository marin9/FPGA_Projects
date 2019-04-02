#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main(int argc, char **argv){
	FILE *fi, *fo;
	char instr[16];
	char cons[16];

	if(argc!=3){
		printf("Usage: asm [input] [output]\n");
		return 1;
	}

	fi=fopen(argv[1], "rb");
	if(!fi){
		printf("ERROR: fopen.\n");
		return 3;
	}

	fo=fopen(argv[2], "w");
	if(!fo){
		printf("ERROR: fopen.\n");
		return 4;
	}

	while(1){
		int word=0;
		char w[8];
		fscanf(fi, "%s", instr);
		fscanf(fi, "%s", cons);

		if(strcmp(instr, "lda")==0) word|=0x00;
		else if(strcmp(instr, "sta")==0) word|=0x1000;
		else if(strcmp(instr, "jeq")==0) word|=0x2000;
		else if(strcmp(instr, "jsr")==0) word|=0x3000;
		else if(strcmp(instr, "ret")==0) word|=0x4000;
		else if(strcmp(instr, "ldi")==0) word|=0x5000;
		else if(strcmp(instr, "sti")==0) word|=0x6000;
		else if(strcmp(instr, "add")==0) word|=0x7000;
		else if(strcmp(instr, "nor")==0) word|=0x8000;
		else if(strcmp(instr, "set")==0) word|=0x0000;
		else if(strcmp(instr, "end")==0) break;
		else printf("ERROR: Syntax error.\n");

		word=word|atoi(cons);
		*((int*)w)=word;
		fwrite(w+1, 1, 1, fo);
		fwrite(w+0, 1, 1, fo);
	}

	fclose(fi);
	fclose(fo);
	return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LEN 64
#define WORD_LEN	 16
#define FILENAME_LEN 64

/*
INSTRUCTIONS

jmp {number 0-4095}
tst {z, nz, c, nc}
sta {number 0-255}

lda {number 0-255}
lda #{number 0-255}
add {number 0-255}
add #{number 0-255}
sub {number 0-255}
sub #{number 0-255}
and {number 0-255}
and #{number 0-255}
orr {number 0-255}
orr #{number 0-255}
xor {number 0-255}
xor #{number 0-255}

/comment


EXAMPLE:

lda #5
sta 0
lda #7
sta 1

lda 0
add 1
sta 2

/MEM[0]=5
/MEM[1]=7
/MEM[2]=12


*/

void GetParams(int argc, char **argv, char *inputFile, char *outputFile);
FILE* OpenFileRead(char *inputFile);
FILE* OpenFileWrite(char *outputFile);
int ReadLine(FILE *f, char *line);
void writeCode(FILE *f, int code);



int main(int argc, char **argv){
    FILE *fin, *fout;
	char inputFile[FILENAME_LEN];
	char outputFile[FILENAME_LEN];

	GetParams(argc, argv, inputFile, outputFile);
	fin=OpenFileRead(inputFile);
	fout=OpenFileWrite(outputFile);

	int line=0;
	char buff[MAX_LINE_LEN];

	while(ReadLine(fin, buff)){
        char word1[WORD_LEN]={0};
        char word2[WORD_LEN]={0};

        int s=sscanf(buff, "%s %s", word1, word2);

        if(s!=-1) ++line;

        if(strlen(word1)==0){
			continue;

        }else if(word1[0]=='/'){
            continue;

        }else if(strcmp(word1, "tst")==0){
			if(strcmp(word2, "nz")==0) 		writeCode(fout, 0x2000);
			else if(strcmp(word2, "z")==0) 	writeCode(fout, 0x2400);
			else if(strcmp(word2, "nc")==0) writeCode(fout, 0x2800);
			else if(strcmp(word2, "c")==0) 	writeCode(fout, 0x2C00);
			else printf("ERROR: Line %d\n", line);

        }else if(word2[0]=='#'){
			short num=atoi(word2+1);

			if(strcmp(word1, "lda")==0) 	 writeCode(fout, 0x4000|num);
			else if(strcmp(word1, "add")==0) writeCode(fout, 0x5000|num);
			else if(strcmp(word1, "sub")==0) writeCode(fout, 0x6000|num);
			else if(strcmp(word1, "and")==0) writeCode(fout, 0x7000|num);
			else if(strcmp(word1, "orr")==0) writeCode(fout, 0x8000|num);
			else if(strcmp(word1, "xor")==0) writeCode(fout, 0x9000|num);
			else printf("ERROR: Line %d\n", line);

		}else{
			short num=atoi(word2);

			if(strcmp(word1, "lda")==0) 	 writeCode(fout, 0xA000|num);
			else if(strcmp(word1, "jmp")==0) writeCode(fout, 0x1000|num);
			else if(strcmp(word1, "sta")==0) writeCode(fout, 0x3000|num);

			else if(strcmp(word1, "add")==0) writeCode(fout, 0xB000|num);
			else if(strcmp(word1, "sub")==0) writeCode(fout, 0xC000|num);
			else if(strcmp(word1, "and")==0) writeCode(fout, 0xD000|num);
			else if(strcmp(word1, "orr")==0) writeCode(fout, 0xE000|num);
			else if(strcmp(word1, "xor")==0) writeCode(fout, 0xF000|num);
			else printf("ERROR: Line %d\n", line);
		}
	}

	fclose(fin);
	fclose(fout);
	return 0;
}


void GetParams(int argc, char **argv, char *inputFile, char *outputFile){
	if(argc==2){
		strcpy(inputFile, argv[1]);
		strcpy(outputFile, "out.bin");
	}else if(argc==3){
		strcpy(inputFile, argv[1]);
		strcpy(outputFile, argv[2]);
	}else{
		printf("ERROR: Ilegal arguments.\n");
		printf("Usage: cx8 input_file.asm output_file.bin\n");
		exit(1);
	}
}

FILE* OpenFileRead(char *inputFile){
	FILE *f=fopen(inputFile, "r");
	if(f==NULL){
		printf("ERROR: File '%s' not exist.\n", inputFile);
		exit(2);
	}
	return f;
}

FILE* OpenFileWrite(char *outputFile){
	FILE *f=fopen(outputFile, "wb");
	if(f==NULL){
		printf("ERROR: Can't create file '%s'.\n", outputFile);
		exit(3);
	}
	return f;
}

int ReadLine(FILE *f, char *line){
	int i, n, nl, len;
	char buff[MAX_LINE_LEN]={0};
	long start=ftell(f);

	if((n=fread(buff, 1, MAX_LINE_LEN, f))<1) return 0;

	for(i=0;i<n;++i){
		if(buff[i]=='\n'){
			nl=1;
			break;
		}
	}

	len=i;

	if(line!=NULL){
		memset(line, 0, MAX_LINE_LEN);
		memcpy(line, buff, len);
	}else{
		return 0;
	}

	fseek(f, start+len+nl, SEEK_SET);
	return 1;
}

void writeCode(FILE *f, int code){
	unsigned char c[2];

	c[1]=code&0xff;
	c[0]=(code&0xff00)>>8;

	fwrite(c, 2, 1, f);
}


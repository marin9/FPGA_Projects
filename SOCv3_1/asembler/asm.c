#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LINE_LEN	64
#define WORD_LEN	16


FILE* openFile(char *filename, char *mode);
int ReadLine(FILE *f, char *line);
void writeCode(FILE *f, unsigned short code);
void writeByte(FILE *f, unsigned char code);


int main(int argc, char **argv){
	if(argc!=2){
		printf("ERROR: Ilegal arguments.\n");
		printf("Usage: asm [input_file]\n");
		return 1;
	}

	FILE *fileIn=openFile(argv[1], "r");
	FILE *fileOut=openFile("prog.txt", "w");
	int line=0;
	char buff[LINE_LEN];

	while(ReadLine(fileIn, buff)){
        char word1[WORD_LEN]={0};
        char word2[WORD_LEN]={0};
        int s=sscanf(buff, "%s %s", word1, word2);
        if(s!=-1) ++line;

        if(strlen(word1)==0) continue;
        else if(word1[0]=='/') continue;
		else if(strcmp(word1, ".byte")==0){
			int num=atoi(word2);
			if(num>255) printf("ERROR: Line %d\n", line);
			writeByte(fileOut, num);

        }else if(word2[0]=='#'){
			int num=atoi(word2+1);
			if(num>255) printf("ERROR: Line %d\n", line);

			if(strcmp(word1, "add")==0) 	 writeCode(fileOut, 0x0000|num);
			else if(strcmp(word1, "nor")==0) writeCode(fileOut, 0x1000|num);
			else if(strcmp(word1, "xor")==0) writeCode(fileOut, 0x2000|num);
			else if(strcmp(word1, "lda")==0) writeCode(fileOut, 0x3000|num);
			else printf("ERROR: Line %d\n", line);
		}else{
			int num=atoi(word2);
			if(num>4095) printf("ERROR: Line %d\n", line);

			if(strcmp(word1, "add")==0) 	 writeCode(fileOut, 0x4000|num);
			else if(strcmp(word1, "nor")==0) writeCode(fileOut, 0x5000|num);
			else if(strcmp(word1, "xor")==0) writeCode(fileOut, 0x6000|num);
			else if(strcmp(word1, "lda")==0) writeCode(fileOut, 0x7000|num);
			else if(strcmp(word1, "sta")==0) writeCode(fileOut, 0x8000|num);
			else if(strcmp(word1, "jmp")==0) writeCode(fileOut, 0x9000|num);
			else if(strcmp(word1, "jeq")==0) writeCode(fileOut, 0xA000|num);
			else printf("ERROR: Line %d\n", line);
		}
	}
	fclose(fileIn);
	fclose(fileOut);
	return 0;
}

FILE* openFile(char *filename, char *mode){
	FILE *f=fopen(filename, mode);
	if(f==NULL){
		printf("ERROR: Open/Create file fail.\n");
		exit(2);
	}
	return f;
}

int ReadLine(FILE *f, char *line){
	int i, n, nl, len;
	char buff[LINE_LEN]={0};
	long start=ftell(f);

	if((n=fread(buff, 1, LINE_LEN, f))<1) return 0;
	for(i=0;i<n;++i){
		if(buff[i]=='\n'){
			nl=1;
			break;
		}
	}
	len=i;
	if(line!=NULL){
		memset(line, 0, LINE_LEN);
		memcpy(line, buff, len);
	}else{
		return 0;
	}
	fseek(f, start+len+nl, SEEK_SET);
	return 1;
}

void writeCode(FILE *f, unsigned short code){
	int i;
	for(i=15;i>=0;--i){
		if((code>>i)&1) fwrite("1", 1, 1, f);
		else 			fwrite("0", 1, 1, f);
		if(i==8) fwrite("\n", 1, 1, f);
	}
	fwrite("\n", 1, 1, f);
}

void writeByte(FILE *f, unsigned char code){
	int i;
	for(i=7;i>=0;--i){
		if((code>>i)&1) fwrite("1", 1, 1, f);
		else 			fwrite("0", 1, 1, f);
	}
	fwrite("\n", 1, 1, f);
}


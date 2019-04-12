#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RAMSIZE	(64*1024)

FILE *fi, *fo;
char *buff;
int prog[RAMSIZE];
int size, err, n, i, p;


void error(char *msg){
	if(!err){
		err=1;
		printf("ERROR: %s: line: %d.\n", msg, n+1);
	}
}

void writeToFile(){
	int j, b;
	char w[17];
	for(j=0;j<p;++j){
		//printf(".%x\n", prog[j]); //for debug
		for(b=7;b>=0;--b){
			if(prog[j]&(1<<(7-b))){
				w[b+8]='1';
			}else{
				w[b+8]='0';
			}
		}
		for(b=7;b>=0;--b){
			if(prog[j]&(1<<(b+8))){
				w[7-b]='1';
			}else{
				w[7-b]='0';
			}
		}
		w[16]='\n';
		fwrite(w, 17, 1, fo);
	}
}

int isDigit(char c){
	if(c>='0' && c<='9') return 1;
	return 0;
}

int isAlpha(char c){
	if(c>='A' && c<='Z') return 1;
	if(c>='a' && c<='z') return 1;
	return 0;
}

void skipSpaces(){
	while(buff[i]==' ' || buff[i]=='\t') ++i;
}

void skipLabel(){
	int tmp=i;
	while(isAlpha(buff[i]) || isDigit(buff[i]) || buff[i]=='_') ++i;
	if(buff[i]==':'){
		++i;
	}else{
		i=tmp;
	}
}

void parseEnd(){
	if(buff[i]=='\n'){
		++i;
		++n;
	}else if(buff[i]=='\0'){
		err=1;
		++i;
		++n;
	}else{
		error("Syntax error.");
	}
}

void skipComment(){
	if(buff[i]==';'){
		++i;
		while(buff[i]!='\n' && buff[i]!='\0') ++i;
	}
}

int getLabelValue(char *label){


	//TODO labels



	return label[0];
}

int parseArgument(){
	int value, x=0;
	char b[64+1];

	memset(b, 0, 64+1);
	if(isDigit(buff[i])){
		while(isDigit(buff[i]) && x<64){
			b[x++]=buff[i++];
		}
		b[x]=0;
		value=atoi(b);
	}else if(isAlpha(buff[i])){
		while((isDigit(buff[i]) || isAlpha(buff[i]) || buff[i]=='_') && x<64){
			b[x++]=buff[i++];
		}
		b[x]=0;
		value=getLabelValue(b);
	}else{
		error("Syntax error.");
	}
	return value;
}

void parseInstruction(){
	int word=0;
	if(strncmp(buff+i, "lda ", 4)==0){
		i+=4;
		skipSpaces();
		word|=0x0000;
		word|=parseArgument();
		prog[p++]=word;
	}else if(strncmp(buff+i, "sta ", 4)==0){
		i+=4;
		skipSpaces();
		word|=0x1000;
		word|=parseArgument();
		prog[p++]=word;
	}else if(strncmp(buff+i, "jeq ", 4)==0){
		i+=4;
		skipSpaces();
		word|=0x2000;
		word|=parseArgument();
		prog[p++]=word;
	}else if(strncmp(buff+i, "jsr ", 4)==0){
		i+=4;
		skipSpaces();
		word|=0x3000;
		word|=parseArgument();
		prog[p++]=word;
	}else if(strncmp(buff+i, "ret", 3)==0){
		i+=3;
		skipSpaces();
		word|=0x4000;
		prog[p++]=word;
	}else if(strncmp(buff+i, "ldi ", 4)==0){
		i+=4;
		skipSpaces();
		word|=0x5000;
		word|=parseArgument();
		prog[p++]=word;
	}else if(strncmp(buff+i, "sti ", 4)==0){
		i+=4;
		skipSpaces();
		word|=0x6000;
		word|=parseArgument();
		prog[p++]=word;
	}else if(strncmp(buff+i, "add ", 4)==0){
		i+=4;
		skipSpaces();
		word|=0x7000;
		word|=parseArgument();
		prog[p++]=word;
	}else if(strncmp(buff+i, "nor ", 4)==0){
		i+=4;
		skipSpaces();
		word|=0x8000;
		word|=parseArgument();
		prog[p++]=word;
	}else if(strncmp(buff+i, ".org ", 5)==0){
		i+=5;
		skipSpaces();
		word=parseArgument();
		if(p>word){
			error("Org overflow");
			return;
		}
		p=word;
	}else if(strncmp(buff+i, ".rm ", 4)==0){
		i+=4;
		skipSpaces();
		word=parseArgument();
		p+=word;
	}else if(strncmp(buff+i, ".str ", 5)==0){
		i+=5;
		skipSpaces();
		if(buff[i]!='"'){
			error("Syntax error.");
			return;
		}
		++i;
		while(buff[i]!='"' && buff[i]!='\n' && buff[i]!='\0'){
			prog[p++]=buff[i++];
		}
		if(buff[i]!='"'){
			error("Syntax error.");
			return;
		}
		++i;
	}else if(strncmp(buff+i, ".dw ", 4)==0){
		i+=4;
		skipSpaces();
		word=parseArgument();
		prog[p++]=word;
		skipSpaces();
		while(buff[i]==','){
			++i;
			skipSpaces();
			word=parseArgument();
			prog[p++]=word;
			skipSpaces();
		}
	}
	// .org 5
	// .rm 5
	// .dw 5, 6, 7, 8
	// .str "text"
}


void parseLine(){
	skipSpaces();
	skipLabel();
	skipSpaces();
	parseInstruction();
	skipSpaces();
	skipComment();
	parseEnd();
}

int main(int argc, char **argv){
	if(argc!=3){
		printf("Usage: a9c [input] [output]\n");
		return 1;
	}
	if((fi=fopen(argv[1], "rb"))==0){
		printf("ERROR: Cant open input file.\n");
		return 2;
	}
	if((fo=fopen(argv[2], "wb"))==0){
		printf("ERROR: Cant create output file.\n");
		return 3;
	}
	fseek(fi, 0L, SEEK_END);
	size=ftell(fi);
	fseek(fi, 0L, SEEK_SET);
	if((buff=(char*)malloc(sizeof(char)*size))==0){
		printf("ERROR: Memory alocation fail.\n");
		return 4;
	}
	fread(buff, 1, size, fi);

	i=0;
	n=0;
	p=0;
	err=0;
	while(!err){
		parseLine();
	}
	writeToFile();

	free(buff);
	fclose(fi);
	fclose(fo);
	return 0;
}


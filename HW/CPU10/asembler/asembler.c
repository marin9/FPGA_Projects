#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "asembler.h"
#include "table.h"
#include "mlib.h"
#include "lang.h"

#define LINE_SIZE	128
#define MEMORY_SIZE	4096


char *p;
char line[LINE_SIZE];
char token[LINE_SIZE];
int line_num;
int address;
unsigned char *program;



unsigned char* asembler(char *file_name, int *length){
	FILE *fin=fopen(file_name, "r");
	if(fin==NULL){
		printf("ERROR: fopen: Open input file fail.\n");
		exit(10);
	}

	program=(unsigned char*)malloc(MEMORY_SIZE*sizeof(unsigned char));
	if(program==NULL){
		printf("ERROR: malloc: program memory init fail.\n");
		exit(11);
	}

	address=0;
	line_num=1;
	table_init();

	// First stage
	while(ReadLine(fin, line)){
		p=line;

		while(1){
			p=getToken(p, token);
			if(token[0]==0){
				break;
			}else if(token[0]==';'){
				break;
			}else if(parseLabel(token)){
				if(!table_add(token, address)){
					continue;
				}else{
					printf("ERROR: Line %d: Label already defined.\n", line_num);
					exit(12);
				}
			}else if(parseMnemonic(token)){
				address=address+2;
				break;
			}else if(parseCommand(token)){
				if(strcmp(token, ".org")==0){
					int num;
					p=getToken(p, token);
					num=parseNumber(token);
					if(num<0 || num>MEMORY_SIZE || num<address){
						printf("ERROR: Line %d: Invalid number.\n", line_num); 
						exit(13);
					}
					address=num;
					checkEnd();
					break;
				}else if(strcmp(token, ".str")==0){
					int num;
					p=getToken(p, token);
					num=parseString(token);
					if(num<0){
						printf("ERROR: Line %d: Syntax error.\n", line_num); 
						exit(14);
					}
					address += num;
					checkEnd();
					break;
				}else if(strcmp(token, ".rmb")==0){
					int num;
					p=getToken(p, token);
					num=parseNumber(token);
					if(num<0 || num>MEMORY_SIZE){
						printf("ERROR: Line %d: Invalid number.\n", line_num); 
						exit(15);
					}
					address += num;
					checkEnd();
					break;
				}else if(strcmp(token, ".equ")==0){
					p=getToken(p, token);
					if(!parseConstant(token)){
						printf("ERROR: Line %d: Syntax error.\n", line_num); 
						exit(16);
					}else{
						int num;
						char tmp[LINE_SIZE];
						p=getToken(p, tmp);
						num=parseNumber(tmp);						
						if(num<0 || num>MEMORY_SIZE){
							printf("ERROR: Line %d: Invalid number.\n", line_num); 
							exit(17);
						}
						if(table_add(token, num)){
							printf("ERROR: Line %d: Label already defined.\n", line_num);
							exit(18);
						}
						checkEnd();
						break;
					}
				}else if(strcmp(token, ".byte")==0){
					address += 1;
					break;
				}
			}
		}
		++line_num;		
	}

	// Second stage
	fseek (fin, 0, SEEK_SET);
	*length=0;
	line_num=1;

	while(ReadLine(fin, line)){
		p=line;

		while(1){
			p=getToken(p, token);
			if(token[0]==0){
				break;
			}else if(token[0]==';'){
				break;
			}else if(parseLabel(token)){
				continue;
			}else if(parseCommand(token)){
				continue;
			}else if(parseMnemonic(token)){




				//TODO
			}else{
				printf("ERROR: Line %d: Syntax error.\n", line_num);
				exit(19);
			}
		}
		++line_num;
	}
	return program;
}

char *getToken(char *buff, char *token){
	int strtoken=0;
	while(*buff==' ' || *buff=='\t') ++buff;
	while(1){
		if(*buff==' ' && !strtoken || *buff=='\t' || *buff==0) break;

		if(!strtoken && *buff=='"') strtoken=1;
		else if(strtoken && *buff=='"') strtoken=0;
		*token=*buff;
		++token;
		++buff;
	}
	*token=0;
	return buff;
}

int parseLabel(char *t){
	if(*t!='_' && !isAlpha(*t)) return 0;
	++t;

	while(*t!=0 && *t!=':'){
		if(!isAlpha(*t) && !isDigit(*t) && *t!='_') return 0;
		++t;
	}
	if(*t==':'){
		*t=0;
		return 1;
	}else{
		return 0;
	}
}

int parseMnemonic(char *t){
	return isInstruction(t);
}

int parseCommand(char *t){
	if(*t!='.') return 0;
	++t;
	while(isAlpha(*t)) ++t;

	if(*t==0) return 1;
	else return 0;
}

int parseNumber(char *t){
	char *tmp;
	if(*t=='$'){
		++t;
		tmp=t;
		while(isAlphaAF(*tmp) || isDigit(*tmp)){
			++tmp;
		}
		if(*tmp!=0) return -1;
		else 		return strToNum(t, 'h');
	}else if(*t=='%'){
		++t;
		tmp=t;
		while(*tmp=='0' || *tmp=='1'){
			++tmp;
		}
		if(*tmp!=0) return -1;
		else 		return strToNum(t, 'b');
	}else if(*t=='\''){
		return *(t+1);
	}else{
		tmp=t;
		while(isDigit(*tmp)){
			++tmp;
		}
		if(*tmp!=0) return -1;
		else 		return strToNum(t, 'd');
	}
}

int parseString(char *t){
	int len=0;
	if(*t!='"') return -1;
	++t;

	while(*t!='"' && *t!=0){
		++t;
		++len;
	}

	if(*t!='"') return -1;
	++t;

	if(*t!=0)	return -1;
	else		return len;
}

int parseConstant(char *t){
	if(*t=='#' || *t=='*') ++t;

	if(*t!='_' && !isAlpha(*t)) return 0;
	++t;

	while(*t!=0){
		if(!isAlpha(*t) && !isDigit(*t) && *t!='_') return 0;
		++t;
	}
	return 1;
}

void checkEnd(){
	p=getToken(p, token);
	if(*token!=';' && *token!=0){ 
		printf("ERROR: Line %d: Syntax error.\n", line_num);
		exit(20);
	}
}



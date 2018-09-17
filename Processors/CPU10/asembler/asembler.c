#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "asembler.h"
#include "table.h"
#include "mlib.h"


#define IMPLIED		0
#define CONSTANT	1
#define ADDRESS		2
#define POINTER		3


unsigned char *program;
int line_num;
int address;
char *p;
char line[LINE_SIZE];
char token[LINE_SIZE];


int parseInstruction(char *mnm, char *opr);


void asembler(FILE *file_in, int *length, unsigned char *prog){
	address=0;
	line_num=1;
	table_init();

	// First pass
	while(ReadLine(file_in, line)){
		p=line;
		while(1){
			p=getToken(p, token);
			if(parseEnd(token)){
				break;
			}else if(parseLabel(token)){
				if(table_add(token, address)){
					printf("ERROR: Line %d: Label already defined: %s.\n", line_num, token);
					exit(10);
				}
			}else if(parseMnemonic(token)){
				p=getToken(p, token);
				p=getToken(p, token);
				address=address+2;
			}else if(parseCommand(token)){
				if(strcmp(token, ".org")==0){
					p=getToken(p, token);
					int num=parseNumber(token);
					if(num<0 || num>MEMORY_SIZE || num<address){
						printf("ERROR: Line %d: Invalid number.\n", line_num); 
						exit(11);
					}
					address=num;
				}else if(strcmp(token, ".db")==0){
					p=getToken(p, token);
					address += 1;
				}else{
					printf("ERROR: Line %d: Unknown command.\n", line_num); 
					exit(12);
				}
			}else{
				printf("ERROR: Line %d: Syntax error.\n", line_num); 
				exit(13);
			}
		}
		++line_num;		
	}
	printf("First pass ok\n");

	// Second pass
	fseek (file_in, 0, SEEK_SET);
	*length=0;
	line_num=1;
	address=0;

	while(ReadLine(file_in, line)){
		p=line;
		while(1){
			p=getToken(p, token);

			if(parseEnd(token)){
				break;
			}else if(parseLabel(token)){
				continue;
			}else if(parseMnemonic(token)){
				char opr[32]={0};
				p=getToken(p, opr);
				int opcode=parseInstruction(token, opr);
				if(opcode==-1){
					printf("ERROR: Line %d: Syntax error.\n", line_num); 
					exit(14);
				}

				prog[address]=(unsigned char)((opcode&0xFF00)>>8);
				prog[address+1]=(unsigned char)(opcode&0xFF);
				address += 2;
			}else if(parseCommand(token)){
				if(strcmp(token, ".org")==0){
					p=getToken(p, token);
					int num=parseNumber(token);
					if(num<0 || num>MEMORY_SIZE || num<address){
						printf("ERROR: Line %d: Invalid number.\n", line_num); 
						exit(15);
					}
					address=num;
				}else if(strcmp(token, ".db")==0){
					p=getToken(p, token);
					int num=parseNumber(token);
					if(num>256){
						printf("ERROR: Line %d: Invalid number.\n", line_num); 
						exit(16);
					}
					prog[address]=(unsigned char)num;
					address += 1;
				}else{
					printf("ERROR: Line %d: Unknown command.\n", line_num); 
					exit(17);
				}
			}else{
				printf("ERROR: Line %d: Syntax error: %s\n", line_num, token);
				exit(18);
			}
		}
		++line_num;
	}
	printf("Second pass ok\n");
	*length=address;
}

int parseInstruction(char *mnm, char *opr){
	int opc;
	int amod;
	int num;		
	
	// get addressing mod
	if(*opr==0){
		amod=IMPLIED;
	}else if(*opr=='#'){
		amod=CONSTANT;
		++opr;
	}else if(*opr=='*'){
		amod=POINTER;
		++opr;
	}else{
		amod=ADDRESS;
	}

	// get number
	if(amod!=IMPLIED){
		if(parseLabelArg(opr)){
			num=table_get(opr);
			if(num<0){
				printf("ERROR: Line %d: Label not defined: %s\n", line_num, opr);
				exit(19);
				return -1;
			}
		}else if(parseNumber(opr)){
			if(*opr=='$'){
				++opr;
				num=strToNum(opr, 'h');
			}else if(*opr=='%'){
				++opr;
				num=strToNum(opr, 'b');
			}else{
				num=strToNum(opr, 'd');	
			}
		}else{
			return -1;
		}

		if(amod==CONSTANT && num>256) return -1;
		else if(num>2048) return -1;
	}
	
	// get instruction
	if(strcmp(mnm, "add")==0){
		if(amod==CONSTANT) opc=0x0000|num;
		else if(amod==ADDRESS) opc=0x8000|num;
		else if(amod==POINTER) return -1;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "nor")==0){
		if(amod==CONSTANT) opc=0x0800|num;
		else if(amod==ADDRESS) opc=0x8800|num;
		else if(amod==POINTER) return -1;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "xor")==0){
		if(amod==CONSTANT) opc=0x1000|num;
		else if(amod==ADDRESS) opc=0x9000|num;
		else if(amod==POINTER) return -1;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "lda")==0){
		if(amod==CONSTANT) opc=0x1800|num;
		else if(amod==ADDRESS) opc=0x9800|num;
		else if(amod==POINTER) opc=0xD800|num;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "sta")==0){
		if(amod==CONSTANT) return -1;
		else if(amod==ADDRESS) opc=0x2000|num;
		else if(amod==POINTER) opc=0xA000|num;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "jmp")==0){
		if(amod==CONSTANT) return -1;
		else if(amod==ADDRESS) opc=0x2800|num;
		else if(amod==POINTER) return -1;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "jeq")==0){
		if(amod==CONSTANT) return -1;
		else if(amod==ADDRESS) opc=0x3000|num;
		else if(amod==POINTER) return -1;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "jcs")==0){
		if(amod==CONSTANT) return -1;
		else if(amod==ADDRESS) opc=0x3800|num;
		else if(amod==POINTER) return -1;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "jsr")==0){
		if(amod==CONSTANT) return -1;
		else if(amod==ADDRESS) opc=0x4000|num;
		else if(amod==POINTER) return -1;
		else if(amod==IMPLIED) return -1;

	}else if(strcmp(mnm, "rts")==0){
		if(amod==CONSTANT) return -1;
		else if(amod==ADDRESS) return -1;
		else if(amod==POINTER) return -1;
		else if(amod==IMPLIED) opc=0x4800;
	}
	return opc;
}



#include "lang.h"
#include <string.h>

#define INSTR_NUM	10

static char instructions[INSTR_NUM][4]={
	"add",
	"nor",
	"xor",
	"lda",
	"sta",
	"rts",
	"jsr",
	"jmp",
	"jeq",
	"jcs"
};


int isInstruction(char *t){
	int i;
	for(i=0;i<INSTR_NUM;++i){
		if(strcmp(t, instructions[i])==0) return 1;
	}
	return 0;
}



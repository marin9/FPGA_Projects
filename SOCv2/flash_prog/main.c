#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wiringPi.h>
#include "25lc640.h"

#define RS	29
#define PR	28

void printHelp();
void fileRead(char *f_name, unsigned char *data, int *len);
void fileWrite(char *f_name, unsigned char *data, int len);
void resetDevice();


int main(int argc, char **argv){
	char filename[64];
	unsigned char *data=(unsigned char*)malloc(MEM_SIZE);
	memset(data, 0, MEM_SIZE);

	wiringPiSetup();
	init_25lc640();
	pinMode(RS, OUTPUT);
	pinMode(PR, OUTPUT);
	digitalWrite(RS, LOW);
	digitalWrite(PR, LOW);

	if(argc==1 || argc>3){
		printHelp();
		return 1;
	}else if(argc==3 && argv[1][0]=='-' && argv[1][1]=='w'){
		int len;

		strcpy(filename, argv[2]);
		fileRead(filename, data, &len);
		if(len>MEM_SIZE){
			printf("\e[31mERROR:\e37m No enough memory: Memory size=%d B, data=%d B\n", MEM_SIZE, len);
			exit(4);
		}
		printf("Wait...\n");
		digitalWrite(PR, HIGH);
		WriteAllMemory(data);

		unsigned char *tmp=(unsigned char*)malloc(MEM_SIZE);
		printf("Verify...\n");
		ReadAllMemory(tmp);
		digitalWrite(PR, LOW);
		resetDevice();

		if(memcmp(data, tmp, MEM_SIZE)==0){
			printf("\e[32mMemory verify OK.\n\e[37m");
		}else{
			printf("\e[31mMemory verify fail.\n\e[37m");
		}

	}else if((argc==3 || argc==2) && argv[1][0]=='-' && argv[1][1]=='r'){
		if(argc==3) strcpy(filename, argv[2]);
		else strcpy(filename, "memory.bin");

		digitalWrite(PR, HIGH);
		ReadAllMemory(data);
		digitalWrite(PR, LOW);
		resetDevice();
		fileWrite(filename, data, MEM_SIZE);
		printf("\e[32mMemory read finish.\n\e[37m");

	}else if(argc==3 && argv[1][0]=='-' && argv[1][1]=='s'){
		char wpen=argv[2][0]-48;
		char bp1= argv[2][4]-48;
		char bp0= argv[2][5]-48;
		char wel= argv[2][6]-48;
		char wip= argv[2][7]-48;

		unsigned char byte=0;
		byte=byte|(wpen<<7);
		byte=byte|(bp1<<3);
		byte=byte|(bp0<<2);
		byte=byte|(wel<<1);
		byte=byte|(wip<<0);

		digitalWrite(PR, HIGH);
		WriteSR(byte);
		digitalWrite(PR, LOW);
		resetDevice();

		unsigned char tmp;
		ReadSR(&tmp);
		if(tmp==byte){
			printf("\e[32mSR write ok.\n\e[37m");
		}else{
			printf("\e[31mSR write fail.\n\e[37m");
		}
	}else if(argc==2 && argv[1][0]=='-' && argv[1][1]=='g'){
		unsigned char byte;
		digitalWrite(PR, HIGH);
		ReadSR(&byte);
		digitalWrite(PR, LOW);
		resetDevice();

		char wpen=(byte>>7)&0x01;
		char bp1= (byte>>3)&0x01;
		char bp0= (byte>>2)&0x01;
		char wel= (byte>>1)&0x01;
		char wip= (byte>>0)&0x01;

		printf("Status register:\n");
		printf("WPEN  BP1  BP0  WEL  WIP\n");
		printf("  %d    %d    %d    %d    %d\n\n", wpen, bp1, bp0, wel, wip);
	}else{
		printHelp();
		return 1;
	}

	return 0;
}


void printHelp(){
	printf("Usage:\n");
	printf("progSOC -w filename     -- write file into memory.\n");
	printf("progSOC -r filename     -- read memory into file.\n");
	printf("progSOC -s 00101011     -- write status register.\n");
	printf("progSOC -g	            -- read status register.\n");
	printf("\n");
	printf("Status Register:  WPEN   X    X    X   BP1  BP0  WEL  WIP\n");
	printf("                    7    6    5    4    3    2    1    0\n");
	printf("\n");

	printf("+----+----+----+----+----+----+---\n");
	printf("| 0V | SS | CK | SI | SO | HD |...\n");
	printf("+----+----+----+----+----+-----+--\n");
	printf("| RS | PR | Vc | 0V | WP | 0V |...\n");
	printf("+----+----+----+----+----+----+---\n");
}

void fileRead(char *f_name, unsigned char *data, int *len){
	FILE *f=fopen(f_name, "rb");
	if(f==NULL){
		printf("\e[31mERROR: File not found.\n\e[37m");
		exit(2);
	}

	fseek(f, 0L, SEEK_END);
	*len=ftell(f);
	fseek(f, 0L, SEEK_SET);

	int s=0, t;
	while(s<*len){
		t=fread(data+s, 1,4096, f);
		s=s+t;
	}
	fclose(f);
}

void fileWrite(char *f_name, unsigned char *data, int len){
	FILE *f=fopen(f_name, "wb");
	if(f==NULL){
		printf("\e[31mERROR: File write fail.\n\e[37m");
		exit(3);
	}

	int s=0;
	delay(1);
	while(s<len){
		fwrite(data+s, 4096,1, f);
		s=s+4096;
	}
	fclose(f);
}

void resetDevice(){
	digitalWrite(RS, HIGH);
	delay(10);
	digitalWrite(RS, LOW);
}


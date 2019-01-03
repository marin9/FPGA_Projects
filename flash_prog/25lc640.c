#include <string.h>
#include <wiringPi.h>
#include "25lc640.h"
#include "spi.h"



void SetWREN(){
	spi_begin();
	spi_sendByte(M25LC640_WREN);
	spi_end();
}

void ResetWREN(){
	spi_begin();
	spi_sendByte(M25LC640_WRDI);
	spi_end();
}

void ReadSR(char *byte){
	spi_begin();
	spi_sendByte(M25LC640_RDSR);
	*byte=spi_readByte();
	spi_begin();
}

void WriteSR(char byte){
	SetWREN();
	spi_begin();
	spi_sendByte(M25LC640_WRSR);
	spi_sendByte(byte);
	spi_begin();
}

void ReadByte(int addr, char *data){
	char addrH=(char)((addr&0xff00)>>8);
	char addrL=(char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(M25LC640_READ);
	spi_sendByte(addrH);
	spi_sendByte(addrL);
	*data=spi_readByte();
	spi_end();
}

void WriteByte(int addr, char data){
	char addrH=(char)((addr&0xff00)>>8);
	char addrL=(char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(M25LC640_WREN);
	spi_end();

	spi_begin();
	spi_sendByte(M25LC640_WRITE);
	spi_sendByte(addrH);
	spi_sendByte(addrL);
	spi_sendByte(data);
	spi_end();
	delay(10);
}

void ReadBlock32(int addr, char *data){
	int i;
	char addrH=(char)((addr&0xff00)>>8);
	char addrL=(char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(M25LC640_READ);
	spi_sendByte(addrH);
	spi_sendByte(addrL);
	for(i=0;i<32;++i){
		data_32B[i]=spi_readByte();
	}
	spi_end();
}

void WriteBlock32(int addr, char *data){
	int i;
	char addrH=(char)((addr&0xff00)>>8);
	char addrL=(char)(addr&0x00ff);

	SetWREN();

	spi_begin();
	spi_sendByte(M25LC640_WRITE);
	spi_sendByte(addrH);
	spi_sendByte(addrL);
	for(i=0;i<32;++i){
		spi_sendByte(data[i]);
	}
	spi_end();
	delay(10);
}

void ReadAllMemory(char *data){
	int i;

	spi_begin();
	spi_sendByte(M25LC640_READ);
	spi_sendByte(0x00);
	spi_sendByte(0x00);
	for(i=0;i<MEM_SIZE;++i){
		data[i]=spi_readByte();
	}
	spi_end();
}

void WriteAllMemory(char *data){
	int b;
	int addr=0;
	char block[BLOCK_SIZE];

	for(b=0;b<BLOCKS_NUM;++b){
		memcpy(block, data+addr, BLOCK_SIZE);
		WriteBlock32(addr, block);
		addr+=BLOCK_SIZE;
	}
}


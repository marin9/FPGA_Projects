#include <string.h>
#include <wiringPi.h>
#include "25lc640.h"
#include "spi.h"


void init_25lc640(){
	spi_init();
}

void SetWREN(){
	spi_begin();
	spi_sendByte(0x06);
	spi_end();
}

void ResetWREN(){
	spi_begin();
	spi_sendByte(0x04);
	spi_end();
}


void WriteSR(unsigned char byte){
	SetWREN();
	spi_begin();
	spi_sendByte(0x01);
	spi_sendByte(byte);
	spi_begin();
}

void ReadSR(unsigned char *byte){
	spi_begin();
	spi_sendByte(0x05);
	*byte=spi_readByte();
	spi_begin();
}

void ReadByte(int addr, unsigned char *data){
	unsigned char addrH=(unsigned char)((addr&0xff00)>>8);
	unsigned char addrL=(unsigned char)(addr&0x00ff);

	spi_begin();

	spi_sendByte(0x03);
	spi_sendByte(addrH);
	spi_sendByte(addrL);
	*data=spi_readByte();

	spi_end();
}

void WriteByte(int addr, unsigned char data){
	unsigned char addrH=(unsigned char)((addr&0xff00)>>8);
	unsigned char addrL=(unsigned char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(0x06);
	spi_end();

	spi_begin();

	spi_sendByte(0x02);
	spi_sendByte(addrH);
	spi_sendByte(addrL);
	spi_sendByte(data);

	spi_end();
	delay(10);
}

void ReadBlock32(int addr, unsigned char *data_32B){
	int i;
	unsigned char addrH=(unsigned char)((addr&0xff00)>>8);
	unsigned char addrL=(unsigned char)(addr&0x00ff);

	spi_begin();

	spi_sendByte(0x03);
	spi_sendByte(addrH);
	spi_sendByte(addrL);

	for(i=0;i<32;++i){
		data_32B[i]=spi_readByte();
	}
	spi_end();
}

void WriteBlock32(int addr, unsigned char *data_32B){
	int i;
	unsigned char addrH=(unsigned char)((addr&0xff00)>>8);
	unsigned char addrL=(unsigned char)(addr&0x00ff);

	SetWREN();
	spi_begin();

	spi_sendByte(0x02);
	spi_sendByte(addrH);
	spi_sendByte(addrL);

	for(i=0;i<32;++i){
		spi_sendByte(data_32B[i]);
	}
	spi_end();
	delay(10);
}

void ReadAllMemory(unsigned char *data){
	int i;
	spi_begin();

	spi_sendByte(0x03);
	spi_sendByte(0x00);
	spi_sendByte(0x00);

	for(i=0;i<MEM_SIZE;++i){
		data[i]=spi_readByte();
	}
	spi_end();
}

void WriteAllMemory(unsigned char *data){
	int b;
	int addr=0;
	unsigned char block[BLOCK_SIZE];

	for(b=0;b<BLOCKS_NUM;++b){
		memcpy(block, data+addr, BLOCK_SIZE);
		WriteBlock32(addr, block);
		addr+=BLOCK_SIZE;
	}
}


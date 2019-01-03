#include "flash.h"
#include "spi.h"


char flash_readSR(){
	char sr;
	spi_begin();
	spi_sendByte(CMD_RDSR);
	sr=spi_readByte();
	spi_end();
	return sr;
}

void flash_writeSR(char byte){
	spi_begin();
	spi_sendByte(CMD_WREN);
	spi_end();
	
	spi_begin();
	spi_sendByte(CMD_WRSR);
	spi_sendByte(byte);
	spi_end();
}

char flash_readByte(int addr){
	char addr1=(char)((addr&0xff00)>>8);
	char addr0=(char)(addr&0x00ff);
	char byte;

	spi_begin();
	spi_sendByte(CMD_READ);
	spi_sendByte(addr1);
	spi_sendByte(addr0);
	byte=spi_readByte();
	spi_end();
	return byte;
}

void flash_writeByte(int addr, char data){
	char addr1=(char)((addr&0xff00)>>8);
	char addr0=(char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(CMD_WREN);
	spi_end();

	spi_begin();
	spi_sendByte(CMD_WRITE);
	spi_sendByte(addr1);
	spi_sendByte(addr0);
	spi_sendByte(data);
	spi_end();
	delay(WRITETIME);
}

int flash_readPage(int addr, char *data){
	int i;
	char addr1=(char)((addr&0xff00)>>8);
	char addr0=(char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(CMD_READ);
	spi_sendByte(addr1);
	spi_sendByte(addr0);
	for(i=0;i<PAGELEN;++i){
		data[i]=spi_readByte();
	}
	spi_end();
	return PAGELEN;
}

int flash_writePage(int addr, char *data){
	int i;
	char addr1=(char)((addr&0xff00)>>8);
	char addr0=(char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(CMD_WREN);
	spi_end();

	spi_begin();
	spi_sendByte(CMD_WRITE);
	spi_sendByte(addr1);
	spi_sendByte(addr0);
	for(i=0;i<PAGELEN;++i){
		spi_sendByte(data[i]);
	}
	spi_end();
	delay(WRITELEN);
	return PAGELEN;
}

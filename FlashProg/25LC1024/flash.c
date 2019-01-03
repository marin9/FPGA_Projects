#include "flash.h"
#include "spi.h"


static int addr_size;
static int page_size;
static int write_time;


int flash_init(int ftype){
	if(ftype==F_25LC640){
		addr_size=16;
		page_size=32;
		write_time=5+2;
		return 0;
	}else if(ftype==F_25LC1024){
		addr_size=24;
		page_size=256;
		write_time=6+2;
		return 0;
	}else{
		return -1;
	}
}

void flash_setWREN(){
	spi_begin();
	spi_sendByte(CMD_WREN);
	spi_end();
}

void flash_rstWREN(){
	spi_begin();
	spi_sendByte(CMD_WRDI);
	spi_end();
}

char flash_readSR(){
	char sr;
	spi_begin();
	spi_sendByte(CMD_RDSR);
	sr=spi_readByte();
	spi_end();
	return sr;
}

void flash_writeSR(char byte){
	SetWREN();
	spi_begin();
	spi_sendByte(CMD_WRSR);
	spi_sendByte(byte);
	spi_end();
}

char flash_readByte(int addr){
	char addr2=(char)((addr&0xff0000)>>16);
	char addr1=(char)((addr&0xff00)>>8);
	char addr0=(char)(addr&0x00ff);
	char byte;

	spi_begin();
	spi_sendByte(CMD_READ);
	if(addr_size==24)
		spi_sendByte(addr2);
	spi_sendByte(addr1);
	spi_sendByte(addr0);
	byte=spi_readByte();
	spi_end();
	return byte;
}

void flash_writeByte(int addr, char data){
	char addr2=(char)((addr&0xff0000)>>16);
	char addr1=(char)((addr&0xff00)>>8);
	char addr0=(char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(CMD_WREN);
	spi_end();

	spi_begin();
	spi_sendByte(CMD_WRITE);
	if(addr_size==24)
		spi_sendByte(addr2);
	spi_sendByte(addr1);
	spi_sendByte(addr0);
	spi_sendByte(data);
	spi_end();
	delay(write_time);
}

int flash_readPage(int addr, char *data){
	int i;
	char addr2=(char)((addr&0xff0000)>>16);
	char addr1=(char)((addr&0xff00)>>8);
	char addr0=(char)(addr&0x00ff);

	spi_begin();
	spi_sendByte(CMD_READ);
	if(addr_size==24)
		spi_sendByte(addr2);
	spi_sendByte(addr1);
	spi_sendByte(addr0);
	for(i=0;i<page_size;++i){
		data[i]=spi_readByte();
	}
	spi_end();
	return page_size;
}

int flash_writePage(int addr, char *data){
	int i;
	char addr2=(char)((addr&0xff0000)>>16);
	char addr1=(char)((addr&0xff00)>>8);
	char addr0=(char)(addr&0x00ff);

	SetWREN();

	spi_begin();
	spi_sendByte(CMD_WRITE);
	if(addr_size==24)
		spi_sendByte(addr2);
	spi_sendByte(addr1);
	spi_sendByte(addr0);
	for(i=0;i<page_size;++i){
		spi_sendByte(data[i]);
	}
	spi_end();
	delay(write_time);
	return page_size;
}

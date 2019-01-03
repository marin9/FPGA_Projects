#pragma once

#define CMD_READ	0x03
#define CMD_WRITE	0x02
#define CMD_WREN	0x06
#define CMD_WRDI	0x04
#define CMD_RDSR	0x05
#define CMD_WRSR	0x01

#define CAPACITY	8192
#define PAGELEN		32
#define ADDRLEN		16
#define WRITETIME	(5+2)


char flash_readSR();
void flash_writeSR(char byte);

char flash_readByte(int addr);
void flash_writeByte(int addr, char data);
int flash_readPage(int addr, char *data);
int flash_writePage(int addr, char *data);


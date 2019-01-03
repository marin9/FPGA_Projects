#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include "flash.h"
#include "spi.h"


/*
char flash_readByte(int addr);
void flash_writeByte(int addr, char data);
int flash_readPage(int addr, char *data);
int flash_writePage(int addr, char *data);
*/

int main(int argc, char **argv){
	wiringPiSetup();
	spi_init();





	return 0;
}





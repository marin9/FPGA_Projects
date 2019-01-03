#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include "spi.h"
#include "flash.h"
#include "fs.h"



int main(int argc, char **argv){
	wiringPiSetup();
	spi_init();
	flash_init();
	fs_init();





	return 0;
}





#include <stdio.h>
#include "fs.h"
#include "25lc640.h"

static struct flash_d finfo;


void flash_open(int flash_type){
	if(flash_type==FLASH_25LC640){
		finfo.flash_size=128;
		int i;
		for(i=0;i<12;++i){
			ReadByte(i, &(finfo.name[i]));
		}
		unsigned char b3, b2, b1, b0;
		ReadByte(8, &b3);
		ReadByte(9, &b3);
		ReadByte(10, &b3);
		ReadByte(11, &b3);
		b3-=48;
		b2-=48;
		b1-=48;
		b0-=48;
		finfo.file_size=0;
		finfo.file_size=(b3<<12)|(b2<<8)|(b1<<4)|(b0<<0);
		finfo.file_num=finfo.flash_size/finfo.file_size
	}
}

void flash_info(struct flash_d* desc){


}

void flash_format(int file_size);
void flash_fcreate(char *name);
void flash_fremove(char *name);
void flash_fread(char *name, char *data);
void flash_fwrite(char *name, char *data);
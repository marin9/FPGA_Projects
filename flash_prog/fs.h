#pragma once

#define FLASH_25LC640	0


struct flash_d{
	char name[12];
	int flash_size;
	int file_size;
	int file_num;
};


void flash_open(int flash_type);
void flash_info(struct flash_d* desc);
void flash_format(int file_size);
void flash_fcreate(char *name);
void flash_fremove(char *name);
void flash_fread(char *name, char *data);
void flash_fwrite(char *name, char *data);

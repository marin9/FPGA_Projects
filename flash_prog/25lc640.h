#pragma once

#define MEM_SIZE 	8192
#define BLOCK_SIZE	32
#define BLOCKS_NUM	(MEM_SIZE/BLOCK_SIZE)

#define M25LC640_READ	0x03
#define M25LC640_WRITE	0x02
#define M25LC640_WREN	0x06
#define M25LC640_WRDI	0x04
#define M25LC640_RDSR	0x05
#define M25LC640_WRSR	0x01


void SetWREN();
void ResetWREN();

void ReadSR(char *byte);
void WriteSR(char byte);

void ReadByte(int addr, char *data);
void WriteByte(int addr, char data);

void ReadBlock32(int addr, char *data);
void WriteBlock32(int addr, char *data);

void ReadAllMemory(char *data);
void WriteAllMemory(char *data);

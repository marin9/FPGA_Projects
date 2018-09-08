#pragma once

#define MEM_SIZE 	8192
#define BLOCK_SIZE	32
#define BLOCKS_NUM	(MEM_SIZE/BLOCK_SIZE)

void init_25lc640();

void SetWREN();
void ResetWREN();

void WriteSR(unsigned char byte);
void ReadSR(unsigned char *byte);

void ReadByte(int addr, unsigned char *data);
void WriteByte(int addr, unsigned char data);

void ReadBlock32(int addr, unsigned char *data_32B);
void WriteBlock32(int addr, unsigned char *data_32B);

void ReadAllMemory(unsigned char *data);
void WriteAllMemory(unsigned char *data);

#pragma once

#define VC 27
#define WP 26
#define CS 25
#define CK 24
#define SI 23
#define SO 22
#define HD 21


void spi_init();
void spi_begin();
void spi_end();
void spi_sendByte(char byte);
char spi_readByte();


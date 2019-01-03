#pragma once

void spi_init(int ck, int cs, int si, int so);
void spi_begin();
void spi_end();
void spi_sendByte(char byte);
char spi_readByte();


#pragma once

void spi_init(int cs, int ck, int si, int so);
void spi_begin();
void spi_end();
void spi_sendByte(char byte);
char spi_readByte();


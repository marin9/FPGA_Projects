#pragma once

void spi_init();
void spi_begin();
void spi_end();

void spi_sendByte(unsigned char byte);
unsigned char spi_readByte();


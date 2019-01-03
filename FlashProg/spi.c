#include <wiringPi.h>
#include "spi.h"

static int CK;
static int CS;
static int SI;
static int SO;


void spi_init(int ck, int cs, int si, int so){
	CK=ck;
	CS=cs;
	SI=si;
	SO=so;

	pinMode(CS, OUTPUT);
	pinMode(SO, INPUT);
	pinMode(SI, OUTPUT);
	pinMode(CK, OUTPUT);

	digitalWrite(CS, HIGH);
	digitalWrite(SI, LOW);
	digitalWrite(CK, LOW);
}

void spi_begin(){
	digitalWrite(CS, LOW);
	delayMicroseconds(1);
}

void spi_end(){
	delayMicroseconds(1);
	digitalWrite(CS, HIGH);
}

void spi_sendByte(char byte){
	digitalWrite(CK, LOW);
	digitalWrite(SI, byte&0x80);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	digitalWrite(SI, byte&0x40);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	digitalWrite(SI, byte&0x20);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	digitalWrite(SI, byte&0x10);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	digitalWrite(SI, byte&0x08);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	digitalWrite(SI, byte&0x04);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	digitalWrite(SI, byte&0x02);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	digitalWrite(SI, byte&0x01);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);
}

char spi_readByte(){
	unsigned char byte=0;
	char bit[8];

	digitalWrite(CK, LOW);
	delayMicroseconds(1);
	bit[7]=digitalRead(SO);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	delayMicroseconds(1);
	bit[6]=digitalRead(SO);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	delayMicroseconds(1);
	bit[5]=digitalRead(SO);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	delayMicroseconds(1);
	bit[4]=digitalRead(SO);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	delayMicroseconds(1);
	bit[3]=digitalRead(SO);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	delayMicroseconds(1);
	bit[2]=digitalRead(SO);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	delayMicroseconds(1);
	bit[1]=digitalRead(SO);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);

	digitalWrite(CK, LOW);
	delayMicroseconds(1);
	bit[0]=digitalRead(SO);
	delayMicroseconds(1);
	digitalWrite(CK, HIGH);
	delayMicroseconds(1);
	digitalWrite(CK, LOW);
	delayMicroseconds(1);

	byte=byte|((0x01&bit[0])<<0);
	byte=byte|((0x01&bit[1])<<1);
	byte=byte|((0x01&bit[2])<<2);
	byte=byte|((0x01&bit[3])<<3);
	byte=byte|((0x01&bit[4])<<4);
	byte=byte|((0x01&bit[5])<<5);
	byte=byte|((0x01&bit[6])<<6);
	byte=byte|((0x01&bit[7])<<7);

	return byte;
}



System on chip

CPU_freq: 1 MHz
Data bus: 8 bit
Address bus: 12 bit
Registers: 
	acc: 8 bit
	pc: 12 bit

Instructions:
	add {#}{const/address}
	nor {#}{const/address}
	xor {#}{const/address}
	lda {#}{const/address}
	sta address
	jmp address
	jeq address

const: 8 bit
address: 12 bit


RAM/ROM: 4096 B
Timer: 8 bit, tick 10ms
	read at 0xfff
	write at 0xffd
GPIO: 8 bit
	read at 0xffe
	write data at 0xffb
	write mode at 0xffc

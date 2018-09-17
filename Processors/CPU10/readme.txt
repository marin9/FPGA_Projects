8-bit Processor (10 instructions)

Freq:			12.5 MHz
Data bus:		8 bit
Address bus:	11 bit
Registers: 
	A: 8 bit
	SR: 4 bit	|C|S2|S1|S0|
	PC: 11 bit

Instructions:
	add {#}const
	nor {#}const
	xor {#}const
	lda {#/*}const
	sta {*}const
	jmp const
	jeq const
	jcs const
	jsr const
	rts

const: 
	#const: data 8 bit
	const: address 11 bit
	*const: pointer 8 bit


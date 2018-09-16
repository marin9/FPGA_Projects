8-bit Processor (7 instructions)

Freq:			12.5 MHz
Data bus:		8 bit
Address bus:	11 bit
Registers: 
	A: 8 bit
	PC: 11 bit

Instructions:
	add {#}const
	nor {#}const
	xor {#}const
	lda {#}const
	sta const
	jmp const
	jeq const

const: 
	#const: data 8 bit
	const: address 11 bit


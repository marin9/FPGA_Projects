System on chip

CPU_freq: 12.5 MHz
Data bus: 8 bit
Address bus: 11 bit
Registers: 
	acc: 8 bit
	pc: 11 bit

Instructions:
	add {#}const
	nor {#}const
	xor {#}const
	lda {#}const
	sta const
	jmp const
	jeq const

const: 
	#data:   8 bit
	address: 11 bit


RAM/ROM: 2048 B
Timer: 8 bit, tick 10ms
	read:  0x7ff
	write: 0x7fd
GPIO: 8 bit
	read:  0x7fe
	write: 0x7fc

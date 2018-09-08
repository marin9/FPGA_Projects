System on chip

CPU_freq: 12.5 MHz
Data bus: 8 bit
Address bus: 12 bit
Registers: 
	acc: 8 bit
	pc: 12 bit

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
	address: 12 bit


RAM/ROM: 4096 B
Timer: 8 bit, tick 10ms
	read:  0xfff
	write: 0xffd
GPIO: 8 bit
	read:  0xffe
	write: 0xffc

CPU registers:
	ACC 8  bit
	PC  13 bit
	SR  2  bit (c, z)


INSTRUCTIONS:
(all two bytes)

	ADD(im):	0x10 kk
	SUB(im):	0x11 kk
	AND(im):	0x12 kk
	XOR(im):	0x13 kk

	ADD(di):	0x20 aa
	SUB(di):	0x21 aa
	AND(di):	0x22 aa
	XOR(di):	0x23 aa

	LDA(im):	0x40 kk
	LDA(di):	0x41 aa
	STA(di):	0x42 aa

	INN:		0x80 pp
	OUT:		0x81 pp

	JMP:		101aaaaa aa
	JEQ:		110aaaaa aa
	JCS:		111aaaaa aa


I/O: UART, TIMER, GPIO, PWM

	0x01 uart_wr		8 bit, W
	0x02 uart_rd		8 bit, R
	0x03 uart_empty		1 bit, R
	0x04 uart_full		1 bit, R
	0x05 pwm_wr		8 bit, W
	0x06 timer_wr		8 bit, W
	0x07 timer_rd		8 bit, R
	0x08 gpio_mod_wr	8 bit, W (1 out, 0 in)
	0x09 gpio_data_wr	8 bit, W
	0x0A gpio_data_rd 	8 bit, R


UART: 19200, 8 bit, 1 start bit, 1 stop bit, no parity bit
TIMER: 8 bit, 10ms clock
PWM: 1 pin
GPIO: 8 pins input/output



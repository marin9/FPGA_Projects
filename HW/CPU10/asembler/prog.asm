	; Constants
	.equ UART_WR	$fff
	.equ UART_TF	$ffe

	; Start program
	jmp start
msg:	.str "Hello world"
	.byte 13
	.byte 10
	.byte 0
	.rmb  10
p:	.byte msg


	.org 256
start:	lda UART_TF	;Check is uart ready
	jeq start
	lda *p
	jeq end
	sta UART_WR	;Send data
	lda p
	add #1
	sta p
	jmp start
end:	lda #'E
	sta UART_WR
ee:	jmp ee

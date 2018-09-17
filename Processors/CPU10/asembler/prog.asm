	; Start program
	jmp start
	.db 'M	;string
	.db 'a
	.db 'r
	.db 'i
	.db 'n
	.db 0

		.org 128
src:	.db 2
dst:	.db 150


		.org 256
start:	lda *src ;memcpy
		sta *dst
		jeq end
		lda src	
		add #1
		sta src
		lda dst
		add #1
		sta dst
		jmp start
end:	jmp end


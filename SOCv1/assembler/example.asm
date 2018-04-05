lda 254
and #15
sta 0
sta 1
lda #0
sta 2

lda 2
add 0
sta 2
lda 1
sub #1
sta 1
tst nz
jmp 6

lda 2
sta 255
jmp 0


/output = input(3 downto 0) ^ 2

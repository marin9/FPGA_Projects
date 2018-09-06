/ init gpio
lda #255
sta 4092

// init var
lda #0
sta 100

/ set gpio
lda 100
sta 4091

/ inc
add #1
sta 100

/ set timer
lda #64
sta 4093

/ wait
lda 4095
jeq 8
jmp 20


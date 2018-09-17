/ init var
lda #0
sta 100

/ set gpio
lda 100
sta 2044

/ inc
add #1
sta 100

/ loop
jeq 4


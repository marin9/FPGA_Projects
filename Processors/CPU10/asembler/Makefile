CC=gcc
CFLAGS=-Wall -Wextra -c
LFLAGS=-lm
DEPS=asembler.h table.h mlib.h
OBJS=asembler.o table.o mlib.o main.o
TARGET=asm10


%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) $<

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(LFLAGS)

clean:
	rm -f *.o
	rm -f $(TARGET)


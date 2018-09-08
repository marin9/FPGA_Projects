CC=gcc
FLAGS=-Wall -Wextra -c
LIBS=-lwiringPi
HDRS=spi.h 25lc540.h
OBJ=main.o 25lc640.o spi.o
TARGET=progSOC


%.o: %.c $(HDRS)
	$(CC) $(FLAGS) $@ $<

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET) $(LIBS)

clean:
	rm *.o
	rm $(TARGET)

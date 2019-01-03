CC=gcc
FLAGS=-Wall -Wextra -c
LIBS=-lwiringPi
HDRS=flash.h fs.h
OBJ=flash.h fs.o main.o
TARGET=flashProg


all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET) $(LIBS)

%.o: %.c $(HDRS)
	$(CC) $(FLAGS) $< -o $@

clean:
	rm *.o
	rm $(TARGET)

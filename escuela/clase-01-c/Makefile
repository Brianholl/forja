CC      = gcc
CFLAGS  = -Wall -Wextra -g
TARGET  = oraculo
SRC     = oraculo.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

.PHONY: all clean

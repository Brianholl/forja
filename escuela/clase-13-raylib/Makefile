CC     = gcc
CFLAGS = -Wall -Wextra -g
LIBS   = -lraylib -lm
TARGET = dungeon
SRC    = dungeon.c

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LIBS)

clean:
	rm -f $(TARGET)

.PHONY: all clean

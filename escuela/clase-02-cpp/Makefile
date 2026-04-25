CXX      = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -g
TARGET   = forja
SRC      = forja.cpp

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

.PHONY: all clean

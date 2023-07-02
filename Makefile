# Application source
APP_SRC ?= test_tinyp256.c

# For Linux or any machines with gcc compiler
CC ?= gcc

# For Linux
CFLAGS := -Os -std=c99 -Wall -Wextra -D_ISOC99_SOURCE -MMD -I.


SRC = tinyp256.c ecc.c ecc_dsa.c

OBJ = $(SRC:.c=.o)

%.o:%.c
	$(CC) -c $< $(CFLAGS)

all: test_tinyp256

test_tinyp256: $(basename $(APP_SRC)).o $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $(basename $(APP_SRC)).o \
		-o test_tinyp256

.PHONY: clean
clean:
	rm -rf *.o test_tinyp256 *.d
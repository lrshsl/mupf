MUPF_SOURCE = examples/calc.mupf

BIN = mupf
SRC = ./src
BUILD = ./build
CSOURCES = $(BUILD)/$(BIN).tab.c $(BUILD)/lex.yy.c
LSOURCES = $(SRC)/mupf.l
YSOURCES = $(SRC)/mupf.y

CC = gcc
CFLAGS = -Wall -Wextra
YACC = bison
YFLAGS = -d -H
LEX = lex
LFLAGS =

.PHONY: all clean
.SILENT: clean


all: $(BIN)

run: $(BIN)
	./$(BIN) $(MUPF_SOURCE)

$(BIN): $(CSOURCES)
	$(CC)    $(CFLAGS)   $(CSOURCES) -o $(BIN)

$(CSOURCES): $(LSOURCES) $(YSOURCES)
	$(LEX)   $(LFLAGS)   -o $(BUILD)/lex.yy.c      $(LSOURCES)
	$(YACC)  $(YFLAGS)   -o $(BUILD)/$(BIN).tab.c  $(YSOURCES)

$(LSOURCES) $(YSOURCES):
	echo "Source files not found"

clean:
	rm -f $(BIN) $(BUILD)/*




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
LEX = flex
LFLAGS =

.PHONY: all clean
.SILENT: clean


all: $(BIN)

$(BIN): $(CSOURCES)
	$(CC)    $(CFLAGS)   $(CSOURCES) -o $(BIN)

$(CSOURCES): $(LSOURCES) $(YSOURCES)
	$(LEX)   $(LFLAGS)   -o $(BUILD)/lex.yy.c      $(LSOURCES)
	$(YACC)  $(YFLAGS)   -o $(BUILD)/$(BIN).tab.c  $(YSOURCES)

clean:
	rm -f $(BIN) $(BUILD)/*



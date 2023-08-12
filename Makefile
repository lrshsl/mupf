MUPF_SOURCE = examples/addition.mupf

BIN = mupf
DBG_BIN = mupf_dbg
SRC = ./src
BUILD = ./build
CSOURCES = $(BUILD)/$(BIN).tab.c $(BUILD)/lex.yy.c
C_DBG_SOURCES = $(BUILD)/$(BIN).dbg.tab.c $(BUILD)/lex.dbg.yy.c
LSOURCES = $(SRC)/mupf.l
YSOURCES = $(SRC)/mupf.y

CC = gcc
CFLAGS = -Wall -Wextra

YACC = bison
YFLAGS = -H
YFLAGS_DBG = -d -H

LEX = lex
LFLAGS =
LFLAGS_DBG = -d

.PHONY: all clean
.SILENT: clean


all: $(BIN)

run: $(BIN)
	./$< $(MUPF_SOURCE)

dbg:
	$(LEX)   $(LFLAGS_BIN)  -o $(BUILD)/lex.dbg.yy.c   	  $(LSOURCES)
	$(YACC)  $(YFLAGS_DBG)	-o $(BUILD)/$(BIN).dbg.tab.c  $(YSOURCES)
	$(CC)    $(CFLAGS_DBG)  -o $(DBG_BIN)                 $(C_DBG_SOURCES)
	./$(DBG_BIN) $(MUPF_SOURCE)

$(BIN): $(CSOURCES)
	$(CC)    $(CFLAGS)   -o $(BIN)  $<

$(CSOURCES): $(LSOURCES) $(YSOURCES)
	$(LEX)   $(LFLAGS)   -o $(BUILD)/lex.yy.c      $(LSOURCES)
	$(YACC)  $(YFLAGS)   -o $(BUILD)/$(BIN).tab.c  $(YSOURCES)

$(LSOURCES) $(YSOURCES):
	echo "Source files not found"

clean:
	rm -f $(BIN) $(BUILD)/*



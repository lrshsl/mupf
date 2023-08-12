MUPF_SOURCE = examples/addition.mupf

BIN = mupf
DBG_BIN = mupf_dbg
SRC = ./src
BUILD = ./build
CSOURCES = $(BUILD)/$(BIN).tab.c \
			  $(BUILD)/$(BIN).tab.h \
			  $(BUILD)/lex.yy.c
C_DBG_SOURCES = $(BUILD)/$(BIN).dbg.tab.c \
					 $(BUILD)/$(BIN).dbg.tab.h \
					 $(BUILD)/lex.dbg.yy.c
LSOURCES = $(SRC)/mupf.l
YSOURCES = $(SRC)/mupf.y

CC = gcc
CFLAGS_REL = -O2
CFLAGS_DBG		= -g -Og -Wall -Wextra --std=c99 --pedantic

YACC = bison
YFLAGS_REL = -d --color=yes --warnings=all --locations
YFLAGS_DBG = -d --color=yes -t --warnings=all \
				 -g --html=build/out/graph.html \
				 --locations --file-prefix=dbg \
				 --report=all, --report-file=build/out/report
# Flags:
# 	-d		Produce header
# 	-t		Debug information
# 	-g		Produce graph
# 	-r		Report
# 	-v		Verbose

LEX = lex
LFLAGS_REL =
#LFLAGS_DBG = -d -T

.PHONY: all run dbg clean
.SILENT: clean


all: $(BIN)

dbg:
	$(LEX)   $(LFLAGS_DBG)	-o $(BUILD)/lex.dbg.yy.c   	$(LSOURCES)
	$(YACC)  $(YFLAGS_DBG)	-o $(BUILD)/$(BIN).dbg.tab.c	$(YSOURCES)
	$(CC)		$(CFLAGS_DBG)	-o $(DBG_BIN)						$(C_DBG_SOURCES)

# Release
$(BIN): $(CSOURCES)
	$(CC)		$(CFLAGS_REL)	-o		$(BIN)	$(CSOURCES)

$(CSOURCES): $(LSOURCES) $(YSOURCES)
	$(LEX)	$(LFLAGS_REL)	-o		$(BUILD)/lex.yy.c			$(LSOURCES)
	$(YACC)	$(YFLAGS_REL)	-o		$(BUILD)/$(BIN).tab.c	$(YSOURCES)

$(LSOURCES) $(YSOURCES):
	echo "Source files not found"

# Clean
clean:
	rm -f $(BIN) $(DBG_BIN)
	rm -rf $(BUILD)/*
	mkdir $(BUILD)/out



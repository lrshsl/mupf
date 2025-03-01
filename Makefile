MUPF_SOURCE = examples/addition.mupf

BIN = mupf
DBGBIN = mupf_dbg
SRC = ./src
BUILD = ./build
OUTDIR = $(BUILD)/out
CSOURCES = $(BUILD)/$(BIN).tab.c \
			  $(BUILD)/lex.yy.c \
			  $(wildcard src/*.c)
C_DBG_SOURCES = $(BUILD)/$(BIN).dbg.tab.c \
					 $(BUILD)/lex.dbg.yy.c \
					 $(wildcard src/*.c)
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
				 --report=all, --report-file=$(OUTDIR)/report \
				 -Wcounterexamples -v
# Flags:
# 	-d		Produce header
# 	-t		Debug information
# 	-g		Produce graph
# 	-r		Report
# 	-v		Verbose

LEX = flex
LFLAGS_REL =
#LFLAGS_DBG = -d -T

.PHONY: all run dbg clean
.SILENT: clean


all: $(BIN)

run: $(DBGBIN)
	./$(DBGBIN)

dbg: $(DBGBIN)
debug: $(DBGBIN)
release: $(BIN)

$(DBGBIN): $(LSOURCES) $(YSOURCES) $(BUILD) $(OUTDIR)
	$(LEX)   $(LFLAGS_DBG)	-o $(BUILD)/lex.dbg.yy.c   	$(LSOURCES)
	$(YACC)  $(YFLAGS_DBG)	-o $(BUILD)/$(BIN).dbg.tab.c	$(YSOURCES)
	$(CC)		$(CFLAGS_DBG)	-o $@                         $(C_DBG_SOURCES)

# Release
$(BIN): $(CSOURCES)
	$(CC)		$(CFLAGS_REL)	-o		$(BIN)	$(CSOURCES)

$(CSOURCES): $(LSOURCES) $(YSOURCES) $(BUILD)
	$(LEX)	$(LFLAGS_REL)	-o		$(BUILD)/lex.yy.c			$(LSOURCES)
	$(YACC)	$(YFLAGS_REL)	-o		$(BUILD)/$(BIN).tab.c	$(YSOURCES)

$(OUTDIR):
	@mkdir -p $@

$(BUILD):
	@mkdir -p $@

$(LSOURCES) $(YSOURCES):
	echo "Source files not found: $(LSOURCES) and $(YSOURCES) are needed"

# Clean
clean:
	rm -f $(BIN) $(DBG_BIN)
	rm -rf $(BUILD)/*



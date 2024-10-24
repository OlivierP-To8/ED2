#
# Makefile for exomizer
#
WFLAGS = -Wall -Wstrict-prototypes
CFLAGS = $(WFLAGS) -O2 -ffast-math -fomit-frame-pointer -fgcse -pedantic
LDFLAGS = -s

SHARED_OBJS = getflag.o log.o membuf.o
RAW_OBJS = match.o search.o exo_raw.o optimal.o output.o membuf_io.o \
           chunkpool.o radix.o exo_helper.o exodec.o progress.o exo_util.o \
           vec.o
ALL_OBJS = $(RAW_OBJS) $(SHARED_OBJS)

#.SILENT:

.PHONY: build clean

build: $(MAKEFILE) exoraw

exoraw: $(RAW_OBJS) $(SHARED_OBJS)
	@echo "Linking $@"
	@$(CC) $(LDFLAGS) -o $@ $(RAW_OBJS) $(SHARED_OBJS)

clean:
	@echo "Cleaning project"
	-@$(RM) $(RAW_OBJS) $(SHARED_OBJS)
	-@$(RM) exoraw

%.o:	%.c
	@echo "Compiling $<"
	@$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

%:	%.o
	@$(CC) $(LDFLAGS) $< -o $@

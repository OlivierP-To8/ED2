# define anything system specific here
#
# set these variables if needed
# PROGSUFFIX: suffix added to binaries
# BUILDTPREFIX: prefix added to build utilities (cc, etc.) for xcompile
# can also set them when invoking "make"
#PROGSUFFIX := .exe
#BUILDTPREFIX=i586-mingw32msvc-

# this are probably pointless but they will make sure
# the variables are set without overriding the environment
# or automatic values from make itself.
CC ?= cc
AR ?= ar
RANLIB ?= ranlib

# Set variables for cross compiling
ifneq ($(BUILDTPREFIX),)
CC := $(BUILDTPREFIX)$(CC)
AR := $(BUILDTPREFIX)$(AR)
RANLIB := $(BUILDTPREFIX)$(RANLIB)
endif

CPPFLAGS += -I lwlib -Icommon
CPPFLAGS += -DPREFIX=$(PREFIX) -DLWCC_LIBDIR=$(LWCC_LIBDIR)
CPPFLAGS += -DPROGSUFFIX=$(PROGSUFFIX)
LDFLAGS += -Llwlib -llw

# The format truncation warnings are bleeping stupid when applied to
# snprintf() and friends. I'm using snprintf() precisely to prevent
# overflows and I don't care if the string is truncated, so why should
# I need to test the return value? Bleeping stupid.

# -O3 breaks the build on some compiler/system targets so default to
# -O2 which seems okay for now. Ideally identifying what breaks at
# -O3 is indicated, but so far, identifying the specific source of
# the breakage has been problematic.
CFLAGS ?= -O2 -Wno-char-subscripts -Wno-format-truncation

MAIN_TARGETS := lwasm/lwasm$(PROGSUFFIX)

.PHONY: default
default: $(MAIN_TARGETS)

.PHONY: all
all: $(MAIN_TARGETS) $(SECONDARY_TARGETS)

lwlib_srcs := lw_alloc.c lw_realloc.c lw_free.c lw_error.c lw_expr.c \
	lw_stack.c lw_string.c lw_stringlist.c lw_cmdline.c lw_strbuf.c \
	lw_strpool.c lw_dict.c
lwlib_srcs := $(addprefix lwlib/,$(lwlib_srcs))

lwasm_srcs := cycle.c debug.c input.c insn_bitbit.c insn_gen.c insn_indexed.c \
	insn_inh.c insn_logicmem.c insn_rel.c insn_rlist.c insn_rtor.c insn_tfm.c \
	instab.c list.c lwasm.c macro.c main.c os9.c output.c pass1.c pass2.c \
	pass3.c pass4.c pass5.c pass6.c pass7.c pragma.c pseudo.c section.c \
	strings.c struct.c symbol.c symdump.c unicorns.c
lwasm_srcs := $(addprefix lwasm/,$(lwasm_srcs))

lwasm_objs := $(lwasm_srcs:.c=.o)
lwlib_objs := $(lwlib_srcs:.c=.o)

lwasm_deps := $(lwasm_srcs:.c=.d)
lwlib_deps := $(lwlib_srcs:.c=.d)

.PHONY: lwlink lwasm lwar lwobjdump lwcc
lwasm: lwasm/lwasm$(PROGSUFFIX)

lwasm/lwasm$(PROGSUFFIX): $(lwasm_objs) lwlib
	@echo Linking $@
	@$(CC) -o $@ $(lwasm_objs) $(LDFLAGS)
	cp lwasm/lwasm ..

#.PHONY: lwlib
.INTERMEDIATE: lwlib
lwlib: lwlib/liblw.a

lwlib/liblw.a: $(lwlib_objs)
	@echo Linking $@
	@$(AR) rc $@ $(lwlib_objs)
	@$(RANLIB) $@

alldeps := $(lwasm_deps) $(lwlib_deps)

-include $(alldeps)

extra_clean := $(extra_clean) *~ */*~

%.o: %.c
	@echo "Building dependencies for $@"
	@$(CC) -MM $(CPPFLAGS) -o $*.d $<
	@mv -f $*.d $*.d.tmp
	@sed -e 's|.*:|$*.o $*.d:|' < $*.d.tmp > $*.d
	@sed -e 's/.*://' -e 's/\\$$//' < $*.d.tmp | fmt -1 | sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
	@rm -f $*.d.tmp
	@echo Building $@
	@$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

.PHONY: clean
clean: $(cleantargs)
	@echo "Cleaning up"
	@rm -f lwlib/liblw.a lwasm/lwasm$(PROGSUFFIX)
	@rm -f $(lwasm_objs) $(lwlib_objs)
	@rm -f $(extra_clean)
	@rm -f */*.exe
	@echo "Cleaning up even more"
	@rm -f $(lwasm_deps) $(lwlib_deps)

.PHONY: test
test: all test/runtests
	@test/runtests


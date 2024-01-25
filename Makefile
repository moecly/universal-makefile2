project := demo

PHONY := _all 
_all: all

srctree := .
objtree := .
export srctree objtree

# Set libs
libs-y :=
libs-y += src/
libs-y := $(sort $(libs-y))
libs   = $(patsubst %/, %/built-in.o, $(libs-y))
libs-dirs = $(patsubst %/, %, $(filter %/, $(libs-y)))

# Set lib gcc
libgcc := 

# Set inc gcc
incgcc := 
incgcc += -Iinc

scripts/Kbuild.include: ;
include scripts/Kbuild.include

# Make variables (CC, etc...)
CROSS_COMPILE := 
AS		= $(CROSS_COMPILE)as
LD		= $(CROSS_COMPILE)ld
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
NM		= $(CROSS_COMPILE)nm
LDR		= $(CROSS_COMPILE)ldr
STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump
export CROSS_COMPILE AS LD CC CPP AR NM LDR STRIP OBJCOPY OBJDUMP

# Set compiler
KBUILD_CFLAGS 	:= -Wall -Wextra -fPIC $(incgcc)
KBUILD_CPPFLAGS := -E $(KBUILD_CFLAGS)
KBUILD_AFLAGS 	:= 
KBUILD_LDLAGS 	:= -L./lib
KBUILD_ARFLAGS  :=
export KBUILD_CFLAGS KBUILD_CPPFLAGS KBUILD_AFLAGS KBUILD_LDLAGS KBUILD_ARFLAGS

cpp_flags := $(KBUILD_CPPFLAGS)
c_flags := $(KBUILD_CFLAGS)

# If KBUILD_VERBOSE equals 0 then the above command will be hidden.
# If KBUILD_VERBOSE equals 1 then the above command is displayed.
#
# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands
ifeq ("$(origin V)", "command line")
	KBUILD_VERBOSE = $(V)
endif
ifndef KBUILD_VERBOSE
	KBUILD_VERBOSE = 0
endif

ifeq ($(KBUILD_VERBOSE),1)
	quiet =
	Q =
else
	quiet = quiet_
	Q = @
endif
export quiet Q 

ifeq ($(KBUILD_EXTMOD),)
	build-dir  = $(patsubst %/,%,$(dir $@))
	target-dir = $(dir $@)
else
	zap-slash=$(filter-out .,$(patsubst %/,%,$(dir $@)))
	build-dir  = $(KBUILD_EXTMOD)$(if $(zap-slash),/$(zap-slash))
	target-dir = $(if $(KBUILD_EXTMOD),$(dir $<),$(dir $@))
endif

PHONY += all
all: compiler

PHONY += compiler
compiler: $(libs-dirs)
	$(Q)$(CC) $(c_flags) -o $(project) $(libs) 

$(libs-dirs): FORCE
	$(Q)$(MAKE) $(build)=$@

PHONY += clean
clean:
	$(call cmd,clean_files)

quiet_cmd_clean_files = CLEAN      $@
cmd_clean_files = find -name *.o | xargs rm -rf; \
	rm $(project) -rf;

PHONY += FORCE
FORCE:

.PHONY: $(PHONY)

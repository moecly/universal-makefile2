project := demo

PHONY := _all 
_all: all

srctree := .
objtree := .
export srctree objtree

custom_c_flag   := -Wno-unused-variable -Wno-unused-function 
custom_cpp_flag := -Wno-unused-variable -Wno-unused-function 
custom_a_flag   :=
custom_ld_flag  :=
custom_ar_flag  :=

# Set build libs
libs-y    :=
libs-y    += src/
libs-y    := $(sort $(libs-y))
libs      = $(patsubst %/, %/built-in.o, $(libs-y))
libs-dirs = $(patsubst %/, %, $(filter %/, $(libs-y)))

# Set inc headers
inch :=
inch += inc/
inch := $(sort $(inch))
inch := $(foreach inc,$(inch),-I$(inc))

# Set inc libs
incl := 
incl += lib/
incl := $(sort $(incl))
incl := $(foreach inc,$(incl),-L$(inc))

# Set use libs
uselibs := 
uselibs += 
uselibs := $(sort $(uselibs))
uselibs := $(foreach lib,$(uselibs),-l$(lib))

custom_c_flag   += $(inch) $(incl) $(uselibs)
custom_cpp_flag += $(inch) $(incl) $(uselibs)

scripts/Kbuild.include: ;
include scripts/Kbuild.include

# Make variables (CC, etc...)
CROSS_COMPILE := 
AS			  = $(CROSS_COMPILE)as
LD			  = $(CROSS_COMPILE)ld
CC			  = $(CROSS_COMPILE)gcc
CPP			  = $(CROSS_COMPILE)g++
AR			  = $(CROSS_COMPILE)ar
NM			  = $(CROSS_COMPILE)nm
LDR			  = $(CROSS_COMPILE)ldr
STRIP		  = $(CROSS_COMPILE)strip
OBJCOPY		  = $(CROSS_COMPILE)objcopy
OBJDUMP		  = $(CROSS_COMPILE)objdump
export CROSS_COMPILE AS LD CC CPP AR NM LDR STRIP OBJCOPY OBJDUMP

# Set compiler
KBUILD_CFLAGS 	:= -fstack-usage -Wall -Wextra -fPIC $(custom_c_flag)
KBUILD_CPPFLAGS := -fstack-usage -Wall -Wextra -fPIC $(custom_cpp_flag)
KBUILD_AFLAGS 	:= $(custom_a_flag)
KBUILD_LDFLAGS 	:= $(custom_ld_flag)
KBUILD_ARFLAGS  := cDPrsT$(custom_ar_flag)

export KBUILD_CFLAGS KBUILD_CPPFLAGS KBUILD_AFLAGS KBUILD_LDFLAGS KBUILD_ARFLAGS

c_flags   := $(KBUILD_CFLAGS)
cpp_flags := $(KBUILD_CPPFLAGS)
a_flags   := $(KBUILD_AFLAGS)
ld_flags  := $(KBUILD_LDFLAGS)
ar_flags  := $(KBUILD_ARFLAGS)

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

PHONY += all
all: $(project)

$(project): link-libs
	$(call cmd,build_obj)

PHONY += link-libs
link-libs: $(libs-dirs)
	$(call cmd,link_libs)

$(libs-dirs): FORCE
	$(Q)$(MAKE) $(build)=$@

PHONY += clean-libs
clean-libs: 
	$(Q)$(foreach dir, $(libs-dirs), $(MAKE) $(clean)=$(dir);)

PHONY += clean-build
clean-build: 
	$(call cmd,clean_build)

clean-link-libs:
	$(call cmd,clean_link_libs)

PHONY += clean
clean: clean-link-libs clean-libs clean-build

quiet_cmd_link_libs = AR        $@
cmd_link_libs 		= $(AR) $(ar_flags) -o lib$(project).a $(libs)

quiet_cmd_build_obj = BUILD     $@
cmd_build_obj 		= $(CPP) -o $(project) -L. -l$(project) $(cpp_flags) 

quiet_cmd_clean_link_libs = CLEAN     link-libs
cmd_clean_link_libs 	  = rm lib$(project).a -f;

quiet_cmd_clean_build = CLEAN     $(project)
cmd_clean_build 	  = rm $(project) -f;

PHONY += FORCE
FORCE:

.PHONY: $(PHONY)

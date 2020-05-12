OUT ?= index.html

OUTD ?= bin
OBJD ?= obj
SRCD ?= src

SRCS := $(shell find $(SRCD) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:$(SRCD)/%=$(OBJD)/%.bc)
DEPS := $(OBJS:.bc=.d)

INC_DIRS := $(shell find $(SRCD) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -s USE_SDL=2
LDFLAGS ?= -s USE_SDL=2
DEBUG_FLAGS = --js-opts 0 -g4 --source-map-base / --emrun

build: $(OUTD)/$(OUT)

DEBUG: CPPFLAGS += $(DEBUG_FLAGS)
DEBUG: LDFLAGS += $(DEBUG_FLAGS)
DEBUG: build $(OUTD)/$(SRCD)/

$(OUTD)/$(OUT): $(OBJS)
	$(MKDIR_P) $(@D)
	$(LINK.o) $(OBJS) $(LOADLIBES) $(LDLIBS) -o $@

$(OUTD)/$(SRCD)/:
	ln -srf $(SRCD) $(OUTD)

# assembly
$(OBJD)/%.s.bc: $(SRCD)/%.s
	$(MKDIR_P) $(@D)
	$(COMPILE.s) $< $(OUTPUT_OPTION)

# c source
$(OBJD)/%.c.bc: $(SRCD)/%.c
	$(MKDIR_P) $(@D)
	$(COMPILE.c) $< $(OUTPUT_OPTION)

# c++ source
$(OBJD)/%.cpp.bc: $(SRCD)/%.cpp
	$(MKDIR_P) $(@D)
	$(COMPILE.cpp) $< $(OUTPUT_OPTION)

.PHONY: clean build rebuild

rebuild: clean build
clean: clean_obj clean_out

clean_obj:
	$(RM) -r $(OBJD)

clean_out:
	$(RM) -r $(OUTD)

-include $(DEPS)

MKDIR_P ?= mkdir -p
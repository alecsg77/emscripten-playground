OUT ?= index.html

OUTD ?= bin
OBJD ?= obj
SRCD ?= src

SRCS := $(shell find $(SRCD) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:$(SRCD)/%=$(OBJD)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRCD) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -s USE_SDL=2

$(OUTD)/$(OUT): $(OBJS)
	$(MKDIR_P) $(@D)
	$(LINK.o) $(OBJS) -o $@ $(LDFLAGS)

# assembly
$(OBJD)/%.s.o: $(SRCD)/%.s
	$(MKDIR_P) $(@D)
	$(COMPILE.s) $< $(OUTPUT_OPTION)

# c source
$(OBJD)/%.c.o: $(SRCD)/%.c
	$(MKDIR_P) $(@D)
	$(COMPILE.c) $< $(OUTPUT_OPTION)

# c++ source
$(OBJD)/%.cpp.o: $(SRCD)/%.cpp
	$(MKDIR_P) $(@D)
	$(COMPILE.cpp) $< $(OUTPUT_OPTION)

.PHONY: clean

clean:
	$(RM) -r $(OBJD) $(OUTD)

-include $(DEPS)

MKDIR_P ?= mkdir -p
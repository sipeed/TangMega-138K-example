ROOT := $(shell pwd)

COMPILER_PREFIX ?= riscv-none-embed

# Define option(s) defined in pre-processor compiler option(s)
DEFINE_OPTS = -DDEBUG=1
# Optimisation option(s)
OPTIM_OPTS = -O3
# Debug option(s)
DEBUG = -g

SUBDIR := $(ROOT)
SUBDIR += $(ROOT)/Startup
SUBDIR += $(ROOT)/RVMSIS
SUBDIR += $(ROOT)/Peripheral
SUBDIR += $(ROOT)/CH56x_usb30
SUBDIR += $(ROOT)/User

MODE ?= bridge

ifeq ($(MODE),rx16)
TARGET := firmware_hspi_rx16
else
TARGET := firmware
endif
OUTPUT := ./output

LINK_FILE := $(ROOT)/Startup/wch56x.ld
MAP_FILE := $(OUTPUT)/$(TARGET).map
ELF_FILE := $(OUTPUT)/$(TARGET).elf
HEX_FILE := $(OUTPUT)/$(TARGET).hex
BIN_FILE := $(OUTPUT)/$(TARGET).bin
LST_FILE := $(OUTPUT)/$(TARGET).lst
SIZ_FILE := $(OUTPUT)/$(TARGET).siz

INCS := $(foreach dir,$(SUBDIR),-I$(dir))
ifeq ($(MODE),rx16)
SRCS := $(wildcard $(ROOT)/RVMSIS/*.c)
SRCS += $(wildcard $(ROOT)/Peripheral/*.c)
SRCS += $(ROOT)/User/hspi_rx_only.c
else
SRCS := $(foreach dir,$(SUBDIR),$(wildcard $(dir)/*.c))
SRCS := $(filter-out $(ROOT)/User/hspi_rx_only.c,$(SRCS))
endif
ASMS := $(foreach dir,$(SUBDIR),$(wildcard $(dir)/*.S))
OBJS := $(patsubst $(ROOT)/%.c,$(OUTPUT)/%.o,$(SRCS))
OBJS += $(patsubst $(ROOT)/%.S,$(OUTPUT)/%.o,$(ASMS))
DEPS := $(patsubst %.o,%.d,$(OBJS))
ifeq ($(MODE),rx16)
LIBS :=
else
# The USB3 and HSPI data path is built entirely from source.
LIBS := $(foreach dir,$(SUBDIR),$(wildcard $(dir)/*.a))
endif

BASE_OPTS = -march=rv32imac -mabi=ilp32\
			-msmall-data-limit=8 $(OPTIM_OPTS)\
			-fmessage-length=0 -fsigned-char\
			-ffunction-sections -fdata-sections
C_OPTS    = $(DEBUG) $(DEFINE_OPTS)\
			$(INCS)\
			-std=gnu99\
			-MMD -MP -MT"$(@)"
LD_OPTS   = -T "$(LINK_FILE)"\
			-nostartfiles\
			-Xlinker --gc-sections\
			-Xlinker --print-memory-usage\
			-Wl,-Map,"$(MAP_FILE)"\
			--specs=nano.specs\
			--specs=nosys.specs

$(OUTPUT)/%.o : %.c
		@echo compile $<...
		@mkdir -p $(dir $@)
		@$(COMPILER_PREFIX)-gcc $(BASE_OPTS) $(C_OPTS) -c -o $@ $<

$(OUTPUT)/%.o : %.S
		@echo compile $<...
		@mkdir -p $(dir $@)
		@$(COMPILER_PREFIX)-gcc $(BASE_OPTS) -c -o $@ $<


$(ELF_FILE) : $(OBJS)
	@echo 'Invoking: GNU RISC-V Cross C Linker'
	@$(COMPILER_PREFIX)-gcc $(BASE_OPTS) $(LD_OPTS) -o $@ $(OBJS) $(LIBS)
	@echo complete!

$(HEX_FILE): $(ELF_FILE)
	@echo 'Invoking: GNU RISC-V Cross Create Flash Image'
	$(COMPILER_PREFIX)-objcopy -O ihex $< $@
	@echo ' '

$(BIN_FILE): $(ELF_FILE)
	-@echo 'Invoking: GNU RISC-V Cross Create Flash Image BIN'
	-$(COMPILER_PREFIX)-objcopy -O binary $< $@
	-@echo ' '

$(LST_FILE): $(ELF_FILE)
	@echo 'Invoking: GNU RISC-V Cross Create Listing'
	$(COMPILER_PREFIX)-objdump --source --all-headers --demangle --line-numbers --wide $< > $@
	@echo ' '

$(SIZ_FILE): $(ELF_FILE)
	@echo 'Invoking: GNU RISC-V Cross Print Size'
	$(COMPILER_PREFIX)-size --format=berkeley $<
	@echo ' '


# All Target
all: $(ELF_FILE)\
		$(HEX_FILE)  $(BIN_FILE)\
		$(LST_FILE)\
		$(SIZ_FILE)

clean:
		@echo try to clean...
		@rm -rf $(OUTPUT)
		@echo clean complete!

.PHONY: all clean
-include $(DEPS)

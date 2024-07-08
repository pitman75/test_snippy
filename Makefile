GCC_DIR = ~/.local/xPacks/riscv-none-elf-gcc/xpack-riscv-none-elf-gcc-13.2.0-2/bin
TOOL_NAME = riscv-none-elf-
OBJDUMP = objdump
OBJCOPY = objcopy
LD      = ld
AS      = as
START_FILE = _start
MARCH = rv32i_zicsr
MABI = ilp32
SPIKE_DIR = ~/bin/
CURRENT_DIR := $(shell pwd)
TESTS_DIR = tests
YAML_LIST := $(wildcard ./$(TESTS_DIR)/*.yaml)
YAML_TESTS:= $(notdir $(YAML_LIST))
YAML_NAME := $(basename $(YAML_TESTS))

docker:
	docker build ./ --tag llvm-snippy

test:
	$(GCC_DIR)/$(TOOL_NAME)$(AS) -march=$(MARCH) -mabi=$(MABI) $(TESTS_DIR)/$(START_FILE).S -o $(TESTS_DIR)/$(START_FILE).o
	@$(foreach file, $(YAML_NAME), \
		echo "[LOG] Generate test for a file: $(file)" ; \
		docker run --network none -it -v $(CURRENT_DIR)/$(TESTS_DIR):/app/snippy llvm-snippy /usr/bin/llvm-snippy --riscv-disable-misaligned-access ./$(file).yaml --dump-registers-yaml=$(file)_regs_final.yaml; \
		$(GCC_DIR)/$(TOOL_NAME)$(LD) -T $(TESTS_DIR)/link.ld $(TESTS_DIR)/$(START_FILE).o $(TESTS_DIR)/$(file).elf -o $(TESTS_DIR)/$(file) ; \
		$(GCC_DIR)/$(TOOL_NAME)$(OBJDUMP) -D $(TESTS_DIR)/$(file) > $(TESTS_DIR)/$(file).objdump ; \
		$(GCC_DIR)/$(TOOL_NAME)$(OBJCOPY) -O verilog --verilog-data-width 4 -j .text.init -j .text -j .snippy.text.rx --gap-fill=0x00 $(TESTS_DIR)/$(file) $(TESTS_DIR)/$(file)_rom_init.tmp ; \
		grep -v "^@" $(TESTS_DIR)/$(file)_rom_init.tmp > $(TESTS_DIR)/$(file)_rom_init.mem ; \
		rm -f $(TESTS_DIR)/$(file)_rom_init.tmp ; \
		$(GCC_DIR)/$(TOOL_NAME)$(OBJCOPY) -O verilog --verilog-data-width 4 -j .rodata -j .srodata.cst8 -j .eh_frame -j .data -j .sdata -j .bss -j .snippy.data.rw -j .snippy.stack.rw -j .sbss --gap-fill=0x00 --pad-to 0x20008000 $(TESTS_DIR)/$(file) $(TESTS_DIR)/$(file)_ram_init.tmp ; \
		grep -v "^@" $(TESTS_DIR)/$(file)_ram_init.tmp > $(TESTS_DIR)/$(file)_ram_init.mem ; \
		rm -f $(TESTS_DIR)/$(file)_ram_init.tmp ; \
		$(SPIKE_DIR)spike  --isa=RV32I_zicsr --priv=m -m0x20000000:0x8000,0x20100000:0x1000,0x80000000:0x100000 -d --debug-cmd=spike.cmd --log-commits -l --log=$(TESTS_DIR)/$(file)_spike_run.txt $(TESTS_DIR)/$(file) ; \
	)	

clean:
	@$(foreach file, $(YAML_NAME), \
		echo "[LOG] Remove test file: ./$(TESTS_DIR)/$(file)" ; \
		rm -f ./$(TESTS_DIR)/$(file) ; \
	)
	rm -f ./$(TESTS_DIR)/*_spike_run.txt
	rm -f ./$(TESTS_DIR)/*.elf
	rm -f ./$(TESTS_DIR)/*.elf.ld
	rm -f ./$(TESTS_DIR)/*.objdump
	rm -f ./$(TESTS_DIR)/*.o
	rm -f ./$(TESTS_DIR)/*_rom_init.mem
	rm -f ./$(TESTS_DIR)/*_ram_init.mem

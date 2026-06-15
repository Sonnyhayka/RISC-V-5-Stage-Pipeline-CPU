# Icarus Verilog simulation flow for the RISC-V 5-stage pipeline CPU.
#
#   make test                 run the default testbench (tb_riscv_pipeline_cpu)
#   make test TB=../tb/tb_alu.v TOP=tb_alu   run a specific testbench
#   make clean                remove build artifacts

IVERILOG ?= iverilog
VVP      ?= vvp

RTL   := $(shell find ../rtl -name '*.v') ../riscv_pipeline_cpu.v
TB    ?= ../tb/tb_riscv_pipeline_cpu.v
TOP   ?= tb_riscv_pipeline_cpu
BUILD := build

$(BUILD)/$(TOP).vvp: $(RTL) $(TB)
	@mkdir -p $(BUILD)
	$(IVERILOG) -g2012 -Wall -s $(TOP) -o $@ $(RTL) $(TB)

.PHONY: test
test: $(BUILD)/$(TOP).vvp
	$(VVP) $<

.PHONY: clean
clean:
	rm -rf $(BUILD)

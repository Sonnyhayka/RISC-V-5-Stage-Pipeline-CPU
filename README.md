# RISC-V 5-Stage Pipeline CPU

A 32-bit, in-order, 5-stage pipelined processor implementing the RV32I base integer
instruction set in Verilog. The design includes full data forwarding, load-use stall
insertion, and control-hazard flushing, and is verified in simulation against a
reference model.

## Pipeline

The classic five stages, each separated by a pipeline register:

1. Instruction Fetch (IF) - program counter, instruction memory, PC+4
2. Instruction Decode (ID) - register file, control unit, immediate generation
3. Execute (EX) - ALU, branch comparator, branch/jump target
4. Memory (MEM) - data memory access with sub-word support
5. Writeback (WB) - result selection back into the register file

Hazard handling:

- Data forwarding from the MEM and WB stages into EX
- A write-first register file so a writeback feeds a same-cycle decode read
- One-cycle stall for load-use dependencies
- Flush of the two younger instructions on a taken branch or jump

## Supported instructions

The full RV32I base integer set:

- Register-register: `ADD SUB SLL SLT SLTU XOR SRL SRA OR AND`
- Register-immediate: `ADDI SLTI SLTIU XORI ORI ANDI SLLI SRLI SRAI`
- Loads: `LB LH LW LBU LHU`
- Stores: `SB SH SW`
- Branches: `BEQ BNE BLT BGE BLTU BGEU`
- Jumps: `JAL JALR`
- Upper immediates: `LUI AUIPC`

`FENCE`, `ECALL`, and `EBREAK` decode as no-ops. There is no privileged
architecture, CSRs, exceptions, or M/A/F/D extension support.

## Repository layout

```
riscv_pipeline_cpu.v          top-level module
rtl/
  fetch/      pc, pc_adder, pc_mux, instruction_memory, fetch_cycle
  decode/     register_file, extend_unit, decode_cycle
              control/ control_unit, main_decoder, alu_decoder
  execute/    alu, branch_comparator, execute_cycle
  memory/     data_memory, load_store_unit, memory_cycle
  writeback/  writeback_cycle
  hazard/     hazard_unit
tb/           testbenches and test programs
sim/          Makefile, run.sh, assembler, reference model
scripts/      Vivado project, build, and constraint files
```

## Simulation

Functional verification uses Icarus Verilog. From the repository root:

```
bash sim/run.sh
```

or with GNU make:

```
make -C sim test TB=../tb/tb_full.v TOP=tb_full
```

The suite contains:

- `tb_alu` - direct test of every ALU operation
- `tb_baseline` - the basic arithmetic program
- `tb_full` - a program exercising every instruction class, byte and halfword
  memory access, the load-use stall, and the branch/jump flush. The final
  register file is compared against a reference model for all 32 registers.

## Writing test programs

`sim/assemble.py` assembles an RV32I program to a hex image, and `sim/rv32i_ref.py`
runs the same program through a functional reference model to produce the expected
register state:

```
python sim/assemble.py tb/programs/full.s tb/programs/full.hex
python sim/rv32i_ref.py tb/programs/full.s tb/programs/full_expected.hex
```

A testbench loads the image into instruction memory with `$readmemh` and compares
the resulting register file against the expected values.

## FPGA synthesis

`scripts/create_project.tcl` builds a Vivado project for the new source layout and
`scripts/build_and_test.tcl` runs synthesis and implementation. `scripts/constraints.xdc`
provides a 100 MHz clock constraint and commented pin assignments for common Artix-7
boards. The default part is `xc7a35tcpg236-1`; change it for your target.

## Memory configuration

- Instruction memory: 1024 words, word-addressed, loadable via `$readmemh`
- Data memory: 256 words by default (`memory_cycle` parameter `MEM_DEPTH`), with
  per-byte write strobes for sub-word stores

## References

- RISC-V Instruction Set Manual, Volume I: Unprivileged ISA
- Harris and Harris, Digital Design and Computer Architecture, RISC-V Edition

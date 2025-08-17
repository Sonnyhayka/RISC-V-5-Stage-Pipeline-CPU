# RISC 5 Stage CPU

## Overview
This project implements a RISC style CPU using the classic 5 stage pipeline found in many computer architecture courses. The design focuses on clarity for learning while still demonstrating pipelining, hazard detection, and data forwarding.

## Architecture
Instruction flows through the five stages shown below.

    IF → ID → EX → MEM → WB
       │     │     │     │
       ▼     ▼     ▼     ▼
    IF/ID  ID/EX  EX/MEM MEM/WB    (pipeline registers)

Stages  
1. Instruction Fetch IF  fetch from program memory  
2. Instruction Decode ID  read registers and decode control  
3. Execute EX  ALU ops branch compare address calc  
4. Memory MEM  data memory read or write  
5. Write Back WB  write result to register file

## Features
* Instruction subset inspired by MIPS  add sub and or xor slt lui addi andi ori xori lw sw beq bne j jr jal
* Register file with 32 general purpose registers  x0 is hardwired to zero
* ALU supports integer arithmetic logical shifts and comparisons
* Forwarding unit for EX and MEM sources to reduce stalls
* Hazard detection unit for load use and control hazards with safe stalling and flushing
* Separate instruction and data memories for simple Harvard style simulation
* Modular Verilog design  each stage and support unit is its own module
* Synthesizable RTL  suitable for FPGA labs  a simple top is provided for boards like Basys 3
* Self checking testbench and example programs

## Repository Layout
    /src
      alu.v
      control.v
      hazard_unit.v
      forwarding_unit.v
      register_file.v
      instruction_memory.v
      data_memory.v
      pipeline_regs.v
      branch_unit.v
      cpu_core.v
      cpu_top.v
    /testbench
      cpu_tb.v
      program_mem_init.mem
    /docs
      architecture_diagram.png
      instruction_set.md
    /scripts
      build_modelsim.do
      build_vivado.tcl

## Quick Start
1. Clone the repo

        git clone https://github.com/<your-username>/RISC-V-5-Stage-Pipeline-CPU.git
        cd RISC-V-5-Stage-Pipeline-CPU

2. Run the testbench in your simulator

   ModelSim or Questa

        vlog src/*.v testbench/cpu_tb.v
        vsim work.cpu_tb
        run 1 ms

   Vivado xsim

        xvlog src/*.v testbench/cpu_tb.v
        xelab cpu_tb
        xsim work.cpu_tb

   Icarus Verilog

        iverilog -o cpu_tb.vvp src/*.v testbench/cpu_tb.v
        vvp cpu_tb.vvp

3. View waves  add these for a good first look

        cpu_tb.dut.pc
        cpu_tb.dut.if_id_*
        cpu_tb.dut.id_ex_*
        cpu_tb.dut.ex_mem_*
        cpu_tb.dut.mem_wb_*
        cpu_tb.dut.regfile.regs
        cpu_tb.dut.alu.result
        cpu_tb.dut.data_memory.mem

4. Load your own program  edit testbench/program_mem_init.mem  one 32 bit hex word per line  comment lines start with semicolon

        ; example
        20080005
        21090003
        01095020

   Or modify src/instruction_memory.v to point at a different mem file

## Running On FPGA optional
* Set cpu_top as the synthesis top
* Map clock and reset pins plus a UART or LEDs as desired
* For Basys 3 provide 100 MHz clock and active high reset  adapt in cpu_top if needed

## Hazard Policy summary
* Data hazards
  * Forward EX or MEM results into EX stage when possible
  * Insert one stall bubble for load use when forwarding cannot satisfy timing
* Control hazards
  * Resolve branch in EX
  * Flush IF and ID on taken branch or jump

## Verification
* Unit tests for ALU register file and control
* End to end programs cover arithmetic memory and branches
* The testbench reports pass at end of simulation when the result signature matches

## Design Notes
* x0 is constant zero  writes to x0 are ignored
* Instruction and data memory use single cycle access in simulation
* Parameterizable widths  default is 32 bit data and addresses
* No exceptions or interrupts yet
* Branches are resolved in EX with a one cycle penalty on taken branches

## Roadmap
* Multiply divide and barrel shifter
* Compressed or immediate rich instructions
* Early branch and simple static predictor
* Instruction and data caches with ready valid handshake
* Minimal assembler and loader script

## Contributing
* Open an issue for bugs or feature requests
* Use a topic branch and a clear commit message style
* Include a waveform or log that shows the fix or failure

## License
MIT  see LICENSE

## Acknowledgments
Based on standard 5 stage teaching cores and course labs  written for learning and recruiting demos

---

## Logic Verification Summary

**Data hazards and forwarding**  
* Forwarding supplies operands from EX MEM and MEM WB back to EX when source registers match recent destinations and RegWrite is asserted  
* Load use hazard is detected when an instruction in ID needs the destination of a load currently in EX  the hazard unit stalls PC and IF ID for one cycle and injects a bubble into ID EX  on the next cycle the needed value can be forwarded from MEM

**Control hazards**  
* Branch and jump are resolved in EX  
* When taken  the design flushes IF and ID so wrong path instructions do not execute  
* PC is updated to the target in the same cycle so fetch resumes from the correct address  this creates a one cycle penalty on taken control flow changes

**Priority and correctness**  
* Flush on a taken branch has priority over a data stall in that cycle  avoiding redundant control actions  
* Register x0 always reads as zero and ignores writes which guarantees architectural zero regardless of pipeline timing  
* Forwarding gives priority to the newest available result  EX MEM over MEM WB  ensuring most recent data reaches the ALU

**Conclusion**  
The pipeline control matches a classic five stage implementation  forwarding removes most stalls  a single bubble covers the load use case  and taken branches are handled by flushes from EX  This aligns with the stated hazard policy and feature set

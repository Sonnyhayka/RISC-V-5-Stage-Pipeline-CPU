# RISC-V 5-Stage Pipeline CPU

This project implements a 32-bit 5-stage pipelined CPU based on the RISC-V architecture (RV32I instruction set). The design is written in Verilog and follows the classic five pipeline stages: **Instruction Fetch (IF)**, **Instruction Decode (ID)**, **Execute (EX)**, **Memory Access (MEM)**, and **Write Back (WB)**. The CPU is targeted for FPGA implementation using Xilinx Vivado, and can also be simulated to verify functionality.

## Project Overview

- **Architecture:** Implements the base RV32I RISC-V instruction set (Integer operations and basic loads/stores and branches). The CPU is structured into five stages with pipeline registers between them for high throughput.
- **Pipeline Stages:**
  - *IF (Instruction Fetch):* Fetches the 32-bit instruction from instruction memory and calculates the address of the next instruction (PC + 4). Includes a Program Counter (PC) register and an instruction memory (acting as instruction ROM).
  - *ID (Instruction Decode):* Decodes the fetched instruction. Reads source registers from the register file, sign-extends immediate values, and generates control signals via the control unit (which consists of the main decoder and ALU control logic).
  - *EX (Execute):* Performs ALU operations or address calculations. This stage executes arithmetic and logic instructions using the ALU, computes memory addresses for loads/stores, and evaluates branch conditions (e.g., compares registers for a BEQ).
  - *MEM (Memory Access):* Accesses data memory for load and store instructions. On a load, it retrieves data from data memory; on a store, it writes data to memory.
  - *WB (Write Back):* Writes the result of an instruction back to the register file (either an ALU result or loaded data from memory). This stage completes the execution of instructions by updating registers.
- **Hazard Handling:** The design will include forwarding (bypassing) and stalling logic to handle data hazards. For instance, if an instruction needs a result that isn’t written back yet, the forwarding unit will route the data from a later pipeline stage to an earlier one. A hazard detection unit inserts pipeline stalls (bubbles) when necessary (for example, on a load-use hazard where forwarding cannot resolve the dependency in the same cycle). Branch hazards are handled by flushing instructions that were fetched speculatively after a taken branch.
- **Branching:** Branch instructions (e.g., BEQ, BNE, JAL, JALR) are supported. The CPU computes branch target addresses and decides whether to take a branch in the EX stage. If a branch is taken, the instructions in the pipeline that were fetched after the branch will be flushed, and the PC will be updated to the branch target. (No advanced branch prediction is used in this basic design – it uses a simple flush on take.)
- **Module Structure:** The project is organized by pipeline stage:
  - *Instruction Fetch* stage modules: `pc.v` (Program Counter register), `PCAdder.v` (PC + 4 adder), `PXMux.v` (PC selection multiplexer for branch/jump), `instruction_memory.v` (ROM for instructions), and `fetch_cycle.v` (top-level IF stage logic).
  - *Instruction Decode* stage modules: `registerFile.v` (32x32-bit register file), `extendUnit.v` (Immediate value sign extender), and the Control Unit which includes `mainDecoder.v` (opcode decoder for main control signals), `ALUDecoder.v` (ALU control logic), combined in `controlUnit.v`. The decode stage logic is wrapped in `instructionDecode.v`.
  - *Execute* stage modules: **(to be implemented)** e.g., an `ALU.v` for arithmetic/logic, and logic for branch evaluation and forwarding. This stage will be integrated with an `execute_cycle.v` (EX stage wrapper).
  - *Memory* stage modules: **(to be implemented)** e.g., `data_memory.v` for data RAM and a `memory_cycle.v` if needed to handle MEM stage logic.
  - *Write Back* stage: This stage is simple and handled by routing outputs to the register file. A `writeback_cycle.v` module (if created) or the MEM stage logic will directly feed the register file in the final step.
- **Current Status:** The IF and ID stages are implemented and under test, while the EX, MEM, and WB stages are in development. The pipeline control (forwarding, hazard detection, stalling, flushing) is being added to ensure correct operation under all instruction sequences.

## Features and Goals

- **RISC-V Instruction Support:** Implements the RV32I base instruction set:
  - Arithmetic & Logic: ADD, SUB, SLL, SRL, SRA, AND, OR, XOR, SLT, SLTU, with immediate variants (ADDI, ANDI, ORI, etc.).
  - Load/Store: LW (load word), SW (store word). *(Extension to byte/halfword loads/stores and unsigned variants can be added in the future.)*
  - Control Transfer: BEQ, BNE (branch equal/not equal) and other conditional branches (`BLT, BGE, BLTU, BGEU` as needed), JAL (jump and link), JALR (jump and link register). Also LUI and AUIPC for upper-immediate operations.
- **5-Stage Pipelining:** The processor fetches and executes multiple instructions simultaneously, one in each stage of the pipeline. This improves throughput, executing one instruction per clock cycle in ideal cases (after pipeline fill).
- **Hazard Mitigation:** Incorporates data forwarding and pipeline stalling. The design checks for hazards:
  - Data hazards: Forwarding logic feeds results from EX/MEM/WB back to the ALU input as needed. Load-use hazards are resolved by stalling for one cycle.
  - Control hazards: The pipeline flushes the next instruction if a branch is taken (minimizing wasted cycles to 1 flush after a branch).
- **FPGA Compatibility:** The design is written in synthesizable Verilog and can be deployed on FPGA. The memory modules (instruction and data memory) can be mapped to block RAMs. The register file uses flip-flops or inferred block RAM. 
- **Modularity:** Each stage is modular, making it easier to test and debug in isolation (e.g., you can test the ALU or the control unit separately). This also allows future upgrades (like adding an ALU multiplier for the M extension, or a branch predictor) by modifying the relevant module without large changes to others.

## Getting Started 

### Prerequisites

- **Vivado 20xx.x** (or a similar FPGA design tool supporting Verilog and your target FPGA). The project was developed with Xilinx Vivado (for example, Vivado 2021.2 or later).
- A target FPGA board (if you plan to synthesize and run on hardware). You can also use Vivado’s simulator (XSIM) for testing without hardware.

### Project Structure

Clone the repository and open the folder in VS Code or your preferred environment. Key source files are located in stage-specific subfolders:

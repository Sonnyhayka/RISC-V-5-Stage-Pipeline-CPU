# RISC-V 5-Stage Pipeline CPU — Professional Refactor + Full RV32I

**Date:** 2026-06-14
**Status:** Approved for planning

## Goal

Turn an existing, partially-complete RV32I pipeline into a professional, presentable
repository: consistent style, honest documentation, a clean layout, and a *complete,
simulation-verified* RV32I integer core. The README currently advertises instructions
the hardware does not actually execute; after this work, every claim is backed by a
passing test.

## Scope

In scope:

1. Repository reorganization into a tooling-friendly, space-free layout.
2. Uniform code style (naming, port declarations, comments) across all RTL.
3. Documentation cleanup (remove emoji icons, decorative separators, fabricated metrics).
4. Completion of the RV32I base integer ISA, including sub-word loads/stores.
5. Correctness fixes for genuine bugs (hazard stall/flush wiring, reset port mismatch,
   XOR decode).
6. A self-checking Icarus Verilog verification flow plus the retained, corrected Vivado flow.

Out of scope (documented as intentional): M/A/F/D extensions, caches, branch prediction,
exceptions/CSRs/traps. `FENCE`, `ECALL`, `EBREAK` decode to NOP and are documented as stubs.

## Sequencing

Work proceeds **refactor-first, then test-driven feature completion**:

1. Behavior-preserving cleanup (layout, naming, comments, docs). No logic changes.
2. Stand up the Icarus Verilog flow and get the *existing* program passing as a green baseline.
3. Add each instruction class as its own tested increment: write the directed test with
   expected results, implement, confirm it passes, confirm no regression.

This keeps every step independently verifiable and makes regressions obvious.

## Target Repository Layout

Moves are performed with `git mv` so history is preserved.

```
riscv_pipeline_cpu.v              # top module (renamed from 'main')
rtl/
  fetch/      pc.v  pc_adder.v  pc_mux.v  instruction_memory.v  fetch_cycle.v
  decode/     register_file.v  extend_unit.v  decode_cycle.v
              control/ control_unit.v  main_decoder.v  alu_decoder.v
  execute/    alu.v  branch_comparator.v  execute_cycle.v
  memory/     data_memory.v  load_store_unit.v  memory_cycle.v
  writeback/  writeback_cycle.v
  hazard/     hazard_unit.v
tb/           tb_riscv_pipeline_cpu.v  + directed test programs
sim/          Makefile  (iverilog/vvp flow)  + generated program hex/mem files
scripts/      create_project.tcl  build_and_test.tcl  constraints.xdc
docs/         architecture notes  (COMPLETION_SUMMARY.md folded in / removed)
README.md
```

- File names are `snake_case.v`.
- Module and signal names remain Harris & Harris **CamelCase** with pipeline-stage
  suffixes `_F / _D / _E / _M / _W` (the dominant existing convention).

## Coding Standards

- ANSI-style port declarations in every module (replaces the non-ANSI fetch-stage modules).
- Reset is **synchronous, active-high, named `rst`** everywhere. This also removes the
  `memory_cycle` `reset`-vs-`rst` port mismatch.
- Memories and the register file are not reset (standard practice); only the PC and
  pipeline control/data registers reset.
- Comments explain intent where non-obvious; no decorative separator banners
  (`=====`, `-----`, box-drawing), no "corrected from…" / "not used" throwaway notes,
  no emoji.

## Datapath Changes for Full RV32I

### ALU (`rtl/execute/alu.v`)
Widen `ALUControl` from 3 to 4 bits. Operation set:

| Code | Op   | Code | Op    |
|------|------|------|-------|
| 0000 | ADD  | 0101 | SLT   |
| 0001 | SUB  | 0110 | SLTU  |
| 0010 | AND  | 0111 | SLL   |
| 0011 | OR   | 1000 | SRL   |
| 0100 | XOR  | 1001 | SRA   |

`zero` flag retained for completeness but branch decisions move to a dedicated comparator.

### Decoders (`rtl/decode/control/`)
- `main_decoder`: add U-type (`LUI` opcode `0110111`, `AUIPC` opcode `0010111`) handling;
  produce the new `ALUSrcA` and U-type `ImmSrc` controls.
- `alu_decoder`: emit XOR/SLTU/SRA correctly; split ADD/SUB and SRL/SRA via `funct7[5]`
  (guarded so immediate shifts decode correctly). Fixes the current bug where XOR/XORI
  silently decode to ADD and SLTU/SRA are absent.

### Immediates (`rtl/decode/extend_unit.v`)
Widen `ImmSrc` from 2 to 3 bits to add the **U-type** immediate (`{Instr[31:12], 12'b0}`).
Existing I/S/B/J formats retained.

### LUI / AUIPC
Add a source-A select `SrcAE ∈ {ForwardedRD1, PCE, 32'b0}` driven by a new `ALUSrcA` control:
- `LUI`  → `SrcA = 0`,  `SrcB = ImmU`, ALU ADD  ⇒ result = ImmU.
- `AUIPC`→ `SrcA = PCE`,`SrcB = ImmU`, ALU ADD  ⇒ result = PC + ImmU.

This reuses the ALU instead of adding a separate writeback adder.

### Branches (`rtl/execute/branch_comparator.v`)
New combinational comparator taking the two forwarded register operands and `funct3`:

| funct3 | Branch | Condition          |
|--------|--------|--------------------|
| 000    | BEQ    | A == B             |
| 001    | BNE    | A != B             |
| 100    | BLT    | signed A <  B      |
| 101    | BGE    | signed A >= B      |
| 110    | BLTU   | unsigned A <  B    |
| 111    | BGEU   | unsigned A >= B    |

`PCSrcE = (BranchE & TakeBranch) | JumpE`.

### Jumps
- `JAL`  target = `PCE + ImmJ`.
- `JALR` target = `(ForwardedRD1 + ImmI)` with bit 0 forced to 0.

A jump-target mux selects between the branch/JAL adder output and the JALR address.
`rd` receives `PC+4` (existing `ResultSrc = 10` path).

### Sub-word memory (`rtl/memory/`)
- `funct3` is pipelined ID → EX → MEM (one signal, also used by the branch comparator in EX).
- `data_memory`: word array with **per-byte write strobes** so SB/SH/SW write only the
  addressed lanes (synthesizable byte-enable writes; no read-modify-write hazard).
- `load_store_unit`:
  - Store: replicate/align store data to the correct byte lanes; generate byte-write mask
    from `funct3` (SB/SH/SW) and address low bits.
  - Load: select addressed bytes/halfword/word from the read data and sign- or zero-extend
    per `funct3` (LB/LBU/LH/LHU/LW).
- Misaligned accesses are not trapped (no exception support); the README documents word/half
  alignment expectations.

## Hazard Unit Fix (`rtl/hazard/hazard_unit.v` + stage registers)

The hazard unit already computes `StallF / StallD / FlushD / FlushE`, but they are dangling
in the top module today, so load-use stalls and branch flushes do nothing. Fix:

- Add `en` (hold) and `clr` (bubble) controls to: the PC register, the IF/ID register
  (in `fetch_cycle`), and the ID/EX register (in `decode_cycle`).
- Connect: `StallF → PC.en=0`, `StallD → IF/ID.en=0`, `FlushD → IF/ID.clr`,
  `FlushE → ID/EX.clr`.
- Keep the existing forwarding logic (it is correct). Replace the `ResultSrcE[0]`
  load-detection with an explicit `MemReadE` signal for clarity and robustness.

Result: load-use hazards stall one cycle and resolve via forwarding; taken
branches/jumps flush the two younger instructions.

## Verification

Primary flow: **Icarus Verilog**.

- Install `iverilog` / `vvp` via msys2 (`pacman`), with explicit confirmation at that step.
- `sim/Makefile` compiles all RTL + a testbench and runs `vvp`.
- The testbench is **self-checking**: each instruction class runs a directed program with
  precomputed expected register/memory results; the bench compares actual vs expected,
  prints a per-check PASS/FAIL line and a final summary, and **exits non-zero on any
  mismatch** (CI-friendly). Register/memory state is inspected via hierarchical references
  into the DUT.
- Coverage, one focused program per class: R-type, I-type ALU (incl. the previously-broken
  XOR and shifts), LUI/AUIPC, all six branches (taken and not-taken), JAL/JALR, all loads,
  all stores, and a hazard scenario (load-use stall + forwarding + a taken branch flush).
- Baseline gate: the original 8-instruction arithmetic program must pass before any feature
  work begins.

Secondary flow: **Vivado**. The existing `create_project.tcl` / `build_and_test.tcl` /
`constraints.xdc` are retained but updated for the new file layout and module name, and
their decorative banners cleaned. `constraints.xdc` stays board-agnostic (timing only;
the commented example pinouts for Nexys A7 / Basys 3 / ZedBoard are kept as reference).

## Documentation

- `README.md` rewritten: no emoji, no decorative rules used as separators, no fabricated
  synthesis/timing/power table. It describes the implemented ISA, the verified test
  results, how to run the Icarus and Vivado flows, and the architecture. A small resource
  table may be added later only if populated from a real synthesis run.
- `COMPLETION_SUMMARY.md` (emoji checklist that overlaps the README) is removed; any
  unique content folds into `docs/`.

## Success Criteria

- `make -C sim` builds with no errors/warnings of substance and runs the self-checking
  testbench to a PASS summary with non-zero-exit on failure.
- Every RV32I base integer instruction (R, I, S, B, U, J, all load/store widths) has a
  directed test that passes; `FENCE/ECALL/EBREAK` documented as NOP stubs.
- Load-use stall, data forwarding, and branch/jump flush demonstrated by passing hazard tests.
- No emoji, decorative separators, fabricated metrics, mixed reset names, or non-ANSI ports
  remain. One consistent naming convention throughout.
- README claims correspond exactly to verified behavior.
- Git history preserved across the file moves.

## Risks / Notes

- Byte-enable memory writes and the load-extend mux are the most error-prone additions;
  they get dedicated taken/not-taken and alignment test cases.
- Adding `en`/`clr` to pipeline registers touches reset behavior — tests must cover
  reset-during-stall.
- msys2 `pacman` install requires network access and user confirmation; if unavailable,
  fall back to review-level verification and document that the Icarus flow is provided but
  unrun locally.

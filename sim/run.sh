#!/usr/bin/env bash
# Build and run Icarus Verilog testbenches for the RISC-V 5-stage pipeline CPU.
#
#   ./run.sh                       run the full regression suite
#   ./run.sh ../tb/tb_alu.v tb_alu run a single testbench by file and top module
#
# Requires iverilog and vvp on PATH.
set -u
cd "$(dirname "$0")"

RTL=$(find ../rtl -name '*.v')
RTL="$RTL ../riscv_pipeline_cpu.v"
BUILD=build
mkdir -p "$BUILD"

run_one() {
    local tb="$1" top="$2"
    echo "=== $top ==="
    if ! iverilog -g2012 -Wall -s "$top" -o "$BUILD/$top.vvp" $RTL "$tb"; then
        echo "BUILD FAILED: $top"
        return 1
    fi
    vvp "$BUILD/$top.vvp"
}

if [ $# -eq 2 ]; then
    run_one "$1" "$2"
    exit $?
fi

# Full regression suite (testbenches are added as each instruction class lands).
status=0
run_one ../tb/tb_alu.v tb_alu || status=1
run_one ../tb/tb_baseline.v tb_baseline || status=1
run_one ../tb/tb_full.v tb_full || status=1
exit $status

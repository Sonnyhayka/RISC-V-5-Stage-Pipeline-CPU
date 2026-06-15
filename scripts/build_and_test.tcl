# Build and test script for the RISC-V 5-stage pipeline CPU.
# Run from the repository root: vivado -mode batch -source scripts/build_and_test.tcl

set project_name "RISCV_Pipeline_CPU"
set run_simulation 1
set run_synthesis 1
set run_implementation 0

if {![file exists $project_name]} {
    source scripts/create_project.tcl
} else {
    open_project $project_name
}

add_files -fileset constrs_1 -norecurse scripts/constraints.xdc

if {$run_simulation} {
    launch_simulation
    run 2000ns
    close_sim -quiet
}

if {$run_synthesis} {
    reset_run synth_1
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
        puts "Synthesis failed"
        exit 1
    }
    open_run synth_1 -name synth_1
    report_utilization -file utilization_synth.rpt
    report_timing_summary -file timing_synth.rpt
}

if {$run_implementation} {
    reset_run impl_1
    launch_runs impl_1 -jobs 4
    wait_on_run impl_1
    if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
        puts "Implementation failed"
        exit 1
    }
    open_run impl_1
    report_utilization -file utilization_impl.rpt
    report_timing_summary -file timing_impl.rpt
    write_bitstream -force cpu.bit
}

puts "Build complete."

# RISC-V Pipeline CPU - Build and Test Script
# Usage: vivado -mode tcl -source build_and_test.tcl

# Set script variables
set project_name "RISCV_Pipeline_CPU"
set run_simulation 1
set run_synthesis 1
set run_implementation 0

puts "========================================"
puts "RISC-V 5-Stage Pipeline CPU Build Script"
puts "========================================"

# Create project if it doesn't exist
if {![file exists $project_name]} {
    puts "Creating new project..."
    source create_project.tcl
} else {
    puts "Opening existing project..."
    open_project $project_name
}

# Add constraints file
add_files -fileset constrs_1 -norecurse constraints.xdc

# Check syntax
puts "Checking syntax..."
check_syntax -fileset sources_1

if {$run_simulation} {
    puts "Running simulation..."
    launch_simulation
    
    # Run simulation for specified time
    run 500ns
    
    # Check for errors
    if {[get_value simulation.status] eq "success"} {
        puts "Simulation completed successfully"
    } else {
        puts "Simulation failed - check log"
        exit 1
    }
    
    # Close simulation
    close_sim -quiet
}

if {$run_synthesis} {
    puts "Running synthesis..."
    
    # Reset previous runs
    reset_run synth_1
    
    # Launch synthesis
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    
    # Check synthesis results
    if {[get_property PROGRESS [get_runs synth_1]] eq "100%"} {
        puts "Synthesis completed successfully"
        
        # Report utilization
        open_run synth_1 -name synth_1
        report_utilization -file utilization_synth.rpt
        report_timing_summary -file timing_synth.rpt
        
        puts "Resource utilization:"
        puts [report_utilization -return_string -brief]
        
    } else {
        puts "Synthesis failed - check log"
        exit 1
    }
}

if {$run_implementation} {
    puts "Running implementation..."
    
    # Reset previous runs
    reset_run impl_1
    
    # Launch implementation
    launch_runs impl_1 -jobs 4
    wait_on_run impl_1
    
    # Check implementation results
    if {[get_property PROGRESS [get_runs impl_1]] eq "100%"} {
        puts "Implementation completed successfully"
        
        # Generate reports
        open_run impl_1
        report_utilization -file utilization_impl.rpt
        report_timing_summary -file timing_impl.rpt
        report_power -file power.rpt
        
        # Generate bitstream
        write_bitstream -force cpu.bit
        
        puts "Bitstream generated: cpu.bit"
        
    } else {
        puts "Implementation failed - check log"
        exit 1
    }
}

puts "========================================"
puts "Build completed successfully!"
puts "========================================"

# Optional: Start GUI for manual inspection
# start_gui

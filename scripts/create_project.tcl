# Vivado Project Creation Script for RISC-V 5-Stage Pipeline CPU
# Run this script in Vivado TCL Console to automatically create the project

# Set project variables
set project_name "RISCV_Pipeline_CPU"
set project_dir "."
set part_name "xc7a35tcpg236-1"  # Artix-7 35T (change as needed)

# Create project
create_project $project_name $project_dir -part $part_name -force

# Add design source files
add_files -norecurse {
    main
    hazard_unit.v
}

# Add source files from subdirectories
add_files [glob -directory "Instruction Fetch" *.v]
add_files [glob -directory "Instruction Decode" *.v] 
add_files [glob -directory "Instruction Decode/Control Unit" *.v]
add_files [glob -directory "Execute" *.v]

# Set top module
set_property top riscv_pipeline_cpu [current_fileset]

# Add simulation sources
add_files -fileset sim_1 -norecurse {
    tb_riscv_pipeline_cpu.v
}

# Set simulation top
set_property top tb_riscv_pipeline_cpu [get_filesets sim_1]

# Update compile order
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Set simulation runtime
set_property -name {xsim.simulate.runtime} -value {500ns} -objects [get_filesets sim_1]

puts "Project created successfully!"
puts "To run simulation: launch_simulation"
puts "To synthesize: launch_runs synth_1"

# Optional: Launch GUI
# start_gui

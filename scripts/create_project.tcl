# Vivado project creation script for the RISC-V 5-stage pipeline CPU.
# Run from the repository root: vivado -mode batch -source scripts/create_project.tcl

set project_name "RISCV_Pipeline_CPU"
set project_dir "."
set part_name "xc7a35tcpg236-1"

create_project $project_name $project_dir -part $part_name -force

add_files -norecurse riscv_pipeline_cpu.v
add_files [glob rtl/fetch/*.v]
add_files [glob rtl/decode/*.v]
add_files [glob rtl/decode/control/*.v]
add_files [glob rtl/execute/*.v]
add_files [glob rtl/memory/*.v]
add_files [glob rtl/writeback/*.v]
add_files [glob rtl/hazard/*.v]

set_property top riscv_pipeline_cpu [current_fileset]

add_files -fileset sim_1 -norecurse tb/tb_riscv_pipeline_cpu.v
set_property top tb_riscv_pipeline_cpu [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property -name {xsim.simulate.runtime} -value {2000ns} -objects [get_filesets sim_1]

puts "Project created. Run launch_simulation to simulate or launch_runs synth_1 to synthesize."

# Timing Constraints for RISC-V 5-Stage Pipeline CPU
# Target: 100MHz operation (10ns period)

# Create clock constraint
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Set input delay for reset
set_input_delay -clock sys_clk 1.0 [get_ports rst]

# Set clock uncertainty
set_clock_uncertainty 0.5 [get_clocks sys_clk]

# Set false paths for reset
set_false_path -from [get_ports rst] -to [all_registers]

# Optional: Pin assignments for common FPGA boards
# Uncomment and modify for your specific board

# # Nexys A7-100T Example (Artix-7)
# set_property PACKAGE_PIN E3 [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports clk]
# set_property PACKAGE_PIN C12 [get_ports rst]
# set_property IOSTANDARD LVCMOS33 [get_ports rst]

# # Basys 3 Example (Artix-7)
# set_property PACKAGE_PIN W5 [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports clk]
# set_property PACKAGE_PIN U18 [get_ports rst]
# set_property IOSTANDARD LVCMOS33 [get_ports rst]

# # ZedBoard Example (Zynq)
# set_property PACKAGE_PIN Y9 [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports clk]
# set_property PACKAGE_PIN P16 [get_ports rst]
# set_property IOSTANDARD LVCMOS18 [get_ports rst]

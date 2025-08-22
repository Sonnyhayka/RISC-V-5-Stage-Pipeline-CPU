// Testbench for RISC-V 5-Stage Pipeline CPU
`timescale 1ns / 1ps

module tb_riscv_pipeline_cpu;
    // Clock and reset signals
    reg clk;
    reg rst;
    
    // Instantiate the CPU
    riscv_pipeline_cpu uut (
        .clk(clk),
        .rst(rst)
    );
    
    // Clock generation
    always #5 clk = ~clk; // 100MHz clock (10ns period)
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        
        // Display header
        $display("======================================");
        $display("RISC-V 5-Stage Pipeline CPU Testbench");
        $display("======================================");
        
        // Hold reset for a few cycles
        #20;
        rst = 0;
        $display("Time: %0t - Reset released, CPU starting", $time);
        
        // Run for several clock cycles to see pipeline operation
        #200;
        
        $display("======================================");
        $display("Simulation completed successfully");
        $display("======================================");
        $finish;
    end
    
    // Monitor key signals
    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %h | RegWrite: %b", 
                 $time, uut.IF_stage.PCF, uut.InstrD, uut.RegWriteW);
    end
    
endmodule

`timescale 1ns / 1ps

module tb_riscv_pipeline_cpu;
    reg clk;
    reg rst;

    riscv_pipeline_cpu uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #20;
        rst = 0;
        $display("Time: %0t - reset released, CPU starting", $time);
        #200;
        $display("Time: %0t - simulation completed", $time);
        $finish;
    end

    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %h | RegWrite: %b",
            $time, uut.IF_stage.PCF, uut.InstrD, uut.RegWriteW);
    end
endmodule

`timescale 1ns/1ps

module tb_full;
    reg clk = 0;
    reg rst = 1;
    integer errors = 0;
    integer i;
    reg [31:0] expected [0:31];

    riscv_pipeline_cpu dut(.clk(clk), .rst(rst));

    always #5 clk = ~clk;

    initial begin
        #1;
        $readmemh("../tb/programs/full.hex", dut.IF_stage.IM_module.Mem);
        $readmemh("../tb/programs/full_expected.hex", expected);
        #19 rst = 0;
        #1500;
        for (i = 0; i < 32; i = i + 1) begin
            if (dut.ID_stage.Register_File.regFile[i] !== expected[i]) begin
                $display("FAIL x%0d = %h (expected %h)", i,
                    dut.ID_stage.Register_File.regFile[i], expected[i]);
                errors = errors + 1;
            end
        end
        if (errors == 0) $display("ALL TESTS PASSED (32 registers)");
        else begin
            $display("%0d FAILURES", errors);
            $fatal;
        end
        $finish;
    end
endmodule

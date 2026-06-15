`timescale 1ns/1ps

module tb_baseline;
    reg clk = 0;
    reg rst = 1;
    integer errors = 0;

    riscv_pipeline_cpu dut(.clk(clk), .rst(rst));

    always #5 clk = ~clk;

    task check;
        input [4:0] r;
        input [31:0] exp;
        begin
            if (dut.ID_stage.Register_File.regFile[r] !== exp) begin
                $display("FAIL x%0d = %h (expected %h)",
                    r, dut.ID_stage.Register_File.regFile[r], exp);
                errors = errors + 1;
            end else begin
                $display("PASS x%0d = %h", r, exp);
            end
        end
    endtask

    initial begin
        #1;
        $readmemh("../tb/programs/base.hex", dut.IF_stage.IM_module.Mem);
        #19 rst = 0;
        #200;
        check(1, 32'd5);
        check(2, 32'd3);
        check(3, 32'd8);
        check(4, 32'd2);
        check(5, 32'd40);
        check(6, 32'd0);
        check(7, 32'd7);
        check(8, 32'd1);
        if (errors == 0) $display("ALL TESTS PASSED");
        else begin
            $display("%0d FAILURES", errors);
            $fatal;
        end
        $finish;
    end
endmodule

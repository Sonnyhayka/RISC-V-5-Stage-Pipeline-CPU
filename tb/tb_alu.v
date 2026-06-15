`timescale 1ns/1ps

module tb_alu;
    reg [31:0] A, B;
    reg [3:0] ctrl;
    wire [31:0] result;
    wire zero;
    integer errors = 0;

    ALU dut(.A(A), .B(B), .ALUControl(ctrl), .result(result), .zero(zero));

    task check;
        input [3:0] c;
        input [31:0] exp;
        begin
            ctrl = c;
            #1;
            if (result !== exp) begin
                $display("FAIL ctrl=%b A=%h B=%h result=%h exp=%h", c, A, B, result, exp);
                errors = errors + 1;
            end else begin
                $display("PASS ctrl=%b -> %h", c, exp);
            end
        end
    endtask

    initial begin
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        check(4'b0000, 32'h00000000);
        check(4'b0001, 32'hFFFFFFFE);
        check(4'b0010, 32'h00000001);
        check(4'b0011, 32'hFFFFFFFF);
        check(4'b0100, 32'hFFFFFFFE);
        check(4'b0101, 32'h00000001);
        check(4'b0110, 32'h00000000);
        check(4'b0111, 32'hFFFFFFFE);
        check(4'b1000, 32'h7FFFFFFF);
        check(4'b1001, 32'hFFFFFFFF);
        if (errors == 0) $display("ALL TESTS PASSED");
        else begin
            $display("%0d FAILURES", errors);
            $fatal;
        end
        $finish;
    end
endmodule

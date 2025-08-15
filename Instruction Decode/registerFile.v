`timescale 1ns / 1ps

module registerFile(a1, a2, a3, rd1, rd2, wd3, we3, clk, rst);
    input wire clk, rst;
    input wire we3, wd3;
    input wire [4:0] a1, a2, a3;
    output wire [31:0] rd1, rd2;
    
    reg [31:0] regFile [31:0];
    
    always @(posedge clk) begin
        if(we3 & (a3 != 5'b0)) begin
            regFile[a3] <= wd3;
        end
    end
    
    assign rd1 = rst ? 5'b0 : regFile[a1];
    assign rd2 = rst ? 5'b0 : regFile[a2];
endmodule

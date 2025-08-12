`timescale 1ns / 1ps

module programCounter(rst, clk, PCnext, PC);
    input wire rst;
    input wire clk;
    input wire [31:0] PCnext;
    output reg [31:0] PC;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 32'b0;
        end else if (clk) begin
            PC <= PCnext;
        end
    end   
endmodule
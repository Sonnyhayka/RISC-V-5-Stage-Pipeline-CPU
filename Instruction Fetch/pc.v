`timescale 1ns / 1ps

// Program Counter Module
module programCounter(rst, clk, PCnext, PC);
    input wire rst;                // Reset signal (active high)
    input wire clk;                // Clock signal
    input wire [31:0] PCnext;      // Next value for the program counter
    output reg [31:0] PC;          // Current value of the program counter

    // Update PC on rising edge of clock or reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            PC <= 32'b0;           // Reset PC to 0
        end else if (clk) begin
            PC <= PCnext;          // Load next PC value
        end
    end   
endmodule
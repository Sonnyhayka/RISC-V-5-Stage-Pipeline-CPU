`timescale 1ns / 1ps

// Register File Module for RISC-V CPU
module registerFile(
    input  wire        clk,      // Clock signal
    input  wire        rst,      // Reset signal (active high)
    input  wire        we3,      // Write enable for port 3
    input  wire [4:0]  a1,       // Read address 1
    input  wire [4:0]  a2,       // Read address 2
    input  wire [4:0]  a3,       // Write address 3
    input  wire [31:0] wd3,      // Write data for port 3
    output wire [31:0] rd1,      // Read data 1
    output wire [31:0] rd2       // Read data 2
);
    // 32 registers, each 32 bits wide
    reg [31:0] regFile [31:0];

    integer i;
    // Synchronous write and asynchronous reset
    always @(posedge clk) begin
        if (rst) begin
            // Reset all registers to zero
            for (i = 0; i < 32; i = i + 1) begin
                regFile[i] <= 32'b0;
            end
        end else if (we3 && (a3 != 5'b0)) begin
            // Write data to register a3 if write enabled and not x0
            regFile[a3] <= wd3;
        end
    end

    // asynchronous read ports with x0 hardwired to zero
    assign rd1 = (a1 == 5'b0) ? 32'b0 : regFile[a1];
    assign rd2 = (a2 == 5'b0) ? 32'b0 : regFile[a2];
endmodule

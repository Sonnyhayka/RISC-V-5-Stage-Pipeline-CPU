`timescale 1ns / 1ps

module registerFile(
    input  wire        clk,
    input  wire        rst,
    input  wire        we3,
    input  wire [4:0]  a1,
    input  wire [4:0]  a2,
    input  wire [4:0]  a3,
    input  wire [31:0] wd3,     // This is for writing data
    output wire [31:0] rd1,
    output wire [31:0] rd2
);
    reg [31:0] regFile [31:0];

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regFile[i] <= 32'b0;
            end
        end else if (we3 && (a3 != 5'b0)) begin
            regFile[a3] <= wd3;
        end
    end

    // asynchronous read ports with x0 hardwired to zero
    assign rd1 = (a1 == 5'b0) ? 32'b0 : regFile[a1];
    assign rd2 = (a2 == 5'b0) ? 32'b0 : regFile[a2];
endmodule

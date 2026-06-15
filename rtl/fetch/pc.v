`timescale 1ns / 1ps

module programCounter(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [31:0] PCnext,
    output reg [31:0] PC
);
    always @(posedge clk) begin
        if (rst) PC <= 32'b0;
        else if (en) PC <= PCnext;
    end
endmodule

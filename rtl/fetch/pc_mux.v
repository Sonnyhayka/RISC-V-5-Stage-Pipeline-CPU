`timescale 1ns / 1ps

module PCMux(
    input wire s,
    input wire [31:0] in1,
    input wire [31:0] in2,
    output wire [31:0] out
);
    assign out = s ? in2 : in1;
endmodule

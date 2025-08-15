`timescale 1ns / 1ps

module PCMux(s, in1, in2, out);
    input wire s;
    input wire [31:0] in1;
    input wire [31:0] in2;
    output wire [31:0] out;

    assign out = (~s) ? in1 : in2;
endmodule

`timescale 1ns / 1ps

module extend(
    input  wire [31:0] InstrD,
    input  wire [1:0]  ImmSrcD,
    output wire [31:0] ImmExtD
);
    assign ImmExtD =
        // I type
        (ImmSrcD == 2'b00) ? {{20{InstrD[31]}}, InstrD[31:20]} :
        // S type
        (ImmSrcD == 2'b01) ? {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]} :
        // B type
        (ImmSrcD == 2'b10) ? {{20{InstrD[31]}}, InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0} :
        // J type for jal
        (ImmSrcD == 2'b11) ? {{12{InstrD[31]}}, InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0} :
        32'b0;
endmodule

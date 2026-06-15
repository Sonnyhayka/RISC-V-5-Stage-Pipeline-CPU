`timescale 1ns / 1ps

module extend(
    input  wire [31:0] InstrD,    // Instruction input
    input  wire [1:0]  ImmSrcD,   // Immediate source type selector
    output wire [31:0] ImmExtD    // Extended immediate output
);
    assign ImmExtD =
        // I-type immediate: bits [31:20], sign-extended
        (ImmSrcD == 2'b00) ? {{20{InstrD[31]}}, InstrD[31:20]} :
        // S-type immediate: bits [31:25] and [11:7], sign-extended
        (ImmSrcD == 2'b01) ? {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]} :
        // B-type immediate: bits [31], [7], [30:25], [11:8], sign-extended, LSB is 0
        (ImmSrcD == 2'b10) ? {{20{InstrD[31]}}, InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0} :
        // J-type immediate (for jal): bits [31], [19:12], [20], [30:21], sign-extended, LSB is 0
        (ImmSrcD == 2'b11) ? {{12{InstrD[31]}}, InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0} :
        // Default: zero
        32'b0;
endmodule

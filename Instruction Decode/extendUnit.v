`timescale 1ns / 1ps

module extend(
    input wire [31:0] InstrD,
    input wire [1:0] ImmSrcD,
    output wire [31:0] ImmExtD
    );
    
    assign ImmExtD = (ImmSrcD == 2'b00) ? {{20{InstrD[31]}}, InstrD[31:20]} :
                     (ImmSrcD == 2'b01) ? {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]} : 
                     (ImmSrcD == 2'b10) ? {{20{InstrD[31]}}, InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0} :
                     32'b0;
endmodule

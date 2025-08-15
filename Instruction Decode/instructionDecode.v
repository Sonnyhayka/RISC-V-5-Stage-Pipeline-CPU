`timescale 1ns / 1ps

module instructionDecode(
    input wire [31:0] InstrD
    );
    
    // In-between wires
    wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD;
    wire [31:0] ImmExtD;
    
    // In-between registers
    reg RegWriteD_reg, MemWriteD_reg, JumpD_reg, BranchD_reg, ALUSrcD_reg; 
    reg [1:0] ResultSrcD_reg, ImmSrcD_reg;
    reg [2:0] ALUControlD_reg;
    reg [31:0] ImmExtD_reg;
    
    // Delcare control unit
    controlUnit Control_Unit(
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD)
        );
        
    // Declare extend unit
    extend extend_unit(
        .InstrD(InstrD[31:0]),
        .ImmSrcD(ImmSrcD),
        .ImmExtD(ImmExtD)
        );
endmodule

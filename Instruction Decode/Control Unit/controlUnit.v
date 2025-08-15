`timescale 1ns / 1ps

module controlUnit(
    input wire [6:0] op,
    input wire [6:0] funct7,
    input wire [2:0] funct3,
    output wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD,
    output wire [1:0] ResultSrcD, ImmSrcD, ALUOp,
    output wire [2:0] ALUControlD
    );
    
    mainDecoder Main_Decoder(
        .op(op),
        .Branch(BranchD),
        .Jump(JumpD),
        .MemWrite(MemWriteD),
        .ALUSrc(ALUSrcD),
        .RegWrite(RegWriteD),
        .ResultSrc(ResultSrcD),
        .ImmSrc(ImmSrcD),
        .ALUOp(ALUOp)
    );
    
    ALUDecoder ALU_Decoder(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(op),
        .ALUControl(ALUControlD)
    );
endmodule

`timescale 1ns / 1ps

module controlUnit(
    input wire [6:0] op,
    input wire [6:0] funct7,
    input wire [2:0] funct3,
    output wire RegWriteD, MemWriteD, MemReadD, ALUSrcD, BranchD, JumpD, JumpSrcD,
    output wire [1:0] ResultSrcD, ALUSrcAD,
    output wire [2:0] ImmSrcD,
    output wire [3:0] ALUControlD
);
    wire [1:0] ALUOp;

    mainDecoder Main_Decoder(
        .op(op),
        .RegWrite(RegWriteD),
        .MemWrite(MemWriteD),
        .MemRead(MemReadD),
        .ALUSrc(ALUSrcD),
        .Branch(BranchD),
        .Jump(JumpD),
        .JumpSrc(JumpSrcD),
        .ResultSrc(ResultSrcD),
        .ALUOp(ALUOp),
        .ALUSrcA(ALUSrcAD),
        .ImmSrc(ImmSrcD)
    );

    ALUDecoder ALU_Decoder(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(op),
        .ALUControl(ALUControlD)
    );
endmodule

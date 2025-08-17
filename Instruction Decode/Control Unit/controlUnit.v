`timescale 1ns / 1ps
// Control Unit for RISC-V Processor
module controlUnit(
    input wire [6:0] op,   // opcode bits [6:0] from instruction
    input wire [6:0] funct7, // bits [31:25] from instruction
    input wire [2:0] funct3, // bits [14:12] from instruction
    
    // Control signals output
    output wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, 
    output wire [1:0] ResultSrcD, ImmSrcD, ALUOp,
    output wire [2:0] ALUControlD
    );
    
    // Instantiate the main decoder to generate control signals based on opcode
    mainDecoder Main_Decoder(
        .op(op),             // Input: Instruction opcode
        .Branch(BranchD),    // Output: Branch control signal
        .Jump(JumpD),        // Output: Jump control signal
        .MemWrite(MemWriteD),// Output: Memory write enable
        .ALUSrc(ALUSrcD),    // Output: ALU source select
        .RegWrite(RegWriteD),// Output: Register write enable
        .ResultSrc(ResultSrcD), // Output: Result source select
        .ImmSrc(ImmSrcD),    // Output: Immediate source select
        .ALUOp(ALUOp)        // Output: ALU operation select
    );
    
    // Instantiate the ALU decoder to generate ALU control signals based on ALUOp, funct3, funct7, and opcode
    ALUDecoder ALU_Decoder(
        .ALUOp(ALUOp),           // Input: ALU operation select from main decoder
        .funct3(funct3),         // Input: funct3 field from instruction
        .funct7(funct7),         // Input: funct7 field from instruction
        .op(op),                 // Input: opcode bits from instruction
        .ALUControl(ALUControlD) // Output: ALU control signal
    );
endmodule

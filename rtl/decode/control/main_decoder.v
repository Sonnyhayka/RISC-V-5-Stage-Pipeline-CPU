`timescale 1ns / 1ps

module mainDecoder(
    input wire [6:0] op,
    output wire Branch, Jump, MemWrite, ALUSrc, RegWrite,
    output wire [1:0] ResultSrc, ImmSrc, ALUOp
    );
    
    // Branch: High for branch instructions (BEQ, BNE, etc.)
    assign Branch = (op == 7'b1100011) ? 1'b1 : 1'b0;
    
    // Jump: High for jump instructions (JAL, JALR)
    assign Jump = (op == 7'b1101111 | op == 7'b1100111) ? 1'b1 : 1'b0;

    // MemWrite: High for store instructions (SW)
    assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;
    
    // ALUSrc: High for instructions that use immediate (LW, SW, I-type ALU, LUI, AUIPC)
    assign ALUSrc = (op == 7'b0000011 | op == 7'b0100011 | op == 7'b0010011 | 
                     op == 7'b0110111 | op == 7'b0010111) ? 1'b1 : 1'b0;
                    
    // RegWrite: High for instructions that write to register file
    assign RegWrite = (op == 7'b0000011 | op == 7'b0110011 | op == 7'b0010011 | 
                       op == 7'b1101111 | op == 7'b1100111 | op == 7'b0110111 | 
                       op == 7'b0010111) ? 1'b1 : 1'b0;
                    
    // ResultSrc: 01 for load, 10 for jump, 00 for ALU result
    assign ResultSrc = (op == 7'b0000011) ? 2'b01 :  // Load instructions
                       (op == 7'b1101111 | op == 7'b1100111) ? 2'b10 :  // Jump instructions
                       2'b00;  // ALU result
    
    // ImmSrc: Immediate type selection
    assign ImmSrc = (op == 7'b0100011) ? 2'b01 :     // S-type (SW)
                    (op == 7'b1100011) ? 2'b10 :     // B-type (Branch)
                    (op == 7'b1101111) ? 2'b11 :     // J-type (JAL)
                    2'b00;                            // I-type (default)
    
    // ALUOp: Operation type for ALU decoder
    assign ALUOp = (op == 7'b0110011 | op == 7'b0010011) ? 2'b10 :  // R-type and I-type ALU
                   (op == 7'b1100011) ? 2'b01 :                     // Branch (subtract for comparison)
                   2'b00;                                            // Load/Store (add)                             
endmodule

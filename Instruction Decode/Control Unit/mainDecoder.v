`timescale 1ns / 1ps

module mainDecoder(
    input wire [6:0] op,
    output wire Branch, Jump, MemWrite, ALUSrc, RegWrite,
    output wire [1:0] ResultSrc, ImmSrc, ALUOp
    );
    
    // Branch: High for BEQ instruction
    assign Branch = (op == 7'b1100011) ? 1'b1 : 1'b0;
    
    // Jump: High for JAL instruction
    assign Jump = (op == 7'b1101111) ? 1'b1 : 1'b0;

    // MemWrite: High for SW instruction
    assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;
    
    // ALUSrc: High for LW, SW, and I-type ALU instructions
    assign ALUSrc = (op == 7'b0000011 | op == 7'b0100011 | op == 7'b0010011) ?
                    1'b1 : 1'b0;
                    
    // RegWrite: High for LW, R-type, I-type ALU, and JAL instructions
    assign RegWrite = (op == 7'b0000011 | op == 7'b0110011 | op == 7'b0010011 | op == 7'b1101111) ?
                      1'b1 : 1'b0;
                    
    // ResultSrc: 01 for LW, 10 for JAL, 00 otherwise
    assign ResultSrc = (op == 7'b0000011) ? 2'b01 :
                       (op == 7'b1101111) ? 2'b10 :
                       2'b00;
    
    // ImmSrc: 01 for SW, 10 for BEQ, 11 for JAL, 00 otherwise
    assign ImmSrc = (op == 7'b0100011) ? 2'b01 :
                    (op == 7'b1100011) ? 2'b10 :
                    (op == 7'b1101111) ? 2'b11 :
                    2'b00; 
    
    // ALUOp: 10 for R-type and I-type ALU, 01 for BEQ, 00 otherwise
    assign ALUOp = (op == 7'b0110011) ? 2'b10 :
                   (op == 7'b1100011) ? 2'b01 :
                   (op == 7'b0010011) ? 2'b10 :
                   2'b00;                             
endmodule

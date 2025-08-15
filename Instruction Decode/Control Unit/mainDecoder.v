`timescale 1ns / 1ps

module mainDecoder(
    input wire [6:0] op,
    output wire Branch, Jump, MemWrite, ALUSrc, RegWrite,
    output wire [1:0] ResultSrc, ImmSrc, ALUOp
    );
    
    // beq
    assign Branch = (op == 7'b1100011) ? 1'b1 : 1'b0;
    
    // jal
    assign Jump = (op == 7'b1101111) ? 1'b1 : 1'b0;

    // sw
    assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0;
    
    // lw, sw, I-type ALU
    assign ALUSrc = (op == 7'b0000011 | op == 7'b0100011 | op == 7'b0010011) ?
                    1'b1 : 1'b0;
                    
    // lw, R-type, I-type ALU, jal
    assign RegWrite = (op == 7'b0000011 | op == 7'b0110011 | op == 7'b0010011 | op == 7'b1101111) ?
                      1'b1 : 1'b0;
                    
    // lw jal                  
    assign ResultSrc = (op == 7'b0000011) ? 2'b01 :
                       (op == 7'b1101111) ? 2'b10 :
                       2'b00;
    
    // sw, beq, jal                   
    assign ImmSrc = (op == 7'b0100011) ? 2'b01 :
                    (op == 7'b1100011) ? 2'b10 :
                    (op == 7'b1101111) ? 2'b11 :
                    2'b00; 
    
    // R-type, beq, I-type ALU                
    assign ALUOp = (op == 7'b0110011) ? 2'b10 :
                   (op == 7'b1100011) ? 2'b01 :
                   (op == 7'b0010011) ? 2'b10 :
                   2'b00;                             
endmodule

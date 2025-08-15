`timescale 1ns / 1ps

module ALUDecoder(
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire [6:0] funct7, op,
    output wire [2:0] ALUControl
    );
    
    assign ALUControl = (ALUOp == 2'b00) ? 3'b000 : //add (lw, sw)
                        (ALUOp == 2'b01) ? 3'b001 : //subtract (beq)
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5], funct7[5]}) == 2'b11) ? 
                            3'b001 : //subtract
                        ((ALUOp == 2'b10) & (funct3 == 3'b000) & ({op[5], funct7[5]}) != 2'b11) ? 
                            3'b000 : //add
                        ((ALUOp == 2'b10) & (funct3 == 3'b010)) ? 3'b101 : //slt
                        ((ALUOp == 2'b10) & (funct3 == 3'b110)) ? 3'b011 : //or
                        ((ALUOp == 2'b10) & (funct3 == 3'b111)) ? 3'b010 : //and
                        3'b111; //otherwise, do nothing
endmodule

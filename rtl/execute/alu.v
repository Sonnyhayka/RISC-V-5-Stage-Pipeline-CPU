`timescale 1ns / 1ps

module ALU (
    input [31:0] A, B,
    input [2:0] ALUControl,
    output reg [31:0] result,
    output zero
);
    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;
    localparam ALU_AND = 3'b010;
    localparam ALU_OR = 3'b011;
    localparam ALU_XOR = 3'b100;
    localparam ALU_SLT = 3'b101;
    localparam ALU_SLL = 3'b110;
    localparam ALU_SRL = 3'b111;

    always @(*) begin
        case (ALUControl)
            ALU_ADD: result = A + B;
            ALU_SUB: result = A - B;
            ALU_AND: result = A & B;
            ALU_OR: result = A | B;
            ALU_XOR: result = A ^ B;
            ALU_SLT: result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
            ALU_SLL: result = A << B[4:0];
            ALU_SRL: result = A >> B[4:0];
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);
endmodule

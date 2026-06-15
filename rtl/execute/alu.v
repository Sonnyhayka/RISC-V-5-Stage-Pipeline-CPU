`timescale 1ns / 1ps

module ALU (
    input [31:0] A, B,
    input [3:0] ALUControl,
    output reg [31:0] result,
    output zero
);
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;
    localparam ALU_SLTU = 4'b0110;
    localparam ALU_SLL = 4'b0111;
    localparam ALU_SRL = 4'b1000;
    localparam ALU_SRA = 4'b1001;

    always @(*) begin
        case (ALUControl)
            ALU_ADD: result = A + B;
            ALU_SUB: result = A - B;
            ALU_AND: result = A & B;
            ALU_OR: result = A | B;
            ALU_XOR: result = A ^ B;
            ALU_SLT: result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;
            ALU_SLTU: result = (A < B) ? 32'b1 : 32'b0;
            ALU_SLL: result = A << B[4:0];
            ALU_SRL: result = A >> B[4:0];
            ALU_SRA: result = $signed(A) >>> B[4:0];
            default: result = 32'b0;
        endcase
    end

    assign zero = (result == 32'b0);
endmodule

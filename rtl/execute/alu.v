// ALU Module for RISC-V 5-Stage Pipeline CPU
`timescale 1ns / 1ps

// ALU performs arithmetic and logic operations required by the ISA
module ALU (
    input [31:0] A, B,          // 32-bit inputs
    input [2:0] ALUControl,     // 3-bit control signal (corrected from 4-bit)
    output reg [31:0] result,   // 32-bit result output
    output zero                 // Zero flag output
);

    // ALU operation codes (using 3-bit encoding)
    localparam ALU_ADD  = 3'b000; // Addition
    localparam ALU_SUB  = 3'b001; // Subtraction
    localparam ALU_AND  = 3'b010; // AND
    localparam ALU_OR   = 3'b011; // OR
    localparam ALU_XOR  = 3'b100; // XOR
    localparam ALU_SLT  = 3'b101; // Set less than (signed)
    localparam ALU_SLL  = 3'b110; // Logical shift left
    localparam ALU_SRL  = 3'b111; // Logical shift right

    always @(*) begin
        // Select ALU operation based on ALUControl signal
        case (ALUControl)
            ALU_ADD:   result = A + B;                                        // Addition
            ALU_SUB:   result = A - B;                                        // Subtraction
            ALU_AND:   result = A & B;                                        // AND
            ALU_OR:    result = A | B;                                        // OR
            ALU_XOR:   result = A ^ B;                                        // XOR
            ALU_SLT:   result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;  // Set less than (signed)
            ALU_SLL:   result = A << B[4:0];                                 // Logical shift left
            ALU_SRL:   result = A >> B[4:0];                                 // Logical shift right
            default:   result = 32'b0;                                        // Default case
        endcase
    end

    assign zero = (result == 32'b0); // Zero flag: high if result is zero
endmodule

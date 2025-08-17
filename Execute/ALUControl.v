`timescale 1ns / 1ps

// ALU performs arithmetic and logic operations required by the ISA. Taking in 32 bits input, 4 bits control signal and producing 32 bits output.


// Create ALU module
module ALU (
    input [31:0] A, B, // 32-bit inputs
    input [3:0] ALUControl, // 4-bit control signal
    //Output
    output reg [31:0] result, // 32-bit result output
    output zero // Zero flag output
);

// ALU operation codes
localparam ALU_ADD  = 4'b0000; // Addition
localparam ALU_SUB  = 4'b0001; // Subtraction
localparam ALU_AND  = 4'b0010; // AND
localparam ALU_OR   = 4'b0011; // OR
localparam ALU_XOR  = 4'b0100; // XOR
localparam ALU_SLL  = 4'b0101; // Logical shift left
localparam ALU_SRL  = 4'b0110; // Logical shift right
localparam ALU_SRA  = 4'b0111; // Arithmetic shift right
localparam ALU_SLT  = 4'b1000; // Set less than (signed)
localparam ALU_SLTU = 4'b1001; // Set less than (unsigned)

always @ (*) begin
    // Select ALU operation based on ALUControl signal
    case (ALUControl)
        ALU_ADD:   result = A + B; // Addition
        ALU_SUB:   result = A - B; // Subtraction
        ALU_AND:   result = A & B; // AND
        ALU_OR:    result = A | B; // OR
        ALU_XOR:   result = A ^ B; // XOR
        ALU_SLL:   result = A << B[4:0]; // Logical shift left
        ALU_SRL:   result = A >> B[4:0]; // Logical shift right
        ALU_SRA:   result = $signed(A) >>> B[4:0]; // Arithmetic shift right
        ALU_SLT:   result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // Set less than ( for signed)
        ALU_SLTU:  result = (A < B) ? 32'b1 : 32'b0; // Set less than (for unsigned)
        default:   result = 32'b0; // Default case when no operation matches
    endcase
end

assign zero = (result == 32'b0); // Zero flag: high if result is zero
endmodule

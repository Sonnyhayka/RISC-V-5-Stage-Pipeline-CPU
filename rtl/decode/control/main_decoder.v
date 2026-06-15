`timescale 1ns / 1ps

module mainDecoder(
    input wire [6:0] op,
    output reg RegWrite, MemWrite, MemRead, ALUSrc, Branch, Jump, JumpSrc,
    output reg [1:0] ResultSrc, ALUOp, ALUSrcA,
    output reg [2:0] ImmSrc
);
    always @(*) begin
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        MemRead = 1'b0;
        ALUSrc = 1'b0;
        Branch = 1'b0;
        Jump = 1'b0;
        JumpSrc = 1'b0;
        ResultSrc = 2'b00;
        ALUOp = 2'b00;
        ALUSrcA = 2'b00;
        ImmSrc = 3'b000;
        case (op)
            7'b0110011: begin
                RegWrite = 1'b1;
                ALUOp = 2'b10;
            end
            7'b0010011: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b10;
            end
            7'b0000011: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                MemRead = 1'b1;
                ResultSrc = 2'b01;
            end
            7'b0100011: begin
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
                ImmSrc = 3'b001;
            end
            7'b1100011: begin
                Branch = 1'b1;
                ImmSrc = 3'b010;
            end
            7'b1101111: begin
                RegWrite = 1'b1;
                Jump = 1'b1;
                ResultSrc = 2'b10;
                ImmSrc = 3'b011;
            end
            7'b1100111: begin
                RegWrite = 1'b1;
                Jump = 1'b1;
                JumpSrc = 1'b1;
                ALUSrc = 1'b1;
                ResultSrc = 2'b10;
                ImmSrc = 3'b000;
            end
            7'b0110111: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUSrcA = 2'b10;
                ImmSrc = 3'b100;
            end
            7'b0010111: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUSrcA = 2'b01;
                ImmSrc = 3'b100;
            end
            default: begin
            end
        endcase
    end
endmodule

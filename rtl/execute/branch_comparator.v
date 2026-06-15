`timescale 1ns / 1ps

module branchComparator(
    input wire [31:0] A, B,
    input wire [2:0] funct3,
    output reg TakeBranch
);
    always @(*) begin
        case (funct3)
            3'b000: TakeBranch = (A == B);
            3'b001: TakeBranch = (A != B);
            3'b100: TakeBranch = ($signed(A) < $signed(B));
            3'b101: TakeBranch = ($signed(A) >= $signed(B));
            3'b110: TakeBranch = (A < B);
            3'b111: TakeBranch = (A >= B);
            default: TakeBranch = 1'b0;
        endcase
    end
endmodule

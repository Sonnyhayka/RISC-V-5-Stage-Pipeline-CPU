`timescale 1ns / 1ps

module instructionFetch(
    input wire clk,
    input wire rst,
    input wire PCSrcE,
    input wire [31:0] PCTargetE,
    output wire [31:0] InstrD,
    output wire [31:0] PCD,
    output wire [31:0] PCPlus4D
);
    wire [31:0] PCF, PCnextF, instrF, PCPlus4F;

    reg [31:0] PCF_reg, PCPlus4F_reg, instr_reg;

    programCounter PC_module(
        .clk(clk),
        .rst(rst),
        .PCnext(PCnextF),
        .PC(PCF)
    );

    instructionMemory IM_module(
        .addr(PCF),
        .rd(instrF)
    );

    PCAdder PC_Adder(
        .in1(PCF),
        .in2(32'h4),
        .out(PCPlus4F)
    );

    PCMux PC_Mux(
        .s(PCSrcE),
        .in1(PCPlus4F),
        .in2(PCTargetE),
        .out(PCnextF)
    );

    always @(posedge clk) begin
        if (rst) begin
            PCF_reg <= 32'b0;
            PCPlus4F_reg <= 32'b0;
            instr_reg <= 32'b0;
        end else begin
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
            instr_reg <= instrF;
        end
    end

    assign InstrD = instr_reg;
    assign PCD = PCF_reg;
    assign PCPlus4D = PCPlus4F_reg;
endmodule

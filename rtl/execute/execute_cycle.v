`timescale 1ns / 1ps

module execute_cycle(
    input wire clk,
    input wire rst,
    input wire RegWriteE,
    input wire MemWriteE,
    input wire JumpE,
    input wire BranchE,
    input wire ALUSrcE,
    input wire [1:0] ResultSrcE,
    input wire [2:0] ALUControlE,
    input wire [4:0] RdE,
    input wire [4:0] Rs1E, Rs2E,
    input wire [31:0] RD1_E,
    input wire [31:0] RD2_E,
    input wire [31:0] ImmExtE,
    input wire [31:0] PCE,
    input wire [31:0] PCPlus4E,
    input wire [1:0] ForwardAE,
    input wire [1:0] ForwardBE,
    input wire [31:0] ResultW,
    input wire [31:0] ALUResultM,
    output reg RegWriteM,
    output reg MemWriteM,
    output reg MemReadM,
    output reg [1:0] ResultSrcM,
    output reg [4:0] RdM,
    output reg [31:0] ALUResultM_out,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCPlus4M,
    output wire PCSrcE,
    output wire [31:0] PCTargetE
);
    wire [31:0] SrcAE, SrcBE;
    wire [31:0] ALUResultE;
    wire ZeroE;
    wire [31:0] ForwardedRD1, ForwardedRD2;
    wire MemReadE;

    assign ForwardedRD1 = (ForwardAE == 2'b00) ? RD1_E :
        (ForwardAE == 2'b01) ? ResultW :
        (ForwardAE == 2'b10) ? ALUResultM :
        RD1_E;

    assign ForwardedRD2 = (ForwardBE == 2'b00) ? RD2_E :
        (ForwardBE == 2'b01) ? ResultW :
        (ForwardBE == 2'b10) ? ALUResultM :
        RD2_E;

    assign SrcAE = ForwardedRD1;
    assign SrcBE = ALUSrcE ? ImmExtE : ForwardedRD2;

    ALU alu_unit(
        .A(SrcAE),
        .B(SrcBE),
        .ALUControl(ALUControlE),
        .result(ALUResultE),
        .zero(ZeroE)
    );

    assign PCTargetE = PCE + ImmExtE;
    assign PCSrcE = (BranchE & ZeroE) | JumpE;
    assign MemReadE = (ResultSrcE == 2'b01);

    always @(posedge clk) begin
        if (rst) begin
            RegWriteM <= 1'b0;
            MemWriteM <= 1'b0;
            MemReadM <= 1'b0;
            ResultSrcM <= 2'b00;
            RdM <= 5'b00000;
            ALUResultM_out <= 32'b0;
            WriteDataM <= 32'b0;
            PCPlus4M <= 32'b0;
        end else begin
            RegWriteM <= RegWriteE;
            MemWriteM <= MemWriteE;
            MemReadM <= MemReadE;
            ResultSrcM <= ResultSrcE;
            RdM <= RdE;
            ALUResultM_out <= ALUResultE;
            WriteDataM <= ForwardedRD2;
            PCPlus4M <= PCPlus4E;
        end
    end
endmodule

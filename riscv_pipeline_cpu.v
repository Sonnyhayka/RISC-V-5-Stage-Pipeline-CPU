`timescale 1ns / 1ps

module riscv_pipeline_cpu(
    input wire clk,
    input wire rst
);
    wire [31:0] InstrD, PCD, PCPlus4D;

    wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
    wire [1:0] ResultSrcE;
    wire [2:0] ALUControlE;
    wire [4:0] RdE, Rs1E, Rs2E;
    wire [31:0] RD1_E, RD2_E, ImmExtE, PCE, PCPlus4E;

    wire RegWriteM, MemWriteM, MemReadM;
    wire [1:0] ResultSrcM;
    wire [4:0] RdM;
    wire [31:0] ALUResultM, WriteDataM, PCPlus4M;

    wire RegWriteW;
    wire [4:0] RdW;
    wire [31:0] ALUResultW, ReadDataW, PCPlus4W, ResultW;
    wire [1:0] ResultSrcW;

    wire PCSrcE;
    wire [31:0] PCTargetE;

    wire StallF, StallD, FlushD, FlushE;
    wire [1:0] ForwardAE, ForwardBE;

    instructionFetch IF_stage(
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    instructionDecode ID_stage(
        .clk(clk),
        .rst(rst),
        .RegWriteW(RegWriteW),
        .RDW(RdW),
        .ResultW(ResultW),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUControlE),
        .RdE(RdE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .ImmExtE(ImmExtE),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E)
    );

    execute_cycle EX_stage(
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUControlE),
        .RdE(RdE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .ImmExtE(ImmExtE),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ResultW(ResultW),
        .ALUResultM(ALUResultM),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .MemReadM(MemReadM),
        .ResultSrcM(ResultSrcM),
        .RdM(RdM),
        .ALUResultM_out(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE)
    );

    memory_cycle MEM_stage(
        .clk(clk),
        .rst(rst),
        .alu_result_in(ALUResultM),
        .store_data_in(WriteDataM),
        .pc_plus4_in(PCPlus4M),
        .rd_addr_in(RdM),
        .memRead_in(MemReadM),
        .memWrite_in(MemWriteM),
        .regWrite_in(RegWriteM),
        .resultSrc_in(ResultSrcM),
        .read_data_out(ReadDataW),
        .alu_result_out(ALUResultW),
        .pc_plus4_out(PCPlus4W),
        .rd_addr_out(RdW),
        .regWrite_out(RegWriteW),
        .resultSrc_out(ResultSrcW)
    );

    writeback_cycle WB_stage(
        .alu_result_in(ALUResultW),
        .read_data_in(ReadDataW),
        .pc_plus4_in(PCPlus4W),
        .resultSrc_in(ResultSrcW),
        .write_data_out(ResultW)
    );

    hazard_unit HU(
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE[0]),
        .PCSrcE(PCSrcE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE)
    );
endmodule

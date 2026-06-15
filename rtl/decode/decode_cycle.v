`timescale 1ns / 1ps

module instructionDecode(
    input wire clk, rst, FlushE, RegWriteW,
    input wire [4:0] RDW,
    input wire [31:0] ResultW, InstrD, PCD, PCPlus4D,
    output wire RegWriteE, MemWriteE, MemReadE, JumpE, BranchE, JumpSrcE, ALUSrcE,
    output wire [1:0] ResultSrcE, ALUSrcAE,
    output wire [3:0] ALUControlE,
    output wire [2:0] funct3E,
    output wire [4:0] RdE,
    output wire [4:0] Rs1E, Rs2E,
    output wire [31:0] RD1_E, RD2_E, ImmExtE, PCE, PCPlus4E
);
    wire RegWriteD, MemWriteD, MemReadD, JumpD, BranchD, JumpSrcD, ALUSrcD;
    wire [1:0] ResultSrcD, ALUSrcAD;
    wire [2:0] ImmSrcD;
    wire [3:0] ALUControlD;
    wire [31:0] RD1_D, RD2_D, ImmExtD;

    wire [4:0] RdD = InstrD[11:7];
    wire [4:0] Rs1D = InstrD[19:15];
    wire [4:0] Rs2D = InstrD[24:20];
    wire [2:0] funct3D = InstrD[14:12];

    reg RegWriteD_reg, MemWriteD_reg, MemReadD_reg, JumpD_reg, BranchD_reg, JumpSrcD_reg, ALUSrcD_reg;
    reg [1:0] ResultSrcD_reg, ALUSrcAD_reg;
    reg [3:0] ALUControlD_reg;
    reg [2:0] funct3D_reg;
    reg [4:0] RdD_reg, Rs1D_reg, Rs2D_reg;
    reg [31:0] RD1_D_reg, RD2_D_reg, PCD_reg, ImmExtD_reg, PCPlus4D_reg;

    controlUnit Control_Unit(
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .MemReadD(MemReadD),
        .ALUSrcD(ALUSrcD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .JumpSrcD(JumpSrcD),
        .ResultSrcD(ResultSrcD),
        .ALUSrcAD(ALUSrcAD),
        .ImmSrcD(ImmSrcD),
        .ALUControlD(ALUControlD)
    );

    extend extend_unit(
        .InstrD(InstrD),
        .ImmSrcD(ImmSrcD),
        .ImmExtD(ImmExtD)
    );

    registerFile Register_File(
        .clk(clk),
        .rst(rst),
        .we3(RegWriteW),
        .wd3(ResultW),
        .a1(Rs1D),
        .a2(Rs2D),
        .a3(RDW),
        .rd1(RD1_D),
        .rd2(RD2_D)
    );

    always @(posedge clk) begin
        if (rst || FlushE) begin
            RegWriteD_reg <= 1'b0;
            MemWriteD_reg <= 1'b0;
            MemReadD_reg <= 1'b0;
            ALUSrcD_reg <= 1'b0;
            BranchD_reg <= 1'b0;
            JumpD_reg <= 1'b0;
            JumpSrcD_reg <= 1'b0;
            ResultSrcD_reg <= 2'b0;
            ALUSrcAD_reg <= 2'b0;
            ALUControlD_reg <= 4'b0;
            funct3D_reg <= 3'b0;
            RdD_reg <= 5'b0;
            Rs1D_reg <= 5'b0;
            Rs2D_reg <= 5'b0;
            RD1_D_reg <= 32'b0;
            RD2_D_reg <= 32'b0;
            PCD_reg <= 32'b0;
            ImmExtD_reg <= 32'b0;
            PCPlus4D_reg <= 32'b0;
        end else begin
            RegWriteD_reg <= RegWriteD;
            MemWriteD_reg <= MemWriteD;
            MemReadD_reg <= MemReadD;
            ALUSrcD_reg <= ALUSrcD;
            BranchD_reg <= BranchD;
            JumpD_reg <= JumpD;
            JumpSrcD_reg <= JumpSrcD;
            ResultSrcD_reg <= ResultSrcD;
            ALUSrcAD_reg <= ALUSrcAD;
            ALUControlD_reg <= ALUControlD;
            funct3D_reg <= funct3D;
            RdD_reg <= RdD;
            Rs1D_reg <= Rs1D;
            Rs2D_reg <= Rs2D;
            RD1_D_reg <= RD1_D;
            RD2_D_reg <= RD2_D;
            PCD_reg <= PCD;
            ImmExtD_reg <= ImmExtD;
            PCPlus4D_reg <= PCPlus4D;
        end
    end

    assign RegWriteE = RegWriteD_reg;
    assign MemWriteE = MemWriteD_reg;
    assign MemReadE = MemReadD_reg;
    assign JumpE = JumpD_reg;
    assign BranchE = BranchD_reg;
    assign JumpSrcE = JumpSrcD_reg;
    assign ALUSrcE = ALUSrcD_reg;
    assign ResultSrcE = ResultSrcD_reg;
    assign ALUSrcAE = ALUSrcAD_reg;
    assign ALUControlE = ALUControlD_reg;
    assign funct3E = funct3D_reg;
    assign RdE = RdD_reg;
    assign Rs1E = Rs1D_reg;
    assign Rs2E = Rs2D_reg;
    assign RD1_E = RD1_D_reg;
    assign RD2_E = RD2_D_reg;
    assign ImmExtE = ImmExtD_reg;
    assign PCE = PCD_reg;
    assign PCPlus4E = PCPlus4D_reg;
endmodule

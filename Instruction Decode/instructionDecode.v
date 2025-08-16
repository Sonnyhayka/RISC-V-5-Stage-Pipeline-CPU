`timescale 1ns / 1ps

module instructionDecode(
    input wire clk, rst, RegWriteW,
    input wire [4:0] RDW,
    input wire [31:0] ResultW, InstrD, PCD, PCPlus4D,
    
    output wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
    output wire [1:0] ResultSrcE,
    output wire [2:0] ALUControlE,
    output wire [4:0] RdE,
    output wire [31:0] RD1_E, RD2_E, ImmExtE, PCE, PCPlus4E 
    );
    
    // In-between wires
    wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD;
    wire [4:0] RdD;
    wire [31:0] RD1_D, RD2_D, ImmExtD;
    
    // In-between registers
    reg RegWriteD_reg, MemWriteD_reg, JumpD_reg, BranchD_reg, ALUSrcD_reg; 
    reg [1:0] ResultSrcD_reg;
    reg [2:0] ALUControlD_reg;
    reg [4:0] RdD_reg;
    reg [31:0] RD1_D_reg, RD2_D_reg, PCD_reg, ImmExtD_reg, PCPlus4D_reg;
    
    // Delcare control unit
    controlUnit Control_Unit(
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .ImmSrcD(ImmSrcD)
        );
        
    // Declare extend unit
    extend extend_unit(
        .InstrD(InstrD[31:0]),
        .ImmSrcD(ImmSrcD),
        .ImmExtD(ImmExtD)
        );
        
    registerFile Register_File(
        .clk(clk),
        .rst(rst),
        .we3(RegWriteW),
        .wd3(ResultW),
        .a1(InstrD[19:15]),
        .a2(InstrD[24:20]),
        .a3(RDW),
        .rd1(RD1_D),
        .rd2(RD2_D)
        );
        
    always @(posedge clk) begin
        if (rst) begin
            RegWriteD_reg <= 1'b0;
            MemWriteD_reg <= 1'b0;
            ALUSrcD_reg <= 1'b0;
            BranchD_reg <= 1'b0;
            JumpD_reg <= 1'b0;
            ResultSrcD_reg <= 2'b0;
            ALUControlD_reg <= 3'b0;
            RdD_reg <= 5'b0;
            RD1_D_reg <= 32'b0;
            RD2_D_reg <= 32'b0;
            PCD_reg <= 32'b0;
            ImmExtD_reg <= 32'b0;
            PCPlus4D_reg <= 32'b0;
        end else begin
            RegWriteD_reg <= RegWriteD;
            MemWriteD_reg <= MemWriteD;
            ALUSrcD_reg <= ALUSrcD;
            BranchD_reg <= BranchD;
            JumpD_reg <= JumpD;
            ResultSrcD_reg <= ResultSrcD;
            ALUControlD_reg <= ALUControlD;
            RdD_reg <= RdD;
            RD1_D_reg <= RD1_D;
            RD2_D_reg <= RD2_D;
            PCD_reg <= PCD;
            ImmExtD_reg <= ImmExtD;
            PCPlus4D_reg <= PCPlus4D;
        end
    end
    
    assign RegWriteE =  RegWriteD_reg;
    assign ResultSrcE = ResultSrcD_reg;
    assign MemWriteE = MemWriteD_reg;
    assign JumpE = JumpD_reg;
    assign BranchE = BranchD_reg;
    assign ALUControlE = ALUControlD_reg;
    assign ALUSrcE = ALUSrcD_reg;
    assign RD1_E = RD1_D_reg;
    assign RD2_E = RD2_D_reg;
    assign PCE = PCD_reg;
    assign RdE = RdD_reg;
    assign ImmExtE = ImmExtD_reg;
    assign PCPlus4E = PCPlus4D_reg;
endmodule

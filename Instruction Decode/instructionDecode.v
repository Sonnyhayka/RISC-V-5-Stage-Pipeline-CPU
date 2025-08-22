`timescale 1ns / 1ps

// Instruction Decode module for RISC-V 5-stage pipeline CPU
module instructionDecode(
    input wire clk, rst, RegWriteW,                // Clock, reset, and write enable from Writeback stage
    input wire [4:0] RDW,                          // Destination register address from Writeback stage
    input wire [31:0] ResultW, InstrD, PCD, PCPlus4D, // Writeback result, instruction, PC, and PC+4 from Decode stage
    
    output wire RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, // Control signals to Execute stage
    output wire [1:0] ResultSrcE,                  // Result source control to Execute stage
    output wire [2:0] ALUControlE,                 // ALU control to Execute stage
    output wire [4:0] RdE,                         // Destination register address to Execute stage
    output wire [4:0] Rs1E, Rs2E,                 // Source register addresses to Execute stage  
    output wire [31:0] RD1_E, RD2_E, ImmExtE, PCE, PCPlus4E // Register values, immediate, PC, and PC+4 to Execute stage
    );
    
    // Internal wires for control and data signals from control/extend/registerFile units
    wire RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [2:0] ALUControlD;
    wire [4:0] RdD;
    wire [31:0] RD1_D, RD2_D, ImmExtD;
    
    // Extract register addresses and destination register from instruction
    assign RdD = InstrD[11:7];  // Destination register rd
    wire [4:0] Rs1D = InstrD[19:15]; // Source register 1 rs1
    wire [4:0] Rs2D = InstrD[24:20]; // Source register 2 rs2
    
    // Pipeline registers to hold signals between Decode and Execute stages
    reg RegWriteD_reg, MemWriteD_reg, JumpD_reg, BranchD_reg, ALUSrcD_reg; 
    reg [1:0] ResultSrcD_reg;
    reg [2:0] ALUControlD_reg;
    reg [4:0] RdD_reg, Rs1D_reg, Rs2D_reg;
    reg [31:0] RD1_D_reg, RD2_D_reg, PCD_reg, ImmExtD_reg, PCPlus4D_reg;
    
    // Instantiate control unit: decodes instruction to control signals
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
        
    // Instantiate immediate extend unit: generates extended immediate value
    extend extend_unit(
        .InstrD(InstrD[31:0]),
        .ImmSrcD(ImmSrcD),
        .ImmExtD(ImmExtD)
        );
        
    // Instantiate register file: reads register values and handles writeback
    registerFile Register_File(
        .clk(clk),
        .rst(rst),
        .we3(RegWriteW),
        .wd3(ResultW),
        .a1(InstrD[19:15]),    // rs1
        .a2(InstrD[24:20]),    // rs2
        .a3(RDW),               // rd (writeback)
        .rd1(RD1_D),
        .rd2(RD2_D)
        );
        
    // Pipeline register update: store control/data signals for next stage
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
            ALUSrcD_reg <= ALUSrcD;
            BranchD_reg <= BranchD;
            JumpD_reg <= JumpD;
            ResultSrcD_reg <= ResultSrcD;
            ALUControlD_reg <= ALUControlD;
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
    
    // Output assignments to Execute stage
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
    assign Rs1E = Rs1D_reg;
    assign Rs2E = Rs2D_reg;
    assign ImmExtE = ImmExtD_reg;
    assign PCPlus4E = PCPlus4D_reg;
endmodule

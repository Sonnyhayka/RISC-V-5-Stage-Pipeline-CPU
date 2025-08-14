`timescale 1ns / 1ps

module instructionFetch(clk, rst, InstrD, PCD, PCPlus4D, PCSrcE, PCTargetE);
    // IO Allocations
    input wire clk;
    input wire rst;
    input wire PCSrcE;
    input wire [31:0] PCTargetE;
    output wire [31:0] InstrD;
    output wire [31:0] PCD;
    output wire [31:0] PCPlus4D;
    
    // Wire for operations
    wire [31:0] PCF;
    wire [31:0] PC_F;
    wire [31:0] instr;
    wire [31:0] PCPlus4F;
        
    // Registers for storing respective values
    reg [31:0] PCF_reg;
    reg [31:0] PCPlus4F_reg;
    reg [31:0] instr_reg;
    
    // Declare Program Counter
    programCounter PC_module(
        .rst(rst),
        .clk(clk),
        .PCnext(PC_F),
        .PC(PCF)
        );
        
    // Declare Instruction Memory
    instructionMemory IM_module(
        .addr(PCF),
        .rd(instr),
        .rst(rst)
        );
        
    // Declare the PC adder to incriment instruction
    PCAdder PC_Adder(
        .out(PCPlus4F),
        .in1(PCF),
        .in2(32'h4)
        );
        
    // Declare PC MUX 
    PCMux PC_Mux(
        .s(PCSrcE),
        .in1(PCPlus4F),
        .in2(PCTargetE),
        .out(PC_F)
        );
    
    // Logic for resetting or storing values in registers
    always @(posedge clk) begin
        if (rst) begin
            PCF_reg <= 32'b0;
            PCPlus4F_reg <= 32'b0;
            instr_reg <= 32'b0;
        end else begin
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
            instr_reg <= instr;
        end
    end
    
    // Assigning reg values to IOs
    assign InstrD = instr_reg;
    assign PCD = PCF_reg;
    assign PCPlus4D = PCPlus4F_reg;
endmodule

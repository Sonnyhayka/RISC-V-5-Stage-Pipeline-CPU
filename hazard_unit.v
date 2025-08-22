// Hazard Detection and Forwarding Unit for RISC-V 5-Stage Pipeline CPU
`timescale 1ns / 1ps

module hazard_unit(
    // Register addresses for hazard detection
    input wire [4:0] Rs1E,      // Source register 1 in Execute stage
    input wire [4:0] Rs2E,      // Source register 2 in Execute stage
    input wire [4:0] RdE,       // Destination register in Execute stage
    input wire [4:0] RdM,       // Destination register in Memory stage
    input wire [4:0] RdW,       // Destination register in Writeback stage
    
    // Control signals
    input wire RegWriteM,       // Register write enable in Memory stage
    input wire RegWriteW,       // Register write enable in Writeback stage
    input wire ResultSrcE,      // Result source in Execute (1 for load)
    input wire PCSrcE,          // PC source (1 for branch/jump taken)
    
    // Forwarding control outputs
    output reg [1:0] ForwardAE, // Forward control for ALU input A
    output reg [1:0] ForwardBE, // Forward control for ALU input B
    
    // Stall and flush control outputs
    output wire StallF,         // Stall Fetch stage
    output wire StallD,         // Stall Decode stage
    output wire FlushD,         // Flush Decode stage
    output wire FlushE          // Flush Execute stage
);

    // Load-use hazard detection
    wire lwStall;
    assign lwStall = ResultSrcE & ((Rs1E == RdE) | (Rs2E == RdE)) & (RdE != 5'b0);
    
    // Stall control
    assign StallF = lwStall;
    assign StallD = lwStall;
    
    // Flush control
    assign FlushD = PCSrcE;     // Flush on branch/jump taken
    assign FlushE = lwStall | PCSrcE; // Flush on stall or branch/jump
    
    // Forwarding logic for ALU input A (Rs1E)
    always @(*) begin
        if ((Rs1E == RdM) & RegWriteM & (RdM != 5'b0)) begin
            ForwardAE = 2'b10;  // Forward from Memory stage
        end else if ((Rs1E == RdW) & RegWriteW & (RdW != 5'b0)) begin
            ForwardAE = 2'b01;  // Forward from Writeback stage
        end else begin
            ForwardAE = 2'b00;  // No forwarding needed
        end
    end
    
    // Forwarding logic for ALU input B (Rs2E)
    always @(*) begin
        if ((Rs2E == RdM) & RegWriteM & (RdM != 5'b0)) begin
            ForwardBE = 2'b10;  // Forward from Memory stage
        end else if ((Rs2E == RdW) & RegWriteW & (RdW != 5'b0)) begin
            ForwardBE = 2'b01;  // Forward from Writeback stage
        end else begin
            ForwardBE = 2'b00;  // No forwarding needed
        end
    end

endmodule

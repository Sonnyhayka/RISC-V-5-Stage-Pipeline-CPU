`timescale 1ns / 1ps

module hazard_unit(
    input wire [4:0] Rs1D,
    input wire [4:0] Rs2D,
    input wire [4:0] Rs1E,
    input wire [4:0] Rs2E,
    input wire [4:0] RdE,
    input wire [4:0] RdM,
    input wire [4:0] RdW,
    input wire RegWriteM,
    input wire RegWriteW,
    input wire MemReadE,
    input wire PCSrcE,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output wire StallF,
    output wire StallD,
    output wire FlushD,
    output wire FlushE
);
    wire lwStall;
    assign lwStall = MemReadE & ((Rs1D == RdE) | (Rs2D == RdE)) & (RdE != 5'b0);

    assign StallF = lwStall;
    assign StallD = lwStall;
    assign FlushD = PCSrcE;
    assign FlushE = lwStall | PCSrcE;

    always @(*) begin
        if ((Rs1E == RdM) & RegWriteM & (RdM != 5'b0)) begin
            ForwardAE = 2'b10;
        end else if ((Rs1E == RdW) & RegWriteW & (RdW != 5'b0)) begin
            ForwardAE = 2'b01;
        end else begin
            ForwardAE = 2'b00;
        end
    end

    always @(*) begin
        if ((Rs2E == RdM) & RegWriteM & (RdM != 5'b0)) begin
            ForwardBE = 2'b10;
        end else if ((Rs2E == RdW) & RegWriteW & (RdW != 5'b0)) begin
            ForwardBE = 2'b01;
        end else begin
            ForwardBE = 2'b00;
        end
    end
endmodule

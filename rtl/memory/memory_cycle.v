`timescale 1ns / 1ps

module memory_cycle #(
    parameter MEM_DEPTH = 256
)(
    input clk,
    input rst,
    input [31:0] alu_result_in,
    input [31:0] store_data_in,
    input [31:0] pc_plus4_in,
    input [4:0] rd_addr_in,
    input memRead_in,
    input memWrite_in,
    input regWrite_in,
    input [1:0] resultSrc_in,
    output reg [31:0] read_data_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] pc_plus4_out,
    output reg [4:0] rd_addr_out,
    output reg regWrite_out,
    output reg [1:0] resultSrc_out
);
    reg [31:0] data_mem [0:MEM_DEPTH-1];
    wire [31:0] mem_read = data_mem[alu_result_in[31:2]];

    always @(posedge clk) begin
        if (memWrite_in) begin
            data_mem[alu_result_in[31:2]] <= store_data_in;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            read_data_out <= 32'b0;
            alu_result_out <= 32'b0;
            pc_plus4_out <= 32'b0;
            rd_addr_out <= 5'b0;
            regWrite_out <= 1'b0;
            resultSrc_out <= 2'b0;
        end else begin
            read_data_out <= memRead_in ? mem_read : 32'b0;
            alu_result_out <= alu_result_in;
            pc_plus4_out <= pc_plus4_in;
            rd_addr_out <= rd_addr_in;
            regWrite_out <= regWrite_in;
            resultSrc_out <= resultSrc_in;
        end
    end
endmodule

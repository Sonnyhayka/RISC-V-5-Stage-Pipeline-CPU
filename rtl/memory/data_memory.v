`timescale 1ns / 1ps

module dataMemory #(
    parameter MEM_DEPTH = 256
)(
    input wire clk,
    input wire [31:0] Addr,
    input wire [31:0] WriteData,
    input wire [3:0] ByteWE,
    output wire [31:0] ReadData
);
    localparam AW = $clog2(MEM_DEPTH);

    reg [31:0] mem [0:MEM_DEPTH-1];
    wire [AW-1:0] word = Addr[AW+1:2];

    integer j;
    initial begin
        for (j = 0; j < MEM_DEPTH; j = j + 1)
            mem[j] = 32'b0;
    end

    always @(posedge clk) begin
        if (ByteWE[0]) mem[word][7:0] <= WriteData[7:0];
        if (ByteWE[1]) mem[word][15:8] <= WriteData[15:8];
        if (ByteWE[2]) mem[word][23:16] <= WriteData[23:16];
        if (ByteWE[3]) mem[word][31:24] <= WriteData[31:24];
    end

    assign ReadData = mem[word];
endmodule

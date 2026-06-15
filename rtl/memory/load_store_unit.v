`timescale 1ns / 1ps

module loadStoreUnit(
    input wire [2:0] funct3,
    input wire [1:0] addr,
    input wire memWrite,
    input wire [31:0] storeData,
    input wire [31:0] readWord,
    output reg [3:0] byteWE,
    output reg [31:0] writeData,
    output reg [31:0] loadResult
);
    wire [7:0] selByte = readWord[(addr*8) +: 8];
    wire [15:0] selHalf = readWord[(addr[1]*16) +: 16];

    always @(*) begin
        byteWE = 4'b0000;
        writeData = storeData;
        loadResult = readWord;
        case (funct3)
            3'b000: begin
                if (memWrite) byteWE = 4'b0001 << addr;
                writeData = {4{storeData[7:0]}};
                loadResult = {{24{selByte[7]}}, selByte};
            end
            3'b001: begin
                if (memWrite) byteWE = addr[1] ? 4'b1100 : 4'b0011;
                writeData = {2{storeData[15:0]}};
                loadResult = {{16{selHalf[15]}}, selHalf};
            end
            3'b010: begin
                if (memWrite) byteWE = 4'b1111;
                writeData = storeData;
                loadResult = readWord;
            end
            3'b100: begin
                loadResult = {24'b0, selByte};
            end
            3'b101: begin
                loadResult = {16'b0, selHalf};
            end
            default: begin
            end
        endcase
    end
endmodule

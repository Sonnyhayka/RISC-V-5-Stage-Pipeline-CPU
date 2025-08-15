`timescale 1ns / 1ps

module instructionMemory(addr, rd, rst);
    input wire [31:0] addr;
    output reg [31:0] rd;
    input wire rst;
    
    // Declaring 1024 word memory, 32 bits wide
    reg [31:0] Mem [1023:0];
    
    // Assignined the read to memory content at addr
    always @(*) begin
        if (rst) begin
            rd <= 32'b0;
        end else begin
            rd <= Mem[addr];
        end
    end
endmodule

`timescale 1ns / 1ps

module instructionMemory(addr, rd, rst);
    input wire [31:0] addr;
    output reg [31:0] rd;
    input wire rst;
    
    // Declaring 1024 word memory, 32 bits wide
    reg [31:0] Mem [1023:0];
    
    // Initialize memory with some test instructions
    initial begin
        // Initialize all memory to NOP (ADDI x0, x0, 0)
        integer i;
        for (i = 0; i < 1024; i = i + 1) begin
            Mem[i] = 32'h00000013; // NOP instruction
        end
        
        // Test program: Simple arithmetic operations
        Mem[0] = 32'h00500093;  // ADDI x1, x0, 5      (x1 = 5)
        Mem[1] = 32'h00300113;  // ADDI x2, x0, 3      (x2 = 3)
        Mem[2] = 32'h002081B3;  // ADD  x3, x1, x2     (x3 = x1 + x2 = 8)
        Mem[3] = 32'h40208233;  // SUB  x4, x1, x2     (x4 = x1 - x2 = 2)
        Mem[4] = 32'h002092B3;  // SLL  x5, x1, x2     (x5 = x1 << x2)
        Mem[5] = 32'h0020A333;  // SLT  x6, x1, x2     (x6 = x1 < x2 ? 1 : 0)
        Mem[6] = 32'h0020E3B3;  // OR   x7, x1, x2     (x7 = x1 | x2)
        Mem[7] = 32'h0020F433;  // AND  x8, x1, x2     (x8 = x1 & x2)
    end
    
    // Assigned the read to memory content at addr (word aligned)
    always @(*) begin
        if (rst) begin
            rd <= 32'b0;
        end else begin
            rd <= Mem[addr[31:2]]; // Word-aligned access
        end
    end
endmodule

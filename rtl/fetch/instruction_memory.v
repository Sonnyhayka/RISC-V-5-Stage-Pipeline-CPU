`timescale 1ns / 1ps

module instructionMemory(
    input wire [31:0] addr,
    output wire [31:0] rd
);
    reg [31:0] Mem [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            Mem[i] = 32'h00000013;

        Mem[0] = 32'h00500093;
        Mem[1] = 32'h00300113;
        Mem[2] = 32'h002081B3;
        Mem[3] = 32'h40208233;
        Mem[4] = 32'h002092B3;
        Mem[5] = 32'h0020A333;
        Mem[6] = 32'h0020E3B3;
        Mem[7] = 32'h0020F433;
    end

    assign rd = Mem[addr[31:2]];
endmodule

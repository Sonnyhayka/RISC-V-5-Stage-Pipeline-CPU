`timescale 1ns / 1ps

module instructionMemory #(
    parameter INIT_FILE = ""
)(
    input wire [31:0] addr,
    output wire [31:0] rd
);
    reg [31:0] Mem [0:1023];
    integer i;

    initial begin
        for (i = 0; i < 1024; i = i + 1)
            Mem[i] = 32'h00000013;
        if (INIT_FILE != "")
            $readmemh(INIT_FILE, Mem);
    end

    assign rd = Mem[addr[31:2]];
endmodule

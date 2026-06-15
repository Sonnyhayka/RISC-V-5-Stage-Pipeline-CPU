`timescale 1ns / 1ps

module writeback_cycle(
    input [31:0] alu_result_in,
    input [31:0] read_data_in,
    input [31:0] pc_plus4_in,
    input [1:0] resultSrc_in,
    output [31:0] write_data_out
);
    reg [31:0] result;

    always @(*) begin
        case (resultSrc_in)
            2'b00: result = alu_result_in;
            2'b01: result = read_data_in;
            2'b10: result = pc_plus4_in;
            default: result = alu_result_in;
        endcase
    end

    assign write_data_out = result;
endmodule

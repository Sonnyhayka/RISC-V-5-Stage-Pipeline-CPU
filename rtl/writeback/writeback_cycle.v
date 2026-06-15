// Writeback Cycle Module
// Selects the correct data to write back to the register file based on resultSrc_in
module writeback_cycle(
    input [31:0] alu_result_in,   // ALU computation result
    input [31:0] read_data_in,    // Data read from memory
    input [31:0] pc_plus4_in,     // PC + 4 value (for link instructions)
    input [4:0]  rd_addr_in,      // Destination register address
    input regWrite_in,     // Register write enable signal
    input [1:0]  resultSrc_in,    // Selects source for writeback
    output [31:0] write_data_out,  // Data to write to register file
    output [4:0]  rd_addr_out,     // Output register address
    output regWrite_out     // Output write enable signal
);
    reg [31:0] result;

    // Select the data to write back based on resultSrc_in
    always @(*) begin
        case (resultSrc_in)
            2'b00: result = alu_result_in;   // ALU result 
            2'b01: result = read_data_in;    // Memory load data
            2'b10: result = pc_plus4_in; 
            default: result = alu_result_in; // Default to ALU result
        endcase
    end

    // Assign outputs
    assign write_data_out = result;      // Data to write back
    assign rd_addr_out    = rd_addr_in;  // Pass through destination register address
    assign regWrite_out   = regWrite_in; // Pass through write enable control
endmodule

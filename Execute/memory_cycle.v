/* Memory cycle will takes ALU result, PC + 4, and destination register address as inputs
and provides the read data output, ALU result output, PC + 4 output, destination register address output,
register write enable output, and result source selector output. */

module memory_cycle #(
    parameter MEM_DEPTH = 256  // Number of 32-bit words in data memory (adjust as needed)
)(
    input         clk,
    input         reset,
    input [31:0] alu_result_in,   // ALU result (used as memory address)
    input [31:0] store_data_in,   // Data to store in memory
    input [31:0] pc_plus4_in,     // PC + 4 value
    input [4:0]  rd_addr_in,      // Destination register address
    input memRead_in, // Memory read enable
    input memWrite_in, // Memory write enable
    input regWrite_in, // Register write enable
    input [1:0]  resultSrc_in, // Result source selector
    output reg [31:0] read_data_out,  // Data read from memory
    output [31:0] alu_result_out, // ALU result output
    output [31:0] pc_plus4_out,   // PC + 4 output
    output [4:0]  rd_addr_out,    // Destination register address output
    output regWrite_out,   // Register write enable output
    output [1:0]  resultSrc_out   // Result source selector output
);
    // Data Memory
    reg [31:0] data_mem [0:MEM_DEPTH-1];
    
    // Synchronous write to memory for store operations
    always @(posedge clk) begin
        if (memWrite_in) begin
            // Store data at address specified by ALU result (word aligned)
            data_mem[alu_result_in[31:2]] <= store_data_in;
        end
    end

    // Combinational read from memory for load operations
    always @(*) begin
        if (memRead_in) begin
            // Read data from address specified by ALU result (word aligned)
            read_data_out = data_mem[alu_result_in[31:2]];
        end else begin
            read_data_out = 32'b0;
        end
    end
    
    // Pass-through signals to next pipeline stage
    assign alu_result_out  = alu_result_in;
    assign pc_plus4_out    = pc_plus4_in;
    assign rd_addr_out     = rd_addr_in;
    assign regWrite_out    = regWrite_in;
    assign resultSrc_out   = resultSrc_in;
endmodule

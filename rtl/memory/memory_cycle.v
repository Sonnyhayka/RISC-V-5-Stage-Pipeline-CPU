/* Memory cycle: performs the data-memory access for the instruction in the MEM
   stage and registers its results into the MEM/WB pipeline register. The store
   writes data memory; the load reads it; all values forwarded to writeback are
   captured on the clock edge so MEM and WB are genuinely separate stages. */

module memory_cycle #(
    parameter MEM_DEPTH = 256  // Number of 32-bit words in data memory
)(
    input         clk,
    input         rst,
    input [31:0] alu_result_in,   // ALU result (used as memory address)
    input [31:0] store_data_in,   // Data to store in memory
    input [31:0] pc_plus4_in,     // PC + 4 value
    input [4:0]  rd_addr_in,      // Destination register address
    input memRead_in,             // Memory read enable
    input memWrite_in,            // Memory write enable
    input regWrite_in,            // Register write enable
    input [1:0]  resultSrc_in,    // Result source selector
    output reg [31:0] read_data_out,  // Data read from memory (MEM/WB)
    output reg [31:0] alu_result_out, // ALU result (MEM/WB)
    output reg [31:0] pc_plus4_out,   // PC + 4 (MEM/WB)
    output reg [4:0]  rd_addr_out,    // Destination register address (MEM/WB)
    output reg regWrite_out,          // Register write enable (MEM/WB)
    output reg [1:0]  resultSrc_out   // Result source selector (MEM/WB)
);
    // Data memory
    reg [31:0] data_mem [0:MEM_DEPTH-1];
    wire [31:0] mem_read = data_mem[alu_result_in[31:2]]; // word-aligned read

    // Store: synchronous write to data memory in the MEM stage
    always @(posedge clk) begin
        if (memWrite_in) begin
            data_mem[alu_result_in[31:2]] <= store_data_in;
        end
    end

    // MEM/WB pipeline register: capture memory read and pass-through signals
    always @(posedge clk) begin
        if (rst) begin
            read_data_out  <= 32'b0;
            alu_result_out <= 32'b0;
            pc_plus4_out   <= 32'b0;
            rd_addr_out    <= 5'b0;
            regWrite_out   <= 1'b0;
            resultSrc_out  <= 2'b0;
        end else begin
            read_data_out  <= memRead_in ? mem_read : 32'b0;
            alu_result_out <= alu_result_in;
            pc_plus4_out   <= pc_plus4_in;
            rd_addr_out    <= rd_addr_in;
            regWrite_out   <= regWrite_in;
            resultSrc_out  <= resultSrc_in;
        end
    end
endmodule

`timescale 1ns / 1ps

module tb_riscv_pipeline_cpu;
    reg clk = 0;
    reg rst = 1;

    riscv_pipeline_cpu uut(.clk(clk), .rst(rst));

    always #5 clk = ~clk;

    initial begin
        #1;
        uut.IF_stage.IM_module.Mem[0] = 32'h00500093;
        uut.IF_stage.IM_module.Mem[1] = 32'h00300113;
        uut.IF_stage.IM_module.Mem[2] = 32'h002081b3;
        uut.IF_stage.IM_module.Mem[3] = 32'h40208233;
        uut.IF_stage.IM_module.Mem[4] = 32'h002092b3;
        uut.IF_stage.IM_module.Mem[5] = 32'h0020a333;
        uut.IF_stage.IM_module.Mem[6] = 32'h0020e3b3;
        uut.IF_stage.IM_module.Mem[7] = 32'h0020f433;
        uut.IF_stage.IM_module.Mem[8] = 32'h00000063;
        #19 rst = 0;
        #200;
        $display("Time %0t: x1=%h x3=%h x5=%h x8=%h", $time,
            uut.ID_stage.Register_File.regFile[1],
            uut.ID_stage.Register_File.regFile[3],
            uut.ID_stage.Register_File.regFile[5],
            uut.ID_stage.Register_File.regFile[8]);
        $finish;
    end

    initial begin
        $monitor("Time %0t PC=%h Instr=%h", $time, uut.IF_stage.PCF, uut.InstrD);
    end
endmodule

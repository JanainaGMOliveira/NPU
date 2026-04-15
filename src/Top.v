module Top(
    input  clk,
    input  reset
);
    wire [31:0] pc, instr, readData, dataAddr, writeData, memWriteEnable;
    
    NPUCore           core(clk, reset, pc, instr, memwrite, dataadr, writedata, readdata);
    InstructionMemory imem(instr, pc);
    DataMemory        dmem(readData, dataAddr, writeData, memWriteEnable, clk);

endmodule
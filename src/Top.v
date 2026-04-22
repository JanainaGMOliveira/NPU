module Top(
    input  clk,
    input  rst
);
    wire [31:0] pc;
    wire [31:0] instruction;

    wire        immSrcD;
    wire        regWriteD;
    wire        memWriteD;
    wire        useMacD;
    wire [1:0]  resultSrcD;
    wire [1:0]  actFunctD;

    InstructionMemory imem(instruction, pc);

    MainDecoder       control(immSrcD, regWriteD, memWriteD, useMacD, resultSrcD, actFunctD, instruction);

    NPUCore           datapath(pc, immSrcD, regWriteD, memWriteD, useMacD, resultSrcD, actFunctD, clk, rst);
    
    DataMemory        dmem(readData, dataAddr, writeData, memWriteEnable, clk);

endmodule
module WriteBackStage(
    output [31:0] oWriteDataReg,
    output        oRegWrite,

    input  [31:0] iResult,
    input  [31:0] iMemoryData,

    input         iRegWrite,
    input         iValidInstruction,
    input  [1:0]  iResultSrc
);
    assign oWriteDataReg = iResultSrc == 2'b01 ? iMemoryData : iResult;
    assign oRegWrite     = iValidInstruction && iRegWrite;
endmodule
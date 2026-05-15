module MemoryStage(
    output [31:0] oMemoryAddr,
    output        oMemoryRead,
    output        oMemoryWrite,
    output [31:0] oMemoryWData,

    output [31:0] oMemoryResult,

    output        oMemStall,

    input         iValid,

    input         iMemRead,
    input         iMemWrite,

    input  [31:0] iMemAddr,
    input  [31:0] iStoreData,

    input  [31:0] iMemoryRData,
    input         iMemoryReady
);
    assign oMemoryAddr = iMemAddr;

    assign oMemoryRead = iValid && iMemRead;

    assign oMemoryWrite = iValid && iMemWrite;

    assign oMemoryWData = iStoreData;

    assign oMemoryResult = iMemoryRData;

    assign oMemStall = iValid && (iMemRead || iMemWrite ) && !iMemoryReady;
endmodule
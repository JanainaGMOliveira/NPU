module Top(
    output            oBusy,
    output            oDone,
    output            oInterrupt,
    output            oPipelineEmpty,

    input             iStart,
    input      [31:0] iInstructionBaseAddr,

    output     [31:0] oInstructionMemoryAddr,
    output            oInstructionMemoryRead,
    input      [31:0] iInstructionRData,
    input             iInstructionReady,

    // Memory interface
    output  [31:0] oMemoryAddr,
    output         oMemoryRead,
    output         oMemoryWrite,
    output  [31:0] oMemoryWData,
    input   [31:0] iMemoryRData,
    input          iMemoryReady,

    input  clk,
    input  rst
);
    wire [31:0] instructionF,      instructionD;

    wire        validInstructionF, validInstructionD, validInstructionE1, validInstructionE2, validInstructionM, validInstructionWB;
    wire                           regWriteD,         regWriteE1,         regWriteE2,         regWriteM,         regWriteWB, regWriteValid;
    wire                           memReadD,          memReadE1,          memReadE2,          memReadM;
    wire                           memWriteD,         memWriteE1,         memWriteE2,         memWriteM;
    wire [1:0]                     resultSrcD,        resultSrcE1,        resultSrcE2,        resultSrcM,        resultSrcWB;
    wire                           useMacD,           useMacE1,           useMacE2,           useMacM;
    wire [1:0]                     actFunctD,         actFunctE1,         actFunctE2;
    wire                           isActivationD,     isActivationE1,     isActivationE2;
    wire                           isECALLD;
    wire                                                                  useAccBypassOnActE2;

    wire [31:0]                                       mulResultE1,        mulResultE2;
    wire [31:0]                                                           resultE2,           resultM,           resultWB;
    wire [31:0]                    readData1D,        readData1E1;
    wire [31:0]                    readData2D,        readData2E1;
    wire [4:0]                     rs1D,              rs1E1,              rs1E2;
    wire [4:0]                     rs2D,              rs2E1;
    wire [4:0]                     rdD,               rdE1,               rdE2,               rdM,                rdWB;
    wire [31:0]                                                                                                   writeDataReg;
    wire [31:0]                                                           storeDataE2,        storeDataM;
    wire [31:0]                                                                                                   memoryDataWB;
    wire [11:0]                    immD,              immE1,              immE2;
    wire [31:0] operandAForwardedE1, operandAForwardedE2;
    wire [31:0] operandBForwardedE1;
    wire [31:0] dataMem;
    wire [31:0] memoryDataM;

    wire haltRequisition;
    wire stallF,          stallD,         stallE1,          stallE2, stallM;
    wire stallF_HDU,      stallD_HDU;
    wire                  flushD,         flushE1;

    assign oPipelineEmpty = !validInstructionF  &&
                            !validInstructionD  &&
                            !validInstructionE1 &&
                            !validInstructionE2 &&
                            !validInstructionWB &&
                            !validInstructionM;

    GlobalControl globalCtrl(.oBusy(oBusy),
                             .oDone(oDone),
                             .oInterrupt(oInterrupt),
                             .iStart(iStart),
                             .rst(rst),
                             .clk(clk),
                             .iHaltRequisition(haltRequisition),
                             .iPipelineEmpty(oPipelineEmpty));

    PipelineControl pipelineCtrl(.oFlushD           (flushD),
                                 .iIsECALLD         (isECALLD),
                                 .iValidInstructionD(validInstructionD));

    InstructionFetchUnit IF(.oInstruction          (instructionF),
                            .oValid                (validInstructionF),
                            .oInstructionMemoryAddr(oInstructionMemoryAddr),
                            .oInstructionMemoryRead(oInstructionMemoryRead),
                            .iInstructionRData     (iInstructionRData),
                            .iInstructionReady     (iInstructionReady),
                            .iEnable               (!stallF && !haltRequisition),
                            .iStart                (iStart),
                            .iInstructionBaseAddr  (iInstructionBaseAddr),
                            .clk                   (clk),
                            .rst                   (rst));

    PipelineRegister #(33) regF_D(.oQ    ({instructionD, validInstructionD}),
                                  .iD    ({instructionF, validInstructionF}),
                                  .iStall(stallD),
                                  .iFlush(flushD),
                                  .rst   (rst),
                                  .clk   (clk));

    MainDecoder control(.oIsECALL         (isECALLD),
                        .oRegWrite        (regWriteD),
                        .oMemWrite        (memWriteD),
                        .oMemRead         (memReadD),
                        .oUseMac          (useMacD),
                        .oResultSrc       (resultSrcD),
                        .oActFunct        (actFunctD),
                        .oIsActivation    (isActivationD),
                        .oRs1             (rs1D),
                        .oRs2             (rs2D),
                        .oRd              (rdD),
                        .oImmediate       (immD),
                        .oHaltRequisition (haltRequisition),
                        .iInstruction     (instructionD),
                        .iValidInstruction(validInstructionD),
                        .rst              (rst),
                        .clk              (clk));

    RegisterFile #(8, 32) regFile(.oReadData1   (readData1D),
                                  .oReadData2   (readData2D),
                                  .iAddr1       (rs1D),
                                  .iAddr2       (rs2D),
                                  .iAddr3       (rdWB),
                                  .iWriteData3  (writeDataReg),
                                  .iWriteEnable3(regWriteValid),
                                  .clk          (clk),
                                  .rst          (rst));

    PipelineRegister #(101) regD_E1(.oQ    ({regWriteE1, memWriteE1, memReadE1, useMacE1, resultSrcE1, actFunctE1, isActivationE1,
                                            validInstructionE1,
                                            rs1E1, rs2E1, rdE1,
                                            readData1E1, readData2E1,
                                            immE1}),
                                   .iD    ({regWriteD,  memWriteD,  memReadD,  useMacD,  resultSrcD,  actFunctD, isActivationD,
                                            validInstructionD,  
                                            rs1D, rs2D, rdD,
                                            readData1D,  readData2D,
                                            immD}),
                                   .iStall(stallE1),
                                   .iFlush(flushE1),
                                   .rst   (rst),
                                   .clk   (clk));
    
    ExecuteStage1 ex1(.oP     (mulResultE1),
                      .iValid (validInstructionE1),
                      .iUseMac(useMacE1),
                      .iA     (operandAForwardedE1),
                      .iB     (operandBForwardedE1));
 
    PipelineRegister #(128) regE1_E2(.oQ    ({regWriteE2, memWriteE2, memReadE2, useMacE2, resultSrcE2, actFunctE2, isActivationE2,
                                             validInstructionE2,
                                             rs1E2, rdE2,
                                             immE2,
                                             mulResultE2, storeDataE2,
                                             operandAForwardedE2}),
                                    .iD    ({regWriteE1, memWriteE1, memReadE1, useMacE1, resultSrcE1, actFunctE1, isActivationE1,
                                             validInstructionE1,
                                             rs1E1, rdE1,
                                             immE1,
                                             mulResultE1, readData2E1,
                                             operandAForwardedE1}),
                                    .iStall(stallE2),
                                    .iFlush(1'b0),
                                    .rst   (rst),
                                    .clk   (clk));

    assign useAccBypassOnActE2 = validInstructionE2 &&
                                 isActivationE2     &&
                                 useMacM            &&
                                 (rdM == rs1E2)     &&
                                 (rdM != 0);

    ExecuteStage2 ex2(.oResult              (resultE2),
                      .iValid               (validInstructionE2),
                      .iUseMac              (useMacE2),
                      .iActFunct            (actFunctE2),
                      .iUseAccBypassOnAct   (useAccBypassOnActE2),
                      .iIsActivationFunction(isActivationE2),
                      .iMulResult           (mulResultE2),
                      .iOperand             (operandAForwardedE2),
                      .iImm                 ({20'b0, immE2}),
                      .clk                  (clk),
                      .rst                  (rst));

    PipelineRegister #(76) regE2_M(.oQ   ({regWriteM,  memWriteM,  memReadM,  useMacM,  resultSrcM,
                                            validInstructionM,
                                            rdM,
                                            resultM,
                                            storeDataM}),
                                   .iD    ({regWriteE2, memWriteE2, memReadE2, useMacE2, resultSrcE2,
                                            validInstructionE2,
                                            rdE2,
                                            resultE2,
                                            storeDataE2}),
                                   .iStall(stallM),
                                   .iFlush(1'b0),
                                   .rst   (rst),
                                   .clk   (clk));

    MemoryStage memStage(.oMemoryAddr   (oMemoryAddr),
                         .oMemoryRead   (oMemoryRead),
                         .oMemoryWrite  (oMemoryWrite),
                         .oMemoryWData  (oMemoryWData),
                         .oMemoryResult (memoryDataM),
                         .oMemStall     (stallM),
                         .iValid        (validInstructionM),
                         .iMemRead      (memReadM),
                         .iMemWrite     (memWriteM),
                         .iMemAddr      (resultM),
                         .iStoreData    (storeDataM),
                         .iMemoryRData  (iMemoryRData),
                         .iMemoryReady  (iMemoryReady));

    PipelineRegister #(73) regM_WB(.oQ    ({regWriteWB, resultSrcWB,
                                            validInstructionWB,
                                            rdWB,
                                            resultWB,
                                            memoryDataWB}),
                                   .iD    ({regWriteM,  resultSrcM,
                                            validInstructionM,
                                            rdM,
                                            resultM,
                                            memoryDataM}),
                                   .iStall(1'b0),
                                   .iFlush(1'b0),
                                   .rst   (rst),
                                   .clk   (clk));

    WriteBackStage WBStage(.oWriteDataReg    (writeDataReg),
                           .oRegWrite        (regWriteValid),
                           .iResult          (resultWB),
                           .iMemoryData      (memoryDataWB),
                           .iRegWrite        (regWriteWB),
                           .iValidInstruction(validInstructionWB),
                           .iResultSrc       (resultSrcWB));

    ForwardingUnit fwdUnit(.oOperandAForwarded(operandAForwardedE1),
                           .oOperandBForwarded(operandBForwardedE1),
                           .iRs1E1            (rs1E1),
                           .iRs2E1            (rs2E1),
                           .iRdE2             (rdE2),
                           .iRdM              (rdM),
                           .iRdWB             (rdWB),
                           .iRegWriteE2       (regWriteE2),
                           .iRegWriteM        (regWriteM),
                           .iRegWriteWB       (regWriteWB),
                           .iReadData1E1      (readData1E1),
                           .iReadData2E1      (readData2E1),
                           .iResultE2         (resultE2),
                           .iDataMem          (dataMem),
                           .iWriteDataReg     (writeDataReg));
    assign dataMem = resultSrcM == 2'b01 ? memoryDataM : resultM;

    HazardDetectionUnit hdu(.oStallF   (stallF_HDU),
                            .oStallD   (stallD_HDU),
                            .oFlushE1  (flushE1),
                            .iRs1D     (rs1D),
                            .iRs2D     (rs2D),
                            .iRdE1     (rdE1),
                            .iRdE2     (rdE2),
                            .iMemReadE1(memReadE1),
                            .iMemReadE2(memReadE2));

    assign stallF  = stallM  || stallF_HDU;
    assign stallD  = stallM  || stallD_HDU;
    assign stallE1 = stallM;
    assign stallE2 = stallM;
endmodule
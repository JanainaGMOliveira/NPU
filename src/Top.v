module Top(
    output            oBusy,
    output            oDone,
    output            oInterrupt,

    input             iStart,  // came from control unit, indicates when to start fetching instructions
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
    wire        validInstructionF, validInstructionD, validInstructionE;
    wire [31:0] instructionF,      instructionD;

    
    wire        isECALLD;
    wire        immSrcD,    immSrcE;
    wire        regWriteD,  regWriteE;
    wire        memWriteD,  memWriteE;
    wire        memReadD,   memReadE;
    wire        useMacD,    useMacE;
    wire [1:0]  resultSrcD, resultSrcE;
    wire [1:0]  actFunctD,  actFunctE;

    reg         haltRequisition;
    wire        stallF, stallD;
    wire        flushD, flushE;
    

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
                                  .iStall(stallD || stallF),
                                  .iFlush(flushD),
                                  .rst   (rst),
                                  .clk   (clk));

    MainDecoder control(.oIsECALL         (isECALLD),
                        .oImmSrc          (immSrcD),
                        .oRegWrite        (regWriteD),
                        .oMemWrite        (memWriteD),
                        .oMemRead         (memReadD),
                        .oUseMac          (useMacD),
                        .oResultSrc       (resultSrcD),
                        .oActFunct        (actFunctD),
                        .iInstruction     (instructionD),
                        .iValidInstruction(validInstructionD));

    always @(posedge clk)
    begin
    if (rst)
        haltRequisition <= 0;
    else if (isECALLD && validInstructionD)
        haltRequisition <= 1;
    end

    PipelineControl pipelineCtrl(.oStallF           (stallF),
                                 .oStallD           (stallD),
                                 .oFlushD           (flushD),
                                 .oFlushE           (flushE),
                                 .iMemReadE         (memReadE),
                                 .iMemWriteE        (memWriteE),
                                 .iMemReady         (iMemoryReady),
                                 .iIsECALLD         (isECALLD),
                                 .iValidInstructionD(validInstructionD));

    PipelineRegister #(10) regD_E(.oQ    ({immSrcE, regWriteE, memWriteE, memReadE, useMacE, resultSrcE, actFunctE, validInstructionE}),
                                  .iD    ({immSrcD, regWriteD, memWriteD, memReadD, useMacD, resultSrcD, actFunctD, validInstructionD}),
                                  .iStall(stallD),
                                  .iFlush(flushE),
                                  .rst   (rst),
                                  .clk   (clk));

    NPUCore           datapath(pc, immSrcE, regWriteE, memWriteE, useMacE, resultSrcE, actFunctE, instructionE, validInstructionE, clk, rst);
    
    //DataMemory        dmem(readData, dataAddr, writeData, memWriteEnable, clk); // vai para teste

endmodule
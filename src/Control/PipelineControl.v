module PipelineControl(
    output reg oStallF,
    output reg oStallD,
    output reg oFlushD,
    output reg oFlushE,

    input      iMemReadE,
    input      iMemWriteE,
    input      iMemReady,
    input      iIsECALLD,
    input      iValidInstructionD
);
    always @(*)
    begin
        oStallF = 0;
        oStallD = 0;
        oFlushD = 0;
        oFlushE = 0;

        if ((iMemReadE || iMemWriteE) && !iMemReady)
        begin
            oStallF = 1;
            oStallD = 1;
        end
        else if (iIsECALLD && iValidInstructionD)
        begin
            oFlushD = 1;
        end
    end
endmodule
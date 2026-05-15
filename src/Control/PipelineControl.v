module PipelineControl(
    output reg oFlushD,

    input      iIsECALLD,
    input      iValidInstructionD
);
    always @(*)
    begin
        oFlushD  = 0;
        
        if (iIsECALLD && iValidInstructionD)
        begin
            oFlushD = 1;
        end
    end
endmodule
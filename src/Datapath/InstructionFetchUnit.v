module InstructionFetchUnit(    
    output reg [31:0] oInstruction,
    output reg        oValid,

    output     [31:0] oInstructionMemoryAddr,
    output            oInstructionMemoryRead,
    input      [31:0] iInstructionRData,
    input             iInstructionReady,

    input             iEnable,
    input             iStart,
    input      [31:0] iInstructionBaseAddr,

    input             clk,
    input             rst
);
    reg  [31:0] pc;
    wire [31:0] pcNext;

    assign pcNext = pc + 4;

    always @(posedge clk)
    begin
        if (rst)
        begin
            pc <= 0;
        end
        else if (iStart)
        begin
            pc <= iInstructionBaseAddr;
        end
        else if (iEnable)
        begin
            pc <= pcNext;
        end
    end

    assign oInstructionMemoryAddr = pc;
    assign oInstructionMemoryRead = iEnable;

    always @(posedge clk)
    begin
        if (rst)
        begin
            oValid <= 0;
        end
        else if (iInstructionReady && iEnable)
        begin
            oInstruction <= iInstructionRData;
            oValid <= 1;
        end
        else
        begin
            oValid <= 0;
        end
    end
endmodule
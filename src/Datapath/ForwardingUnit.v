module ForwardingUnit(
    output reg [31:0] oOperandAForwarded,
    output reg [31:0] oOperandBForwarded,

    input      [4:0]  iRs1E1,
    input      [4:0]  iRs2E1,
    input      [4:0]  iRdE2,
    input      [4:0]  iRdM,
    input      [4:0]  iRdWB,
    input             iRegWriteE2,
    input             iRegWriteM,
    input             iRegWriteWB,

    input      [31:0] iReadData1E1,
    input      [31:0] iReadData2E1,
    input      [31:0] iResultE2,
    input      [31:0] iDataMem,
    input      [31:0] iWriteDataReg
);
    always @(*)
    begin
        // EX2 tem prioridade sobre M e WB, pois é mais recente no pipeline. Se EX2 e WB estiverem escrevendo no mesmo registrador que E1 está lendo, o resultado de EX2 deve ser encaminhado para E1
        // caso a instrução em EX2 esteja escrevendo no registrador que a instrução em E1 está lendo, é necessário encaminhar o resultado de EX2 para E1
        if (iRegWriteE2 && (iRdE2 != 0))
        begin
            if (iRdE2 == iRs1E1)
                oOperandAForwarded = iResultE2;
            if (iRdE2 == iRs2E1)
                oOperandBForwarded = iResultE2;
        end
        else if (iRegWriteM && (iRdM != 0)) // caso contrário, se a instrução em M estiver escrevendo no registrador que a instrução em E1 está lendo, é necessário encaminhar o resultado de M para E1
        begin
            if (iRdM == iRs1E1)
                oOperandAForwarded = iDataMem;
            if (iRdM == iRs2E1)
                oOperandBForwarded = iDataMem;
        end
        else if (iRegWriteWB && (iRdWB != 0)) // caso contrário, se a instrução em WB estiver escrevendo no registrador que a instrução em E1 está lendo, é necessário encaminhar o resultado de WB para E1
        begin
            if (iRdWB == iRs1E1)
                oOperandAForwarded = iWriteDataReg;
            if (iRdWB == iRs2E1)
                oOperandBForwarded = iWriteDataReg;
        end
        else
        begin
            oOperandAForwarded = iReadData1E1;
            oOperandBForwarded = iReadData2E1;
        end
    end
endmodule
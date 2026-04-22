module NPUCore(
    output [31:0] oPc,
    // colocar dados de memória para a saída e entrada
    input         iImmSrcD,
    input         iRegWriteD,
    input         iMemWriteD,
    input         iUseMacD,
    input [1:0]   iResultSrcD,
    input [1:0]   iActFunctD,
    input         clk,
    input         rst
);
    wire [31:0] pcNext;

    // FETCH
    PipelineRegister #(32) pcCounter(oPc, pcNext, rst, clk);
    Adder #(32) pcAdder(pcNext, pc, 32'd4);

    //RegisterFile regFile();
    //ExtendUnit extendUnit();

    PipelineRegister #(8) regE({immSrcE, regWriteE, memWriteE, useMacE, resultSrcE, actFunctE}, 
                               {iImmSrcD, iRegWriteD, iMemWriteD, iUseMacD, iResultSrcD, iActFunctD}, 
                               rst, clk);

    //MacUnit macUnit();
    //ActivationFunctUnit activationFunctUnit();

    PipelineRegister #(8) regM({immSrcM, regWriteM, memWriteM, useMacM, resultSrcM, actFunctM}, 
                               {immSrcE, regWriteE, memWriteE, useMacE, resultSrcE, actFunctE}, 
                               rst, clk);

    //Mux #(32) memorySrcMux();

    PipelineRegister #(8) regW({immSrcW, regWriteW, memWriteW, useMacW, resultSrcW, actFunctW}, 
                               {immSrcM, regWriteM, memWriteM, useMacM, resultSrcM, actFunctM}, 
                               rst, clk);

    //WriteBackMux writeBackMux();
endmodule

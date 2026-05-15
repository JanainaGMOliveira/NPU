module ExecuteStage2(
    output reg [31:0] oResult,

    input             iValid,
    input             iUseMac,
    input      [1:0]  iActFunct,
    input             iUseAccBypassOnAct,
    input             iIsActivationFunction,

    input      [31:0] iMulResult,
    input      [31:0] iOperand,

    input      [31:0] iImm,

    input             clk,
    input             rst
);
    reg [31:0] acc;

    wire [31:0]  accNext;
    reg  [31:0]  activationInput;
    reg  [7:0]   activationResult;

    // definição de entradas do somador
    assign opA = !iUseMac ? iImm : acc;
    assign opB = !iUseMac ? iOperand : iMulResult;

    Adder #(32) memAddrSum(.oSum(soma),
                           .iA  (opA),
                           .iB  (opB));

    // definição da saída
    always @(*)
    begin
        if (rst)
            oResult <= 32'b0;
        else if (iIsActivationFunction)
            oResult = {24'b0, activationResult}; // erradíssimo, mas é só pra teste mesmo
        else
            oResult = soma;
    end

    // acumulador interno
    always @(posedge clk)
    begin
        if (rst)
            acc <= 32'b0;
        else if (iValid && iUseMac)
            acc <= accNext;
    end

    // função de ativação
    assign activationInput = iUseAccBypassOnAct ? accNext : iOperand;
    ActivationFunction af(.oActivationFunction(activationResult),
                           .iActFunct         (iActFunct),
                           .iMacResult        (activationInput));
endmodule

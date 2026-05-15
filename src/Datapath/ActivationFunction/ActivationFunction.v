module ActivationFunction(
    output reg [7:0]  oActivationFunction,
    input      [1:0]  iActFunct,
    input      [31:0] iMacResult
);
    wire [7:0] resultReLu, resultRampa, resultTanh, resultSigm;

    ReLu afRelu(.oActivationFunction(resultReLu),
                .iMacResult(iMacResult));

    Rampa afRampa(.oActivationFunction(resultRampa),
                  .iMacResult(iMacResult));

    Tanh afTanh(.oActivationFunction(resultTanh),
                .iMacResult(iMacResult));

    Sigm afSigm(.oActivationFunction(resultSigm),
                .iMacResult(iMacResult));

    always @(*)
    begin
        case (iActFunct)
            2'b00: oActivationFunction = resultReLu;
            2'b01: oActivationFunction = resultRampa;
            2'b10: oActivationFunction = resultTanh;
            2'b11: oActivationFunction = resultSigm;
        endcase
    end
endmodule
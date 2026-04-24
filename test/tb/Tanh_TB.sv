`timescale 1ns/1ps
module Tanh_TB;
    real         macInputReal;
    logic [31:0] macInputQ12_20;

    real         activationFunctionReal;
    logic [7:0]  activationFunctionQ3_5;

    real         expectedActivationFunctReal;
    logic [7:0]  expectedActivationFunctQ3_5;
    
    real         error;

    Tanh DUT(
             .iMacResult(macInputQ12_20),
             .oActivationFunction(activationFunctionQ3_5)
    );

    function real tanh(input real x);
        return (1.0 - $exp(-2.0 * x)) / (1.0 + $exp(-2.0 * x));
    endfunction

    function real Q12_20ToReal(input logic [31:0] val);
        int signed_val;
        signed_val = $signed(val);
        return signed_val / (2.0**20);
    endfunction

    function logic [31:0] RealToQ12_20(input real val);
        return int'(val * (2.0**20));
    endfunction

    function real Q3_5ToReal(input logic [7:0] val);
        int signed_val;
        signed_val = $signed(val);
        return signed_val / (2.0**5);
    endfunction

    function logic [7:0] RealToQ3_5(input real val);
        return int'(val * (2.0**5));
    endfunction

    function string FormatQ3_5(input logic [7:0] val);
        return $sformatf("%03b_%05b", val[7:5], val[4:0]);
    endfunction

    function string FormatQ12_20(input logic [31:0] val);
        return $sformatf("%012b_%020b", val[31:20], val[19:0]);
    endfunction

    initial
    begin
        for (int i = -8; i <= 8; i++)
        begin
            macInputReal = i * 0.5;
            macInputQ12_20 = RealToQ12_20(macInputReal); #1;

            expectedActivationFunctReal  = tanh(macInputReal);
            expectedActivationFunctQ3_5  = RealToQ3_5(expectedActivationFunctReal);

            activationFunctionReal = Q3_5ToReal(activationFunctionQ3_5);

            error = expectedActivationFunctReal - activationFunctionReal;

            $display("x = %0f (%s) || esperado = %0f (%s) | obtido = %0f (%s) || erro = %0f (%6.2f%%)",
                     macInputReal,
                     FormatQ12_20(macInputQ12_20),
                     expectedActivationFunctReal,
                     FormatQ3_5(expectedActivationFunctQ3_5),
                     activationFunctionReal,
                     FormatQ3_5(activationFunctionQ3_5),
                     error,
                     (expectedActivationFunctReal != 0.0) ? ((expectedActivationFunctReal - activationFunctionReal) / expectedActivationFunctReal) * 100.0
        : 0.0);
        end

        $stop;
    end
endmodule
module ExecuteStage1(
    output [31:0] oP,
    input         iValid,
    input         iUseMac,
    input  [31:0] iA,
    input  [31:0] iB
);
    wire [31:0] mulResult;

    MultiplierSigned mult(.oP(mulResult),
                          .iA(iA[7:0]),
                          .iB(iB[15:0]));
    assign oP = iValid && iUseMac ? mulResult : 32'b0;
endmodule

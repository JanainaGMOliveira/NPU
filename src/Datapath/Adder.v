module Adder #(parameter N = 32)(
    output [N-1:0] oSum,
    input  [N-1:0] iA,
    input  [N-1:0] iB
);
    assign oSum = iA + iB;
endmodule
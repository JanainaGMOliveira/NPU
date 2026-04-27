module RegisterFile #(parameter SIZE = 8, N = 32)(
    output [N-1:0] oReadData1,
    output [N-1:0] oReadData2,
    input  [4:0]  iAddr1,
    input  [4:0]  iAddr2,
    input  [4:0]  iAddr3,
    input  [N-1:0] iWriteData3,
    input         iWriteEnable3,
    input         clk
);
    reg [N-1:0] regFile [SIZE - 1:0];

    assign oReadData1 = regFile[iAddr1];
    assign oReadData2 = regFile[iAddr2];

    always @(posedge clk)
    begin
        if (iWriteEnable3)
        begin 
            regFile[iAddr3] <= iWriteData3;
        end
    end
endmodule
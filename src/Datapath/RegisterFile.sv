module RegisterFile(
    output [31:0] oReadData1,
    output [31:0] oReadData2,
    input  [4:0]  iAddr1,
    input  [4:0]  iAddr2,
    input  [4:0]  iAddr3,
    input  [31:0] iWriteData3,
    input         iWriteEnable3,
    input         clk
);
    reg [31:0] regFile [31:0];

    assign oReadData1 = iAddr1 != 32'd0 ? regFile[iAddr1] : 32'd0;
    assign oReadData2 = iAddr2 != 32'd0 ? regFile[iAddr2] : 32'd0;

    always @(posedge clk)
    begin
        if (iWriteEnable3)
        begin 
            regFile[iAddr3] <= iWriteData3;
        end
    end
endmodule
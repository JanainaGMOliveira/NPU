module DataMemory(
    output [31:0] oReadData,
    input  [31:0] iAddr,
    input  [31:0] iWriteData,
    input         iWriteEnable,
    input         clk
);
    reg [31:0] dataMem [31:0];

    assign oReadData = dataMem[iAddr[31:2]];

    always @(posedge clk)
    begin
        if (iWriteEnable) 
        begin 
            dataMem[iAddr[31:2]] <= iWriteData;
        end
    end
endmodule
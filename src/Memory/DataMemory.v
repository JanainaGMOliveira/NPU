module DataMemory  #(parameter SIZE = 64, N = 32)(
    output [N-1:0] oReadData,
    input  [N-1:0] iAddr,
    input  [N-1:0] iWriteData,
    input         iWriteEnable,
    input         clk
);
    reg [N-1:0] dataMem [SIZE - 1:0];

    assign oReadData = dataMem[iAddr[N-1:2]];

    always @(posedge clk)
    begin
        if (iWriteEnable) 
        begin 
            dataMem[iAddr[N-1:2]] <= iWriteData;
        end
    end
endmodule
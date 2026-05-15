module PipelineRegister #(parameter N = 32)(
    output [N-1:0] oQ,
    input  [N-1:0] iD,
    input          iStall,
    input          iFlush,
    input          rst,
    input          clk
);
    reg [N-1:0] q;
    assign oQ = q;

    always @(posedge clk)
    begin
        if (rst)
        begin
            q <= {N{1'b0}};
        end
        else if (iFlush)
        begin
            q <= {N{1'b0}};
        end 
        else if (!iStall)
        begin
            q <= iD;
        end
    end
endmodule
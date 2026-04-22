module PipelineRegister #(parameter N = 32)(
    output [N-1:0] oQ,
    input  [N-1:0] iD,
    input  rst,
    input  clk
);
    reg [N-1:0] q;
    assign oQ = q;

    always @(posedge clk)
    begin
        if (rst)
        begin
            q <= {N{1'b0}};
        end
        else
        begin
            q <= iD;
        end
    end    
endmodule
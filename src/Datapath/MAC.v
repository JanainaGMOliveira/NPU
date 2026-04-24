module MAC #(parameter N = 8)(
	output reg [4*N-1:0] oMac,
	input      [N-1:0]   iX,
	input      [2*N-1:0] iW,
	input      [4*N-1:0] iAcc,
	input                clk
);
	function [4*N-1:0] SumOverflow;
		input [4*N-1:0] iA, iB;
		reg [4*N-1:0] aux;

		begin // ajustar para usar complemento de 2
			aux = iA + iB;
			if (iA[4*N-1] == 1'b1 & iB[4*N-1] == 1'b1 & aux[4*N-1] == 1'b0)
				aux = {1'b1, {4*N-1{1'b0}}};
			else if (iA[4*N-1] == 1'b0 & iB[4*N-1] == 1'b0 & aux[4*N-1] == 1'b1)
				aux = {1'b0, {4*N-1{1'b1}}};
				
			SumOverflow = aux;
		end
	endfunction

	wire [31:0] auxProd;
	
	multiplier m1(auxProd, iX, iW);
	// ajustar para caso seja pipelined
	always @(posedge clk)
	begin
        oMac = SumOverflow(iAcc, auxProd);
    end
endmodule
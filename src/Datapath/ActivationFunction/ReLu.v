module ReLu(
	output       [7:0]  oActivationFunction,
	input signed [31:0] iMacResult
);	
	assign oActivationFunction = iMacResult[31] ? 8'b111_00000 : 8'b001_00000;
endmodule
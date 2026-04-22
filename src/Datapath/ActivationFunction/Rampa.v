module Rampa(
	output reg    [7:0]  oActivationFunction,
	input  signed [31:0] iMacResult
);
	always @(*)
	begin
		// menor que -4
		if (iMacResult <= $signed(32'b111111111100_00000000000000000000))
			oActivationFunction = 8'b100_00000; 
		// maior que 3,96875
		else if (iMacResult >= $signed(32'b000000000100_00000000000000000000))
			oActivationFunction = 8'b011_11111; 
		// entre -4 e 3,96875
		else 
			oActivationFunction = iMacResult[22:15];
	end
endmodule
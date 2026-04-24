module Sigm(
	output reg [7:0]  oActivationFunction,
	input      [31:0] iMacResult
);
	wire [31:0] cMacResult;
	reg [7:0]   auxAF;
	
	TwosComplement #(32) c1(cMacResult, iMacResult, iMacResult[31]); 
	
	always @(*)
	begin
		if (cMacResult >= 32'b000000000101_00000000000000000000)
		begin
			auxAF = 8'b00100000;
		end
		else if (cMacResult >= 32'b000000000010_01100000000000000000)
		begin
			auxAF[7:2] = 6'b000111;
			auxAF[1] = ~cMacResult[21] | cMacResult[20];
			auxAF[0] = ~cMacResult[20];
		end
		else if (cMacResult >= 32'b000000000001_00000000000000000000)
		begin
			auxAF[7:3] = 5'b00011;
			auxAF[2] = ~cMacResult[20];
			auxAF[1:0] = cMacResult[19:18];
		end
		else if (cMacResult >= 32'b000000000000_00000000000000000000)
		begin
			auxAF[7:3] = 5'b00010;
			auxAF[2:0] = cMacResult[19:17];
		end

        if (iMacResult[31])
			oActivationFunction = 8'b00100000 - auxAF;
		else
			oActivationFunction = auxAF;
	end
endmodule
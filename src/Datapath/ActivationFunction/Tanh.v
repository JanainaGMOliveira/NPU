module Tanh(
	output reg [7:0]  oActivationFunction,
	input      [31:0] iMacResult
);
	wire [31:0] cMacResult;
	reg [7:0]   auxAF;
	
	TwosComplement #(.N(32)) c1(cMacResult, iMacResult, iMacResult[31]); 
	
	always @(*)
	begin
		if(cMacResult >= 32'b000000000000_00000000000000000000 & cMacResult < 32'b000000000000_10000000000000000000)
		begin
			auxAF = cMacResult[22:15];
			if (iMacResult[31])
				oActivationFunction = (auxAF ^ {8{1'b1}}) + 1'b1;
			else
				oActivationFunction = auxAF;
		end
		else if(cMacResult >= 32'b000000000000_10000000000000000000 & cMacResult < 32'b000000000001_00000000000000000000)
		begin
			auxAF[7:3] = 5'b00010;
			auxAF[2:0] = cMacResult[18:16];
			if (iMacResult[31])
				oActivationFunction = (auxAF ^ {8{1'b1}}) + 1'b1;
			else
				oActivationFunction = auxAF;
		end
		else if(cMacResult >= 32'b000000000001_00000000000000000000 & cMacResult < 32'b000000000010_00000000000000000000)
		begin
			auxAF[7:3] = 5'b00011;
			auxAF[2:0] = cMacResult[19:17];
			if (iMacResult[31])
				oActivationFunction = (auxAF ^ {8{1'b1}}) + 1'b1;
			else
				oActivationFunction = auxAF;
		end
		else if(cMacResult >= 32'b000000000010_00000000000000000000)
		begin
			auxAF = 8'b001_00000;
			if (iMacResult[31])
				oActivationFunction = 8'b111_00000;
			else
				oActivationFunction = auxAF;
		end
	end
	
endmodule
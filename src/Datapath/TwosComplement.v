module TwosComplement #(parameter N = 3)(
	output [N-1:0] oC,
	input [N-1:0] iE,
	input iCtrl
);
	reg [N-1:0] auxC;
	assign oC = auxC;

	always @(*)
	begin
		if (iCtrl)
			auxC = (iE ^ {N{1'b1}}) + 1'b1;
		else
			auxC = iE;
	end	
endmodule
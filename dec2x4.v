module dec2x4(output reg [3:0]w, input wire [1:0]in, input wire Ld);
	always @ (Ld)
	begin
		if(Ld)
			w = 4'b0001<<in;
	end
endmodule
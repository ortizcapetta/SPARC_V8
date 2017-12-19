module global_mux (output reg[7:0] O, input[1:0]CW,input[7:0]w0,w1,w2,w3);
always @(CW)
//output O: 7 bits that will tell if any of the global regs are enabled
//input CW: current window pointer to verify which of the ws(decoder outputs) is the mux gonna forward
//inputs w3,w2,w1,w0: the last 8 bits of the decoder outputs, which are the global regs
	case(CW)
		2'b00: O = w0;
		2'b01: O = w1;
		2'b10: O = w2;
		2'b11: O = w3;


endmodule

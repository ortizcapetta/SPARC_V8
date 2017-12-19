module DataReg(Q,D,Le,Clk);
  // BUS width
  parameter DATA_WIDTH = 32; 
  
  
  // Outputs
  output reg [DATA_WIDTH-1:0]Q;	
  // Inputs	
  input[DATA_WIDTH-1:0]D;	
  input Le,Clr,Clk;
  					 	
  always @ (posedge Clk,)
  if (Le) Q <= D;
endmodule
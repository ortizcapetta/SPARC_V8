

						/*			RAM 512x8                
								by Alejandra Ortiz         */
module ram512x8(output reg [31:0] DataOut, 
				 output reg MOC,
				 input ReadWrite, MOV,
				 input[8:0] Address, //2^9 = 512
				 input[31:0] DataIn,
				 input [5:0] OP //determines if byte,word, halfword
				); 
	reg[7:0] Mem[0:511]; //512 locations with 1 byte each [512 bytes of memory total]

			/*---------------------------PARAMETERS--------------------------|
			|------------------------------OUTPUTS---------------------------|
			|DataOut - Bus that provides data on a read Operation            |
			|MOC(Memory Operation Completed) - tells the CPU when a memory   |
			|	operation has been completed (1- completed)(0- not completed)|
			|																 |
			| ------------------------------INPUTS---------------------------|
			|DataIn - Bus that receives data to be stored                    |
			|Address - Bus for specifying the memory address                 |
			|ReadWrite - Read & Write operation (1- Read) (0-Write)          |
			|MOV(Memory Operation Valid) - Tells the CPU when a Memory       |
			|	operation has been completed (1-completed)(0-not completed)  |
			|OP - determines the type of the input to be saved (byte,word or |
			|	halfword)      												 |
			|----------------------------------------------------------------*/        									 

	always @(MOV)
		if(MOV)
		begin
			MOC=0;
			if(ReadWrite) //Load
				case(OP)
				//Word (32bits)
					6'b001000:begin
						DataOut[31:24] <= Mem[Address];
						DataOut[23:16] <= Mem[Address+1];
						DataOut[15:8]  <= Mem[Address+2];
						DataOut[7:0]   <= Mem[Address+3];
						end
				//Unsigned Half-Word (16 bits)
					6'b000010:begin
						DataOut[31:16]  <= 16'h0000; //hexadecimal, 16 bits 
						DataOut[15:8]  <= Mem[Address];
						DataOut[7:0]   <= Mem[Address+1];
						end
				//Unsigned Byte (8 bits)
					6'b000001:begin
						DataOut[31:8]  <= 24'h000000; //24 bits in hex
						DataOut[7:0]    <= Mem[Address];	
				//Instructions for double word should be handled from another unit 
				MOC=1;
					end
				endcase
			else //Store
				case(OP)
				//Word (32bits)

					6'b000100:begin //OP code
						Mem[Address] <= DataIn[31:24];
						Mem[Address+1] <= DataIn[23:16];
						Mem[Address+2] <= DataIn[15:8];
						Mem[Address+3] <= DataIn[7:0];
						
					end
						 
				//Half-Word	(16bits)
					6'b000110:begin
						Mem[Address] <= DataIn[15:8];
						Mem[Address+1] <= DataIn[7:0];
					end
				//Byte (8 bits)
					6'b000101:begin
						Mem[Address] <= DataIn[7:0];
					end
				endcase
			
			
				
			MOC=1;
		end

endmodule

						/*Module for testing 512x8 RAM */
module ram512x8_tester;
	//  !!inputs are reg, outputs are wires !! 
	wire[31:0] DataOut;
	wire MOC;
	reg ReadWrite,MOV;
	reg [31:0] DataIn;
	reg[8:0] Address;
	reg[5:0]OP;
	
	//calling the RAM module
	ram512x8 RAM(DataOut,MOC,ReadWrite,MOV,Address,DataIn,OP);
	// just some stuff needed to read code from a text file
	integer   fd,fo, code, index;
	reg [7:0] data;


	initial begin
		 Address = 0;
		 MOV = 1;
		 ReadWrite=0;
	end


	initial begin
		//writing word
		OP=6'b000100;
		DataIn =32'hAE910F2B;
		# 10
		$display("Storing Word %h to RAM",DataIn); 
		$display("Value in Address %b : %b",Address,RAM.Mem[Address]);
		Address = Address + 1;
		$display("Value in Address %b : %b",Address,RAM.Mem[Address]);
		Address = Address + 1;
		$display("Value in Address %b : %b",Address,RAM.Mem[Address]);
		Address = Address + 1;
		$display("Value in Address %b : %b",Address,RAM.Mem[Address]);
		//loading word
		MOV=0;MOV=1;
		ReadWrite=1;
		Address=0;		
		OP=6'b001000;
		#10;
		$display("Loading Word.\nDataOut is: %b", DataOut);
		Address = 4;
		MOV=0;MOV=1;
		ReadWrite=0;
		OP=6'b000110;
		DataIn=16'hAABB;
		#10
		//writing half-word
		$display("Storing Half-World %h to RAM",DataIn);
		$display("Value in Address %b : %b",Address,RAM.Mem[Address]);
		Address = Address + 1;
		$display("Value in Address %b : %b",Address,RAM.Mem[Address]);
		MOV=0;MOV=1;
		ReadWrite=1;
		OP=6'b000010;
		Address=4;
		#10
		//loading half word
		$display("Loading half-word.\nDataOut is: %0b", DataOut);
		//storing byte
		Address=6;
		MOV=0; MOV=1;
		ReadWrite=0;
		OP = 6'b000101;
		DataIn=8'b01010101;
		#10
		$display("Storing Byte %0b to RAM",DataIn);
		$display("Value in Address %b : %b",Address,RAM.Mem[Address]);
		//loading byte
		MOV=0;MOV=1;
		ReadWrite=1;
		OP= 6'b000001;
		#10
		$display("Loading Byte.\nDataOut is: %b", DataOut);


		$display("--LOADING TEST PROGRAM INTO RAM--");
		fo = $fopen("RAMTEST.txt","r"); //RAMTEST.txt can be a file of two words for this specific program to read
		index = 0;
		while (!$feof(fo)) begin

			code = $fscanf(fo, "%b", data);
			RAM.Mem[index]=data;
			index = index + 1;
		end
	  	$fclose(fo);
	  	$display("--TEST PROGRAM LOADED--");
	  	$display("%b",RAM.Mem[0]);
	  	$display("%b",RAM.Mem[1]);
	  	#20
	  	MOV=0;MOV=1;
		ReadWrite=1;
		Address=0;		
		OP=6'b001000;
		#10;
		$display("Loading Instruction.\nDataOut is: %b", DataOut);
		MOV=0;MOV=1;
		ReadWrite=1;
		Address=4;		
		OP=6'b001000;
		#10;
		$display("Loading Instruction.\nDataOut is: %b", DataOut);




	end
	


endmodule

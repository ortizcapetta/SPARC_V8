module PortMux (O,Op,
r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,
r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31
);

parameter DATA_WIDTH = 32; 
parameter OpCode_bits = 5;

//Output
output reg [DATA_WIDTH-1:0]O;

//Inputs
input [OpCode_bits-1:0]Op;
 
input[DATA_WIDTH-1:0]r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31;

always @ (Op)			
    case(Op)
    5'd0: O = r0;
    5'd1: O = r1;
    5'd2: O = r2;
    5'd3: O = r3;
    5'd4: O = r4;
    5'd5: O = r5;
    5'd6: O = r6;
    5'd7: O = r7;
    5'd8: O = r8;
    5'd9: O = r9;
    5'd10:O = r10;
    5'd11:O = r11;
    5'd12:O = r12;
    5'd13:O = r13;
    5'd14:O = r14;
    5'd15:O = r15;
    5'd16:O = r16;
    5'd17:O = r17;
    5'd18:O = r18;
    5'd19:O = r19;
    5'd20:O = r20;
    5'd21:O = r21;
    5'd22:O = r22;
    5'd23:O = r23;
    5'd24:O = r24;
    5'd25:O = r25;
    5'd26:O = r26;
    5'd27:O = r27;
    5'd28:O = r28;
    5'd29:O = r29;
    5'd30:O = r30; 
    5'd31:O = r31; 
       
   endcase
  
endmodule
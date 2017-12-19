module register_window(output reg[31:0]PA,PB,
                        input [31:0] PC,
                        input[1:0]Op, //current window
                        input Ld,Clk,
                        input[4:0] C, //5bits to choose where to write
                       );
  

//5x32 decoder outputs for choosing registers in the window
  wire[31:0] w3; 
  wire[31:0] w2;
  wire[31:0] w1;
  wire[31:0] w0;
  //decoder output window enables (Ex: if win = 0100 then win[2] is enabled)
  wire[3:0] win; 
  //for enabling registers
  wire[71:0] enable_reg; 
  //reg outputs
  wire [31:0] Q[71:0];


  dec2x4 dec_window(win,OP,Ld); 
  BinaryDecoder dec_w3(w3,win[3],C); //w3 = output of decoder
  BinaryDecoder dec_w2(w2,win[2],C);
  BinaryDecoder dec_w1(w1,win[1],C);
  BinaryDecoder dec_w0(w0,win[0],C);


  //or logic to verify in reg is enabled, outs of w
  //buf to save the outputs of decoder to enable reg
  // enable = w3inputs|w0outputs

  or e71(enable_reg[71],w3[31],w0[15]); //enable71 = r31 | r15
  or e70(enable_reg[70],w3[30],w0[14]); //enable70 = r30 | r14
  or e69(enable_reg[69],w3[29],w0[13]); //enable69 = r29 | r13
  or e68(enable_reg[68],w3[28],w0[12]); //enable68 = r28 | r12
  or e67(enable_reg[67],w3[27],w0[11]); //enable67 = r27 | r11
  or e66(enable_reg[66],w3[26],w0[10]); //enable66 = r26 | r10
  or e65(enable_reg[65],w3[25],w0[9]);  //enable65 = r25 | r9
  or e64(enable_reg[64],w3[24],w0[8]);  //enable64 = r24 | r8
  //you do this thing a million more times
  //w3 local r
  buf e63(enable_reg[63],w3[23]); //r23
  buf e62(enable_reg[62],w3[22]); //r22
  buf e61(enable_reg[61],w3[21]); //r21
  buf e60(enable_reg[60],w3[20]); //r20
  buf e59(enable_reg[59],w3[19]); //r19
  buf e58(enable_reg[58],w3[18]); //r18
  buf e57(enable_reg[57],w3[17]); //r17
  buf e56(enable_reg[56],w3[16]); //r16

  //enable = w3 outputs | w2 inputs
  or e55(enable_reg[55],w3[15],w2[32]); 
  or e54(enable_reg[54],w3[14],w2[31]); 
  or e53(enable_reg[53],w3[13],w2[30]); 
  or e52(enable_reg[52],w3[12],w2[29]); 
  or e51(enable_reg[51],w3[11],w2[28]); 
  or e50(enable_reg[50],w3[10],w2[27]); 
  or e49(enable_reg[49],w3[9],w2[26]);  
  or e48(enable_reg[48],w3[8],w2[25]);  
  //w2 local r
  buf e47(enable_reg[47],w2[23]); 
  buf e46(enable_reg[46],w2[22]); 
  buf e45(enable_reg[45],w2[21]); 
  buf e44(enable_reg[44],w2[20]); 
  buf e43(enable_reg[43],w2[19]); 
  buf e42(enable_reg[42],w2[18]); 
  buf e41(enable_reg[41],w2[17]); 
  buf e40(enable_reg[40],w2[16]); 

  //enable = w2 outputs | w1 inputs
  or e39(enable_reg[39],w2[15],w1[32]); 
  or e38(enable_reg[38],w2[14],w1[31]); 
  or e37(enable_reg[37],w2[13],w1[30]); 
  or e36(enable_reg[36],w2[12],w1[29]); 
  or e35(enable_reg[35],w2[11],w1[28]); 
  or e34(enable_reg[34],w2[10],w1[27]); 
  or e33(enable_reg[33],w2[9],w1[26]);  
  or e32(enable_reg[32],w2[8],w1[25]);  
  //w1 locals
  buf e31(enable_reg[31],w2[23]); 
  buf e30(enable_reg[30],w2[22]); 
  buf e29(enable_reg[29],w2[21]); 
  buf e28(enable_reg[28],w2[20]); 
  buf e27(enable_reg[27],w2[19]); 
  buf e26(enable_reg[26],w2[18]); 
  buf e25(enable_reg[25],w2[17]); 
  buf e24(enable_reg[24],w2[16]); 
  //enable = w1 output | w0 input
  or e23(enable_reg[23],w1[15],w0[32]); 
  or e22(enable_reg[22],w1[14],w0[31]); 
  or e21(enable_reg[21],w1[13],w0[30]); 
  or e20(enable_reg[20],w1[12],w0[29]); 
  or e19(enable_reg[19],w1[11],w0[28]); 
  or e18(enable_reg[18],w1[10],w0[27]); 
  or e17(enable_reg[17],w1[9],w0[26]);  
  or e16(enable_reg[16],w1[8],w0[25]);
  //w0 locals
  buf e15(enable_reg[15],w2[23]); 
  buf e14(enable_reg[14],w2[22]); 
  buf e13(enable_reg[13],w2[21]); 
  buf e12(enable_reg[12],w2[20]); 
  buf e11(enable_reg[11],w2[19]); 
  buf e10(enable_reg[10],w2[18]); 
  buf e9(enable_reg[9],w2[17]); 
  buf e8(enable_reg[8],w2[16]);   
  //w0 outputs are above the first enables [e71-64]

  //global enables
  global_mux mux_r0r7(enable_reg[7:0],OP,w0[7:0],w1[7:0],w2[7:0],w3[7:0]); 


  //registers

  //r7-r0, r0 is always 32'b0
  //DataReg(Q,D,Le,Clk), no clear for now
  DataReg reg71(Q[71],PC,enable_reg[71],Clk);
  DataReg reg70(Q[70],PC,enable_reg[70],Clk);
  DataReg reg69(Q[69],PC,enable_reg[69],Clk);
  DataReg reg68(Q[68],PC,enable_reg[68],Clk);
  DataReg reg67(Q[67],PC,enable_reg[67],Clk);
  DataReg reg66(Q[66],PC,enable_reg[66],Clk);
  DataReg reg65(Q[65],PC,enable_reg[65],Clk);
  DataReg reg64(Q[64],PC,enable_reg[64],Clk);
  DataReg reg63(Q[63],PC,enable_reg[63],Clk);
  DataReg reg62(Q[62],PC,enable_reg[62],Clk);
  DataReg reg61(Q[61],PC,enable_reg[61],Clk);
  DataReg reg60(Q[60],PC,enable_reg[60],Clk);
  DataReg reg59(Q[59],PC,enable_reg[59],Clk);
  DataReg reg58(Q[58],PC,enable_reg[58],Clk);
  DataReg reg57(Q[57],PC,enable_reg[57],Clk);
  DataReg reg56(Q[56],PC,enable_reg[56],Clk);
  DataReg reg55(Q[55],PC,enable_reg[55],Clk);
  DataReg reg54(Q[54],PC,enable_reg[54],Clk);
  DataReg reg53(Q[53],PC,enable_reg[53],Clk);
  DataReg reg52(Q[52],PC,enable_reg[52],Clk);
  DataReg reg51(Q[51],PC,enable_reg[51],Clk);
  DataReg reg50(Q[50],PC,enable_reg[50],Clk);
  DataReg reg49(Q[49],PC,enable_reg[49],Clk);
  DataReg reg48(Q[48],PC,enable_reg[48],Clk);
  DataReg reg47(Q[47],PC,enable_reg[47],Clk);
  DataReg reg46(Q[46],PC,enable_reg[46],Clk);
  DataReg reg45(Q[45],PC,enable_reg[45],Clk);
  DataReg reg44(Q[44],PC,enable_reg[44],Clk);
  DataReg reg43(Q[43],PC,enable_reg[43],Clk);
  DataReg reg42(Q[42],PC,enable_reg[42],Clk);
  DataReg reg41(Q[41],PC,enable_reg[41],Clk);
  DataReg reg40(Q[40],PC,enable_reg[40],Clk);
  DataReg reg39(Q[39],PC,enable_reg[39],Clk);
  DataReg reg38(Q[38],PC,enable_reg[38],Clk);
  DataReg reg37(Q[37],PC,enable_reg[37],Clk);
  DataReg reg36(Q[36],PC,enable_reg[36],Clk);
  DataReg reg35(Q[35],PC,enable_reg[35],Clk);
  DataReg reg34(Q[34],PC,enable_reg[34],Clk);
  DataReg reg33(Q[33],PC,enable_reg[33],Clk);
  DataReg reg32(Q[32],PC,enable_reg[32],Clk);
  DataReg reg31(Q[31],PC,enable_reg[31],Clk);
  DataReg reg30(Q[30],PC,enable_reg[30],Clk);
  DataReg reg29(Q[29],PC,enable_reg[29],Clk);
  DataReg reg28(Q[28],PC,enable_reg[28],Clk);
  DataReg reg27(Q[27],PC,enable_reg[27],Clk);
  DataReg reg26(Q[26],PC,enable_reg[26],Clk);
  DataReg reg25(Q[25],PC,enable_reg[25],Clk);
  DataReg reg24(Q[24],PC,enable_reg[24],Clk);
  DataReg reg23(Q[23],PC,enable_reg[23],Clk);
  DataReg reg22(Q[22],PC,enable_reg[22],Clk);
  DataReg reg21(Q[21],PC,enable_reg[21],Clk);
  DataReg reg20(Q[20],PC,enable_reg[20],Clk);
  DataReg reg19(Q[19],PC,enable_reg[19],Clk);
  DataReg reg18(Q[18],PC,enable_reg[18],Clk);
  DataReg reg17(Q[17],PC,enable_reg[17],Clk);
  DataReg reg16(Q[16],PC,enable_reg[16],Clk);
  DataReg reg15(Q[15],PC,enable_reg[15],Clk);
  DataReg reg14(Q[14],PC,enable_reg[14],Clk);
  DataReg reg13(Q[13],PC,enable_reg[13],Clk);
  DataReg reg12(Q[12],PC,enable_reg[12],Clk);
  DataReg reg11(Q[11],PC,enable_reg[11],Clk);
  DataReg reg10(Q[10],PC,enable_reg[10],Clk);
  DataReg reg9(Q[9],PC,enable_reg[9],Clk);
  DataReg reg8(Q[8],PC,enable_reg[8],Clk);
  DataReg reg7(Q[7],PC,enable_reg[7],Clk);
  DataReg reg6(Q[6],PC,enable_reg[6],Clk);
  DataReg reg5(Q[5],PC,enable_reg[5],Clk);
  DataReg reg4(Q[4],PC,enable_reg[4],Clk);
  DataReg reg3(Q[3],PC,enable_reg[3],Clk);
  DataReg reg2(Q[2],PC,enable_reg[2],Clk);
  DataReg reg1(Q[1],PC,enable_reg[1],Clk);
  Q[0] = 32'd0; //reg0 is always 0
  DataReg reg0(Q[0],PC,enable_reg[0],Clk);
  //outputmuxes







endmodule
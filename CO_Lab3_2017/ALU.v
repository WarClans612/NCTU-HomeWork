module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;

//Internal Signals
wire			 zero;
wire			 overflow;
wire	[32-1:0] result;

//Main function
/*your code here*/
  wire[31:0] carryOut;
  wire	set;
  ALU_1bit bit0 (result[0 ], carryOut[0 ], aluSrc1[0 ], aluSrc2[0 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], ALU_operation_i[2], set);
  ALU_1bit bit1 (result[1 ], carryOut[1 ], aluSrc1[1 ], aluSrc2[1 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[0 ], 1'b0);
  ALU_1bit bit2 (result[2 ], carryOut[2 ], aluSrc1[2 ], aluSrc2[2 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[1 ], 1'b0);
  ALU_1bit bit3 (result[3 ], carryOut[3 ], aluSrc1[3 ], aluSrc2[3 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[2 ], 1'b0);
  ALU_1bit bit4 (result[4 ], carryOut[4 ], aluSrc1[4 ], aluSrc2[4 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[3 ], 1'b0);
  ALU_1bit bit5 (result[5 ], carryOut[5 ], aluSrc1[5 ], aluSrc2[5 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[4 ], 1'b0);
  ALU_1bit bit6 (result[6 ], carryOut[6 ], aluSrc1[6 ], aluSrc2[6 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[5 ], 1'b0);
  ALU_1bit bit7 (result[7 ], carryOut[7 ], aluSrc1[7 ], aluSrc2[7 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[6 ], 1'b0);
  ALU_1bit bit8 (result[8 ], carryOut[8 ], aluSrc1[8 ], aluSrc2[8 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[7 ], 1'b0);
  ALU_1bit bit9 (result[9 ], carryOut[9 ], aluSrc1[9 ], aluSrc2[9 ], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[8 ], 1'b0);
  ALU_1bit bit10(result[10], carryOut[10], aluSrc1[10], aluSrc2[10], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[9 ], 1'b0);
  ALU_1bit bit11(result[11], carryOut[11], aluSrc1[11], aluSrc2[11], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[10], 1'b0);
  ALU_1bit bit12(result[12], carryOut[12], aluSrc1[12], aluSrc2[12], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[11], 1'b0);
  ALU_1bit bit13(result[13], carryOut[13], aluSrc1[13], aluSrc2[13], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[12], 1'b0);
  ALU_1bit bit14(result[14], carryOut[14], aluSrc1[14], aluSrc2[14], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[13], 1'b0);
  ALU_1bit bit15(result[15], carryOut[15], aluSrc1[15], aluSrc2[15], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[14], 1'b0);
  ALU_1bit bit16(result[16], carryOut[16], aluSrc1[16], aluSrc2[16], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[15], 1'b0);
  ALU_1bit bit17(result[17], carryOut[17], aluSrc1[17], aluSrc2[17], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[16], 1'b0);
  ALU_1bit bit18(result[18], carryOut[18], aluSrc1[18], aluSrc2[18], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[17], 1'b0);
  ALU_1bit bit19(result[19], carryOut[19], aluSrc1[19], aluSrc2[19], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[18], 1'b0);
  ALU_1bit bit20(result[20], carryOut[20], aluSrc1[20], aluSrc2[20], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[19], 1'b0);
  ALU_1bit bit21(result[21], carryOut[21], aluSrc1[21], aluSrc2[21], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[20], 1'b0);
  ALU_1bit bit22(result[22], carryOut[22], aluSrc1[22], aluSrc2[22], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[21], 1'b0);
  ALU_1bit bit23(result[23], carryOut[23], aluSrc1[23], aluSrc2[23], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[22], 1'b0);
  ALU_1bit bit24(result[24], carryOut[24], aluSrc1[24], aluSrc2[24], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[23], 1'b0);
  ALU_1bit bit25(result[25], carryOut[25], aluSrc1[25], aluSrc2[25], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[24], 1'b0);
  ALU_1bit bit26(result[26], carryOut[26], aluSrc1[26], aluSrc2[26], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[25], 1'b0);
  ALU_1bit bit27(result[27], carryOut[27], aluSrc1[27], aluSrc2[27], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[26], 1'b0);
  ALU_1bit bit28(result[28], carryOut[28], aluSrc1[28], aluSrc2[28], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[27], 1'b0);
  ALU_1bit bit29(result[29], carryOut[29], aluSrc1[29], aluSrc2[29], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[28], 1'b0);
  ALU_1bit bit30(result[30], carryOut[30], aluSrc1[30], aluSrc2[30], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[29], 1'b0);
  ALU_bit31 bit31(result[31], carryOut[31], aluSrc1[31], aluSrc2[31], ALU_operation_i[3], ALU_operation_i[2], ALU_operation_i[1:0], carryOut[30], 1'b0, set, overflow);

 assign zero = ~(result[0] | result[1] | result[2] | result[3] | result[4] | result[5] | result[6] | result[7] | result[8]
	 | result[9] | result[10] | result[11] | result[12] | result[13] | result[14] | result[15] | result[16] | result[17]
	 | result[18] | result[19] | result[20] | result[21] | result[22] | result[23] | result[24] | result[25] | result[26]
	 | result[27] | result[28] | result[29] | result[30] | result[31]);

endmodule

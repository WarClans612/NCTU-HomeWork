//Student ID: 0416106
//Name: Wilbert
module Forwarding_Unit(EX_MEM_RegWrite, EX_MEM_RegRd,
		ID_EX_RegRs, ID_EX_RegRt,
		MEM_WB_RegWrite, MEM_WB_RegRd,
		fwdA, fwdB);

input				EX_MEM_RegWrite, MEM_WB_RegWrite;
input		[5-1:0]	EX_MEM_RegRd, ID_EX_RegRs, ID_EX_RegRt, MEM_WB_RegRd;
output 		[2-1:0]	fwdA, fwdB;

wire first, second, third, fourth;

assign first = EX_MEM_RegWrite && (EX_MEM_RegRd != 0) && (EX_MEM_RegRd == ID_EX_RegRs);
assign second = MEM_WB_RegWrite && (MEM_WB_RegRd != 0) && (MEM_WB_RegRd == ID_EX_RegRs);
assign third = EX_MEM_RegWrite && (EX_MEM_RegRd != 0) && (EX_MEM_RegRd == ID_EX_RegRt);
assign fourth = MEM_WB_RegWrite && (MEM_WB_RegRd != 0) && (MEM_WB_RegRd == ID_EX_RegRt);

assign fwdA = (first) ? 2'b10 : (second && !first) ? 2'b01 : 2'b00;
assign fwdB = (third) ? 2'b10 : (fourth && !third) ? 2'b01 : 2'b00;

endmodule

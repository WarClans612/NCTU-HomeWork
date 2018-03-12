//Student ID: 0416106
//Name: Wilbert
module Hazard_Detection_Unit(PCSrc, Jump, ID_EX_MemRead,
		ID_EX_RegRt, IF_ID_RegRs, IF_ID_RegRt,
		PCWrite, IF_ID_Write, Flush_Decoder,
		IF_Flush, ID_Flush, EX_Flush);

input				PCSrc, Jump, ID_EX_MemRead;
input		[5-1:0]	ID_EX_RegRt, IF_ID_RegRs, IF_ID_RegRt;
output reg			PCWrite, IF_ID_Write, Flush_Decoder, IF_Flush, ID_Flush, EX_Flush;

always@ (*) begin
	if (ID_EX_MemRead && ((ID_EX_RegRt == IF_ID_RegRs) || (ID_EX_RegRt == IF_ID_RegRt))) begin
	PCWrite = 0;
	IF_ID_Write = 0;
	Flush_Decoder = 0;
	end
	else begin
	PCWrite = 1;
	IF_ID_Write = 1;
	Flush_Decoder = 1;
	end
end

always@ (*) begin
	if (PCSrc | Jump) begin
	IF_Flush = 0;
	ID_Flush = 0;
	EX_Flush = 0;
	end
	else begin
	IF_Flush = 1;
	ID_Flush = 1;
	EX_Flush = 1;
	end
end

endmodule

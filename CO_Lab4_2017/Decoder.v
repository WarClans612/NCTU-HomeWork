//Student ID: 0416106
//Name: Wilbert
module Decoder( instr_op_i, jump_o, ALUOp_o, ALUSrc_o, branch_o, branch_type_o, memwrite_o,
	memread_o, mem_to_reg_o, RegWrite_o, RegDst_o, RegFile_data_o);
     
//I/O ports
input	[6-1:0] instr_op_i;

output		jump_o, branch_o, memwrite_o,
		memread_o, mem_to_reg_o, RegWrite_o, RegFile_data_o;
output	[2-1:0]  RegDst_o, ALUSrc_o, branch_type_o;
output	[3-1:0] ALUOp_o;

//Main function
/*your code here*/

assign jump_o = (instr_op_i == 6'b000010 || instr_op_i == 6'b000011) ? 1 : 0;
assign ALUSrc_o =(instr_op_i == 6'b000001) ? 2'd2 : (instr_op_i == 6'b000000 ||
				instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000110) ? 2'd0 : 2'd1;
assign branch_o = (instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000110 || 
					instr_op_i == 6'b000001) ? 1 : 0;
assign branch_type_o = (instr_op_i == 6'b000001) ? 2'd3 : (instr_op_i == 6'b000110) ? 2'd2 : 
						{1'b0,instr_op_i[0]};
assign memwrite_o = (instr_op_i == 6'b101011) ? 1 : 0;
assign memread_o = (instr_op_i == 6'b100011) ? 1 : 0;
assign mem_to_reg_o = (instr_op_i == 6'b100011) ? 1 : 0;
assign RegWrite_o = (instr_op_i == 6'b000000 || instr_op_i == 6'b100011 || instr_op_i == 6'b001000 || 
					instr_op_i == 6'b001111 || instr_op_i == 6'b000011) ? 1 : 0;
assign RegDst_o = (instr_op_i == 6'b000011) ? 2'd2 : (instr_op_i == 6'b000000) ? 2'd1 : 2'd0;
assign ALUOp_o = (instr_op_i == 6'b001000) ? 3'b100 : (instr_op_i == 6'b001111) ? 3'b101 : 
				(instr_op_i == 6'b100011 || instr_op_i == 6'b101011) ? 3'b000 : (instr_op_i == 
				6'b000100) ? 3'b001 : (instr_op_i == 6'b000101) ? 3'b110 : 
				(instr_op_i == 6'b000110 || instr_op_i == 6'b000001) ? 3'b111 : 3'b010;
assign RegFile_data_o = (instr_op_i == 6'b000011) ? 1 : 0;
 
endmodule

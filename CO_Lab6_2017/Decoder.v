//Student ID: 0416106
//Name: Wilbert
module Decoder( instr_op_i, Flush_i, jump_o, ALUOp_o, ALUSrc_o, branch_o, branch_type_o, memwrite_o,
	memread_o, mem_to_reg_o, RegWrite_o, RegDst_o);
     
//I/O ports
input	[6-1:0] instr_op_i;
input			Flush_i;

output		jump_o, branch_o, memwrite_o, RegDst_o,
		memread_o, mem_to_reg_o, RegWrite_o;
output	[2-1:0]  ALUSrc_o, branch_type_o;
output	[3-1:0] ALUOp_o;

wire		jump_to, branch_to, memwrite_to, RegDst_to,
		memread_to, mem_to_reg_to, RegWrite_to;
wire	[2-1:0]  ALUSrc_to, branch_type_to;
wire	[3-1:0] ALUOp_to;

//Main function
/*your code here*/

assign jump_to = (instr_op_i == 6'b000010) ? 1 : 0;
assign ALUSrc_to =(instr_op_i == 6'b000001) ? 2'd2 : (instr_op_i == 6'b000000 ||
				instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000110) ? 2'd0 : 2'd1;
assign branch_to = (instr_op_i == 6'b000100 || instr_op_i == 6'b000101 || instr_op_i == 6'b000110 || 
					instr_op_i == 6'b000001) ? 1 : 0;
assign branch_type_to = (instr_op_i == 6'b000001) ? 2'd3 : (instr_op_i == 6'b000110) ? 2'd2 : 
						{1'b0,instr_op_i[0]};
assign memwrite_to = (instr_op_i == 6'b101011) ? 1 : 0;
assign memread_to = (instr_op_i == 6'b100011) ? 1 : 0;
assign mem_to_reg_to = (instr_op_i == 6'b100011) ? 1 : 0;
assign RegWrite_to = (instr_op_i == 6'b000000 || instr_op_i == 6'b100011 || instr_op_i == 6'b001000 || 
					instr_op_i == 6'b001111) ? 1 : 0;
assign RegDst_to = (instr_op_i == 6'b000000) ? 1'd1 : 1'd0;
assign ALUOp_to = (instr_op_i == 6'b001000) ? 3'b100 : (instr_op_i == 6'b001111) ? 3'b101 : 
				(instr_op_i == 6'b100011 || instr_op_i == 6'b101011) ? 3'b000 : (instr_op_i == 
				6'b000100) ? 3'b001 : (instr_op_i == 6'b000101) ? 3'b110 : 
				(instr_op_i == 6'b000110 || instr_op_i == 6'b000001) ? 3'b111 : 3'b010;
 
assign jump_o = (Flush_i) ? jump_to : 0;
assign ALUSrc_o = (Flush_i) ? ALUSrc_to : 0;
assign branch_o = (Flush_i) ?  branch_to : 0;
assign branch_type_o = (Flush_i) ? branch_type_to : 0;
assign memwrite_o = (Flush_i) ? memwrite_to : 0;
assign memread_o = (Flush_i) ? memread_to : 0;
assign mem_to_reg_o = (Flush_i) ? mem_to_reg_to : 0;
assign RegWrite_o = (Flush_i) ? RegWrite_to : 0;
assign RegDst_o = (Flush_i) ? RegDst_to : 0;
assign ALUOp_o = (Flush_i) ? ALUOp_to : 0;
 
endmodule

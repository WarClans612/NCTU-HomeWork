module ID_EX_register(clk_i, rst_n, flush_i, enable_i, enable_o,
		next_pc_i, instruction_i, next_pc_o, instruction_o,
		data1_i, data2_i, signex_i, zeroex_i, jmp_addr_i, 
		data1_o, data2_o, signex_o, zeroex_o, jmp_addr_o,
		jump_i, branch_i, memwrite_i, RegDst_i,
		memread_i, mem_to_reg_i, RegWrite_i,
		ALUSrc_i, branch_type_i, ALUOp_i,
		jump_o, branch_o, memwrite_o, RegDst_o,
		memread_o, mem_to_reg_o, RegWrite_o,
		ALUSrc_o, branch_type_o, ALUOp_o
		);

input		clk_i;
input		rst_n;
input		enable_i, flush_i;
input		[32-1:0]	next_pc_i, instruction_i;
output reg				enable_o;
output reg	[32-1:0]	next_pc_o, instruction_o;

////data
input		[32-1:0]	data1_i, data2_i, signex_i, zeroex_i, jmp_addr_i;
output reg	[32-1:0]	data1_o, data2_o, signex_o, zeroex_o, jmp_addr_o;

////Decoder input and output
input					jump_i, branch_i, memwrite_i, RegDst_i,
						memread_i, mem_to_reg_i, RegWrite_i;
input		[2-1:0]  	ALUSrc_i, branch_type_i;
input		[3-1:0] 	ALUOp_i;

output reg				jump_o, branch_o, memwrite_o, RegDst_o,
						memread_o, mem_to_reg_o, RegWrite_o;
output reg	[2-1:0]  	ALUSrc_o, branch_type_o;
output reg	[3-1:0] 	ALUOp_o;

always@ (posedge clk_i or negedge rst_n) begin
	if(~rst_n | ~enable_i | ~flush_i) begin
	enable_o			<= 0;
	next_pc_o 			<= 0;
	instruction_o 		<= 0;
	data1_o 			<= 0;
	data2_o 			<= 0;
	signex_o 			<= 0;
	zeroex_o 			<= 0;
	jmp_addr_o 			<= 0;
	jump_o 				<= 0;
	branch_o 			<= 0;
	memwrite_o 			<= 0;
	RegDst_o			<= 0;
	memread_o			<= 0;
	mem_to_reg_o		<= 0;
	RegWrite_o			<= 0;
	ALUSrc_o			<= 0;
	branch_type_o		<= 0;
	ALUOp_o 			<= 0;
	end
	else begin
	enable_o			<= 1;
	next_pc_o 			<= next_pc_i;
	instruction_o 		<= instruction_i;
	data1_o 			<= data1_i;
	data2_o 			<= data2_i;
	signex_o 			<= signex_i;
	zeroex_o 			<= zeroex_i;
	jmp_addr_o 			<= jmp_addr_i;
	jump_o 				<= jump_i;
	branch_o 			<= branch_i;
	memwrite_o 			<= memwrite_i;
	RegDst_o			<= RegDst_i;
	memread_o			<= memread_i;
	mem_to_reg_o		<= mem_to_reg_i;
	RegWrite_o			<= RegWrite_i;
	ALUSrc_o			<= ALUSrc_i;
	branch_type_o		<= branch_type_i;
	ALUOp_o 			<= ALUOp_i;
	end
end

endmodule


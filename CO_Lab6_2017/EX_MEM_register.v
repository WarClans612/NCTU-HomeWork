module EX_MEM_register(clk_i, rst_n, flush_i, enable_i, enable_o,
		write_reg_i, data2_i, last_data_i, next_pc_i, 
		branch_to_PCSrc_i, branch_i, branch_rslt_i, jmp_address_i,
		jump_i, memwrite_i, memread_i, mem_to_reg_i, regWrite_i,
		write_reg_o, data2_o, last_data_o, next_pc_o, 
		branch_to_PCSrc_o, branch_o, branch_rslt_o, jmp_address_o,
		jump_o, memwrite_o, memread_o, mem_to_reg_o, regWrite_o);

input		clk_i;
input		rst_n;
input		enable_i, flush_i;
output reg	enable_o;

input	[5-1:0]		write_reg_i;
input	[32-1:0]	data2_i, last_data_i, next_pc_i;
input				branch_to_PCSrc_i;
input				branch_i;
input	[32-1:0]	branch_rslt_i, jmp_address_i;
input				jump_i, memwrite_i, memread_i, mem_to_reg_i, regWrite_i;

output reg	[5-1:0]		write_reg_o;
output reg	[32-1:0]	data2_o, last_data_o, next_pc_o;
output reg				branch_to_PCSrc_o;
output reg				branch_o;
output reg	[32-1:0]	branch_rslt_o, jmp_address_o;
output reg				jump_o, memwrite_o, memread_o, mem_to_reg_o, regWrite_o;


always@ (posedge clk_i or negedge rst_n) begin
	if(~rst_n | ~enable_i | ~flush_i) begin
	enable_o			<= 0;
	write_reg_o			<= 0;
	data2_o				<= 0;
	last_data_o			<= 0;
	next_pc_o			<= 0;
	branch_to_PCSrc_o	<= 0;	
	branch_o			<= 0;
	branch_rslt_o		<= 0;
	jmp_address_o		<= 0;	
	jump_o				<= 0;
	memwrite_o			<= 0;
	memread_o			<= 0;
	mem_to_reg_o		<= 0;
	regWrite_o			<= 0;
	end
	else begin
	enable_o			<= 1					;
	write_reg_o			<= write_reg_i			;
	data2_o				<= data2_i				;
	last_data_o			<= last_data_i			;
	next_pc_o			<= next_pc_i			;
	branch_to_PCSrc_o	<= branch_to_PCSrc_i	;	
	branch_o			<= branch_i				;
	branch_rslt_o		<= branch_rslt_i		;
	jmp_address_o		<= jmp_address_i		;	
	jump_o				<= jump_i				;
	memwrite_o			<= memwrite_i			;
	memread_o			<= memread_i			;
	mem_to_reg_o		<= mem_to_reg_i			;
	regWrite_o			<= regWrite_i			;
	end
end

endmodule

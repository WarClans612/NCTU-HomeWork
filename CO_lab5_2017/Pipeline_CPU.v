//Student ID: 0416106
//Name: Wilbert
module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire	[32-1:0]	pc_in, pc_out, instr, instr_r, instr_r2, write_data, data1,
			data1_r2, data2, data2_r2, data2_r3, const_signex, const_signex_r2, const_zeroex,
			const_zeroex_r2, alu_data2, mux_data1, mux_data2, next_pc, next_pc_r, 
			next_pc_r2, next_pc_r3, jmp_addr, jmp_addr_r2, jmp_address_r3, constant_addr_shift_o, 
			branch_rslt, branch_rslt_r3, temp_next_addr, last_data_o, last_data_o_r3, 
			last_data_o_r4, memory_data, memory_data_r4;
wire	enable_r, enable_r2, enable_r3;
wire		regWrite, regWrite_r2, regWrite_r3, regWrite_r4, zero, overflow, PCSrc, jump, jump_r2, jump_r3,
			branch, branch_r2, branch_r3, mem_to_reg, mem_to_reg_r2, mem_to_reg_r3, 
			mem_to_reg_r4, mwrite, mwrite_r2, 
			mwrite_r3, mread, mread_r2, mread_r3, regDst, regDst_r2, branch_to_PCSrc, branch_to_PCSrc_r3;
wire	[5-1:0]		write_reg, write_reg_r3, write_reg_r4, shamt_v;
wire	[3-1:0]		alucontrol, alucontrol_r2;
wire	[4-1:0]		alu_operation;
wire	[2-1:0]		last_mux, alusrc, alusrc_r2, branch_type, branch_type_r2;


//modules
Program_Counter PC(
        .clk_i(clk_i),      
	.rst_n(rst_n),     
	.pc_in_i(pc_in) ,   
	.pc_out_o(pc_out) 
	);
	
Adder pc_first_adder(
	.src1_i(pc_out),     
	.src2_i(32'd4),
	.sum_o(next_pc)    
	);
	
IF_ID_register IF_ID(
	.clk_i(clk_i), 
	.rst_n(rst_n), 
	.enable_o(enable_r),
	.next_pc_i(next_pc), 
	.instruction_i(instr),
	.next_pc_o(next_pc_r), 
	.instruction_o(instr_r)
	);
		
Jump_address jump_shift_preparation(
	.instruction(instr_r[25:0]),
	.pc(next_pc_r[31:28]),
	.out(jmp_addr)
	);
		
Shift_left_2 #(.size(32)) constant_addr_shift(
	.in(const_signex_r2),
	.out(constant_addr_shift_o)
	);
		
Adder branch_addr(
	.src1_i(next_pc_r2),
	.src2_i(constant_addr_shift_o),
	.sum_o(branch_rslt)
	);

Mux2to1 #(.size(32)) branch_decision(
	.data0_i(next_pc),
	.data1_i(branch_rslt_r3),
	.select_i(PCSrc),
	.data_o(temp_next_addr)
	);
		
Mux2to1 #(.size(32)) jump_desicion(
	.data0_i(temp_next_addr),
	.data1_i(jmp_address_r3),
	.select_i(jump_r3),
	.data_o(pc_in)
	);
		
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	.instr_o(instr)    
	);

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_r2[20:16]),
        .data1_i(instr_r2[15:11]),
        .select_i(regDst_r2),
        .data_o(write_reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_n(rst_n) ,     
        .RSaddr_i(instr_r[25:21]) ,  
        .RTaddr_i(instr_r[20:16]) ,  
        .Wrtaddr_i(write_reg_r4) ,  
        .Wrtdata_i(write_data)  , 
        .RegWrite_i(regWrite_r4),
        .RSdata_o(data1) ,  
        .RTdata_o(data2)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_r[31:26]),
	.jump_o(jump),
	.ALUOp_o(alucontrol),
	.ALUSrc_o(alusrc),
	.branch_o(branch),
	.branch_type_o(branch_type),
	.memwrite_o (mwrite),
	.memread_o (mread),
	.mem_to_reg_o(mem_to_reg),
	.RegWrite_o(regWrite),  
	.RegDst_o(regDst)
	);

ALU_Ctrl AC(
        .funct_i(instr_r2[5:0]),   
        .ALUOp_i(alucontrol_r2),   
        .ALU_operation_o(alu_operation),
	.FURslt_o(last_mux)
        );
	
Sign_Extend SE(
        .data_i(instr_r[15:0]),
        .data_o(const_signex)
        );

Zero_Filled ZF(
        .data_i(instr_r[15:0]),
        .data_o(const_zeroex)
        );
		
Mux3to1 #(.size(32)) ALU_src2Src(
        .data0_i(data2_r2),
        .data1_i(const_signex_r2),
		.data2_i(32'd0),
        .select_i(alusrc_r2),
        .data_o(alu_data2)
        );	
		
ALU ALU(
	.aluSrc1(data1_r2),
	.aluSrc2(alu_data2),
	.ALU_operation_i(alu_operation),
	.result(mux_data1),
	.zero(zero),
	.overflow(overflow)
	);
		
Mux4to1 #(.size(1)) branch_types(
	.data0_i(zero),
	.data1_i(~zero),
	.data2_i(~mux_data1[0]),
	.data3_i(mux_data1[0]),
	.select_i(branch_type_r2),
	.data_o(branch_to_PCSrc)
	);
		
and (PCSrc, branch_r3, branch_to_PCSrc_r3);
	
Mux2to1 #(.size(5)) shamt_control(
        .data0_i(instr_r2[10:6]),
        .data1_i(data1_r2[4:0]),
        .select_i(instr_r2[2]),
        .data_o(shamt_v)
        );	
	
Shifter shifter( 
	.result(mux_data2), 
	.leftRight(instr_r2[1]),
	.shamt(shamt_v),
	.sftSrc(alu_data2) 
	);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(mux_data1),
        .data1_i(mux_data2),
	.data2_i(const_zeroex_r2),
        .select_i(last_mux),
        .data_o(last_data_o)
        );		

Data_Memory DM(
	.clk_i(clk_i),
	.addr_i(last_data_o_r3),
	.data_i(data2_r3),
	.MemRead_i(mread_r3),
	.MemWrite_i(mwrite_r3),
	.data_o(memory_data)
	);
		
Mux2to1 #(.size(32)) data_reading(
        .data0_i(last_data_o_r4),
        .data1_i(memory_data_r4),
        .select_i(mem_to_reg_r4),
        .data_o(write_data)
        );
		
ID_EX_register ID_EX(
		.clk_i(clk_i), 
		.rst_n(rst_n), 
		.enable_i(enable_r),
		.enable_o(enable_r2),
		.next_pc_i(next_pc_r), 
		.instruction_i(instr_r), 
		.next_pc_o(next_pc_r2), 
		.instruction_o(instr_r2),
		.data1_i(data1), 
		.data2_i(data2), 
		.signex_i(const_signex), 
		.zeroex_i(const_zeroex), 
		.jmp_addr_i(jmp_addr), 
		.data1_o(data1_r2), 
		.data2_o(data2_r2), 
		.signex_o(const_signex_r2), 
		.zeroex_o(const_zeroex_r2), 
		.jmp_addr_o(jmp_addr_r2),
		.jump_i(jump),
		.branch_i(branch), 
		.memwrite_i(mwrite), 
		.RegDst_i(regDst),
		.memread_i(mread), 
		.mem_to_reg_i(mem_to_reg), 
		.RegWrite_i(regWrite),
		.ALUSrc_i(alusrc), 
		.branch_type_i(branch_type), 
		.ALUOp_i(alucontrol),
		.jump_o(jump_r2), 
		.branch_o(branch_r2), 
		.memwrite_o(mwrite_r2), 
		.RegDst_o(regDst_r2),
		.memread_o(mread_r2), 
		.mem_to_reg_o(mem_to_reg_r2), 
		.RegWrite_o(regWrite_r2),
		.ALUSrc_o(alusrc_r2),
		.branch_type_o(branch_type_r2),
		.ALUOp_o(alucontrol_r2)
		);
		
EX_MEM_register EX_MEM(
		.clk_i(clk_i), 
		.rst_n(rst_n),
		.enable_i(enable_r2),
		.enable_o(enable_r3),
		.write_reg_i(write_reg), 
		.data2_i(data2_r2), 
		.last_data_i(last_data_o), 
		.next_pc_i(next_pc_r2),
		.branch_to_PCSrc_i(branch_to_PCSrc),
		.branch_i(branch_r2), 
		.branch_rslt_i(branch_rslt), 
		.jmp_address_i(jmp_addr_r2),
		.jump_i(jump_r2), 
		.memwrite_i(mwrite_r2), 
		.memread_i(mread_r2), 
		.mem_to_reg_i(mem_to_reg_r2), 
		.regWrite_i(regWrite_r2),
		.write_reg_o(write_reg_r3), 
		.data2_o(data2_r3), 
		.last_data_o(last_data_o_r3), 
		.next_pc_o(next_pc_r3),
		.branch_to_PCSrc_o(branch_to_PCSrc_r3),
		.branch_o(branch_r3), 
		.branch_rslt_o(branch_rslt_r3), 
		.jmp_address_o(jmp_address_r3),
		.jump_o(jump_r3), 
		.memwrite_o(mwrite_r3), 
		.memread_o(mread_r3), 
		.mem_to_reg_o(mem_to_reg_r3), 
		.regWrite_o(regWrite_r3)
		);
		
MEM_WB_register MEM_WB(
		.clk_i(clk_i), 
		.rst_n(rst_n),
		.enable_i(enable_r3),
		.write_reg_i(write_reg_r3), 
		.last_data_i(last_data_o_r3), 
		.mem_to_reg_i(mem_to_reg_r3), 
		.regWrite_i(regWrite_r3),
		.memory_data_i(memory_data),
		.write_reg_o(write_reg_r4), 
		.last_data_o(last_data_o_r4), 
		.mem_to_reg_o(mem_to_reg_r4), 
		.regWrite_o(regWrite_r4),
		.memory_data_o(memory_data_r4)
		);

endmodule




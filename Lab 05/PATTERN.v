`timescale 1ns/10ps
`define CYCLE_PERIOD 4.0

module PATTERN(
	input [4:0] out,
	input out_valid,
	output reg [4:0] in,
	output reg in_valid1,
	output reg [1:0] op,
	output reg mode,
	output reg in_valid2,
	output reg clk,
	output reg rst_n
);

parameter CYCLE = `CYCLE_PERIOD;
parameter PATTERN_NUM = 1000;

reg       mode_t;
reg [1:0] op_t;
reg [4:0] in_t;
reg [6:0] push_times;
reg [6:0] pop_times;
reg [4:0] position[0:9];
reg [3:0] number;
reg [5:0] temp;
reg [7:0] length,wait_clk,i,k;
reg	[3:0] m1,m2,m3,m4,m5,m6,m7,m8,m9,m10;
reg	[4:0] p1,p2,p3,p4,p5,p6,p7,p8,p9,p10;

integer latency, total_latency;
integer pattern_num, j;
integer flag1,flag2,flag3,flag4;

initial begin
	total_latency = 0;
end

initial begin
	clk = 0;
	#10;
	$display("before clk");
	forever #(CYCLE/2) clk = ~clk;
end

initial begin
	in <= 'dx;
	mode <= 'dx;
	in_valid1 <= 'bx;
	in_valid2 <= 'bx;
	rst_n <= 1'b1;
	op<='dx;
	temp<='d0;
	$display("before reset");
	#2;
	rst_n <= 1'b0;
	
	#4;
	rst_n <= 1'b1;
	
	check_rst;
	
	in_valid1 <= 'b0;
	in_valid2 <= 'b0;
	
	@(negedge clk);
	
	pattern_num=0; input_task1;	sort; wait_out;	check_ans;
	
	pattern_num=1; input_task2;	sort; wait_out;	check_ans;
	
	pattern_num=2; input_task3;	sort; wait_out;	check_ans;
	
	pattern_num=3; input_task4; sort; wait_out; check_ans; 	
	
	for(pattern_num=1;pattern_num<PATTERN_NUM;pattern_num=pattern_num+1) begin
		wait_clk={$random()}%'d6;
		repeat(wait_clk)@(negedge clk);
		
		input_task;		
		sort;		
		wait_out;		
		check_ans;
	
	end
	
	@(negedge clk);
	$display ("--------------------------------------------------------------------");
	$display ("                         Congratulations !                          ");
	$display ("                  You have passed all patterns !                    ");
	$display ("                  Your total latency is %6d !                       ", total_latency);
	$display ("--------------------------------------------------------------------");
	@(negedge clk);   
	$finish;
	
end

task check_rst;

	if(out !== 'd0 || out_valid !== 1'b0) begin
		$display("");
		$display("=================================================");
		$display("  Output should be reset !!!!               ");
		$display("=================================================");
		$display("");
		@(negedge clk);
		$finish;
	end

endtask



task check_out_vaild;

	if(out_valid !== 1'b0) begin
		$display("");
		$display("=================================================");
		$display("  Out_valid should not be HIGH while in_valid1 is HIGH !!!!");
		$display("=================================================");
		$display("");
		@(negedge clk);
		$finish;
	end

endtask

task input_task1;begin
	pop_times =0;
	push_times =0;
	for(i=0;i<10;i=i+1) begin
		position[i]=0;
	end
	show_pos;
	
	mode_t='d0;
	mode=mode_t;
	in_valid2='d1;
	@(negedge clk);
	
	mode<='dx;
	in_valid2<='d0;
	@(negedge clk);
	
	number=0;
	in_valid1 = 1'b1;
	for (i='d0;i<10;i=i+1)begin
		op='d1;
		push(5'd31);
		
		show_pos;
		check_out_vaild;
		@(negedge clk);
	end
	
	op = 2;
	in_valid1 = 1'b1;
	@(negedge clk);
	
	op = 'dx;
	in_valid1 = 1'b0;
end endtask

task input_task2;begin
	pop_times =0;
	push_times =0;
	for(i=0;i<10;i=i+1) begin
		position[i]=0;
	end
	show_pos;
	
	mode_t='d1;
	mode=mode_t;
	in_valid2='d1;
	@(negedge clk);
	
	mode<='dx;
	in_valid2<='d0;
	@(negedge clk);
	
	number=0;
	in_valid1 = 1'b1;
	for (i='d0;i<10;i=i+1)begin
		op='d1;
		push(5'd31);
		
		show_pos;
		check_out_vaild;
		@(negedge clk);
	end
	
	op = 2;
	in_valid1 = 1'b1;
	@(negedge clk);
	
	op = 'dx;
	in_valid1 = 1'b0;
end endtask

task input_task3;begin
	pop_times =0;
	push_times =0;
	for(i=0;i<10;i=i+1) begin
		position[i]=0;
	end
	show_pos;
	
	mode_t='d0;
	mode=mode_t;
	in_valid2='d1;
	@(negedge clk);
	
	mode<='dx;
	in_valid2<='d0;
	@(negedge clk);
	
	number=0;
	in_valid1 = 1'b1;
	op='d1;
	push(5'd1);
	show_pos;
	@(negedge clk);
	for (i='d0;i<9;i=i+1)begin
		op='d1;
		push(5'd31);
		
		show_pos;
		@(negedge clk);
	end
	
	for (i='d0;i<9;i=i+1)begin
		op='d0;
		pop;
		
		show_pos;
		check_out_vaild;
		@(negedge clk);
	end
	
	op = 2;
	in_valid1 = 1'b1;
	@(negedge clk);
	
	op = 'dx;
	in_valid1 = 1'b0;
end endtask

task input_task4;begin
	pop_times =0;
	push_times =0;
	for(i=0;i<10;i=i+1) begin
		position[i]=0;
	end
	show_pos;
	
	mode_t='d1;
	mode=mode_t;
	in_valid2='d1;
	@(negedge clk);
	
	mode<='dx;
	in_valid2<='d0;
	@(negedge clk);
	
	number=0;
	in_valid1 = 1'b1;
	for (i='d0;i<9;i=i+1)begin
		op='d1;
		push(5'd31);
		
		show_pos;
		@(negedge clk);
	end
	op='d1;
	push(5'd1);
	show_pos;
	@(negedge clk);
	
	for (i='d0;i<9;i=i+1)begin
		op='d0;
		pop;
		
		show_pos;
		check_out_vaild;
		@(negedge clk);
	end
	
	op = 2;
	in_valid1 = 1'b1;
	@(negedge clk);
	
	op = 'dx;
	in_valid1 = 1'b0;
end endtask

task input_task;begin
	pop_times =0;
	push_times =0;
	for(i=0;i<10;i=i+1) begin
		position[i]=0;
	end
	show_pos;
	
	mode_t={$random()}%'d2;
	mode=mode_t;
	in_valid2='d1;
	@(negedge clk);
	
	mode<='dx;
	in_valid2<='d0;
	wait_clk={$random()}%'d6;
	repeat(wait_clk)@(negedge clk);
	
	j=0;
	number=0;
	length={$random()}%'d10+1;
	k={$random()}%'d15+1;
	while (k>'d0)begin
		while (length>'d0)begin
			in_valid1 = 1'b1;
			if (number<'d3)begin
				op='d1;
				in_t={$random()}%'d31+1;
				push(in_t);
			end
			else if (number=='d10)begin
				op='d0;
				pop;
			end
			else begin
				op_t={$random()}%'d2;
				op=op_t;
				in_t={$random()}%'d31+1;
				if (op_t)push(in_t);
				else pop;
			end
			show_pos;
			
			length=length-1;
			check_out_vaild;
			
			@(negedge clk);
		end

		in = 'dx;
		in_valid1 = 1'b0;
		op = 'dx;
		
		wait_clk={$random()}%'d20;
		repeat(wait_clk)@(negedge clk);
		
		length={$random()}%'d10+1;
		k=k-1;
		@(negedge clk);
	end
	
	op = 2;
	in_valid1 = 1'b1;
	
	@(negedge clk);
	
	op = 'dx;
	in_valid1 = 1'b0;
end endtask

task push;
	input [4:0] push_in;
begin
	in = push_in;
	if (mode_t)begin //queue
		position[number]=push_in;
	end
	else begin //stack
		position[number]=push_in;
	end
	number=number+1;
	push_times=push_times+1;
end endtask

task pop;begin
	in = 'dx;
		number=number-1;
		if (mode_t)begin //queue
		position[0]=position[1];
		position[1]=position[2];	
		position[2]=position[3];	
		position[3]=position[4];	
		position[4]=position[5];	
		position[5]=position[6];	
		position[6]=position[7];	
		position[7]=position[8];	
		position[8]=position[9];	
		position[9]='d0;
	end
	else begin //stack
		position[number]=0;
	end
	pop_times=pop_times+1;
end endtask

task sort; begin
	for(i=0;i<10;i=i+1)begin
	    for(j=0;j<9;j=j+1)begin
		    if(position[i]>position[j])begin
			    temp=position[i];
				position[i]=position[j];
				position[j]=temp;
			end
		end
	end
	show_pos;

end endtask

task show_pos; begin
	p1<=position[0]; p2<=position[1]; p3<=position[2]; p4<=position[3]; p5<=position[4]; 
	p6<=position[5]; p7<=position[6]; p8<=position[7]; p9<=position[8]; p10<=position[9];
end endtask

task wait_out;begin

	latency = -1;

	while(!(out_valid === 1'b1)) begin
		if(latency > 100) begin
			$display("");
			$display("=================================================");
			$display("  Latency too more !!!!               ");
			$display("=================================================");
			$display("");
			@(negedge clk);
			$finish;
		end
		latency = latency + 1;
		total_latency = total_latency + 1;
		@(negedge clk);
	end

end endtask

task check_ans;begin
	i=0;
	while(out_valid) begin			
		if (i<10)begin
			if(out !== position[i]) begin
				$display("");
				$display("=================================================");
				$display("  Failed!!  PATTERN %4d is wrong!                ", pattern_num+1);
				$display("  out%d is %d  your ans is%d       ",i+1,position[i],out);
				$display("=================================================");
				$display("");
				@(negedge clk);	
				$finish;
			end
		end
		else if(i>=10)
			begin
			    $display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				$display ("                                                                        FAIL!                                                               ");
				$display ("                                                           Outvalid is more than 10 cycles                                                   ");
				$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
				repeat(9) @(negedge clk);
				$finish;
			end
		i=i+1;
		@(negedge clk);
	end
	
	if(i<10)
		begin
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                                        FAIL!                                                               ");
			$display ("                                                           Outvalid is less than 10 cycles                                                   ");
			$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
			repeat(9) @(negedge clk);
			$finish;
		end
		
	$display("");
	$display(" Pass pattern %3d ", pattern_num+1);
	
	@(negedge clk);

end endtask



endmodule

module CORE(
  clk,
  rst_n,
  in_valid,
  in,
  out_valid,
  out
);
input clk;
input rst_n;
input in_valid;
input [4:0] in;
output reg out_valid;
output reg [6:0] out;

parameter IDLE=0,INPUT=1,EX=2,OUTPUT=3;
reg [1:0] current_state,next_state;
reg [4:0] in1,in2,in3;
reg [2:0] count;
wire [6:0] sum; 
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)current_state<=IDLE;
	else current_state<=next_state;
end

always@(*)
begin
	case(current_state)
		IDLE:if(in_valid)next_state=INPUT;
			else next_state=IDLE;
		INPUT:if(!in_valid)next_state=EX;
			else next_state=INPUT;		
		EX:if(count==4)next_state=OUTPUT;
			else next_state=EX;	
		OUTPUT:next_state=IDLE;
		default:next_state=IDLE;
	endcase
end

assign sum = in1+in2+in3;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)in1<=0;
	else if(in_valid && count==0)in1<=in;
	else in1<=in1;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)in2<=0;
	else if(in_valid && count==1)in2<=in;
	else in2<=in2;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)in3<=0;
	else if(in_valid && count==2)in3<=in;
	else in3<=in3;
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)count<=0;
	else if(in_valid)count<=count+1;
	else if(current_state==EX)count<=count+1;
	else if(current_state==OUTPUT)count<=0;
	else count<=count;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)out_valid<=0;
	else if(count==4)out_valid<=1;
	else out_valid<=0;
end
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)out<=0;
	else if(count==4)out<=sum;
	else out<=out;
end




endmodule

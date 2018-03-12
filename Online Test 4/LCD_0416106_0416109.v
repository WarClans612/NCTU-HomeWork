`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:04 12/18/2016 
// Design Name: 
// Module Name:    LCD 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module LCD(
	input clk,
	input rst,
	input decrease,
	input start,
	input increase,
	input s1,
	input s0,
	input m1,
	input m0,
	output reg [7:0] out,
	output lcd_e,
	output lcd_rs,
	output lcd_rw,
	output [3:0] nibble
    );

wire sec1, sec0, min0, min1;
//Because of misunderstanding
assign sec1 = !s1;
assign sec0 = !s0;
assign min0 = !m0;
assign min1 = !m1;

//Parameter declaration
parameter IDLE = 0, SET = 1, RUN = 2, FINISH = 3, PAUSE = 4;

//Wire and reg declaration
reg [2:0] current_state, next_state;
reg [12:0] timer;
reg [12:0] now;
reg second;
reg [25:0] counter;
wire [3:0] temps0, temps1, tempm0, tempm1;
wire [3:0] nows0, nows1, nowm0, nowm1;
reg [127:0] upper_row, lower_row;

//Design
//Managing current state
always@(posedge clk or posedge rst)
begin
	if(rst) current_state <= IDLE;
	else current_state <= next_state;
end

//Managing next state
always@(*)
begin
	case(current_state)
		IDLE: next_state = SET;
		SET: if(start && counter == 'd1000000) next_state = RUN;
				else next_state = SET;
		RUN: if(now == 0) next_state = FINISH;
				else if(start && counter == 'd1000000) next_state = PAUSE;
				else next_state = RUN;
		PAUSE: if(start && counter == 'd1000000) next_state = RUN;
				else next_state = PAUSE;
		FINISH: next_state = FINISH;
		default: next_state = IDLE;
	endcase
end

//Managing upper row
always@(posedge clk or posedge rst)
begin
	if(rst) begin //All space printed
		upper_row[127:124] <= 4'h2;
		upper_row[123:120] <= 4'h0;
		upper_row[119:116] <= 4'h2;
		upper_row[115:112] <= 4'h0;
		upper_row[111:108] <= 4'h2;
		upper_row[107:104] <= 4'h0;
		upper_row[103:100] <= 4'h2;
		upper_row[99 :96 ] <= 4'h0;
		upper_row[95 :92 ] <= 4'h2;
		upper_row[91 :88 ] <= 4'h0;
		upper_row[87 :84 ] <= 4'h2;
		upper_row[83 :80 ] <= 4'h0;
		upper_row[79 :76 ] <= 4'h2;
		upper_row[75 :72 ] <= 4'h0;
		upper_row[71 :68 ] <= 4'h2;
		upper_row[67 :64 ] <= 4'h0;
		upper_row[63 :60 ] <= 4'h2;
		upper_row[59 :56 ] <= 4'h0;
		upper_row[55 :52 ] <= 4'h2;
		upper_row[51 :48 ] <= 4'h0;
		upper_row[47 :44 ] <= 4'h2;
		upper_row[43 :40 ] <= 4'h0;
		upper_row[39 :36 ] <= 4'h2;
		upper_row[35 :32 ] <= 4'h0;
		upper_row[31 :28 ] <= 4'h2;
		upper_row[27 :24 ] <= 4'h0;
		upper_row[23 :20 ] <= 4'h2;
		upper_row[19 :16 ] <= 4'h0;
		upper_row[15 :12 ] <= 4'h2;
		upper_row[11 :8  ] <= 4'h0;
		upper_row[7  :4  ] <= 4'h2;
		upper_row[3  :0  ] <= 4'h0;
	end
	//print time's up
	else if(current_state == FINISH) begin
		upper_row[127:124] <= 4'h3;
		upper_row[123:120] <= nowm0[3:0];
		upper_row[119:116] <= 4'h3;
		upper_row[115:112] <= nowm1[3:0];
		upper_row[111:108] <= 4'h3;
		upper_row[107:104] <= 4'hA;
		upper_row[103:100] <= 4'h3;
		upper_row[99 :96 ] <= nows0[3:0];
		upper_row[95 :92 ] <= 4'h3;
		upper_row[91 :88 ] <= nows1[3:0];
		upper_row[79 :76 ] <= 4'h5;
		upper_row[75 :72 ] <= 4'h4;
		upper_row[71 :68 ] <= 4'h6;
		upper_row[67 :64 ] <= 4'h9;
		upper_row[63 :60 ] <= 4'h6;
		upper_row[59 :56 ] <= 4'hD;
		upper_row[55 :52 ] <= 4'h6;
		upper_row[51 :48 ] <= 4'h5;
		upper_row[47 :44 ] <= 4'h2;
		upper_row[43 :40 ] <= 4'h7;
		upper_row[39 :36 ] <= 4'h7;
		upper_row[35 :32 ] <= 4'h3;
		upper_row[31 :28 ] <= 4'h2;
		upper_row[27 :24 ] <= 4'h0;
		upper_row[23 :20 ] <= 4'h5;
		upper_row[19 :16 ] <= 4'h5;
		upper_row[15 :12 ] <= 4'h7;
		upper_row[11 :8  ] <= 4'h0;
		upper_row[7  :4  ] <= 4'h2;
		upper_row[3  :0  ] <= 4'h1;
	end
	//Print the upper row timer
	else begin
		upper_row[127:124] <= 4'h3;
		upper_row[123:120] <= nowm0[3:0];
		upper_row[119:116] <= 4'h3;
		upper_row[115:112] <= nowm1[3:0];
		upper_row[111:108] <= 4'h3;
		upper_row[107:104] <= 4'hA;
		upper_row[103:100] <= 4'h3;
		upper_row[99 :96 ] <= nows0[3:0];
		upper_row[95 :92 ] <= 4'h3;
		upper_row[91 :88 ] <= nows1[3:0];
	end
end

//managing lower row
always@(posedge clk or posedge rst)
begin
	if(rst) begin //Print all space
		lower_row[127:124] <= 4'h2;
		lower_row[123:120] <= 4'h0;
		lower_row[119:116] <= 4'h2;
		lower_row[115:112] <= 4'h0;
		lower_row[111:108] <= 4'h2;
		lower_row[107:104] <= 4'h0;
		lower_row[103:100] <= 4'h2;
		lower_row[99 :96 ] <= 4'h0;
		lower_row[95 :92 ] <= 4'h2;
		lower_row[91 :88 ] <= 4'h0;
		lower_row[87 :84 ] <= 4'h2;
		lower_row[83 :80 ] <= 4'h0;
		lower_row[79 :76 ] <= 4'h2;
		lower_row[75 :72 ] <= 4'h0;
		lower_row[71 :68 ] <= 4'h2;
		lower_row[67 :64 ] <= 4'h0;
		lower_row[63 :60 ] <= 4'h2;
		lower_row[59 :56 ] <= 4'h0;
		lower_row[55 :52 ] <= 4'h2;
		lower_row[51 :48 ] <= 4'h0;
		lower_row[47 :44 ] <= 4'h2;
		lower_row[43 :40 ] <= 4'h0;
		lower_row[39 :36 ] <= 4'h2;
		lower_row[35 :32 ] <= 4'h0;
		lower_row[31 :28 ] <= 4'h2;
		lower_row[27 :24 ] <= 4'h0;
		lower_row[23 :20 ] <= 4'h2;
		lower_row[19 :16 ] <= 4'h0;
		lower_row[15 :12 ] <= 4'h2;
		lower_row[11 :8  ] <= 4'h0;
		lower_row[7  :4  ] <= 4'h2;
		lower_row[3  :0  ] <= 4'h0;
	end //Print for the second row
	else if(current_state == RUN || current_state == FINISH || current_state == PAUSE) begin
		lower_row[127:124] <= 4'h5;
		lower_row[123:120] <= 4'h4;
		lower_row[119:116] <= 4'h4;
		lower_row[115:112] <= 4'h9;
		lower_row[111:108] <= 4'h4;
		lower_row[107:104] <= 4'hD;
		lower_row[103:100] <= 4'h4;
		lower_row[99 :96 ] <= 4'h5;
		lower_row[95 :92 ] <= 4'h2;
		lower_row[91 :88 ] <= 4'h0;
		lower_row[87 :84 ] <= 4'h3;
		lower_row[83 :80 ] <= tempm0[3:0];
		lower_row[79 :76 ] <= 4'h3;
		lower_row[75 :72 ] <= tempm1[3:0];
		lower_row[71 :68 ] <= 4'h3;
		lower_row[67 :64 ] <= 4'hA;
		lower_row[63 :60 ] <= 4'h3;
		lower_row[59 :56 ] <= temps0[3:0];
		lower_row[55 :52 ] <= 4'h3;
		lower_row[51 :48 ] <= temps1[3:0];
	end
	else begin //Print all space
		lower_row[127:124] <= 4'h2;
		lower_row[123:120] <= 4'h0;
		lower_row[119:116] <= 4'h2;
		lower_row[115:112] <= 4'h0;
		lower_row[111:108] <= 4'h2;
		lower_row[107:104] <= 4'h0;
		lower_row[103:100] <= 4'h2;
		lower_row[99 :96 ] <= 4'h0;
		lower_row[95 :92 ] <= 4'h2;
		lower_row[91 :88 ] <= 4'h0;
		lower_row[87 :84 ] <= 4'h2;
		lower_row[83 :80 ] <= 4'h0;
		lower_row[79 :76 ] <= 4'h2;
		lower_row[75 :72 ] <= 4'h0;
		lower_row[71 :68 ] <= 4'h2;
		lower_row[67 :64 ] <= 4'h0;
		lower_row[63 :60 ] <= 4'h2;
		lower_row[59 :56 ] <= 4'h0;
		lower_row[55 :52 ] <= 4'h2;
		lower_row[51 :48 ] <= 4'h0;
	end
end

//LCD module
lcd_module modules1(clk, rst, upper_row, lower_row, lcd_e, lcd_rs, lcd_rw, nibble);

//Calculating partition of timer using IP Core
wire [12:0] cable1, cable2, cable3, cable4;
//Timer partition
divider d1(.clk(clk),.dividend(timer),.divisor('d600),.quotient(tempm0),.fractional(cable1));
divider d2(.clk(clk),.dividend(cable1),.divisor('d60),.quotient(tempm1),.fractional(cable2));
divider d3(.clk(clk),.dividend(cable2),.divisor('d10),.quotient(temps0),.fractional(temps1));
//now partition
divider d4(.clk(clk),.dividend(now),.divisor('d600),.quotient(nowm0),.fractional(cable3));
divider d5(.clk(clk),.dividend(cable3),.divisor('d60),.quotient(nowm1),.fractional(cable4));
divider d6(.clk(clk),.dividend(cable4),.divisor('d10),.quotient(nows0),.fractional(nows1));

//Managing now
always@(posedge clk or posedge rst)
begin
	if(rst) now <= 0;
	//else if(current_state == FINISH) now <= 0;
	//else if(current_state == RUN && now == 0) now <= 0;
	else if(current_state == SET) now <= timer;
	else if(current_state == RUN && second == 1 && counter == 'd25000000) now <= now - 1'b1;
	else now <= now;
end

//Managing Timer
always@(posedge clk or posedge rst)
begin
	if(rst) timer <= 0;
	//If timer is inappropriate
	else if(timer > 'd5999) timer <= 0;
	//Increase and decrease is valid when state is SET
	else if(current_state == SET) begin
			//For increasing problem
			if(increase && counter == 'd1000000) begin
				if({min0, min1, sec0, sec1} == 4'b0001) timer <= timer + 1;
				else if({min0, min1, sec0, sec1} == 4'b0010) timer <= timer + 10;
				else if({min0, min1, sec0, sec1} == 4'b0100) timer <= timer + 60;
				else if({min0, min1, sec0, sec1} == 4'b1000) timer <= timer + 600;
				else timer <= timer;
			end
			//For decreasing problem
			else if(decrease && counter == 'd1000000) begin
				if({min0, min1, sec0, sec1} == 4'b0001) timer <= timer - 1;
				else if({min0, min1, sec0, sec1} == 4'b0010) timer <= timer - 10;
				else if({min0, min1, sec0, sec1} == 4'b0100) timer <= timer - 60;
				else if({min0, min1, sec0, sec1} == 4'b1000) timer <= timer - 600;
				else timer <= timer;
			end
			else timer <= timer;
	end
	else timer <= timer;
end

//Managing counter
always@(posedge clk or posedge rst)
begin
	if(rst) counter <= 0;
	else if(current_state == IDLE) counter <= 0;
	else if(current_state == SET && !(increase || decrease || start)) counter <= 0;
	else if(counter == 'd25000000) counter <= 0;
	else counter <= counter + 1;
end

//Managing second
always@(posedge clk or posedge rst)
begin
	if(rst) second <= 0;
	else if(current_state == IDLE || current_state == PAUSE) second <= 0;
	else if(counter == 'd25000000) second <= !second;
	else second <= second;
end

//Managing output blink
always@(posedge clk or posedge rst)
begin
	if(rst) out <= 0;
	else if(current_state == FINISH && second == 1) out <= 8'b11111111;
	else out <= 0;
end

endmodule

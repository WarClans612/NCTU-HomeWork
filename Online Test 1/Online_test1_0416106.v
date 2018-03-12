module Online_test1(	
	clk, 
	rst_n, 
	in_valid, 
	in,
	in_mode,
	out_valid, 
	out
);
				
//---------------------------------
//  input and output declaration
//---------------------------------  

input              clk;
input              rst_n;
input              in_valid;
input 	[15:0]     in;
input 	           in_mode;
output             out_valid;
output  [35:0]     out;

//---------------------------------
//   parameter declaration
//---------------------------------  


//----------------------------------
// reg and wire declaration
//--------------------------------- 

reg   [35:0]   max, min, diff; 
reg   [35:0]   out;
reg   [2:0]    in_count;
reg            in_finish;
reg            out_valid, modes;
reg   [15:0]   a0, a1, b0, b1;
wire  [3:0]    m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15;
wire signed   [17:0]    real_out0, imag_out0, real_out1, imag_out1, real_out2, imag_out2;
wire signed   [7:0]     real_a0, imag_a0, real_a1, imag_a1, real_b0, imag_b0, real_b1, imag_b1;
 

 //----------------------------------
//
//         My design
//
//----------------------------------

//in_count problem
always@(posedge clk)
begin
	if(rst_n) in_count <= 0;
	else if(in_valid && in_count == 3) in_count <= 0;
	else if(in_valid) in_count <= in_count + 1;
	else if(in_finish) in_count <= in_count + 1;
	else in_count <= 0;
end


//Mode input
always@(posedge clk)
begin
	if(in_valid && in_count == 0) modes <= in_mode;
	else modes <= modes;
end


//in_finish problem
always@(posedge clk)
begin
	if(rst_n) in_finish <= 0;
	else if(in_valid && in_count == 3) in_finish <= 1;
	else if(out_valid && in_count == 2) in_finish <= 0;
	else in_finish <= in_finish;
end

//Input problem
always@(posedge clk)
begin
	if(in_valid)
		case(in_count)
			2'b00: a0 <= in;
			2'b01: a1 <= in;
			2'b10: b0 <= in;
			2'b11: b1 <= in;
		default: begin
			a0 <= a0;
			a1 <= a1;
			b0 <= b0;
			b1 <= b1;
		end
		endcase
	else begin
		a0 <= a0;
		a1 <= a1;
		b0 <= b0;
		b1 <= b1;
	end
end

//Trying to break input into smaller pieces
assign real_a0 = a0[15:8];
assign imag_a0 = a0[7:0];
assign real_a1 = a1[15:8];
assign imag_a1 = a1[7:0];
assign real_b0 = b0[15:8];
assign imag_b0 = b0[7:0];
assign real_b1 = b1[15:8];
assign imag_b1 = b1[7:0];

//Generationg three output for mode 0 (zero)
assign real_out0 = real_a0*real_b0 + imag_a0*imag_b0;
assign imag_out0 = real_a0*imag_b0 - imag_a0*real_b0;
assign real_out1 = real_a0*real_b1 + imag_a0*imag_b1 + real_a1*real_b0 + imag_a1*imag_b0;
assign imag_out1 = real_a0*imag_b1 - imag_a0*real_b1 + real_a1*imag_b0 - imag_a1*real_b0;
assign real_out2 = real_a1*real_b1 + imag_a1*imag_b1;
assign imag_out2 = real_a1*imag_b1 - imag_a1*real_b1;

//Separating all data into small pieces for maximum and minimum problem
assign m0 = a0[15:12];
assign m1 = a0[11:8];
assign m2 = a0[7:4];
assign m3 = a0[3:0];
assign m4 = a1[15:12];
assign m5 = a1[11:8];
assign m6 = a1[7:4];
assign m7 = a1[3:0];
assign m8 = b0[15:12];
assign m9 = b0[11:8];
assign m10 = b0[7:4];
assign m11 = b0[3:0];
assign m12 = b1[15:12];
assign m13 = b1[11:8];
assign m14 = b1[7:4];
assign m15 = b1[3:0];

//Maximum
always@(*)
begin
	//if(in_valid)
	 if( m0>=m1 && m0>=m2 && m0>=m3 && m0>=m4 && m0>=m5 && m0>=m6 && m0>=m7 && m0>=m8 && m0>=m9 && m0>=m10 && m0>=m11 && m0>=m12 && m0>=m13 && m0>=m14 && m0>=m15) max <= m0;
	else if( m1>=m2 && m1>=m3 && m1>=m4 && m1>=m5 && m1>=m6 && m1>=m7 && m1>=m8 && m1>=m9 && m1>=m10 && m1>=m11 && m1>=m12 && m1>=m13 && m1>=m14 && m1>=m15) max <= m1;
	else if( m2>=m3 && m2>=m4 && m2>=m5 && m2>=m6 && m2>=m7 && m2>=m8 && m2>=m9 && m2>=m10 && m2>=m11 && m2>=m12 && m2>=m13 && m2>=m14 && m2>=m15) max <= m2;
	else if( m3>=m4 && m3>=m5 && m3>=m6 && m3>=m7 && m3>=m8 && m3>=m9 && m3>=m10 && m3>=m11 && m3>=m12 && m3>=m13 && m3>=m14 && m3>=m15) max <= m3;
	else if( m4>=m5 && m4>=m6 && m4>=m7 && m4>=m8 && m4>=m9 && m4>=m10 && m4>=m11 && m4>=m12 && m4>=m13 && m4>=m14 && m4>=m15) max <= m4;
	else if( m5>=m6 && m5>=m7 && m5>=m8 && m5>=m9 && m5>=m10 && m5>=m11 && m5>=m12 && m5>=m13 && m5>=m14 && m5>=m15) max <= m5;
	else if( m6>=m7 && m6>=m8 && m6>=m9 && m6>=m10 && m6>=m11 && m6>=m12 && m6>=m13 && m6>=m14 && m6>=m15) max <= m6;
	else if( m7>=m8 && m7>=m9 && m7>=m10 && m7>=m11 && m7>=m12 && m7>=m13 && m7>=m14 && m7>=m15) max <= m7;
	else if( m8>=m9 && m8>=m10 && m8>=m11 && m8>=m12 && m8>=m13 && m8>=m14 && m8>=m15) max <= m8;
	else if( m9>=m10 && m9>=m11 && m9>=m12 && m9>=m13 && m9>=m14 && m9>=m15) max <= m9;
	else if( m10>=m11 && m10>=m12 && m10>=m13 && m10>=m14 && m10>=m15) max <= m10;
	else if( m11>=m12 && m11>=m13 && m11>=m14 && m11>=m15) max <= m11;
	else if( m12>=m13 && m12>=m14 && m12>=m15) max <= m12;
	else if( m13>=m14 && m13>=m15) max <= m13;
	else if( m14>=m15) max <= m14;
	else max <= m15;
end

//Minimum problem
always@(*)
begin
        //if(in_valid)
         if( m0<=m1 && m0<=m2 && m0<=m3 && m0<=m4 && m0<=m5 && m0<=m6 && m0<=m7 && m0<=m8 && m0<=m9 && m0<=m10 && m0<=m11 && m0<=m12 && m0<=m13 && m0<=m14 && m0<=m15) min <= m0;
        else if( m1<=m2 && m1<=m3 && m1<=m4 && m1<=m5 && m1<=m6 && m1<=m7 && m1<=m8 && m1<=m9 && m1<=m10 && m1<=m11 && m1<=m12 && m1<=m13 && m1<=m14 && m1<=m15) min <= m1;
        else if( m2<=m3 && m2<=m4 && m2<=m5 && m2<=m6 && m2<=m7 && m2<=m8 && m2<=m9 && m2<=m10 && m2<=m11 && m2<=m12 && m2<=m13 && m2<=m14 && m2<=m15) min <= m2;
        else if( m3<=m4 && m3<=m5 && m3<=m6 && m3<=m7 && m3<=m8 && m3<=m9 && m3<=m10 && m3<=m11 && m3<=m12 && m3<=m13 && m3<=m14 && m3<=m15) min <= m3;
        else if( m4<=m5 && m4<=m6 && m4<=m7 && m4<=m8 && m4<=m9 && m4<=m10 && m4<=m11 && m4<=m12 && m4<=m13 && m4<=m14 && m4<=m15) min <= m4;
        else if( m5<=m6 && m5<=m7 && m5<=m8 && m5<=m9 && m5<=m10 && m5<=m11 && m5<=m12 && m5<=m13 && m5<=m14 && m5<=m15) min <= m5;
        else if( m6<=m7 && m6<=m8 && m6<=m9 && m6<=m10 && m6<=m11 && m6<=m12 && m6<=m13 && m6<=m14 && m6<=m15) min <= m6;
        else if( m7<=m8 && m7<=m9 && m7<=m10 && m7<=m11 && m7<=m12 && m7<=m13 && m7<=m14 && m7<=m15) min <= m7;
        else if( m8<=m9 && m8<=m10 && m8<=m11 && m8<=m12 && m8<=m13 && m8<=m14 && m8<=m15) min <= m8;
        else if( m9<=m10 && m9<=m11 && m9<=m12 && m9<=m13 && m9<=m14 && m9<=m15) min <= m9;
        else if( m10<=m11 && m10<=m12 && m10<=m13 && m10<=m14 && m10<=m15) min <= m10;
        else if( m11<=m12 && m11<=m13 && m11<=m14 && m11<=m15) min <= m11;
        else if( m12<=m13 && m12<=m14 && m12<=m15) min <= m12;
        else if( m13<=m14 && m13<=m15) min <= m13;
        else if( m14<=m15) min <= m14;
        else min <= m15;
end


//Output problem
always@(posedge clk)
begin
	if(rst_n) out <= 0;
	else if(in_finish) begin
		if(modes == 0)
		case(in_count)
			2'b00: out <= {real_out0, imag_out0};
			2'b01: out <= {real_out1, imag_out1};
			2'b10: out <= {real_out2, imag_out2};
		default: out <= 0;
		endcase
		else 
		case(in_count)
			2'b00: out <= max;
			2'b01: out <= min;
			2'b10: out <= (max - min);
		default: out <= 0;
		endcase
	end
	else out <= 0;
end

//Output vaild problem
always@(posedge clk)
begin
	if(rst_n) out_valid <= 0;
	else if(in_count == 3) out_valid <= 0;
	else if(in_finish && !in_valid) out_valid <= 1;
	else out_valid <= 0;
end


endmodule

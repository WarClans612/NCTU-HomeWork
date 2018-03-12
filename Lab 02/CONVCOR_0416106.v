module CONVCOR(	
	clk, 
	rst_n, 
	in_valid, 
	in_a,
	in_b,
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
input 	[15:0]     in_a;
input 	[15:0]     in_b;
input 	           in_mode;
output  reg        out_valid;
output  reg [35:0] out;


//----------------------------------
// reg and wire declaration
//--------------------------------- 
reg signed [7:0] real_a0, real_a1, real_a2, real_b0, real_b1, real_b2, imag_a0, imag_a1, imag_a2, imag_b0, imag_b1, imag_b2;
reg [2:0] in_count, out_count;
reg in_finish, out_ready, mode;

//---------------------------------
//         My design
//----------------------------------
                
always@ (negedge clk)
begin
	//Reseting all input and variable inside
	if(rst_n == 0) begin
		/*out_ready <= 0; out_valid <= 0; out <= 0;*/ in_count <= 0; /*out_count <= 0;*/ in_finish <= 0; mode <= 0;
		real_a0<=0; real_a1<=0; real_a2<=0; real_b0<=0; real_b1<=0; real_b2<=0; imag_a0<=0; imag_a1<=0; imag_a2<=0; imag_b0<=0; imag_b1<=0; imag_b2<=0;
	end
	
	//If input is valid, take input
	else if(in_valid) begin
		if(in_count == 0) begin
			real_a0 <= in_a[8+:8]; imag_a0 <= in_a[0+:8];
			real_b0 <= in_b[8+:8]; imag_b0 <= in_b[0+:8];
			//Mode only appear on first cycle
			mode <= in_mode;
			in_count <= in_count + 1;
		end
		else if(in_count == 1) begin
			real_a1 <= in_a[8+:8]; imag_a1 <= in_a[0+:8];
			real_b1 <= in_b[8+:8]; imag_b1 <= in_b[0+:8];
			in_count <= in_count + 1;
		end
		else if(in_count == 2) begin
			real_a2 <= in_a[8+:8]; imag_a2 <= in_a[0+:8];
			real_b2 <= in_b[8+:8]; imag_b2 <= in_b[0+:8];
			//Input has been ready to be calculate
			in_finish <= 1;
			in_count <= 0;
		end
	end
	//Resetting finish input
	if(out_ready) in_finish <= 0;
end

always@ (posedge clk)
begin
        //Reseting all input and variable inside
        if(rst_n == 0) begin
                out_ready <= 0; out_valid <= 0; out <= 0; out_count <= 0;
        end

	//Initializing output after input has been ready
	if(in_finish) begin
		//Input has been accepted
		//in_finish <= 0;
		out_ready <= 1;
		//COrrelation
		if(mode) out_count <= 1;
		//Convolution
		else out_count <= 5;
	end
	else if(out_ready && out_count > 0) begin
		out_valid <= 1;
		out_count <= out_count - 1;
		//Correlation
		if(mode) begin
			out[18+:18] <= ((real_a0 * real_b0) + (imag_a0 * imag_b0)) + ((real_a1 * real_b1) + (imag_a1 * imag_b1)) + ((real_a2 * real_b2) + (imag_a2 * imag_b2));
			out[0+:18] <= ((imag_a0 * real_b0) - (real_a0 * imag_b0)) + ((imag_a1 * real_b1) - (real_a1 * imag_b1)) + ((imag_a2 * real_b2) - (real_a2 * imag_b2));
		end
		//Convolution
		else begin
			if(out_count == 5) begin
				out[18+:18] <= ((real_a0 * real_b0) - (imag_a0 * imag_b0));
				out[0+:18] <= ((real_a0 * imag_b0) + (imag_a0 * real_b0));
			end
			else if(out_count == 4) begin
				out[18+:18] <= ((real_a0 * real_b1) - (imag_a0 * imag_b1)) + ((real_a1 * real_b0) - (imag_a1 * imag_b0));
				out[0+:18] <= ((real_a0 * imag_b1) + (imag_a0 * real_b1)) + ((real_a1 * imag_b0) + (imag_a1 * real_b0));
			end
			else if(out_count == 3) begin
				out[18+:18] <= ((real_a0 * real_b2) - (imag_a0 * imag_b2)) + ((real_a1 * real_b1) - (imag_a1 * imag_b1)) + ((real_a2 * real_b0) - (imag_a2 * imag_b0));
				out[0+:18] <= ((real_a0 * imag_b2) + (imag_a0 * real_b2)) + ((real_a1 * imag_b1) + (imag_a1 * real_b1)) + ((real_a2 * imag_b0) + (imag_a2 * real_b0));
			end
			else if(out_count == 2) begin
				out[18+:18] <= ((real_a1 * real_b2) - (imag_a1 * imag_b2)) + ((real_a2 * real_b1) - (imag_a2 * imag_b1));
				out[0+:18] <= ((real_a1 * imag_b2) + (imag_a1 * real_b2)) + ((real_a2 * imag_b1) + (imag_a2 * real_b1));	
			end
			else if(out_count == 1) begin
				out[18+:18] <= ((real_a2 * real_b2) - (imag_a2 * imag_b2));
				out[0+:18] <= ((real_a2 * imag_b2) + (imag_a2 * real_b2));
			end
		end
	end
	else if (out_count == 0) begin
		out_valid <= 0;
		out_ready <= 0;
		out <= 0;
	end
end



endmodule

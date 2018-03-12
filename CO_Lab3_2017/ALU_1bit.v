module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output wire result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 
  wire	a_choice, b_choice;
  wire	first, second, third;

  assign	a_choice = (invertA) ? ~a : a;
  assign	b_choice = (invertB) ? ~b : b;

  and	(first, a_choice, b_choice);
  or	(second, a_choice, b_choice);
  Full_adder 	adder(third, carryOut, carryIn, a_choice, b_choice);
  assign result = (operation == 2'b00) ? first : (operation == 2'b01) ? second : 
	(operation == 2'b10) ? third : less;
  
endmodule
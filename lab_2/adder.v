module adder(i_op1, i_op2, o_result);
input [29:0] i_op1, i_op2;
output [29:0] o_result;

assign o_result = i_op1 + i_op2;//we don't carry about ovfl, cause it's an address adder
  
endmodule
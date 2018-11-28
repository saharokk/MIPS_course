module alu(i_op1, i_op2, i_control, o_result, o_zf, o_ovfl);

localparam AND = 4'b0000, OR = 4'b0001, ADD = 4'b0010;
localparam SUB = 4'b0110, SOLT = 4'b0111, NOR = 4'b1100; //SOLT - Set On Less then
localparam MSB = 31;
  
input       [31:0]  i_op1, i_op2;
input       [3:0]   i_control;
output  reg [31:0]  o_result;
output              o_ovfl;
output              o_zf;

wire ex; //extra bit to indicate sign change
wire [31:0] adder_op2, add_rezult;

assign o_zf = ~| o_result;// NOR-reduction of all bits  

always@*
begin: ALU_OPS
    case (i_control)
        AND:    o_result =   i_op1 & i_op2;
        OR:     o_result =   i_op1 | i_op2;
        NOR:    o_result =   ~(i_op1 | i_op2);
        ADD, SUB:    o_result = add_rezult;
        SOLT:
            o_result = add_rezult[31] ^ o_ovfl;
    endcase
end

assign adder_op2 = (i_control == ADD) ? i_op2 : ~i_op2;
//SUB and SOLT have second bit set in their codes, so it would help to convert between two's complements, and to handle overflow,
//cause we do this in main add/sub statement
assign {ex, add_rezult} = {i_op1[MSB], i_op1} + {adder_op2[MSB], adder_op2} + i_control[2];
 
assign o_ovfl = ex ^ add_rezult[MSB];//overflow

endmodule
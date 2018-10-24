module aluControl(i_aluOp, i_func, o_aluControl);
 
input       [1:0]   i_aluOp;
input       [5:0]   i_func;
output  reg [3:0]   o_aluControl;

parameter R_type = 2'b10;
parameter LW_SW = 2'b00;
//parameter BR_EQ = 2'b01;

always@ *
begin
    if(i_aluOp == R_type)
    begin
        case(i_func)
            6'b100_000: o_aluControl = 4'b0010;//add
            6'b100_010: o_aluControl = 4'b0110;//sub
            6'b100_100: o_aluControl = 4'b0000;//and
            6'b100_101: o_aluControl = 4'b0001;//or
            6'b101_010: o_aluControl = 4'b0111;//SLT
            default: o_aluControl = 4'b0010;
        endcase        
    end
    else if(i_aluOp == LW_SW)
        o_aluControl = 4'b0010;
    else //Branch equal
        o_aluControl = 4'b0110;
end
endmodule
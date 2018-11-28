module nextPC(
    i_zero,
    i_jump,
    i_bne,
    i_beq,
    i_incPC,
    i_imm26,
    
    o_PCSrc,
    o_targ_addr
    
);

input    i_zero;
input    i_jump;
input    i_bne;
input    i_beq;
input [29:0]   i_incPC;
input [25:0]   i_imm26;
    
output    o_PCSrc;
output  [29:0]  o_targ_addr;

wire [29:0] add_addr;

assign add_addr = i_incPC + { {14{i_imm26[25]}} ,i_imm26[15:0] };

assign o_targ_addr = (i_jump) ? ({i_incPC[29:26] ,i_imm26}) : add_addr;

assign o_PCSrc = i_jump | (i_beq & i_zero) | (i_bne & ~i_zero);

endmodule
module scp_top(
    input i_clk,
    input i_rst_n
);//single cycle processor
wire [4:0] RW, 
           Rd, 
           Rt, 
           Rs;
           
wire [31:0] instr_code, 
            o_alu_mux,
            o_ram_mux,
//            i_wdata,
            o_rdata1,
            o_rdata2,
            o_extdata,
            o_alu_result,
            o_ram_data,
            i_alu_op1;
            
wire [29:0] i_pc,
            o_addr_result,
            o_pc,
            o_targ_addr;

wire o_regWrite,
    o_extOp,
    o_regDst,
    o_jump, 
    o_branch,
    o_memToReg,
    o_memWrite,
    o_aluSrc,
    o_memRead,
    o_zf,
    o_ovfl,
    o_bne,
    o_beq,
    o_PCSrc;
 
wire [1:0] o_aluOp;
 
wire [3:0] i_alu_control; 
                

//--------Instruction fetching datapath
pc pc(
    .i_clk(i_clk), 
    .i_rst_n(i_rst_n), 
    .i_pc(i_pc), 
    .o_pc(o_pc)
);

//address increment
adder adder(
    .i_op1(30'h1), 
    .i_op2(o_pc),
    .o_result(o_addr_result)
);



rom rom(
    .i_addr(o_pc[4:0]),
    .o_data(instr_code)
);

//rom initialisation
initial
begin
    $readmemh("rom_init.dat", rom.rom);
end
    
assign Rd = instr_code[15:11];
assign Rt = instr_code[20:16];
assign Rs = instr_code[25:21];



regFile registers(
   .i_clk(i_clk), 
   .i_raddr1(Rs), 
   .i_raddr2(Rt), 
   .i_waddr(RW), 
   .i_wdata(o_ram_mux), 
   .i_we(o_regWrite),
   .o_rdata1(o_rdata1),
   .o_rdata2(o_rdata2)     
);

signExtend signExtend(
    .i_data(instr_code[15:0]), 
    .o_data(o_extdata), 
    .control(o_extOp)
);

control control(
    .i_instrCode({instr_code[31:26], instr_code[5:0]}), 
    .o_regDst(o_regDst),
    .o_jump(o_jump), 
    .o_branch(o_branch),
    .o_memToReg(o_memToReg),
    .o_aluOp(o_aluOp),
    .o_memWrite(o_memWrite),
    .o_aluSrc(o_aluSrc),
    .o_regWrite(o_regWrite),
    .o_extOp(o_extOp),
    .o_memRead(o_memRead),
    .o_beq(o_beq),
    .o_bne(o_bne)
    );

assign RW = (o_regDst) ? Rd : Rt;

    
 aluControl aluCtrl(
    .i_aluOp(o_aluOp), 
    .i_func(instr_code[5:0]), 
    .o_aluControl(i_alu_control)
 );
 
 assign o_alu_mux = (o_aluSrc) ? o_extdata : o_rdata2;
 
assign i_alu_op1 = o_rdata1;
 
 alu alu(
    .i_op1(i_alu_op1), 
    .i_op2(o_alu_mux), 
    .i_control(i_alu_control), 
    .o_result(o_alu_result), 
    .o_zf(o_zf), 
    .o_ovfl(o_ovfl)
 );

ram ram(
    .i_clk(i_clk), 
    .i_addr(o_alu_result[4:0]), 
    .i_data(o_rdata2), 
    .i_we(o_memWrite), 
    .o_data(o_ram_data)
);

assign o_ram_mux = (o_memToReg) ? o_ram_data : o_alu_result;

nextPC nextPC(
    .i_zero(o_zf),
    .i_jump(o_jump),
    .i_bne(o_bne),
    .i_beq(o_beq),
    .i_incPC(o_addr_result),
    .i_imm26(instr_code[25:0]),
    
    .o_PCSrc(o_PCSrc),
    .o_targ_addr(o_targ_addr)

);
 assign i_pc = (o_PCSrc) ? o_targ_addr : o_addr_result;

 

endmodule
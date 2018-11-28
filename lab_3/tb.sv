`timescale 1 ns / 100 ps
module tb();
   reg  [11:0] i_instrCode;
   wire o_regDst;
   wire o_jump;
   wire o_branch;
   wire o_memToReg;
   wire [1:0] o_aluOp;
   wire o_memWrite;
   wire o_aluSrc;
   wire o_regWrite;
   wire o_memRead;
   
    control control(
        .i_instrCode(i_instrCode),
        .o_regDst(o_regDst),
        .o_jump(o_jump),
        .o_branch(o_branch),
        .o_memToReg(o_memToReg),
        .o_aluOp(o_aluOp),
        .o_memWrite(o_memWrite),
        .o_aluSrc(o_aluSrc),
        .o_regWrite(o_regWrite),
        .o_memRead(o_memRead)
    );
    reg [31:0] tb_rom [12:0];
    integer s_addr = 0;
    reg [31:0] instr;
    initial 
    begin
        $readmemh("rom_init.dat", tb_rom);
        do
        begin
        #5;
           instr = tb_rom[s_addr++];
           i_instrCode = {instr[31:26], instr[5:0]};
           
        #5;   
        end
        while(s_addr != 13);
        #10 $stop;
    end
endmodule
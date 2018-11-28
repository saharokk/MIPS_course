module control(i_instrCode, 
               o_regDst,
               o_jump, 
               o_branch,
               o_memToReg,
               o_aluOp,
               o_memWrite,
               o_aluSrc,
               o_regWrite,
               o_extOp,
               o_memRead,
               o_beq,
               o_bne
               );
  
  // {opcode[5:0], funct[5:0] } Whole opcode, and 6 LSBs of function(if exists)
input     [11:0]  i_instrCode;
output reg           o_regDst;
output reg           o_jump; 
output reg           o_branch;
output reg           o_memToReg;
output reg   [1:0]   o_aluOp;
output reg           o_memWrite;
output reg           o_aluSrc;
output reg           o_regWrite;
output reg           o_extOp;
output reg           o_memRead;
output reg           o_beq;
output reg           o_bne;
 
parameter BEQ = 12'b000_100_xxx_xxx, J = 12'b000_010_xxx_xxx, SW = 12'b101_011_xxx_xxx;
parameter LW = 12'b100_011_xxx_xxx, ADD = 12'b000_000_10_0000, SUB = 12'b000_000_10_0010;
parameter OR = 12'b000_000_10_0101, AND = 12'b000_000_01_0100, ADDU = 12'b000_000_01_0001;
parameter  SUBU = 12'b000_000_10_0011, ADDI = 12'b001_000_xxx_xxx, ADDIU = 12'b001_001_xxx_xxx;
parameter ANDI = 12'b001_100_xxx_xxx, XORI = 12'b001_110_xxx_xxx, ORI = 12'b001_101_xxx_xxx;
parameter BNE = 12'b000_101_xxx_xxx;

always @*
begin
    o_regDst = ~| i_instrCode[11:6]; //for all R-type
    o_jump = (i_instrCode[11:6] == J[11:6]) ? 1'b1 : 1'b0; 
    o_branch = 1'b0;
    o_memToReg = (i_instrCode[11:6] == LW[11:6]) ? 1'b1 : 1'b0;
    o_memRead = o_memToReg;
    o_memWrite = (i_instrCode[11:6] == SW[11:6]) ? 1'b1 : 1'b0;
    
    o_aluSrc = (i_instrCode[11:6] == 6'b000_000  || i_instrCode[11:6] == BEQ[11:6]) ? 1'b0 : 1'b1;
    o_regWrite = (i_instrCode[11:6] == SW[11:6] || i_instrCode[11:6] == BEQ[11:6] || i_instrCode[11:6] == J[11:6]) ? 1'b0 : 1'b1;
    o_extOp = (i_instrCode[11:6] == ANDI[11:6] || i_instrCode[11:6] == ORI[11:6] || i_instrCode[11:6] == XORI[11:6]) ? 1'b0 : 1'b1;
    
    o_beq = (i_instrCode[11:6] == BEQ[11:6]);
    o_bne = (i_instrCode[11:6] == BNE[11:6]);
    
    
    case (i_instrCode[11:6])
        BEQ[11:6]: o_aluOp = 2'b01;//SUB
        ADDI[11:6], LW[11:6], SW[11:6]: o_aluOp = 2'b00;//ADD
        6'b000_000: o_aluOp = 2'b10;//for r-type ops
        default: o_aluOp = 2'b00;
    endcase
end 


endmodule
module control(i_instrCode, 
               o_regDst,
               o_jump, 
               o_branch,
               o_memToReg,
               o_aluOp,
               o_memWrite,
               o_aluSrc,
               o_regWrite,
//               o_extOp,
               o_memRead
               );
  
  // {opcode[5:0], funct[3:0] } Whole opcode, and 4 LSBs of function
input     [11:0]  i_instrCode;
output reg           o_regDst;
output reg           o_jump; 
output reg           o_branch;
output reg           o_memToReg;
output reg   [1:0]   o_aluOp;
output reg           o_memWrite;
output reg           o_aluSrc;
output reg           o_regWrite;
//output            o_extOp;
output reg           o_memRead;

parameter BEQ = 12'b000_100_xxx_xxx, J = 12'b000_010_xxx_xxx, SW = 12'b101_011_xxx_xxx;
parameter LW = 12'b100_011_xxx_xxx, ADD = 12'b000_000_10_0000, SUB = 12'b000_000_10_0010;
parameter OR = 12'b000_000_10_0101, AND = 12'b000_000_01_0100, ADDU = 12'b000_000_01_0001;
parameter  SUBU = 12'b000_000_10_0011, ADDI = 12'b001_000_xxx_xxx, ADDIU = 12'b001_001_xxx_xxx;

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
//    o_extOp = (i_instrCode == A || i_instrCode == BEQ || i_instrCode == J) ? 1'b0 : 1'b1;
    
    case (i_instrCode[11:6])
        BEQ[11:6]: o_aluOp = 4'b0010;//SUB
        ADDI[11:6], LW[11:6], SW[11:6]: o_aluOp = 4'b0000;//ADD
        6'b000_000: o_aluOp = i_instrCode[3:0];//for r-type ops
        default: o_aluOp = 4'b0000;
    endcase
end 


endmodule
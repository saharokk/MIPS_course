
module regFile(i_clk, 
               i_raddr1, 
               i_raddr2, 
               i_waddr, 
               i_wdata, 
               i_we,
               o_rdata1,
               o_rdata2 
               );
               
input           i_clk, i_we;
input  [4:0]   i_raddr1, i_raddr2, i_waddr;
input   [31:0]  i_wdata;           
output reg [31:0]  o_rdata1, o_rdata2;

reg [31:0] MEM [31:0];

always@(posedge i_clk)
begin:READ_FROM_MEM
    o_rdata1 <= MEM[i_raddr1];
    o_rdata2 <= MEM[i_raddr2];
end

always@(posedge i_clk)
begin:WRITE_TO_MEM
    if(i_we)
        MEM[i_waddr] <= i_wdata;
end
  
endmodule
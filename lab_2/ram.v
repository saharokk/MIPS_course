module ram(i_clk, i_addr, i_data, i_we, o_data);
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 5; //32 4-byte words 

input                     i_clk, i_we;
input   [ADDR_WIDTH-1:0]  i_addr;
input   [DATA_WIDTH-1:0]  i_data;
output reg [DATA_WIDTH-1:0]  o_data;

reg [DATA_WIDTH-1: 0] ram [(1 << ADDR_WIDTH)-1: 0];

//write to mem entity
always@(posedge i_clk)
begin
    if(i_we)
        ram[i_addr] = i_data;
end
    
//read from mem entity  

always@*
begin
    if(!i_we)
        o_data = ram[i_addr];
end

endmodule
`timescale 1ns/10ps

module tb_top();

reg i_clk, 
    i_rst_n;

scp_top proc(
    .i_clk(i_clk),
    .i_rst_n(i_rst_n)
);


initial
begin
    i_rst_n = 0;
    @(posedge i_clk)
    #2 i_rst_n = 1;
end

//clocking 
initial
begin
    i_clk = 0;
        forever    
        #10 i_clk = ~i_clk;
end 
 
initial
#400 $stop;
 
endmodule
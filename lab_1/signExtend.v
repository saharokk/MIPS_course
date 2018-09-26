module signExtend(i_data, o_data, control);
input   [15:0]  i_data;
input   control;
output  [31:0]  o_data;

    assign o_data = control ? { {16{i_data[15]}} ,i_data } : { 16'b0000_0000_0000_0000, i_data };
endmodule
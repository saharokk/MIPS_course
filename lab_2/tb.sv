`timescale 1ns / 10ps;

module  tb();

//----------------------ADDER-------------------
reg [31:0] i_op1, i_op2;
wire [31:0] o_result;

adder adder(
    .i_op1(i_op1),
    .i_op2(i_op2), 
    .o_result(o_result)
);

initial begin
    repeat(300)
    begin
        i_op1 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        i_op2 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        #1 assert (o_result == (i_op1 + i_op2))
        else
            $error("Adder assertion failed at %t", $time);

    end
end
//----------------------ALU----------------------

integer alu_i_op1, alu_i_op2;
reg [31:0] alu_o_result;
reg [3:0] i_control;
wire o_zf, o_ovfl;
integer check;

alu alu(
    .i_op1(alu_i_op1), 
    .i_op2(alu_i_op2), 
    .i_control(i_control), 
    .o_result(alu_o_result), 
    .o_zf(o_zf), 
    .o_ovfl(o_ovfl)
);

initial begin
    i_control = 4'b0010;//add
    repeat(300)
    begin
        alu_i_op1 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        alu_i_op2 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        check = alu_i_op1 + alu_i_op2;
        #10;
        assert (alu_o_result == check)
        else
            $error("ALU ADD assertion failed at %t", $time);
    end
    #5;
    alu_i_op1 = 32'h7FFF_FFFF;
    alu_i_op2 = 32'h7FFF_FFFF;
    check = alu_i_op1 + alu_i_op2;

    assert (alu_o_result == check)
    else
        $error("ALU ADD assertion failed at %t", $time);
    #5;
    
    i_control = 4'b0110;//sub
    repeat(300)
    begin
        alu_i_op1 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        alu_i_op2 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        check = alu_i_op1 - alu_i_op2;

        #5;
        assert (alu_o_result == check)
        else
            $error("ALU SUB assertion failed at %t", $time);
        #5;
    end
    
    i_control = 4'b0001;//OR
    repeat(300)
    begin
        alu_i_op1 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        alu_i_op2 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        check = alu_i_op1 | alu_i_op2;
        #5;
        assert (alu_o_result == check)
        else
            $error("ALU OR assertion failed at %t", $time);
        #5;
    end    
    
    i_control = 4'b0111;//SOLT
    repeat(300)
    begin
        alu_i_op1 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        alu_i_op2 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        check = & $signed(alu_i_op1 < alu_i_op2);//and reduction

        #5;;
        assert (alu_o_result == check)
        else
            $error("ALU SOLT assertion failed at %t", $time);
        #5;
    end
    
    i_control = 4'b0000;//and
    repeat(300)
    begin
        alu_i_op1 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        alu_i_op2 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        check = alu_i_op1 & alu_i_op2;
        #5;
        assert (alu_o_result == check)
        else
            $error("ALU AND assertion failed at %t", $time);
        #5;
    end
    
    i_control = 4'b1100;//nor
    repeat(300)
    begin
        alu_i_op1 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        alu_i_op2 = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        check = ~(alu_i_op1 | alu_i_op2);
        #5;
        assert (alu_o_result == check)
        else
            $error("ALU NOR assertion failed at %t", $time);
        #5;
    end
    $stop;
    
end

//concurrent assertions
property o_zflag;
  @(negedge i_clk) 
      !alu_o_result |-> o_zf;
endproperty

o_zflag_assertion: assert property(o_zflag)
    else
        $error("Zero flag assertion failed at %t", $time);

//----------------------ALU control----------------------
reg [1:0] i_aluOp;
reg [5:0] i_func;
wire [3:0] o_aluControl;

aluControl aluControl(
    .i_aluOp(i_aluOp), 
    .i_func(i_func), 
    .o_aluControl(o_aluControl)
);

initial
begin
    i_aluOp = 2'b00;//LW_SW
    #20
    i_aluOp = 2'b01;//Branch equal
    #20
    i_aluOp = 2'b10;//R-type
    
    i_func = 6'b100_000;//ADD
    #20
    assert (o_aluControl == 4'b0010)
    else
        $error("ALU Control assertion failed at %t", $time);
    
    i_func = 6'b100_010;//SUB
    #20
    assert (o_aluControl == 4'b0110)
    else
        $error("ALU Control assertion failed at %t", $time);
    
    i_func = 6'b100_100;//AND
    #20
    assert (o_aluControl == 4'b0000)
    else
        $error("ALU Control assertion failed at %t", $time);
    
    i_func = 6'b100_101;//OR
    #20
    assert (o_aluControl == 4'b0001)
    else
        $error("ALU Control assertion failed at %t", $time);
    
    i_func = 6'b101_010;//SLT
    #20
    assert (o_aluControl == 4'b0111)
    else
        $error("ALU Control assertion failed at %t", $time);
end
//concurrent assertions
property lw_sw;
  @(negedge i_clk) 
      (i_aluOp == 2'b00) |-> (o_aluControl == 4'b0010);
endproperty

lw_sw_assertion: assert property(lw_sw)
    else
        $error("ALU control uint assertion failed at %t", $time);

        
property br_eq;
  @(negedge i_clk) 
      (i_aluOp == 2'b01) |-> (o_aluControl == 4'b0110);
endproperty

br_eq_assertion: assert property(br_eq)
    else
        $error("ALU control uint assertion failed at %t", $time);

//----------------------ROM----------------------

reg [7:0] rom_i_addr;
wire [31:0] rom_o_data;
reg [31:0] tb_rom [12:0];
bit [7:0] s_addr;


rom #(32, 8) rom(
    .i_addr(rom_i_addr),
    .o_data(rom_o_data)
);

initial
begin
    $readmemh("rom_init.dat", rom.rom);
    $readmemh("rom_init.dat", tb_rom);
    s_addr = 0;
    do
    begin
        rom_i_addr = s_addr;
        #1 assert (rom_o_data == tb_rom[s_addr++])
        else
            $error("ROM check assertion failed at %t", $time);
    end
    while(s_addr != 13);
end
//----------------------RAM----------------------
reg i_clk, i_we;
wire [4:0] ram_i_addr;
reg [31:0] ram_i_data;
wire [31:0] ram_o_data;
integer tb_ram_addr = 0;

ram ram(
    .i_clk(i_clk),
    .i_addr(ram_i_addr),
    .i_data(ram_i_data),
    .i_we(i_we),
    .o_data(ram_o_data)
);

assign ram_i_addr = tb_ram_addr;
initial
begin
    
    i_we = 1'b1;
    do 
    begin 
        ram_i_data = $urandom_range(32'h0000_0000, 32'hFFFF_FFFF);
        @(posedge i_clk);
         tb_ram_addr++;
    end
    while(tb_ram_addr != 32);
    i_we = 0;
    tb_ram_addr = 0;
    do
        begin 
            @(posedge i_clk);
            tb_ram_addr++;
        end
    while(tb_ram_addr != 32);
end
//----------------------clocking----------------------
initial
begin
i_clk = 0;
    forever    
    #10 i_clk = ~i_clk;
end
//initial #10000 $stop;
endmodule

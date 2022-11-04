`timescale 1us/1ns
module ALU_TOP_tb #(
    parameter width = 16
) ();
reg [7:0]     A_tb,B_tb;
reg [3:0]           ALU_FUN_tb;
reg                 CLK_tb,RST_tb, Enable_tb;
reg [2:0]          x;
wire [width-1:0]    ALU_OUT_tb;
wire                 OUT_VALID_tb;
//integer          x;

initial 
begin
A_tb = 'b0101110110;
B_tb = 'b0101110110;
Enable_tb = 1'b1;
ALU_FUN_tb = 4'b0000;
CLK_tb = 0;
x=4;
RST_tb = 1;
#5
RST_tb = 0;
#7
RST_tb = 1;
for (ALU_FUN_tb = 4'b0000; ALU_FUN_tb<15; ALU_FUN_tb = ALU_FUN_tb+1 ) 
begin
    #10
    $display("ALU_FUN: %d, ALU_OUT_tb: %d",ALU_FUN_tb,ALU_OUT_tb);
    $display(" OUT_VALID_tb: %d\n", OUT_VALID_tb);
end
#10
    $display("ALU_FUN: %d, ALU_OUT_tb: %d",ALU_FUN_tb,ALU_OUT_tb);
    $display(" OUT_VALID_tb: %d\n", OUT_VALID_tb);


#20
$stop;

    
end

always #x 
begin
    CLK_tb = ~CLK_tb;
    x=10-x;
end
//always 
ALU #(.Width(width)) U6 (
     .A(A_tb),
     .B(B_tb),
     .ALU_FUN(ALU_FUN_tb),
     .CLK(CLK_tb),
     .RST(RST_tb),
     .Enable(Enable_tb),
     .ALU_OUT(ALU_OUT_tb),
     .OUT_VALID(OUT_VALID_tb)
);

    
endmodule
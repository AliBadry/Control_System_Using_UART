`include "/ALU/Arithmatic_Unit.v"
`include "/ALU/CMP_Unit.v"
`include "/ALU/Decoder2X4_ALU_OUT.v"
`include "/ALU/Decoder2X4.v"
`include "/ALU/Logic_Unit.v"
`include "/ALU/OR_Gate.v"
`include "/ALU/Shift_Unit.v"


module ALU
#(parameter Width = 16)
 (
    input wire [7:0]  A,B,
    input wire [3:0]        ALU_FUN,
    input wire              CLK, RST, Enable,
    output  [Width-1:0]  ALU_OUT,
    output  wire              OUT_VALID
);

wire [Width-1:0] Arith_OUT,Logic_OUT,CMP_OUT,Shift_OUT;
wire Arith_Enable,Logic_Enable,CMP_Enable,Shift_Enable;
wire Arith_Flag,Logic_Flag,CMP_Flag,Shift_Flag ,Carry_OUT;
    
Decoder2X4 U1 ( .ALU_FUN(ALU_FUN[3:2]),
                .Arith_Enable(Arith_Enable),
                .Logic_Enable(Logic_Enable),
                .CMP_Enable(CMP_Enable),
                .Enable(Enable),
                .Shift_Enable(Shift_Enable));

Decoder2X4_ALU_OUT #(.Width(Width))  U7 
            (   .ALU_FUN(ALU_FUN[3:2]),
                .Arith_OUT(Arith_OUT),
                .Logic_OUT(Logic_OUT),
                .CMP_OUT(CMP_OUT),
                .Shift_OUT(Shift_OUT),
                .ALU_OUT(ALU_OUT));

Arithmatic_Unit #(.Width(Width)) U2 
            (   .A(A),
                .B(B),
                .ALU_FUN(ALU_FUN[1:0]),
                .CLK(CLK),
                .RST(RST),
                .Arith_Enable(Arith_Enable),
                .Arith_OUT(Arith_OUT),
                .Carry_OUT(Carry_OUT),
                .Arith_Flag(Arith_Flag));

Logic_Unit #(.Width(Width)) U3 
            (   .A(A),
                .B(B),
                .ALU_FUN(ALU_FUN[1:0]),
                .CLK(CLK),
                .RST(RST),
                .Logic_Enable(Logic_Enable),
                .Logic_OUT(Logic_OUT),
                .Logic_Flag(Logic_Flag));

CMP_Unit #(.Width(Width)) U4 
            (   .A(A),
                .B(B),
                .ALU_FUN(ALU_FUN[1:0]),
                .CLK(CLK),
                .RST(RST),
                .CMP_Enable(CMP_Enable),
                .CMP_OUT(CMP_OUT),
                .CMP_Flag(CMP_Flag));

Shift_Unit #(.Width(Width)) U5 
            (   .A(A),
                .B(B),
                .ALU_FUN(ALU_FUN[1:0]),
                .CLK(CLK),
                .RST(RST),
                .Shift_Enable(Shift_Enable),
                .Shift_OUT(Shift_OUT),
                .Shift_Flag(Shift_Flag));

OR_Gate U6 (    .Arith_Flag(Arith_Flag),
                .Logic_Flag(Logic_Flag),
                .CMP_Flag(CMP_Flag),
                .Shift_Flag(Shift_Flag),
                .OUT_VALID(OUT_VALID));

endmodule
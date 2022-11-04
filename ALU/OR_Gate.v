module OR_Gate (
    input wire Arith_Flag,Logic_Flag,CMP_Flag,Shift_Flag,
    output reg OUT_VALID
);

always @(*) 
begin
    OUT_VALID =  (Arith_Flag | Logic_Flag | CMP_Flag | Shift_Flag);
end
endmodule
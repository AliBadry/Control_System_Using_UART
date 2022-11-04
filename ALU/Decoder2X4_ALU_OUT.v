module Decoder2X4_ALU_OUT
#(parameter Width = 16) 
 (
    input wire [1:0]    ALU_FUN,
    input wire [Width-1:0] Arith_OUT, Logic_OUT, CMP_OUT, Shift_OUT,
    output reg  [Width-1:0]        ALU_OUT
);
    
always @(*) 
begin
    ALU_OUT = 'b0;
    case (ALU_FUN)
        2'b00: ALU_OUT = Arith_OUT;
        2'b01: ALU_OUT = Logic_OUT;
        2'b10: ALU_OUT = CMP_OUT;
        2'b11: ALU_OUT = Shift_OUT; 
        default: 
        begin
            ALU_OUT = 'b0;
        end
    endcase
end

endmodule
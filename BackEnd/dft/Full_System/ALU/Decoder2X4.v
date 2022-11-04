module Decoder2X4
#(parameter Width = 1) 
(
    input wire Enable,
    input wire [1:0]    ALU_FUN,
    output reg [Width-1:0]         Arith_Enable,Logic_Enable,CMP_Enable,Shift_Enable
);
    
always @(*) 
begin
    Arith_Enable = 1'b0;
    Logic_Enable = 1'b0;
    CMP_Enable = 1'b0;
    Shift_Enable = 1'b0;
    if(Enable)
    begin
       case (ALU_FUN)
        2'b00: Arith_Enable = 1'b1;
        2'b01: Logic_Enable = 1'b1;
        2'b10: CMP_Enable = 1'b1;
        2'b11: Shift_Enable = 1'b1; 
        default: 
        begin
            Arith_Enable = 1'b0;
            Logic_Enable = 1'b0;
            CMP_Enable = 1'b0;
            Shift_Enable = 1'b0;
        end
    endcase 
    end
    else
    begin
        Arith_Enable = 1'b0;
        Logic_Enable = 1'b0;
        CMP_Enable = 1'b0;
        Shift_Enable = 1'b0;
    end
end

endmodule
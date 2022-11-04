module Shift_Unit #(
    parameter Width=16
) (
    input wire [7:0]  A,B,
    input wire [1:0]        ALU_FUN,
    input wire              CLK,RST,Shift_Enable,
    output reg [Width-1:0]  Shift_OUT,
    output reg              Shift_Flag 
);

reg [Width-1:0] Shift_OUT_Comb;

always @(*) 
begin
    Shift_OUT_Comb = 0;
    case (ALU_FUN)
        2'b00:
            begin
                Shift_OUT_Comb = A>>1;
            end
        2'b01:
            begin
                Shift_OUT_Comb = A<<1;
            end
        2'b10:
            begin
                Shift_OUT_Comb = B>>1;
            end
        2'b11:
            begin
                Shift_OUT_Comb = B<<1;
            end
        
        default: Shift_OUT_Comb = 0;
    endcase    
end

always @(posedge CLK or negedge RST) 
begin
if (!RST) 
    begin
        Shift_OUT <= 0;
        Shift_Flag <= 1'b0;
    end
    else if (Shift_Enable)
    begin
        Shift_OUT <= Shift_OUT_Comb;
        Shift_Flag <= 1'b1;
    end
    else
    begin
        Shift_OUT <= 0;
        Shift_Flag <= 1'b0;
    end

end
    
endmodule
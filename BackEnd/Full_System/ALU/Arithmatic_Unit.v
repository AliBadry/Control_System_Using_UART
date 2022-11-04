module Arithmatic_Unit #(
    parameter Width = 16
) (
    input wire [7:0]  A,B,
    input wire [1:0]        ALU_FUN,
    input wire              CLK,RST,Arith_Enable,
    output reg [Width-1:0]  Arith_OUT,
    output reg              Carry_OUT,Arith_Flag
);

reg [Width-1:0] Arith_OUT_Comb;
reg             Carry_OUT_Comb;

always @(*) 
begin
    {Carry_OUT_Comb, Arith_OUT_Comb} = 0;
    case (ALU_FUN)
        2'b00: 
        begin
            Arith_OUT_Comb = A+B;
            Carry_OUT_Comb = Arith_OUT_Comb[Width];
        end
        2'b01: 
        begin
             Arith_OUT_Comb = A-B;
             Carry_OUT_Comb = Arith_OUT_Comb[Width];
        end
        2'b10: 
        begin
             Arith_OUT_Comb = A*B;
             Carry_OUT_Comb = Arith_OUT_Comb[Width];
        end
        2'b11: 
        begin
             Arith_OUT_Comb = A/B;
             Carry_OUT_Comb = Arith_OUT_Comb[Width];
        end
        default: 
        begin
            Arith_OUT_Comb = 0;
            Carry_OUT_Comb = Arith_OUT_Comb[Width];
        end
    endcase
    
end

always @(posedge CLK or negedge RST) 
begin
    if (!RST) 
    begin
        Arith_OUT <= 0;
        Carry_OUT <= 0;
        Arith_Flag <= 1'b0;
    end
    else if (Arith_Enable)
    begin
        Arith_OUT <= Arith_OUT_Comb;
        Carry_OUT <= Carry_OUT_Comb;
        Arith_Flag <= 1'b1;
    end
    else
    begin
        Arith_OUT <= Arith_OUT_Comb;
        Carry_OUT <= Carry_OUT_Comb;
        Arith_Flag <= 1'b0;
    end
end
    
endmodule
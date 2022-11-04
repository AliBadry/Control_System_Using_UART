module Logic_Unit #(
    parameter Width = 16
) (
    input wire [7:0]  A,B,
    input wire [1:0]        ALU_FUN,
    input wire              CLK,Logic_Enable,RST,
    output reg [Width-1:0]  Logic_OUT,
    output reg              Logic_Flag
);

reg [Width-1:0] Logic_OUT_Comb;

always @(*) 
begin
    Logic_OUT_Comb = 0;
    case (ALU_FUN)
        2'b00:
            begin
                Logic_OUT_Comb = A & B;
            end 
        2'b01:
            begin
                Logic_OUT_Comb = A | B;
            end
        2'b10:
            begin
                Logic_OUT_Comb = ~(A & B);
            end
        2'b11:
            begin
                Logic_OUT_Comb = ~(A | B);
            end 
        default: 
            begin
                Logic_OUT_Comb = 0;
            end
    endcase    
end

always @(posedge CLK or negedge RST) 
begin
    if (!RST) 
    begin
        Logic_OUT <= 0;
        Logic_Flag <= 1'b0;
    end
    else if (Logic_Enable)
    begin
        Logic_OUT <= Logic_OUT_Comb;
        Logic_Flag <= 1'b1;
    end
    else
    begin
        Logic_OUT <= 0;
        Logic_Flag <= 1'b0;
    end    
end
    
endmodule
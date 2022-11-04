module CMP_Unit #(
    parameter Width = 16
) (
    input wire [7:0]  A,B,
    input wire [1:0]        ALU_FUN,
    input wire              CMP_Enable,CLK,RST,
    output reg [Width-1:0]  CMP_OUT,
    output reg              CMP_Flag
);
    
reg [Width-1:0] CMP_OUT_Comb;

always @(*) 
begin
    CMP_OUT_Comb = 0;
    case (ALU_FUN)
        2'b00: 
            begin
                CMP_OUT_Comb = 0;
            end
        2'b01:
            begin
                CMP_OUT_Comb = (A==B)? 1:0;
            end
        2'b10:
            begin
                CMP_OUT_Comb = (A>B)? 2:0;
            end
        2'b11:
            begin
                CMP_OUT_Comb = (A<B)? 3:0;
            end
        default: CMP_OUT_Comb = 0;
    endcase
end

always @(posedge CLK or negedge RST) 
begin
    if (!RST) 
    begin
        CMP_OUT <= 0;
        CMP_Flag <= 1'b0;
    end
    else if (CMP_Enable)
    begin
        CMP_OUT <= CMP_OUT_Comb;
        CMP_Flag <= 1'b1;
    end
    else
    begin
        CMP_OUT <= 0;
        CMP_Flag <= 1'b0;
    end    


end

endmodule
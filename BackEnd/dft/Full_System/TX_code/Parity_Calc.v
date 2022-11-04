module Parity_Calc (
    input wire [7:0]    P_DATA,
    input wire  Data_Valid, PAR_TYP, CLK, RST,
    output reg par_bit
);

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        par_bit <= 1'b0;
    end
    else if (Data_Valid)
        begin
            if (PAR_TYP) 
                begin
                    par_bit <= (~^P_DATA);
                end
            else
                begin
                    par_bit <= ^P_DATA;
                end
        end
end
    
endmodule
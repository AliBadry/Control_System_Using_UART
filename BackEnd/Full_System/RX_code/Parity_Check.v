module Parity_Check (
    input wire par_chk_en, PAR_TYP, sampled_bit,
    input wire [7:0]    P_DATA,
    input wire [2:0]    edge_cnt,
    input wire [3:0]    bit_cnt,
    input wire CLK, RST,
    output reg par_err
);

reg check, par_err_c;


//parity_typ = 0 for even
//parity_typ = 1 for odd


always @(*) 
begin
    if(par_chk_en)
    begin
        case (PAR_TYP)
            1'b0:
            begin
                check = ^P_DATA;
                par_err_c = (check == sampled_bit)?1'b0:1'b1;
            end 
            1'b1:
            begin
                check = ~^P_DATA;
                par_err_c = (check == sampled_bit)?1'b0:1'b1;
            end
            default: par_err_c = 1'b0;
        endcase
    end    
    else
    begin
        par_err_c = 1'b0;
    end
end

always @(posedge CLK or negedge RST) 
begin
    if (!RST) 
    begin
            par_err <= 1'b0;
    end
    else if((edge_cnt == 3'b111) && (bit_cnt == 4'b1001))
    begin
        par_err <= par_err_c;
    end
    else if (bit_cnt == 4'b0000)
    begin
        par_err <= 1'b0;
    end
end
endmodule
module Stop_Check (
    input wire stp_chk_en, sampled_bit,
    input wire [2:0]    edge_cnt,
    output reg stp_err
);
    
    reg stp_err_c;

    always @(*) 
    begin
        if (stp_chk_en) 
        begin
            if (sampled_bit) 
            begin
                stp_err_c = 1'b0;    
            end    
            else
            begin
                stp_err_c = 1'b1;
            end
        end
        else
        begin
            stp_err_c = 1'b0;
        end
    end


always @(*) 
begin
    if(edge_cnt == 3'b111)
    begin
        stp_err = stp_err_c;
    end
    else
    begin
        stp_err = 1'b0;
    end
end

endmodule
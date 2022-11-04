module Start_Check (
    input wire  strt_chk_en, sampled_bit,
    input wire [2:0]    edge_cnt,
    output reg strt_glitch
);

reg strt_glitch_c;

always @(*) 
begin
    if (strt_chk_en) 
    begin
        if (sampled_bit) 
        begin
            strt_glitch_c = 1'b1;
        end    
        else
        begin
            strt_glitch_c = 1'b0;
        end
    end
    else
    begin
        strt_glitch_c = 1'b0;
    end
end

always @(*) 
begin
    if (edge_cnt == 3'b111) 
    begin
        strt_glitch = strt_glitch_c;
    end    
    else
    begin
        strt_glitch = 1'b0;
    end
end
    
endmodule
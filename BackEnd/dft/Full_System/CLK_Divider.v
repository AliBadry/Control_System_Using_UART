//This clock divider works as a divider if the enable is high 
//as well as the dividing ratio is not 1 or 0, else the output
//will be the reference input clock
module CLK_Divider (
    input wire i_ref_clk, i_rst_n, i_clk_en,
    input wire [4:0] i_div_ratio,
    output reg o_div_clk
);

reg [5:0] Counter, Duty;
reg out_seq;

always @ (posedge i_ref_clk or negedge i_rst_n)
begin
    if(!i_rst_n)
    begin
        Duty <= i_div_ratio >> 1;
        out_seq <= 1'b0;
        Counter <= 5'b1;
    end
    else if(i_clk_en && (Counter == Duty) && i_div_ratio != 5'b0 && i_div_ratio != 5'b1)
    begin
        out_seq <= ! out_seq;
        Counter <= 5'b1;
        Duty <= i_div_ratio - Duty;
    end
    else if(i_clk_en && i_div_ratio != 5'b0 && i_div_ratio != 5'b1)
    begin
        Counter <= Counter + 1;
    end

end

//Block to choose the refernce as an output or the divider.
always @(*) 
begin
    if (!i_clk_en || i_div_ratio == 5'b0 || i_div_ratio == 5'b1)
    begin
        o_div_clk = i_ref_clk;
    end
    else
    begin
        o_div_clk = out_seq;
    end
end

//to update the duty cycle when the ratio changes
/*always @(*) 
begin
    Duty = i_div_ratio >> 1;
end*/

endmodule
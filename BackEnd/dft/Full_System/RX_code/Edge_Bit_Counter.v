module Edge_Bit_Counter (
    input wire cnt_en, CLK, RST,
    output reg [2:0]    edge_cnt,
    output reg [3:0]    bit_cnt
);
    
always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        edge_cnt <= 3'b0;
    end
    else if(!cnt_en)
    begin
        edge_cnt <= 3'b0;
    end
    else if(cnt_en)
    begin
        edge_cnt <= edge_cnt+ 1'b1;
    end
end

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        bit_cnt <= 4'b0;
    end    
    else if(!cnt_en)
    begin
        bit_cnt <= 4'b0;
    end
    else if(edge_cnt == 3'b111)
    begin
        bit_cnt <= bit_cnt+1'b1;
    end
end


endmodule
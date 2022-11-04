module Deserializer (
    input wire deser_en, sampled_bit, CLK, RST,
    input wire [2:0]    edge_cnt,
    input wire [3:0]    bit_cnt,
    output reg [7:0] P_DATA
);


always @(posedge CLK or negedge RST)
begin
    if (!RST) 
    begin
        P_DATA <= 8'b0;   
    end
    else if(deser_en && (edge_cnt == 3'b111))
    begin
            P_DATA <= {sampled_bit, P_DATA[7:1]}; 
    end
    else if (bit_cnt == 4'b0001)
    begin
         P_DATA <=8'b0;
    end
end

/*always @(*) 
begin
    if (deser_en) 
    begin
        if(edge_cnt == 3'b111)
        begin
            P_DATA_c = {sampled_bit, P_DATA_c[7:1]}; 
        end
        else
        begin
            P_DATA_c = P_DATA_c;
        end
    end
    else
    begin
        P_DATA_c = 0;
    end    
end*/
    
endmodule
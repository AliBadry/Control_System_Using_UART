module Data_Sampling (
    input wire data_sample_en, RX_IN, CLK, RST,
    input wire [2:0]    edge_cnt,
    input wire [3:0]    Prescale,
    output reg sampled_bit
);

reg [2:0] buffer;
reg [2:0] sample_time;  
reg sampled_bit_c;

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        buffer <= 1'b0;
        sample_time <= (Prescale>>1)-1;
    end
    //else if(data_sample_en && ((edge_cnt == (Prescale>>1)-1) || (edge_cnt == (Prescale>>1)) || (edge_cnt == (Prescale>>1)+1)))
    else if(data_sample_en && ((edge_cnt == ((Prescale>>1)-1)) || (edge_cnt == ((Prescale>>1))) || (edge_cnt == ((Prescale>>1)+1))))
    begin
        buffer[edge_cnt-((Prescale>>1)-1)] <= RX_IN;
    end
end


//-----output the most occured value---------//
always @(*) 
begin
    case (buffer)
        3'b000: sampled_bit_c = 1'b0;
        3'b001: sampled_bit_c = 1'b0;
        3'b010: sampled_bit_c = 1'b0;
        3'b011: sampled_bit_c = 1'b1;
        3'b100: sampled_bit_c = 1'b0;
        3'b101: sampled_bit_c = 1'b1;
        3'b110: sampled_bit_c = 1'b1;
        3'b111: sampled_bit_c = 1'b1; 
        default: sampled_bit_c = 1'b1;
    endcase    
end

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        sampled_bit <= 1'b0;
    end
    else if(edge_cnt == 3'b110)
    begin
        sampled_bit <= sampled_bit_c;
    end
end
    
endmodule
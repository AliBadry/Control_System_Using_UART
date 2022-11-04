module MUX4x1 (
    input wire ser_data, par_bit, CLK, RST, 
    input wire [1:0] mux_sel,
    output reg TX_OUT
);

localparam  start_bit = 1'b0,
            stop_bit = 1'b1;
reg TX_OUT_c;

always @(*) 
begin
    case (mux_sel)
        2'b00:  TX_OUT_c = start_bit;
        2'b01:  TX_OUT_c = stop_bit;
        2'b10:  TX_OUT_c = ser_data;
        2'b11:  TX_OUT_c = par_bit;  
        default: TX_OUT_c = stop_bit;
    endcase    
end
    

always @(posedge CLK  or negedge RST) 
begin
        if(!RST)
        begin
            TX_OUT <= 1'b0;
        end
        else
        begin
            TX_OUT <= TX_OUT_c;
        end
end
endmodule
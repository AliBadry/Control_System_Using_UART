module RST_SYNC 
#(parameter NUM_STAGES = 2)
(
    input wire RST, CLK,
    output wire SYNC_RST
);


reg [NUM_STAGES-1:0] Multi_Flop;

assign SYNC_RST = Multi_Flop[0];

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        Multi_Flop <= 'b0;
    end
    else
    begin
        Multi_Flop <= {1'b1,Multi_Flop[NUM_STAGES-1:1]};
    end
end
    
endmodule
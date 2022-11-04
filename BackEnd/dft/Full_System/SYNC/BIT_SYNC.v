module BIT_SYNC #(
    parameter NUM_STAGES = 1,
    parameter BUS_WIDTH = 1
) (
    input wire [BUS_WIDTH-1:0] ASYNC,
    input wire CLK, RST,
    output wire [BUS_WIDTH-1:0]  SYNC
);

reg [BUS_WIDTH-1:0] Multi_Flop [0:NUM_STAGES-1];
integer Counter;

assign SYNC = Multi_Flop[NUM_STAGES-1];

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        for (Counter = 0; Counter<NUM_STAGES ; Counter = Counter+1) 
        begin
            Multi_Flop[Counter] <= 'b0;
        end
    end    
    else
    begin

        Multi_Flop[0] <= ASYNC;
        for (Counter = 1; Counter<NUM_STAGES ; Counter = Counter+1) 
        begin
            Multi_Flop[Counter] <= Multi_Flop[Counter-1];
        end
    end
end
    
endmodule
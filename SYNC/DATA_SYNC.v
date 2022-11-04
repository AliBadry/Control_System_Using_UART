module DATA_SYNC 
#(  parameter NUM_STAGES = 2, //number of stages should be 2 or more
    parameter BUS_WIDTH = 8)
(
    input wire [BUS_WIDTH-1:0] Unsync_bus,
    input wire bus_enable, CLK, RST,
    output reg enable_pulse,
    output reg [BUS_WIDTH-1:0] sync_bus
);

reg [NUM_STAGES-1:0] Multi_Flop;

reg Pulse_Gen, Pulse_GenFF;

reg [BUS_WIDTH-1:0] MUX_OUT;


integer Counter;

//########## Multiple flip flop stage##############//

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
        Multi_Flop <= {bus_enable,Multi_Flop[NUM_STAGES-1:1]};
        /*Multi_Flop[NUM_STAGES-1] <= bus_enable;
        for (Counter = NUM_STAGES-1; Counter>=1 ; Counter = Counter-1) 
        begin
            Multi_Flop[Counter-1] <= Multi_Flop[Counter];
        end*/
    end
end
//######################################################//

//################## Pulse Gen stage####################//

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        Pulse_GenFF <= 1'b0;
    end
    else
    begin
        Pulse_GenFF <= Multi_Flop[0];
    end    
end

always @(*) 
begin
    Pulse_Gen =  Multi_Flop[0] & (!Pulse_GenFF);   
end
//####################################################//

//################# SYNC_BUS STAGE####################//
always @(*) 
begin
    if(Pulse_Gen)
    begin
        MUX_OUT = Unsync_bus;
    end    
    else
    begin
        MUX_OUT = sync_bus;
    end
end

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        sync_bus <= 'b0;
        enable_pulse <= 1'b0;
    end    
    else
    begin
        sync_bus <= MUX_OUT;
        enable_pulse <= Pulse_Gen;
    end
end
//####################################################//
    
endmodule
//---------latch based clock gating----------------//

module CLK_Gate (
    input wire Enable,
    input wire CLK,
    output reg Gated_CLK
);

reg enable_latch;
    always @(*) 
    begin
        if(!CLK)
        begin
            enable_latch = Enable;
        end
        else
        begin
            enable_latch = enable_latch;
        end
    end

    always @(*) 
    begin
        Gated_CLK = enable_latch && CLK;    
    end

endmodule
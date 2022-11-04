module MUX2x1 
(
    input wire    IN0,IN1,
    input wire Sel,
    output reg   OUT
);

always @(*) 
begin
    if(Sel)
        OUT = IN1;
    else
        OUT = IN0;    
end
    
endmodule

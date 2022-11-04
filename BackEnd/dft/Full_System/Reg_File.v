module Reg_File
#(  parameter Add_Bus = 4,
    parameter Width = 8,
    parameter Depth = 16)
(
    input wire CLK, RST, RdEn, WrEn,
    input wire [Add_Bus-1 : 0]    Address,
    input wire [Width-1 : 0]    WrData,
    output reg [Width-1 : 0]    RdData, Reg0, Reg1, Reg2, Reg3, 
    output reg RdData_Valid
);
    
reg [Width-1:0] MEM [Depth-1:0] ;
integer i;

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        for(i=0; i<Depth; i=i+1)
        begin
            if(i == 2)
            begin
                MEM[i] <= 8'b0010_0001;
            end
            else if(i == 3)
            begin
                MEM[i] <= 8'b0000_1000;
            end
            else
            begin
                MEM[i] <= 8'b0; 
            end
        end
        RdData_Valid <= 1'b0;
        RdData <= 8'b0;
    end
    else if(RdEn && !WrEn)
    begin
        RdData <= MEM[Address];
        RdData_Valid <= 1'b1;  
    end
    else if(WrEn && !RdEn)
    begin
        MEM[Address] <= WrData;
        RdData_Valid <= 1'b0;
    end
    else
    begin
        RdData_Valid <= 1'b0;
    end
end


always @(*) 
begin
    Reg0 = MEM[0];
    Reg1 = MEM[1];
    Reg2 = MEM[2];
    Reg3 = MEM[3];    
end
endmodule
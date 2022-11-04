module Serializer (
    input wire [7:0]    P_DATA,
    input wire ser_en, CLK, RST,
    output reg ser_done, ser_data
);

//reg [7:0] P_DATA_saved;
reg [2:0] Counter;


/*always @(*) 
begin
    if(ser_en && !Counter)
    begin
        P_DATA_saved = P_DATA;
    end
    else
    begin
        P_DATA_saved = P_DATA_saved;
    end
end*/

always @(posedge CLK or negedge RST) 
begin
    if(!RST)   
        begin
            ser_data <= 1'b0;
            Counter <= 3'b0;
            ser_done <= 1'b0;
        end
    else
        begin
            if((Counter == 3'b111) && (ser_en == 1'b1))
                begin
                    ser_done <= 1'b1;
                    ser_data <= P_DATA[Counter]; //----here was P_Data_saved
                    Counter <= Counter +1;
                end
            else if((!Counter) && (ser_en == 1'b1) && (ser_done == 1'b0))
                begin
                    ser_data <= P_DATA[Counter];
                    Counter <= Counter +1;
                end
            else if((Counter < 3'b111) && (ser_en == 1'b1) && (ser_done == 1'b0))
            begin
                ser_data <= P_DATA[Counter];  //----here was P_Data_saved
                Counter <= Counter +1;
            end
            else
                begin
                    ser_done <= 1'b0;
                end
        end
end
    
endmodule
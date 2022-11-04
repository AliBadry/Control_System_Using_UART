//-----------Reset is sync.--------------//
//-----------serial. saves if ser_en is high----------//
module FSM_TX (
    input wire PAR_EN, ser_done, Data_Valid, CLK, RST,
    output reg ser_en, busy,
    output reg [1:0]    mux_sel
);
//----------defining the state machine---------//
    localparam  IDLE = 0,
                START = 1,
                SENDING = 2,
                PARITY = 3,
                STOP = 4;

    localparam  HIGH = 1'b1,
                LOW = 1'b0;

reg [3:0]  Current_state;
reg [3:0]  Next_state;
reg busy_c;

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        Current_state <= IDLE;
    end    
    else
    begin
        Current_state <= Next_state; 
    end
end

always @(*) 
begin
    case (Current_state)
        IDLE: 
            begin
                busy_c = LOW;
                ser_en = LOW;
                mux_sel = 2'b01;
                if (Data_Valid) 
                begin
                    Next_state = START;
                end
                else
                begin
                    Next_state = IDLE;
                end
            end
        START:
            begin
                busy_c = HIGH;
                ser_en = HIGH;
                mux_sel = 2'b00;
                Next_state = SENDING;
            end  
        SENDING:
            begin
                busy_c = HIGH;
                ser_en = HIGH;
                mux_sel = 2'b10;
                if (PAR_EN && ser_done) 
                begin
                    Next_state = PARITY;    
                end
                else if(!PAR_EN && ser_done)
                begin
                    Next_state = STOP;
                end
                else
                begin
                    Next_state = SENDING;
                end
            end
        PARITY:
            begin
                busy_c = HIGH;
                ser_en = LOW;
                mux_sel = 2'b11;
                Next_state = STOP;
            end
        STOP:
            begin
                busy_c = HIGH;
                ser_en = LOW;
                mux_sel = 2'b01;
                if (Data_Valid) 
                begin
                    Next_state = START;    
                end
                else
                begin
                    Next_state = IDLE;
                end
            end   
        default: 
            begin
                busy_c = LOW;
                ser_en = LOW;
                mux_sel = 2'b01;
                if (Data_Valid) 
                begin
                    Next_state = START;
                end
                else
                begin
                    Next_state = IDLE;
                end
            end
    endcase    
end

always @(posedge CLK or negedge RST)
begin
    if(!RST)
    begin
        busy <= 1'b0;
    end
    else
    begin
        busy <= busy_c;
    end
end


endmodule
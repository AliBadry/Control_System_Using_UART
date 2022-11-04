module Controller_FSM_TX (
    input wire ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST,
    input wire [15:0] ALU_OUT,
    input wire [7:0]    RdData,
    output reg [7:0] TX_P_Data,
    output reg TX_D_VLD, CLK_div_en
);

localparam  IDLE = 0,
            ALU_OUT_VLD1 = 1,
            ALU_OUT_Busy1 = 2,
            ALU_OUT_VLD2 = 3,
            ALU_OUT_Busy2 = 4,
            REG_Rd_VLD = 5,
            REG_Rd_Busy = 6;

reg [2:0] Current_State, Next_State;
reg [15:0] REG_ALU_OUT;
reg [7:0]   REG_RdData;


always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        Current_State <= IDLE;
    end    
    else
    begin
        Current_State <= Next_State;
    end
end

always @(*) 
begin
    TX_P_Data = 8'b0;
    TX_D_VLD = 1'b0; 
    CLK_div_en = 1'b1;
    case (Current_State)
        IDLE:
            begin
                if(RdData_VLD && !Busy)
                begin
                    Next_State = REG_Rd_VLD;
                end
                else if(ALU_OUT_VLD && !RdData_VLD && !Busy)
                begin
                    Next_State = ALU_OUT_VLD1;
                end
                else
                begin
                    Next_State = IDLE;
                end
            end 

        ALU_OUT_VLD1:
            begin
                TX_P_Data = REG_ALU_OUT[7:0]; //--------if the TX catches zeros then change this line of code to "ALU_OUT"
                TX_D_VLD = 1'b1;
                if (Busy) 
                begin
                    Next_State = ALU_OUT_Busy1;
                end
                else
                begin
                    Next_State = ALU_OUT_VLD1;
                end
            end

        ALU_OUT_Busy1:
            begin
                TX_P_Data = REG_ALU_OUT[7:0];
                if(!Busy)
                begin
                    Next_State = ALU_OUT_VLD2;
                end
                else 
                begin
                    Next_State = ALU_OUT_Busy1;
                end
            end

        ALU_OUT_VLD2:
            begin
                TX_P_Data = REG_ALU_OUT[15:8];
                TX_D_VLD = 1'b1;
                if(Busy)
                begin
                    Next_State = ALU_OUT_Busy2;
                end
                else
                begin
                    Next_State = ALU_OUT_VLD2;
                end
            end

        ALU_OUT_Busy2:
            begin
                TX_P_Data = REG_ALU_OUT[15:8];
                if (!Busy && RdData_VLD) 
                begin
                    Next_State = REG_Rd_VLD;
                end
                else if(!Busy && ALU_OUT_VLD)
                begin
                    Next_State = ALU_OUT_VLD1;
                end
                else if(!Busy && !ALU_OUT_VLD && !RdData_VLD)
                begin
                    Next_State = IDLE;
                end
                else
                begin
                    Next_State = ALU_OUT_Busy2;
                end
            end   

        REG_Rd_VLD:
            begin
                TX_P_Data = REG_RdData; //--------if the TX catches zeros then change this line of code to "RdData"
                TX_D_VLD = 1'b1;
                if (Busy) 
                begin
                    Next_State = REG_Rd_Busy;
                end
                else
                begin
                    Next_State = REG_Rd_VLD;
                end
            end

        REG_Rd_Busy:
            begin
                TX_P_Data = REG_RdData;
                if (!Busy && RdData_VLD) 
                begin
                    Next_State = REG_Rd_VLD;
                end
                else if(!Busy && ALU_OUT_VLD)
                begin
                    Next_State = ALU_OUT_VLD1;
                end
                else if(!Busy && !ALU_OUT_VLD && !RdData_VLD)
                begin
                    Next_State = IDLE;
                end
                else
                begin
                    Next_State = REG_Rd_Busy;
                end
            end

        default: 
            begin
                if(RdData_VLD && !Busy)
                begin
                    Next_State = REG_Rd_VLD;
                end
                else if(ALU_OUT_VLD && !RdData_VLD && !Busy)
                begin
                    Next_State = ALU_OUT_VLD1;
                end
                else
                begin
                    Next_State = IDLE;
                end
            end 
    endcase

end


always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        REG_ALU_OUT <= 16'b0;
        REG_RdData <= 8'b0;
    end
    else if((Current_State == ALU_OUT_VLD1))
    begin
        REG_ALU_OUT <= ALU_OUT;
    end
    else if((Current_State == REG_Rd_VLD))
    begin
        REG_RdData <= RdData;
    end
end
    
endmodule
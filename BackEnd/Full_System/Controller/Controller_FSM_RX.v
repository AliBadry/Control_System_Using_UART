module Controller_FSM_RX (
    input wire Data_valid, CLK, RST, ALU_OUT_Valid,
    input wire [7:0] P_Data_RX,
    output reg ALU_EN, CLK_EN, WrEn, RdEn,
    output reg [3:0]    ALU_FUN, Address,
    output reg [7:0]    WrData
);
    localparam  IDLE = 0,
                RF_Wr_CMD = 1,
                MID_State_RF_Wr1 = 2,
                RF_Wr_Addr = 3,
                MID_State_RF_Wr2 = 4,
                RF_Wr_Data = 5,
                RF_Rd_CMD = 6,
                MID_State_RF_Rd1 = 7,
                RF_Rd_Addr = 8,
                ALU_OPER_W_OP_CMD = 9,
                MID_State_ALU_OP1 = 10,
                Operand_A = 11,
                MID_State_ALU_OP2 = 12,
                Operand_B = 13,
                MID_State_ALU_OP3 = 14,
                ALU_FUN_FSM = 15,
                MID_State_ALU_OP4 = 16,
                ALU_OPER_W_NOP_CMD = 17,
                MID_State_ALU_NOP1 = 18;


    reg [4:0] Current_State, Next_State;
    reg [3:0] P_Data_Addr;

    
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
        ALU_EN = 1'b0; 
        CLK_EN = 1'b0; 
        WrEn = 1'b0; 
        RdEn = 1'b0;
        ALU_FUN = 4'b0; 
        Address = 4'b0;
        WrData = 8'b0;
        case (Current_State)
            IDLE:
                begin
                    if (Data_valid && (P_Data_RX == 8'hAA)) 
                    begin
                        Next_State = RF_Wr_CMD;
                    end
                    else if(Data_valid && (P_Data_RX == 8'hBB))
                    begin
                        Next_State = RF_Rd_CMD;
                    end
                    else if(Data_valid && (P_Data_RX == 8'hCC))
                    begin
                        Next_State = ALU_OPER_W_OP_CMD;
                    end
                    else if(Data_valid && (P_Data_RX == 8'hDD))
                    begin
                        Next_State = ALU_OPER_W_NOP_CMD;
                    end
                    else
                    begin
                        Next_State = IDLE;
                    end
                end 

            RF_Wr_CMD:
                begin
                    if(!Data_valid)
                    begin
                        Next_State = MID_State_RF_Wr1;
                    end
                    else
                    begin
                        Next_State = RF_Wr_CMD;
                    end
                end
            
            MID_State_RF_Wr1:
                begin
                    if(Data_valid)
                    begin
                        Next_State = RF_Wr_Addr;
                    end
                    else
                    begin
                        Next_State = MID_State_RF_Wr1;
                    end
                end
            
            RF_Wr_Addr:
                begin
                    Address = P_Data_RX[3:0];
                    if(!Data_valid)
                    begin
                        Next_State = MID_State_RF_Wr2;
                    end
                    else
                    begin
                        Next_State = RF_Wr_Addr;
                    end
                end

            MID_State_RF_Wr2:
                begin
                    if(Data_valid)
                    begin
                        Next_State = RF_Wr_Data;
                    end
                    else
                    begin
                        Next_State = MID_State_RF_Wr2;
                    end
                end

            RF_Wr_Data:
                begin
                    Address = P_Data_Addr;
                    WrEn = 1'b1;
                    WrData = P_Data_RX;
                    if(!Data_valid)
                    begin
                        Next_State = IDLE;
                    end
                    else
                    begin
                        Next_State = RF_Wr_Data;
                    end
                end

            RF_Rd_CMD:
                begin
                    if(!Data_valid)
                    begin
                        Next_State = MID_State_RF_Rd1;
                    end
                    else
                    begin
                        Next_State = RF_Rd_CMD;
                    end
                end

            MID_State_RF_Rd1:
                begin
                    if(Data_valid)
                    begin
                        Next_State = RF_Rd_Addr;
                    end
                    else
                    begin
                        Next_State = MID_State_RF_Rd1;
                    end
                end

            RF_Rd_Addr:
                begin
                    Address = P_Data_RX[3:0];
                    RdEn = 1'b1;
                    if(!Data_valid)
                    begin
                        Next_State = IDLE;
                    end
                    else
                    begin
                        Next_State = RF_Rd_Addr;
                    end
                end

            ALU_OPER_W_OP_CMD:
                begin
                    CLK_EN = 1'b1;
                    if(!Data_valid)
                    begin
                        Next_State = MID_State_ALU_OP1;
                    end
                    else
                    begin
                        Next_State = ALU_OPER_W_OP_CMD;
                    end
                end

            MID_State_ALU_OP1:
                begin
                    CLK_EN = 1'b1;
                    if(Data_valid)
                    begin
                        Next_State = Operand_A;
                    end
                    else
                    begin
                        Next_State = MID_State_ALU_OP1;
                    end
                end

            Operand_A:
                begin
                    CLK_EN = 1'b1;
                    Address = 4'b0;
                    WrEn = 1'b1;
                    WrData = P_Data_RX;
                    if(!Data_valid)
                    begin
                        Next_State = MID_State_ALU_OP2;
                    end
                    else
                    begin
                        Next_State = Operand_A;
                    end
                end

            MID_State_ALU_OP2:
                begin
                    CLK_EN = 1'b1;
                    if(Data_valid)
                    begin
                        Next_State = Operand_B;
                    end
                    else
                    begin
                        Next_State = MID_State_ALU_OP2;
                    end
                end

            Operand_B:
                begin
                    CLK_EN = 1'b1;
                    Address = 4'b0001;
                    WrEn = 1'b1;
                    WrData = P_Data_RX;
                    if(!Data_valid)
                    begin
                        Next_State = MID_State_ALU_OP3;
                    end
                    else
                    begin
                        Next_State = Operand_B;
                    end
                end

            MID_State_ALU_OP3:
                begin
                    CLK_EN = 1'b1;
                    if(Data_valid)
                    begin
                        Next_State = ALU_FUN_FSM;
                    end
                    else
                    begin
                        Next_State = MID_State_ALU_OP3;
                    end
                end
            
            ALU_FUN_FSM:
                begin
                    ALU_EN = 1'b1;
                    ALU_FUN = P_Data_RX[3:0];
                    CLK_EN = 1'b1;
                    if(!Data_valid)
                    begin
                        Next_State = MID_State_ALU_OP4;
                    end
                    else
                    begin
                        Next_State = ALU_FUN_FSM;
                    end
                end

            MID_State_ALU_OP4:
                begin
                    CLK_EN = 1'b1;
                    ALU_FUN = P_Data_RX[3:0];
                    //ALU_EN = 1'b1;
                    if (!ALU_OUT_Valid)
                    begin
                        Next_State = IDLE;
                    end
                    else
                    begin
                        Next_State = MID_State_ALU_OP4;
                    end
                end

            ALU_OPER_W_NOP_CMD:
                begin
                    CLK_EN = 1'b1;
                    if(!Data_valid)
                    begin
                        Next_State = MID_State_ALU_NOP1;
                    end
                    else
                    begin
                        Next_State = ALU_OPER_W_NOP_CMD;
                    end
                end

            MID_State_ALU_NOP1:
                begin
                    CLK_EN = 1'b1;
                    if(Data_valid)
                    begin
                        Next_State = ALU_FUN_FSM;
                    end
                    else
                    begin
                        Next_State = MID_State_ALU_NOP1;
                    end
                end

            default:
                begin
                    if (Data_valid && (P_Data_RX == 8'hAA)) 
                    begin
                        Next_State = RF_Wr_CMD;
                    end
                    else if(Data_valid && (P_Data_RX == 8'hBB))
                    begin
                        Next_State = RF_Rd_CMD;
                    end
                    else if(Data_valid && (P_Data_RX == 8'hCC))
                    begin
                        Next_State = ALU_OPER_W_OP_CMD;
                    end
                    else if(Data_valid && (P_Data_RX == 8'hDD))
                    begin
                        Next_State = ALU_OPER_W_NOP_CMD;
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
        if (!RST)
        begin
            P_Data_Addr <= 4'b0;
        end
        else if(Current_State == RF_Wr_Addr)
        begin
            P_Data_Addr <= Address;
        end
    end
endmodule
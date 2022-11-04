module FSM_RX (
    input wire CLK, RST, RX_IN, PAR_EN, par_err, strt_glitch, stp_err,
    input wire [3:0] bit_cnt,
    output reg par_chk_en, strt_chk_en, stp_chk_en, data_valid, deser_en, cnt_en, data_sample_en
);

//-------------gray coding for the state machine--------------//    
    localparam  IDLE = 3'b000,
                START = 3'b001,
                SAMPLE = 3'b011,
                PARITY = 3'b010,
                STOP = 3'b110,
                DATA_VALID = 3'b111;

reg [2:0] Curr_state, Next_state;
reg data_valid_c;

always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        Curr_state <= 3'b000;
    end    
    else
    begin
        Curr_state <= Next_state;
    end
end


always @(*) 
begin
    par_chk_en = 1'b0;
    strt_chk_en = 1'b0; 
    stp_chk_en = 1'b0;
    data_valid_c = 1'b0;
    deser_en = 1'b0;
    cnt_en = 1'b0;
    data_sample_en = 1'b0;
    case (Curr_state)
        IDLE:
            begin
                if(RX_IN == 1)
                begin
                    Next_state = IDLE;
                end
                else
                begin
                    Next_state = START;
                end
            end
        START:
            begin
                strt_chk_en = 1'b1;
                cnt_en = 1'b1;
                data_sample_en = 1'b1;
                if (strt_glitch && bit_cnt == 4'b0001) 
                begin
                    Next_state = IDLE;
                end
                else if (!strt_glitch && bit_cnt == 4'b0001) 
                begin
                    Next_state = SAMPLE;
                end
                else
                begin
                    Next_state = START;
                end
            end 
        SAMPLE:
            begin
                deser_en = 1'b1;
                cnt_en = 1'b1;
                data_sample_en = 1'b1;
                if (PAR_EN && bit_cnt == 4'b1001) 
                begin
                    Next_state = PARITY;
                end
                else if (!PAR_EN && bit_cnt == 4'b1001) 
                begin
                    Next_state = STOP;
                end
                else
                begin
                    Next_state = SAMPLE;
                end
            end
        PARITY:
            begin
                par_chk_en = 1'b1;
                cnt_en = 1'b1;
                data_sample_en = 1'b1;
                if (par_err) //&& bit_cnt == 4'b1010) 
                begin
                    Next_state = STOP;
                end
                else if (!par_err && bit_cnt == 4'b1010) 
                begin
                    Next_state = STOP;
                end
                else
                begin
                    Next_state = PARITY;
                end
            end
        STOP:
            begin
                stp_chk_en = 1'b1;
                cnt_en = 1'b1;
                data_sample_en = 1'b1;
                //if((PAR_EN && stp_err && bit_cnt == 4'b1011) || (!PAR_EN && stp_err && bit_cnt == 4'b1010))
                if(stp_err)
                begin
                    Next_state = IDLE;
                end
                else if(par_err && bit_cnt == 4'b1011)
                begin
                    Next_state = IDLE;
                end
                else if((PAR_EN && !stp_err && bit_cnt == 4'b1011) || (!PAR_EN && !stp_err && bit_cnt == 4'b1010))
                begin
                    Next_state = DATA_VALID;
                end
                else
                begin
                    Next_state = STOP;
                end
            end
        DATA_VALID:
            begin
                data_valid_c = 1'b1;
                if(RX_IN)
                begin
                    Next_state = IDLE;
                end
                else
                begin
                    Next_state = START;
                end
            end
        default: begin
                strt_chk_en = 1'b1;
                cnt_en = 1'b1;
                data_sample_en = 1'b1;
                if (strt_glitch && bit_cnt == 4'b0001) 
                begin
                    Next_state = IDLE;
                end
                else if (!strt_glitch && bit_cnt == 4'b0001) 
                begin
                    Next_state = SAMPLE;
                end
                else
                begin
                    Next_state = START;
                end
            end
    endcase
end


always @(posedge CLK or negedge RST) 
begin
    if(!RST)
    begin
        data_valid <= 1'b0;
    end
    else
    begin
        data_valid <= data_valid_c;
    end
end


endmodule
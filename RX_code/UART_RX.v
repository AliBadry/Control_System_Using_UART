module UART_RX (
    input wire RX_IN, PAR_EN, PAR_TYP, CLK, RST,
    input wire [3:0] Prescale,
    output wire data_valid, Parity_error,  Framing_error,
    output wire [7:0] P_DATA
);


//-------variables for the FSM----------//
wire data_sample_en, strt_glitch;
wire [3:0] bit_cnt;
wire par_chk_en, strt_chk_en, stp_chk_en, deser_en, cnt_en;

//------------variables for the edge bit counter -----------//
wire [2:0] edge_cnt;

//-----------variables for the data sampling------//
wire sampled_bit; 





FSM_RX FSM1 (
    .CLK(CLK),
    .RST(RST),
    .RX_IN(RX_IN),
    .PAR_EN(PAR_EN),
    .par_err(Parity_error),
    .strt_glitch(strt_glitch),
    .stp_err(Framing_error),
    .bit_cnt(bit_cnt),
    .par_chk_en(par_chk_en),
    .strt_chk_en(strt_chk_en),
    .stp_chk_en(stp_chk_en),
    .data_valid(data_valid),
    .deser_en(deser_en),
    .cnt_en(cnt_en),
    .data_sample_en(data_sample_en)
);

Edge_Bit_Counter Counter1 (
    .cnt_en(cnt_en),
    .CLK(CLK),
    .RST(RST),
    .edge_cnt(edge_cnt),
    .bit_cnt(bit_cnt)
);

Data_Sampling Sample1 (
    .data_sample_en(data_sample_en),
    .RX_IN(RX_IN),
    .CLK(CLK),
    .RST(RST),
    .edge_cnt(edge_cnt),
    .Prescale(Prescale),
    .sampled_bit(sampled_bit)
);

Parity_Check Check2 (
    .par_chk_en(par_chk_en),
    .PAR_TYP(PAR_TYP),
    .sampled_bit(sampled_bit),
    .P_DATA(P_DATA),
    .edge_cnt(edge_cnt),
    .bit_cnt(bit_cnt),
    .CLK(CLK),
    .RST(RST),
    .par_err(Parity_error)
);

Start_Check Check1 (
    .strt_chk_en(strt_chk_en),
    .sampled_bit(sampled_bit),
    .edge_cnt(edge_cnt),
    .strt_glitch(strt_glitch)
);

Stop_Check Check3 (
    .stp_chk_en(stp_chk_en),
    .sampled_bit(sampled_bit),
    .edge_cnt(edge_cnt),
    .stp_err(Framing_error)
);

Deserializer Deserializer1 (
    .deser_en(deser_en),
    .sampled_bit(sampled_bit),
    .CLK(CLK),
    .RST(RST),
    .bit_cnt(bit_cnt),
    .edge_cnt(edge_cnt),
    .P_DATA(P_DATA)
);
    
endmodule
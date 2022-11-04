module UART_TX (
    input wire CLK, RST, PAR_TYP, PAR_EN, Data_Valid,
    input wire [7:0]    P_DATA,
    output wire TX_OUT, Busy
);


wire ser_done, ser_en, ser_data, par_bit;
wire [1:0] mux_sel;

FSM_TX U1  (
        .Data_Valid(Data_Valid),
        .PAR_EN(PAR_EN),
        .ser_done(ser_done),
        .CLK(CLK),
        .RST(RST),
        .ser_en(ser_en),
        .busy(Busy),
        .mux_sel(mux_sel)
);


MUX4x1 U2 (
        .ser_data(ser_data),
        .par_bit(par_bit),
        .CLK(CLK),
        .RST(RST),
        .mux_sel(mux_sel),
        .TX_OUT(TX_OUT)
);


Parity_Calc U3 (
        .P_DATA(P_DATA),
        .Data_Valid(Data_Valid),
        .PAR_TYP(PAR_TYP),
        .CLK(CLK),
        .RST(RST),
        .par_bit(par_bit)
);


Serializer U4 (
        .P_DATA(P_DATA),
        .ser_en(ser_en),
        .CLK(CLK),
        .RST(RST),
        .ser_done(ser_done),
        .ser_data(ser_data)
);
    
endmodule
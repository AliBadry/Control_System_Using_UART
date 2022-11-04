/*`include "/RX_code/UART_RX.v"
`include "/TX_code/UART_TX.v"
*/
module UART (
    //------------RX ports------------//
    input wire RX_IN, PAR_EN, PAR_TYP, RX_CLK, TX_CLK, RST,
    input wire [3:0] Prescale,
    output wire data_valid_RX, Parity_error,  Framing_error,
    output wire [7:0] P_DATA_RX,

    //------------TX PORTS------------//
    input wire Data_Valid_TX,
    input wire [7:0]    P_DATA_TX,
    output wire TX_OUT, Busy
);

UART_TX UARTTX (
        .CLK(TX_CLK),
        .RST(RST),
        .PAR_TYP(PAR_TYP),
        .PAR_EN(PAR_EN),
        .Data_Valid(Data_Valid_TX),
        .P_DATA(P_DATA_TX),
        .TX_OUT(TX_OUT),
        .Busy(Busy)
);

UART_RX UARTRX (
        .RX_IN(RX_IN),
        .PAR_EN(PAR_EN),
        .PAR_TYP(PAR_TYP),
        .CLK(RX_CLK),
        .RST(RST),
        .Prescale(Prescale),
        .data_valid(data_valid_RX),
        .Parity_error(Parity_error),
        .Framing_error(Framing_error),
        .P_DATA(P_DATA_RX)
);
    
endmodule

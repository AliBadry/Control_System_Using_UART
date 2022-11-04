`include "./SYNC/BIT_SYNC.v"
`include "./SYNC/DATA_SYNC.v"
`include "./SYNC/RST_SYNC.v"

module SYS_TOP (
    input wire REF_CLK, UART_CLK, RST, RX_IN,
    output wire TX_OUT, Parity_error,  Framing_error
);

//----REG file wires--------//
wire [7:0] Reg0, Reg1, Reg2, Reg3;

//--------CLK_divider wires---------//
wire o_div_clk, CLK_div_en;

//------------CLK_Gate------------//
wire Gate_Enable, ALU_CLK;

//--------RST_SYNC2 wires---------//
wire SYNC_RST2; //RST, UART_CLK;

//---------RST_SYNC1 wires------------//
wire SYNC_RST1; //RST, REF_CLK;

//------------DATA_SYNC_RX wires-----//
wire [7:0] Unsync_bus_RX, sync_bus_RX;
wire bus_enable_RX, enable_pulse_RX; // REF_CLK, RST_SYNC2,

//------------DATA_SYNC_TX wires-----//
wire [7:0] Unsync_bus_TX, sync_bus_TX;
wire bus_enable_TX, enable_pulse_TX; // UART_CLK, RST_SYNC1,

//--------------BIT_SYNC_Data_Valid_TX----------------//
wire  Data_Valid_TX_ASYNC, Data_Valid_TX_SYNC;

//-----------BIT_SYNC_Busy wires--------------//
wire ASYNC_Busy, SYNC_Busy; // REF_CLK, RST_SYNC2,

//------------ALU wires---------//
wire [3:0] ALU_FUN; 
wire ALU_Enable, ALU_OUT_Valid;
wire [15:0] ALU_OUT;

//------------REG File wires--------//
wire RdEn, WrEn, RdData_Valid;
wire [3:0] Reg_Address;
wire [7:0] WrData, RdData;





UART U1 (
        .RX_IN(RX_IN),
        .PAR_EN(Reg2[0]),
        .PAR_TYP(Reg2[1]),
        .RX_CLK(UART_CLK),
        .TX_CLK(o_div_clk),
        .RST(SYNC_RST2),
        .Prescale(Reg2[5:2]),
        .data_valid_RX(bus_enable_RX),
        .Parity_error(Parity_error),
        .Framing_error(Framing_error),
        .P_DATA_RX(Unsync_bus_RX),
        .Data_Valid_TX(Data_Valid_TX_SYNC),
        .P_DATA_TX(sync_bus_TX),
        .TX_OUT(TX_OUT),
        .Busy(SYNC_Busy)
);

DATA_SYNC #(.NUM_STAGES(2),
            .BUS_WIDTH(8)) SYNC_RX1
            (
                .Unsync_bus(Unsync_bus_RX),
                .bus_enable(bus_enable_RX),
                .CLK(REF_CLK),
                .RST(SYNC_RST1),
                .enable_pulse(enable_pulse_RX),
                .sync_bus(sync_bus_RX)
            );

BIT_SYNC #( .NUM_STAGES(2),
            .BUS_WIDTH(1)) BUSY_SYNC1
            (
                .ASYNC(ASYNC_Busy),
                .SYNC(SYNC_Busy),
                .CLK(REF_CLK),
                .RST(SYNC_RST1)
            );

BIT_SYNC #( .NUM_STAGES(2),
            .BUS_WIDTH(1))  Data_Valid_TX_SYNC1
            (
                .ASYNC(Data_Valid_TX_ASYNC),
                .SYNC(Data_Valid_TX_SYNC),
                .CLK(UART_CLK),
                .RST(SYNC_RST2)
            );

DATA_SYNC #(.NUM_STAGES(2),
            .BUS_WIDTH(8)) SYNC_TX1
            (
                .Unsync_bus(Unsync_bus_TX),
                .bus_enable(Data_Valid_TX_ASYNC),
                .CLK(UART_CLK),
                .RST(SYNC_RST2),
                .enable_pulse(enable_pulse_TX),
                .sync_bus(sync_bus_TX)
            );

RST_SYNC RST_SYNC1 (
        .RST(RST),
        .CLK(REF_CLK),
        .SYNC_RST(SYNC_RST1)
);

RST_SYNC RST_SYNC2 (
        .RST(RST),
        .CLK(UART_CLK),
        .SYNC_RST(SYNC_RST2)
);

CLK_Divider TX_DIV1 (
        .i_ref_clk(UART_CLK),
        .i_rst_n(SYNC_RST2),
        .i_clk_en(CLK_div_en),
        .i_div_ratio(Reg3[4:0]),
        .o_div_clk(o_div_clk)
);

CLK_Gate CLK_Gate1 (
        .Enable(Gate_Enable),
        .CLK(REF_CLK),
        .Gated_CLK(ALU_CLK)
);

ALU ALU1 (
        .A(Reg0),
        .B(Reg1),
        .ALU_FUN(ALU_FUN),
        .CLK(ALU_CLK),
        .RST(SYNC_RST1),
        .Enable(ALU_Enable),
        .ALU_OUT(ALU_OUT),
        .OUT_VALID(ALU_OUT_Valid)
);

Reg_File REG_FILE1 (
        .CLK(REF_CLK),
        .RST(SYNC_RST1),
        .RdEn(RdEn),
        .WrEn(WrEn),
        .Address(Reg_Address),
        .WrData(WrData),
        .RdData(RdData),
        .Reg0(Reg0),
        .Reg1(Reg1),
        .Reg2(Reg2),
        .Reg3(Reg3),
        .RdData_Valid(RdData_Valid)
);

SYS_CTRL SYS_CTRL1 (
        .ALU_OUT_VLD(ALU_OUT_Valid),
        .RdData_VLD(RdData_Valid),
        .Busy(SYNC_Busy),
        .CLK(REF_CLK),
        .RST(SYNC_RST1),
        .ALU_OUT(ALU_OUT),
        .RdData(RdData),
        .TX_P_Data(Unsync_bus_TX),
        .TX_D_VLD(Data_Valid_TX_ASYNC),
        .CLK_div_en(CLK_div_en),
        .Data_valid(enable_pulse_RX),
        .P_Data_RX(sync_bus_RX),
        .ALU_EN(ALU_Enable),
        .CLK_EN(Gate_Enable),
        .WrEn(WrEn),
        .RdEn(RdEn),
        .ALU_FUN(ALU_FUN),
        .Address(Reg_Address),
        .WrData(WrData)
);
endmodule
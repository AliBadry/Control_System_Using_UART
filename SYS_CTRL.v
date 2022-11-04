`include "./Controller/Controller_FSM_RX.v"
`include "./Controller/Controller_FSM_TX.v"

module SYS_CTRL (
    //---------TX Ports---------------//
    input wire ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST,
    input wire [15:0] ALU_OUT,
    input wire [7:0]    RdData,
    output wire [7:0] TX_P_Data,
    output wire TX_D_VLD, CLK_div_en,

    //------------RX Ports-------------//
    input wire Data_valid,
    input wire [7:0] P_Data_RX,
    output wire ALU_EN, CLK_EN, WrEn, RdEn,
    output wire [3:0]    ALU_FUN, Address,
    output wire [7:0]    WrData
);

Controller_FSM_TX TX_Control (
    .ALU_OUT_VLD(ALU_OUT_VLD),
    .RdData_VLD(RdData_VLD),
    .Busy(Busy),
    .CLK(CLK),
    .RST(RST),
    .ALU_OUT(ALU_OUT),
    .RdData(RdData),
    .TX_P_Data(TX_P_Data),
    .TX_D_VLD(TX_D_VLD),
    .CLK_div_en(CLK_div_en)
);

Controller_FSM_RX RX_Control (
    .Data_valid(Data_valid),
    .CLK(CLK),
    .RST(RST),
    .ALU_OUT_Valid(ALU_OUT_VLD),
    .P_Data_RX(P_Data_RX),
    .ALU_EN(ALU_EN),
    .CLK_EN(CLK_EN),
    .WrEn(WrEn),
    .RdEn(RdEn),
    .ALU_FUN(ALU_FUN),
    .Address(Address),
    .WrData(WrData)
);
    
endmodule
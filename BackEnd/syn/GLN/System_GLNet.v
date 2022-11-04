/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Thu Oct 13 18:52:57 2022
/////////////////////////////////////////////////////////////


module FSM_TX ( PAR_EN, ser_done, Data_Valid, CLK, RST, ser_en, busy, mux_sel
 );
  output [1:0] mux_sel;
  input PAR_EN, ser_done, Data_Valid, CLK, RST;
  output ser_en, busy;
  wire   busy_c, n7, n8, n10, n11, n12, n13, n14, n15, n1, n2, n3, n4, n5, n6,
         n9;
  wire   [3:0] Current_state;
  wire   [2:0] Next_state;

  OAI32X4M U12 ( .A0(n2), .A1(mux_sel[1]), .A2(n5), .B0(n12), .B1(n15), .Y(
        Next_state[0]) );
  DFFRX1M \Current_state_reg[1]  ( .D(Next_state[1]), .CK(CLK), .RN(RST), .Q(
        Current_state[1]), .QN(n6) );
  DFFRX1M busy_reg ( .D(busy_c), .CK(CLK), .RN(n1), .Q(busy) );
  DFFRX4M \Current_state_reg[2]  ( .D(Next_state[2]), .CK(CLK), .RN(n1), .QN(
        n9) );
  DFFRX2M \Current_state_reg[0]  ( .D(Next_state[0]), .CK(CLK), .RN(n1), .Q(
        Current_state[0]), .QN(n4) );
  CLKBUFX2M U3 ( .A(RST), .Y(n1) );
  NAND3X4M U4 ( .A(Current_state[1]), .B(n4), .C(n9), .Y(n12) );
  INVX2M U5 ( .A(mux_sel[0]), .Y(ser_en) );
  NOR2X4M U6 ( .A(n4), .B(n6), .Y(n10) );
  NAND2X2M U7 ( .A(n9), .B(n8), .Y(mux_sel[0]) );
  NAND2X2M U8 ( .A(n10), .B(n9), .Y(n11) );
  NAND2X2M U9 ( .A(n12), .B(n11), .Y(mux_sel[1]) );
  OAI2B1X2M U10 ( .A1N(n7), .A0(n8), .B0(mux_sel[0]), .Y(busy_c) );
  OAI21X2M U11 ( .A0(n10), .A1(n9), .B0(n11), .Y(n7) );
  INVX2M U13 ( .A(n14), .Y(n5) );
  INVX2M U14 ( .A(Data_Valid), .Y(n2) );
  OAI31X2M U15 ( .A0(n3), .A1(PAR_EN), .A2(n12), .B0(n11), .Y(Next_state[2])
         );
  INVX2M U16 ( .A(ser_done), .Y(n3) );
  XNOR2X4M U17 ( .A(n4), .B(Current_state[1]), .Y(n8) );
  NAND3X2M U18 ( .A(Current_state[0]), .B(n6), .C(n9), .Y(n14) );
  OAI21X2M U19 ( .A0(n13), .A1(n12), .B0(n14), .Y(Next_state[1]) );
  AND2X2M U20 ( .A(n15), .B(ser_done), .Y(n13) );
  NAND2X2M U21 ( .A(PAR_EN), .B(ser_done), .Y(n15) );
endmodule


module MUX4x1 ( ser_data, par_bit, CLK, RST, mux_sel, TX_OUT );
  input [1:0] mux_sel;
  input ser_data, par_bit, CLK, RST;
  output TX_OUT;
  wire   n5, TX_OUT_c, n2, n3, n4;

  DFFRX1M TX_OUT_reg ( .D(TX_OUT_c), .CK(CLK), .RN(RST), .Q(n5) );
  BUFX10M U3 ( .A(n5), .Y(TX_OUT) );
  OAI21X2M U4 ( .A0(n2), .A1(n4), .B0(n3), .Y(TX_OUT_c) );
  NAND3X2M U5 ( .A(mux_sel[1]), .B(n4), .C(ser_data), .Y(n3) );
  NOR2BX2M U6 ( .AN(mux_sel[1]), .B(par_bit), .Y(n2) );
  INVX2M U7 ( .A(mux_sel[0]), .Y(n4) );
endmodule


module Parity_Calc ( P_DATA, Data_Valid, PAR_TYP, CLK, RST, par_bit );
  input [7:0] P_DATA;
  input Data_Valid, PAR_TYP, CLK, RST;
  output par_bit;
  wire   n1, n3, n4, n5, n6, n7, n2;

  DFFRX1M par_bit_reg ( .D(n7), .CK(CLK), .RN(RST), .Q(par_bit) );
  XNOR2X2M U2 ( .A(P_DATA[3]), .B(P_DATA[2]), .Y(n5) );
  OAI2BB2X1M U3 ( .B0(n1), .B1(n2), .A0N(par_bit), .A1N(n2), .Y(n7) );
  INVX2M U4 ( .A(Data_Valid), .Y(n2) );
  XOR3XLM U5 ( .A(n3), .B(PAR_TYP), .C(n4), .Y(n1) );
  XOR3XLM U6 ( .A(P_DATA[1]), .B(P_DATA[0]), .C(n5), .Y(n4) );
  XOR3XLM U7 ( .A(P_DATA[5]), .B(P_DATA[4]), .C(n6), .Y(n3) );
  CLKXOR2X2M U8 ( .A(P_DATA[7]), .B(P_DATA[6]), .Y(n6) );
endmodule


module Serializer ( P_DATA, ser_en, CLK, RST, ser_done, ser_data );
  input [7:0] P_DATA;
  input ser_en, CLK, RST;
  output ser_done, ser_data;
  wire   N1, N2, N3, N4, n4, n5, n6, n7, n8, n9, n10, n11, n12, n1, n2, n3,
         n13;

  AOI2B1X8M U9 ( .A1N(ser_done), .A0(ser_en), .B0(n8), .Y(n5) );
  DFFRQX4M \Counter_reg[1]  ( .D(n10), .CK(CLK), .RN(n1), .Q(N2) );
  DFFRQX4M ser_done_reg ( .D(n8), .CK(CLK), .RN(n1), .Q(ser_done) );
  DFFRQX4M \Counter_reg[0]  ( .D(n12), .CK(CLK), .RN(n1), .Q(N1) );
  DFFRX1M ser_data_reg ( .D(n11), .CK(CLK), .RN(n1), .Q(ser_data) );
  DFFRX2M \Counter_reg[2]  ( .D(n9), .CK(CLK), .RN(n1), .Q(N3) );
  BUFX4M U3 ( .A(RST), .Y(n1) );
  AO2B2X2M U4 ( .B0(ser_data), .B1(n5), .A0(N4), .A1N(n5), .Y(n11) );
  MX2X2M U5 ( .A(n3), .B(n2), .S0(N3), .Y(N4) );
  MX4X1M U6 ( .A(P_DATA[4]), .B(P_DATA[5]), .C(P_DATA[6]), .D(P_DATA[7]), .S0(
        N1), .S1(N2), .Y(n2) );
  MX4X1M U7 ( .A(P_DATA[0]), .B(P_DATA[1]), .C(P_DATA[2]), .D(P_DATA[3]), .S0(
        N1), .S1(N2), .Y(n3) );
  CLKXOR2X2M U8 ( .A(N2), .B(n7), .Y(n10) );
  NOR2BX2M U10 ( .AN(N1), .B(n5), .Y(n7) );
  CLKXOR2X2M U11 ( .A(N3), .B(n4), .Y(n9) );
  NOR2X2M U12 ( .A(n5), .B(n6), .Y(n4) );
  XNOR2X2M U13 ( .A(N1), .B(n5), .Y(n12) );
  NAND2X2M U14 ( .A(N2), .B(N1), .Y(n6) );
  AND3X2M U15 ( .A(n13), .B(N3), .C(ser_en), .Y(n8) );
  INVX2M U16 ( .A(n6), .Y(n13) );
endmodule


module UART_TX ( CLK, RST, PAR_TYP, PAR_EN, Data_Valid, P_DATA, TX_OUT, Busy
 );
  input [7:0] P_DATA;
  input CLK, RST, PAR_TYP, PAR_EN, Data_Valid;
  output TX_OUT, Busy;
  wire   ser_done, ser_en, ser_data, par_bit, n1, n2;
  wire   [1:0] mux_sel;

  FSM_TX U1 ( .PAR_EN(PAR_EN), .ser_done(ser_done), .Data_Valid(Data_Valid), 
        .CLK(CLK), .RST(n1), .ser_en(ser_en), .busy(Busy), .mux_sel(mux_sel)
         );
  MUX4x1 U2 ( .ser_data(ser_data), .par_bit(par_bit), .CLK(CLK), .RST(n1), 
        .mux_sel(mux_sel), .TX_OUT(TX_OUT) );
  Parity_Calc U3 ( .P_DATA(P_DATA), .Data_Valid(Data_Valid), .PAR_TYP(PAR_TYP), 
        .CLK(CLK), .RST(n1), .par_bit(par_bit) );
  Serializer U4 ( .P_DATA(P_DATA), .ser_en(ser_en), .CLK(CLK), .RST(n1), 
        .ser_done(ser_done), .ser_data(ser_data) );
  INVX4M U5 ( .A(n2), .Y(n1) );
  INVX2M U6 ( .A(RST), .Y(n2) );
endmodule


module FSM_RX ( CLK, RST, RX_IN, PAR_EN, par_err, strt_glitch, stp_err, 
        bit_cnt, par_chk_en, strt_chk_en, stp_chk_en, data_valid, deser_en, 
        cnt_en, data_sample_en );
  input [3:0] bit_cnt;
  input CLK, RST, RX_IN, PAR_EN, par_err, strt_glitch, stp_err;
  output par_chk_en, strt_chk_en, stp_chk_en, data_valid, deser_en, cnt_en,
         data_sample_en;
  wire   data_valid_c, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18,
         n19, n20, n21, n1, n3, n4, n5, n6, n22, n23, n24;
  wire   [2:0] Curr_state;
  wire   [2:0] Next_state;

  NOR3X12M U14 ( .A(n23), .B(Curr_state[2]), .C(n22), .Y(deser_en) );
  DFFRQX2M \Curr_state_reg[0]  ( .D(Next_state[0]), .CK(CLK), .RN(n3), .Q(
        Curr_state[0]) );
  DFFRQX2M \Curr_state_reg[2]  ( .D(Next_state[2]), .CK(CLK), .RN(n3), .Q(
        Curr_state[2]) );
  DFFRQX2M data_valid_reg ( .D(data_valid_c), .CK(CLK), .RN(n3), .Q(data_valid) );
  DFFRQX2M \Curr_state_reg[1]  ( .D(Next_state[1]), .CK(CLK), .RN(n3), .Q(
        Curr_state[1]) );
  NAND3X2M U3 ( .A(n22), .B(n24), .C(Curr_state[1]), .Y(n8) );
  NOR3BX4M U4 ( .AN(bit_cnt[0]), .B(bit_cnt[1]), .C(bit_cnt[2]), .Y(n12) );
  INVXLM U5 ( .A(n5), .Y(n1) );
  CLKINVX3M U6 ( .A(n12), .Y(n5) );
  AOI21X1M U7 ( .A0(strt_chk_en), .A1(n14), .B0(deser_en), .Y(n13) );
  NAND3BXLM U8 ( .AN(bit_cnt[2]), .B(bit_cnt[1]), .C(bit_cnt[3]), .Y(n21) );
  OAI211X1M U9 ( .A0(RX_IN), .A1(n15), .B0(n16), .C0(n17), .Y(Next_state[0])
         );
  NAND2X2M U10 ( .A(n20), .B(stp_chk_en), .Y(n10) );
  BUFX4M U11 ( .A(RST), .Y(n3) );
  INVX2M U12 ( .A(n8), .Y(par_chk_en) );
  NAND3X2M U13 ( .A(n8), .B(n10), .C(n13), .Y(Next_state[1]) );
  INVX2M U15 ( .A(n10), .Y(n4) );
  NOR3X4M U16 ( .A(n24), .B(n23), .C(n22), .Y(data_valid_c) );
  NOR3X8M U17 ( .A(n23), .B(Curr_state[0]), .C(n24), .Y(stp_chk_en) );
  INVX4M U18 ( .A(Curr_state[2]), .Y(n24) );
  INVX4M U19 ( .A(Curr_state[1]), .Y(n23) );
  AOI31X2M U20 ( .A0(n23), .A1(n24), .A2(n22), .B0(data_valid_c), .Y(n15) );
  OAI31X2M U21 ( .A0(n5), .A1(bit_cnt[3]), .A2(n14), .B0(strt_chk_en), .Y(n16)
         );
  AOI31X1M U22 ( .A0(n4), .A1(n6), .A2(n18), .B0(n19), .Y(n17) );
  AOI21X6M U23 ( .A0(n24), .A1(n22), .B0(Curr_state[1]), .Y(strt_chk_en) );
  INVX4M U24 ( .A(Curr_state[0]), .Y(n22) );
  NOR3X4M U25 ( .A(strt_glitch), .B(bit_cnt[3]), .C(n5), .Y(n14) );
  AOI31X1M U26 ( .A0(bit_cnt[0]), .A1(n6), .A2(par_err), .B0(stp_err), .Y(n20)
         );
  OAI211X2M U27 ( .A0(n9), .A1(n8), .B0(n10), .C0(n11), .Y(Next_state[2]) );
  AOI2B1X1M U28 ( .A1N(bit_cnt[0]), .A0(n6), .B0(par_err), .Y(n9) );
  NAND4BX1M U29 ( .AN(PAR_EN), .B(deser_en), .C(n1), .D(bit_cnt[3]), .Y(n11)
         );
  INVX2M U30 ( .A(n21), .Y(n6) );
  AOI21BX1M U31 ( .A0(n12), .A1(bit_cnt[3]), .B0N(deser_en), .Y(n19) );
  XNOR2X2M U32 ( .A(PAR_EN), .B(bit_cnt[0]), .Y(n18) );
  CLKBUFX2M U33 ( .A(cnt_en), .Y(data_sample_en) );
  OR4X4M U34 ( .A(deser_en), .B(par_chk_en), .C(stp_chk_en), .D(strt_chk_en), 
        .Y(cnt_en) );
endmodule


module Edge_Bit_Counter ( cnt_en, CLK, RST, edge_cnt, bit_cnt );
  output [2:0] edge_cnt;
  output [3:0] bit_cnt;
  input cnt_en, CLK, RST;
  wire   N8, N9, N10, n4, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n1, n3, n5, n6, n7, n8, n23, n24, n25, n26, n27;

  DFFRHQX8M \edge_cnt_reg[1]  ( .D(N9), .CK(CLK), .RN(n5), .Q(edge_cnt[1]) );
  DFFRHQX8M \edge_cnt_reg[0]  ( .D(N8), .CK(CLK), .RN(n5), .Q(edge_cnt[0]) );
  DFFRHQX8M \edge_cnt_reg[2]  ( .D(N10), .CK(CLK), .RN(n5), .Q(edge_cnt[2]) );
  DFFRHQX8M \bit_cnt_reg[0]  ( .D(n22), .CK(CLK), .RN(n5), .Q(bit_cnt[0]) );
  DFFRHQX8M \bit_cnt_reg[1]  ( .D(n21), .CK(CLK), .RN(n5), .Q(bit_cnt[1]) );
  DFFRHQX8M \bit_cnt_reg[2]  ( .D(n7), .CK(CLK), .RN(n5), .Q(bit_cnt[2]) );
  DFFRX1M \bit_cnt_reg[3]  ( .D(n20), .CK(CLK), .RN(n5), .Q(n3), .QN(n4) );
  INVXLM U3 ( .A(n3), .Y(n1) );
  INVX6M U4 ( .A(n1), .Y(bit_cnt[3]) );
  NAND3X2M U5 ( .A(edge_cnt[0]), .B(cnt_en), .C(edge_cnt[1]), .Y(n17) );
  INVX4M U6 ( .A(n6), .Y(n5) );
  INVX2M U7 ( .A(RST), .Y(n6) );
  INVX4M U8 ( .A(n12), .Y(n8) );
  NAND2X2M U9 ( .A(cnt_en), .B(n8), .Y(n16) );
  INVX2M U10 ( .A(cnt_en), .Y(n27) );
  NOR2X4M U11 ( .A(n24), .B(n8), .Y(n11) );
  NOR2X4M U12 ( .A(n23), .B(n17), .Y(n12) );
  INVX2M U13 ( .A(n14), .Y(n7) );
  AOI32X1M U14 ( .A0(bit_cnt[1]), .A1(n26), .A2(n11), .B0(n13), .B1(bit_cnt[2]), .Y(n14) );
  OAI21X4M U15 ( .A0(bit_cnt[1]), .A1(n8), .B0(n15), .Y(n13) );
  OAI21X2M U16 ( .A0(n9), .A1(n4), .B0(n10), .Y(n20) );
  NAND4X2M U17 ( .A(bit_cnt[2]), .B(bit_cnt[1]), .C(n11), .D(n4), .Y(n10) );
  AOI21X2M U18 ( .A0(n12), .A1(n26), .B0(n13), .Y(n9) );
  OA21X2M U19 ( .A0(bit_cnt[0]), .A1(n8), .B0(n16), .Y(n15) );
  INVX2M U20 ( .A(edge_cnt[2]), .Y(n23) );
  OAI22X2M U21 ( .A0(n24), .A1(n16), .B0(bit_cnt[0]), .B1(n8), .Y(n22) );
  OAI22X2M U22 ( .A0(edge_cnt[2]), .A1(n17), .B0(n19), .B1(n23), .Y(N10) );
  AOI2BB1X1M U23 ( .A0N(edge_cnt[1]), .A1N(n27), .B0(N8), .Y(n19) );
  NOR2X3M U24 ( .A(n27), .B(edge_cnt[0]), .Y(N8) );
  OAI2BB2X1M U25 ( .B0(n15), .B1(n25), .A0N(n25), .A1N(n11), .Y(n21) );
  INVX2M U26 ( .A(bit_cnt[1]), .Y(n25) );
  NOR2X2M U27 ( .A(n18), .B(n27), .Y(N9) );
  XNOR2X2M U28 ( .A(edge_cnt[0]), .B(edge_cnt[1]), .Y(n18) );
  INVX2M U29 ( .A(bit_cnt[0]), .Y(n24) );
  INVX2M U30 ( .A(bit_cnt[2]), .Y(n26) );
endmodule


module Data_Sampling ( data_sample_en, RX_IN, CLK, RST, edge_cnt, Prescale, 
        sampled_bit );
  input [2:0] edge_cnt;
  input [3:0] Prescale;
  input data_sample_en, RX_IN, CLK, RST;
  output sampled_bit;
  wire   N44, N45, N46, N47, N60, N61, N62, N63, N91, n13, n14, n16, n17, n19,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n45, n46, n47, N59, N58,
         N56, \sub_22_2/carry[3] , \sub_22_2/carry[2] , \sub_22_2/carry[1] ,
         n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n15, n18, n20;
  wire   [2:0] buffer;

  DFFRQX2M \buffer_reg[2]  ( .D(n47), .CK(CLK), .RN(n6), .Q(buffer[2]) );
  DFFRQX4M sampled_bit_reg ( .D(n43), .CK(CLK), .RN(n6), .Q(sampled_bit) );
  DFFRQX2M \buffer_reg[1]  ( .D(n46), .CK(CLK), .RN(n6), .Q(buffer[1]) );
  DFFRQX2M \buffer_reg[0]  ( .D(n45), .CK(CLK), .RN(n6), .Q(buffer[0]) );
  CLKBUFX6M U3 ( .A(Prescale[1]), .Y(n2) );
  CLKXOR2X2M U4 ( .A(Prescale[2]), .B(n2), .Y(n1) );
  AOI21X1M U5 ( .A0(Prescale[3]), .A1(n32), .B0(edge_cnt[0]), .Y(n31) );
  CLKINVX1M U6 ( .A(edge_cnt[0]), .Y(n15) );
  NOR4X2M U7 ( .A(N46), .B(n11), .C(n10), .D(n9), .Y(N47) );
  XNOR2X2M U8 ( .A(N59), .B(\sub_22_2/carry[3] ), .Y(N63) );
  XNOR2X4M U9 ( .A(edge_cnt[0]), .B(n7), .Y(N60) );
  INVX1M U10 ( .A(N60), .Y(n12) );
  NAND2BX1M U11 ( .AN(N59), .B(n20), .Y(N58) );
  CLKBUFX6M U12 ( .A(n5), .Y(n4) );
  BUFX4M U13 ( .A(n5), .Y(n3) );
  CLKBUFX2M U14 ( .A(N91), .Y(n5) );
  AND2X2M U15 ( .A(Prescale[2]), .B(n2), .Y(n32) );
  NOR2X2M U16 ( .A(n4), .B(n4), .Y(n37) );
  NOR2X2M U17 ( .A(n3), .B(n4), .Y(n39) );
  NOR2X2M U18 ( .A(n4), .B(n3), .Y(n40) );
  NOR2X2M U19 ( .A(n4), .B(n3), .Y(n38) );
  BUFX4M U20 ( .A(RST), .Y(n6) );
  AND4X2M U21 ( .A(n33), .B(n34), .C(n35), .D(n36), .Y(n23) );
  NOR2X2M U22 ( .A(n4), .B(n3), .Y(n34) );
  NOR2X2M U23 ( .A(n4), .B(n3), .Y(n33) );
  AND4X2M U24 ( .A(n37), .B(n38), .C(n39), .D(n40), .Y(n36) );
  INVX2M U25 ( .A(RX_IN), .Y(n18) );
  NAND3BX2M U26 ( .AN(N61), .B(n22), .C(n23), .Y(n19) );
  NOR4BX2M U27 ( .AN(n41), .B(n5), .C(N62), .D(N63), .Y(n35) );
  NOR2X2M U28 ( .A(n4), .B(n3), .Y(n41) );
  INVX2M U29 ( .A(N56), .Y(n7) );
  INVX2M U30 ( .A(n2), .Y(N56) );
  OAI2BB2X1M U31 ( .B0(n18), .B1(n21), .A0N(n21), .A1N(buffer[1]), .Y(n46) );
  NAND2BX1M U32 ( .AN(n19), .B(N60), .Y(n21) );
  OAI2BB2X1M U33 ( .B0(n17), .B1(n18), .A0N(n17), .A1N(buffer[0]), .Y(n45) );
  NAND2BX2M U34 ( .AN(n19), .B(n12), .Y(n17) );
  OAI2BB2X1M U35 ( .B0(n18), .B1(n24), .A0N(n24), .A1N(buffer[2]), .Y(n47) );
  NAND4X2M U36 ( .A(N61), .B(n23), .C(n22), .D(n12), .Y(n24) );
  AOI31X1M U37 ( .A0(n29), .A1(n30), .A2(n31), .B0(N47), .Y(n28) );
  CLKXOR2X2M U38 ( .A(N44), .B(edge_cnt[1]), .Y(n30) );
  XNOR2X2M U39 ( .A(n32), .B(n27), .Y(n29) );
  ADDFX2M U40 ( .A(edge_cnt[2]), .B(n8), .CI(\sub_22_2/carry[2] ), .CO(
        \sub_22_2/carry[3] ), .S(N62) );
  INVX2M U41 ( .A(N58), .Y(n8) );
  OAI21X2M U42 ( .A0(n2), .A1(Prescale[2]), .B0(Prescale[3]), .Y(n20) );
  ADDFX2M U43 ( .A(edge_cnt[1]), .B(n1), .CI(\sub_22_2/carry[1] ), .CO(
        \sub_22_2/carry[2] ), .S(N61) );
  AND2X2M U44 ( .A(data_sample_en), .B(n25), .Y(n22) );
  OAI31X2M U45 ( .A0(n26), .A1(n15), .A2(n27), .B0(n28), .Y(n25) );
  XOR2X2M U46 ( .A(edge_cnt[1]), .B(Prescale[2]), .Y(n26) );
  CLKXOR2X2M U47 ( .A(edge_cnt[2]), .B(Prescale[3]), .Y(n27) );
  OAI2BB2X1M U48 ( .B0(n13), .B1(n14), .A0N(sampled_bit), .A1N(n14), .Y(n43)
         );
  AOI21X2M U49 ( .A0(buffer[1]), .A1(buffer[0]), .B0(n16), .Y(n13) );
  NAND3X1M U50 ( .A(edge_cnt[1]), .B(n15), .C(edge_cnt[2]), .Y(n14) );
  OA21X2M U51 ( .A0(buffer[1]), .A1(buffer[0]), .B0(buffer[2]), .Y(n16) );
  NOR3X8M U52 ( .A(Prescale[2]), .B(Prescale[3]), .C(n2), .Y(N59) );
  NOR3X4M U53 ( .A(Prescale[2]), .B(Prescale[3]), .C(n2), .Y(N46) );
  OAI21BX4M U54 ( .A0(Prescale[2]), .A1(n2), .B0N(n32), .Y(N44) );
  NAND2BX2M U55 ( .AN(N46), .B(n42), .Y(N45) );
  OAI21X2M U56 ( .A0(n2), .A1(Prescale[2]), .B0(Prescale[3]), .Y(n42) );
  OR2X1M U57 ( .A(n7), .B(edge_cnt[0]), .Y(\sub_22_2/carry[1] ) );
  NOR2X1M U58 ( .A(\sub_22_2/carry[3] ), .B(N59), .Y(N91) );
  CLKXOR2X2M U59 ( .A(N56), .B(edge_cnt[0]), .Y(n11) );
  CLKXOR2X2M U60 ( .A(N45), .B(edge_cnt[2]), .Y(n10) );
  CLKXOR2X2M U61 ( .A(N44), .B(edge_cnt[1]), .Y(n9) );
endmodule


module Parity_Check ( par_chk_en, PAR_TYP, sampled_bit, P_DATA, edge_cnt, 
        bit_cnt, CLK, RST, par_err );
  input [7:0] P_DATA;
  input [2:0] edge_cnt;
  input [3:0] bit_cnt;
  input par_chk_en, PAR_TYP, sampled_bit, CLK, RST;
  output par_err;
  wire   n14, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n2, n13;

  DFFRQX2M par_err_reg ( .D(n2), .CK(CLK), .RN(RST), .Q(n14) );
  NOR4BBX2M U3 ( .AN(bit_cnt[3]), .BN(bit_cnt[0]), .C(bit_cnt[2]), .D(
        bit_cnt[1]), .Y(n12) );
  CLKBUFX12M U4 ( .A(n14), .Y(par_err) );
  INVX2M U5 ( .A(n6), .Y(n13) );
  NAND4X2M U6 ( .A(edge_cnt[1]), .B(edge_cnt[0]), .C(edge_cnt[2]), .D(n12), 
        .Y(n6) );
  INVX2M U7 ( .A(n3), .Y(n2) );
  AOI33X2M U8 ( .A0(n13), .A1(n4), .A2(par_chk_en), .B0(n5), .B1(n6), .B2(
        par_err), .Y(n3) );
  OR4X1M U9 ( .A(bit_cnt[0]), .B(bit_cnt[1]), .C(bit_cnt[2]), .D(bit_cnt[3]), 
        .Y(n5) );
  XNOR2X2M U10 ( .A(P_DATA[7]), .B(P_DATA[6]), .Y(n11) );
  XNOR2X2M U11 ( .A(P_DATA[3]), .B(P_DATA[2]), .Y(n10) );
  XOR3XLM U12 ( .A(n7), .B(n8), .C(n9), .Y(n4) );
  CLKXOR2X2M U13 ( .A(sampled_bit), .B(PAR_TYP), .Y(n7) );
  XOR3XLM U14 ( .A(P_DATA[1]), .B(P_DATA[0]), .C(n10), .Y(n9) );
  XOR3XLM U15 ( .A(P_DATA[5]), .B(P_DATA[4]), .C(n11), .Y(n8) );
endmodule


module Start_Check ( strt_chk_en, sampled_bit, edge_cnt, strt_glitch );
  input [2:0] edge_cnt;
  input strt_chk_en, sampled_bit;
  output strt_glitch;
  wire   n1;

  AND4X2M U2 ( .A(strt_chk_en), .B(sampled_bit), .C(n1), .D(edge_cnt[2]), .Y(
        strt_glitch) );
  AND2X1M U3 ( .A(edge_cnt[1]), .B(edge_cnt[0]), .Y(n1) );
endmodule


module Stop_Check ( stp_chk_en, sampled_bit, edge_cnt, stp_err );
  input [2:0] edge_cnt;
  input stp_chk_en, sampled_bit;
  output stp_err;
  wire   n1;

  AND4X12M U2 ( .A(stp_chk_en), .B(edge_cnt[2]), .C(n1), .D(edge_cnt[1]), .Y(
        stp_err) );
  NOR2BX2M U3 ( .AN(edge_cnt[0]), .B(sampled_bit), .Y(n1) );
endmodule


module Deserializer ( deser_en, sampled_bit, CLK, RST, edge_cnt, bit_cnt, 
        P_DATA );
  input [2:0] edge_cnt;
  input [3:0] bit_cnt;
  output [7:0] P_DATA;
  input deser_en, sampled_bit, CLK, RST;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32;

  DFFRQX2M \P_DATA_reg[0]  ( .D(n11), .CK(CLK), .RN(n31), .Q(P_DATA[0]) );
  DFFRX1M \P_DATA_reg[5]  ( .D(n21), .CK(CLK), .RN(n31), .Q(P_DATA[5]), .QN(n3) );
  DFFRX1M \P_DATA_reg[1]  ( .D(n19), .CK(CLK), .RN(n31), .Q(P_DATA[1]), .QN(n7) );
  DFFRX1M \P_DATA_reg[4]  ( .D(n22), .CK(CLK), .RN(n31), .Q(P_DATA[4]), .QN(n4) );
  DFFRX1M \P_DATA_reg[7]  ( .D(n12), .CK(CLK), .RN(n31), .Q(P_DATA[7]), .QN(n1) );
  DFFRX1M \P_DATA_reg[3]  ( .D(n16), .CK(CLK), .RN(n31), .Q(P_DATA[3]), .QN(n5) );
  DFFRX1M \P_DATA_reg[6]  ( .D(n20), .CK(CLK), .RN(n31), .Q(P_DATA[6]), .QN(n2) );
  DFFRX1M \P_DATA_reg[2]  ( .D(n23), .CK(CLK), .RN(n31), .Q(P_DATA[2]), .QN(n6) );
  AND2X2M U3 ( .A(n27), .B(n28), .Y(n18) );
  OR2X2M U4 ( .A(n24), .B(n25), .Y(n19) );
  NAND2BX1M U5 ( .AN(bit_cnt[1]), .B(bit_cnt[0]), .Y(n10) );
  OA22X2M U6 ( .A0(n8), .A1(n2), .B0(n30), .B1(n1), .Y(n13) );
  INVX2M U7 ( .A(n13), .Y(n20) );
  OA22X2M U8 ( .A0(n8), .A1(n3), .B0(n30), .B1(n2), .Y(n14) );
  INVX2M U9 ( .A(n14), .Y(n21) );
  OA22X2M U10 ( .A0(n8), .A1(n4), .B0(n30), .B1(n3), .Y(n15) );
  INVX2M U11 ( .A(n15), .Y(n22) );
  OA22X2M U12 ( .A0(n8), .A1(n6), .B0(n30), .B1(n5), .Y(n17) );
  INVX2M U13 ( .A(n17), .Y(n23) );
  OAI22X2M U14 ( .A0(n8), .A1(n5), .B0(n30), .B1(n4), .Y(n16) );
  NOR2X1M U15 ( .A(n30), .B(n6), .Y(n24) );
  NOR2X1M U16 ( .A(n7), .B(n8), .Y(n25) );
  NAND2X5M U17 ( .A(n26), .B(n30), .Y(n8) );
  BUFX6M U18 ( .A(n9), .Y(n30) );
  CLKINVX1M U19 ( .A(bit_cnt[2]), .Y(n27) );
  INVXLM U20 ( .A(bit_cnt[3]), .Y(n28) );
  CLKINVX1M U21 ( .A(n10), .Y(n29) );
  NAND2XLM U22 ( .A(n29), .B(n18), .Y(n26) );
  INVX6M U23 ( .A(n32), .Y(n31) );
  INVX2M U24 ( .A(RST), .Y(n32) );
  OAI2B2X1M U25 ( .A1N(P_DATA[0]), .A0(n8), .B0(n30), .B1(n7), .Y(n11) );
  OAI2B2X1M U26 ( .A1N(sampled_bit), .A0(n30), .B0(n8), .B1(n1), .Y(n12) );
  NAND4X1M U27 ( .A(edge_cnt[2]), .B(edge_cnt[1]), .C(edge_cnt[0]), .D(
        deser_en), .Y(n9) );
endmodule


module UART_RX ( RX_IN, PAR_EN, PAR_TYP, CLK, RST, Prescale, data_valid, 
        Parity_error, Framing_error, P_DATA );
  input [3:0] Prescale;
  output [7:0] P_DATA;
  input RX_IN, PAR_EN, PAR_TYP, CLK, RST;
  output data_valid, Parity_error, Framing_error;
  wire   strt_glitch, par_chk_en, strt_chk_en, stp_chk_en, deser_en, cnt_en,
         data_sample_en, sampled_bit, n1, n2;
  wire   [3:0] bit_cnt;
  wire   [2:0] edge_cnt;

  FSM_RX FSM1 ( .CLK(CLK), .RST(n1), .RX_IN(RX_IN), .PAR_EN(PAR_EN), .par_err(
        Parity_error), .strt_glitch(strt_glitch), .stp_err(Framing_error), 
        .bit_cnt(bit_cnt), .par_chk_en(par_chk_en), .strt_chk_en(strt_chk_en), 
        .stp_chk_en(stp_chk_en), .data_valid(data_valid), .deser_en(deser_en), 
        .cnt_en(cnt_en), .data_sample_en(data_sample_en) );
  Edge_Bit_Counter Counter1 ( .cnt_en(cnt_en), .CLK(CLK), .RST(n1), .edge_cnt(
        edge_cnt), .bit_cnt(bit_cnt) );
  Data_Sampling Sample1 ( .data_sample_en(data_sample_en), .RX_IN(RX_IN), 
        .CLK(CLK), .RST(n1), .edge_cnt(edge_cnt), .Prescale(Prescale), 
        .sampled_bit(sampled_bit) );
  Parity_Check Check2 ( .par_chk_en(par_chk_en), .PAR_TYP(PAR_TYP), 
        .sampled_bit(sampled_bit), .P_DATA(P_DATA), .edge_cnt(edge_cnt), 
        .bit_cnt(bit_cnt), .CLK(CLK), .RST(n1), .par_err(Parity_error) );
  Start_Check Check1 ( .strt_chk_en(strt_chk_en), .sampled_bit(sampled_bit), 
        .edge_cnt(edge_cnt), .strt_glitch(strt_glitch) );
  Stop_Check Check3 ( .stp_chk_en(stp_chk_en), .sampled_bit(sampled_bit), 
        .edge_cnt(edge_cnt), .stp_err(Framing_error) );
  Deserializer Deserializer1 ( .deser_en(deser_en), .sampled_bit(sampled_bit), 
        .CLK(CLK), .RST(n1), .edge_cnt(edge_cnt), .bit_cnt(bit_cnt), .P_DATA(
        P_DATA) );
  INVX4M U1 ( .A(n2), .Y(n1) );
  INVX2M U2 ( .A(RST), .Y(n2) );
endmodule


module UART ( RX_IN, PAR_EN, PAR_TYP, RX_CLK, TX_CLK, RST, Prescale, 
        data_valid_RX, Parity_error, Framing_error, P_DATA_RX, Data_Valid_TX, 
        P_DATA_TX, TX_OUT, Busy );
  input [3:0] Prescale;
  output [7:0] P_DATA_RX;
  input [7:0] P_DATA_TX;
  input RX_IN, PAR_EN, PAR_TYP, RX_CLK, TX_CLK, RST, Data_Valid_TX;
  output data_valid_RX, Parity_error, Framing_error, TX_OUT, Busy;
  wire   n1, n2;

  UART_TX UARTTX ( .CLK(TX_CLK), .RST(n1), .PAR_TYP(PAR_TYP), .PAR_EN(PAR_EN), 
        .Data_Valid(Data_Valid_TX), .P_DATA(P_DATA_TX), .TX_OUT(TX_OUT), 
        .Busy(Busy) );
  UART_RX UARTRX ( .RX_IN(RX_IN), .PAR_EN(PAR_EN), .PAR_TYP(PAR_TYP), .CLK(
        RX_CLK), .RST(n1), .Prescale(Prescale), .data_valid(data_valid_RX), 
        .Parity_error(Parity_error), .Framing_error(Framing_error), .P_DATA(
        P_DATA_RX) );
  INVX2M U1 ( .A(n2), .Y(n1) );
  INVX2M U2 ( .A(RST), .Y(n2) );
endmodule


module DATA_SYNC_NUM_STAGES2_BUS_WIDTH8_1 ( Unsync_bus, bus_enable, CLK, RST, 
        enable_pulse, sync_bus );
  input [7:0] Unsync_bus;
  output [7:0] sync_bus;
  input bus_enable, CLK, RST;
  output enable_pulse;
  wire   Pulse_GenFF, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13,
         n14;
  wire   [1:0] Multi_Flop;

  DFFRQX2M Pulse_GenFF_reg ( .D(Multi_Flop[0]), .CK(CLK), .RN(n12), .Q(
        Pulse_GenFF) );
  DFFRQX2M \Multi_Flop_reg[0]  ( .D(Multi_Flop[1]), .CK(CLK), .RN(n12), .Q(
        Multi_Flop[0]) );
  DFFRQX2M \sync_bus_reg[6]  ( .D(n8), .CK(CLK), .RN(n12), .Q(sync_bus[6]) );
  DFFRQX2M \sync_bus_reg[2]  ( .D(n4), .CK(CLK), .RN(n12), .Q(sync_bus[2]) );
  DFFRQX2M \sync_bus_reg[5]  ( .D(n7), .CK(CLK), .RN(n12), .Q(sync_bus[5]) );
  DFFRQX2M \sync_bus_reg[7]  ( .D(n9), .CK(CLK), .RN(n12), .Q(sync_bus[7]) );
  DFFRQX2M \Multi_Flop_reg[1]  ( .D(bus_enable), .CK(CLK), .RN(n12), .Q(
        Multi_Flop[1]) );
  DFFRQX4M \sync_bus_reg[1]  ( .D(n3), .CK(CLK), .RN(n12), .Q(sync_bus[1]) );
  DFFRQX4M enable_pulse_reg ( .D(n14), .CK(CLK), .RN(n12), .Q(enable_pulse) );
  DFFRQX4M \sync_bus_reg[0]  ( .D(n2), .CK(CLK), .RN(n12), .Q(sync_bus[0]) );
  DFFRQX4M \sync_bus_reg[4]  ( .D(n6), .CK(CLK), .RN(n12), .Q(sync_bus[4]) );
  DFFRQX4M \sync_bus_reg[3]  ( .D(n5), .CK(CLK), .RN(n12), .Q(sync_bus[3]) );
  INVX6M U3 ( .A(n10), .Y(n14) );
  BUFX4M U4 ( .A(n1), .Y(n10) );
  BUFX4M U5 ( .A(n1), .Y(n11) );
  INVX8M U6 ( .A(n13), .Y(n12) );
  INVX2M U7 ( .A(RST), .Y(n13) );
  NAND2BX2M U8 ( .AN(Pulse_GenFF), .B(Multi_Flop[0]), .Y(n1) );
  AO22X1M U9 ( .A0(Unsync_bus[4]), .A1(n14), .B0(sync_bus[4]), .B1(n11), .Y(n6) );
  AO22X1M U10 ( .A0(Unsync_bus[0]), .A1(n14), .B0(sync_bus[0]), .B1(n10), .Y(
        n2) );
  AO22X1M U11 ( .A0(Unsync_bus[1]), .A1(n14), .B0(sync_bus[1]), .B1(n10), .Y(
        n3) );
  AO22X1M U12 ( .A0(Unsync_bus[3]), .A1(n14), .B0(sync_bus[3]), .B1(n11), .Y(
        n5) );
  AO22X1M U13 ( .A0(Unsync_bus[7]), .A1(n14), .B0(sync_bus[7]), .B1(n11), .Y(
        n9) );
  AO22X1M U14 ( .A0(Unsync_bus[2]), .A1(n14), .B0(sync_bus[2]), .B1(n10), .Y(
        n4) );
  AO22X1M U15 ( .A0(Unsync_bus[6]), .A1(n14), .B0(sync_bus[6]), .B1(n11), .Y(
        n8) );
  AO22X1M U16 ( .A0(Unsync_bus[5]), .A1(n14), .B0(sync_bus[5]), .B1(n11), .Y(
        n7) );
endmodule


module BIT_SYNC_NUM_STAGES2_BUS_WIDTH1_1 ( ASYNC, CLK, RST, SYNC );
  input [0:0] ASYNC;
  output [0:0] SYNC;
  input CLK, RST;
  wire   \Multi_Flop[0][0] , n1;

  DFFRQX2M \Multi_Flop_reg[1][0]  ( .D(\Multi_Flop[0][0] ), .CK(CLK), .RN(n1), 
        .Q(SYNC[0]) );
  DFFRQX2M \Multi_Flop_reg[0][0]  ( .D(ASYNC[0]), .CK(CLK), .RN(n1), .Q(
        \Multi_Flop[0][0] ) );
  CLKBUFX2M U3 ( .A(RST), .Y(n1) );
endmodule


module BIT_SYNC_NUM_STAGES2_BUS_WIDTH1_0 ( ASYNC, CLK, RST, SYNC );
  input [0:0] ASYNC;
  output [0:0] SYNC;
  input CLK, RST;
  wire   \Multi_Flop[0][0] ;

  DFFRQX2M \Multi_Flop_reg[1][0]  ( .D(\Multi_Flop[0][0] ), .CK(CLK), .RN(RST), 
        .Q(SYNC[0]) );
  DFFRQX2M \Multi_Flop_reg[0][0]  ( .D(ASYNC[0]), .CK(CLK), .RN(RST), .Q(
        \Multi_Flop[0][0] ) );
endmodule


module DATA_SYNC_NUM_STAGES2_BUS_WIDTH8_0 ( Unsync_bus, bus_enable, CLK, RST, 
        enable_pulse, sync_bus );
  input [7:0] Unsync_bus;
  output [7:0] sync_bus;
  input bus_enable, CLK, RST;
  output enable_pulse;
  wire   Pulse_GenFF, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23;
  wire   [1:0] Multi_Flop;

  DFFRQX2M Pulse_GenFF_reg ( .D(Multi_Flop[0]), .CK(CLK), .RN(n12), .Q(
        Pulse_GenFF) );
  DFFRQX2M \Multi_Flop_reg[0]  ( .D(Multi_Flop[1]), .CK(CLK), .RN(n12), .Q(
        Multi_Flop[0]) );
  DFFRQX2M \sync_bus_reg[5]  ( .D(n17), .CK(CLK), .RN(n12), .Q(sync_bus[5]) );
  DFFRQX2M \sync_bus_reg[1]  ( .D(n21), .CK(CLK), .RN(n12), .Q(sync_bus[1]) );
  DFFRQX2M \sync_bus_reg[4]  ( .D(n18), .CK(CLK), .RN(n12), .Q(sync_bus[4]) );
  DFFRQX2M \sync_bus_reg[0]  ( .D(n22), .CK(CLK), .RN(n12), .Q(sync_bus[0]) );
  DFFRQX2M \sync_bus_reg[3]  ( .D(n19), .CK(CLK), .RN(n12), .Q(sync_bus[3]) );
  DFFRQX2M \sync_bus_reg[7]  ( .D(n15), .CK(CLK), .RN(n12), .Q(sync_bus[7]) );
  DFFRQX2M \sync_bus_reg[2]  ( .D(n20), .CK(CLK), .RN(n12), .Q(sync_bus[2]) );
  DFFRQX2M \sync_bus_reg[6]  ( .D(n16), .CK(CLK), .RN(n12), .Q(sync_bus[6]) );
  DFFRQX2M enable_pulse_reg ( .D(n14), .CK(CLK), .RN(n12), .Q(enable_pulse) );
  DFFRQX2M \Multi_Flop_reg[1]  ( .D(bus_enable), .CK(CLK), .RN(n12), .Q(
        Multi_Flop[1]) );
  INVX6M U3 ( .A(n10), .Y(n14) );
  BUFX4M U4 ( .A(n23), .Y(n10) );
  BUFX4M U5 ( .A(n23), .Y(n11) );
  INVX8M U6 ( .A(n13), .Y(n12) );
  INVX2M U7 ( .A(RST), .Y(n13) );
  NAND2BX2M U8 ( .AN(Pulse_GenFF), .B(Multi_Flop[0]), .Y(n23) );
  AO22X1M U9 ( .A0(Unsync_bus[0]), .A1(n14), .B0(sync_bus[0]), .B1(n10), .Y(
        n22) );
  AO22X1M U10 ( .A0(Unsync_bus[1]), .A1(n14), .B0(sync_bus[1]), .B1(n10), .Y(
        n21) );
  AO22X1M U11 ( .A0(Unsync_bus[2]), .A1(n14), .B0(sync_bus[2]), .B1(n10), .Y(
        n20) );
  AO22X1M U12 ( .A0(Unsync_bus[3]), .A1(n14), .B0(sync_bus[3]), .B1(n11), .Y(
        n19) );
  AO22X1M U13 ( .A0(Unsync_bus[4]), .A1(n14), .B0(sync_bus[4]), .B1(n11), .Y(
        n18) );
  AO22X1M U14 ( .A0(Unsync_bus[5]), .A1(n14), .B0(sync_bus[5]), .B1(n11), .Y(
        n17) );
  AO22X1M U15 ( .A0(Unsync_bus[6]), .A1(n14), .B0(sync_bus[6]), .B1(n11), .Y(
        n16) );
  AO22X1M U16 ( .A0(Unsync_bus[7]), .A1(n14), .B0(sync_bus[7]), .B1(n11), .Y(
        n15) );
endmodule


module RST_SYNC_1 ( RST, CLK, SYNC_RST );
  input RST, CLK;
  output SYNC_RST;
  wire   \Multi_Flop[1] ;

  DFFRQX2M \Multi_Flop_reg[0]  ( .D(\Multi_Flop[1] ), .CK(CLK), .RN(RST), .Q(
        SYNC_RST) );
  DFFRQX2M \Multi_Flop_reg[1]  ( .D(1'b1), .CK(CLK), .RN(RST), .Q(
        \Multi_Flop[1] ) );
endmodule


module RST_SYNC_0 ( RST, CLK, SYNC_RST );
  input RST, CLK;
  output SYNC_RST;
  wire   \Multi_Flop[1] ;

  DFFRQX2M \Multi_Flop_reg[0]  ( .D(\Multi_Flop[1] ), .CK(CLK), .RN(RST), .Q(
        SYNC_RST) );
  DFFRQX2M \Multi_Flop_reg[1]  ( .D(1'b1), .CK(CLK), .RN(RST), .Q(
        \Multi_Flop[1] ) );
endmodule


module CLK_Divider_DW01_sub_0 ( A, B, CI, DIFF, CO );
  input [5:0] A;
  input [5:0] B;
  output [5:0] DIFF;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6;
  wire   [6:0] carry;

  ADDFX2M U2_4 ( .A(A[4]), .B(n6), .CI(carry[4]), .CO(carry[5]), .S(DIFF[4])
         );
  ADDFX2M U2_3 ( .A(A[3]), .B(n5), .CI(carry[3]), .CO(carry[4]), .S(DIFF[3])
         );
  ADDFX2M U2_2 ( .A(A[2]), .B(n4), .CI(carry[2]), .CO(carry[3]), .S(DIFF[2])
         );
  ADDFX2M U2_1 ( .A(A[1]), .B(n3), .CI(carry[1]), .CO(carry[2]), .S(DIFF[1])
         );
  CLKXOR2X2M U1 ( .A(n1), .B(carry[5]), .Y(DIFF[5]) );
  INVX2M U2 ( .A(B[5]), .Y(n1) );
  XNOR2X2M U3 ( .A(n2), .B(A[0]), .Y(DIFF[0]) );
  INVX2M U4 ( .A(B[0]), .Y(n2) );
  INVX2M U5 ( .A(B[1]), .Y(n3) );
  OR2X2M U6 ( .A(A[0]), .B(n2), .Y(carry[1]) );
  INVX2M U7 ( .A(B[2]), .Y(n4) );
  INVX2M U8 ( .A(B[3]), .Y(n5) );
  INVX2M U9 ( .A(B[4]), .Y(n6) );
endmodule


module CLK_Divider ( i_ref_clk, i_rst_n, i_clk_en, i_div_ratio, o_div_clk );
  input [4:0] i_div_ratio;
  input i_ref_clk, i_rst_n, i_clk_en;
  output o_div_clk;
  wire   N1, out_seq, N4, N10, N11, N12, N13, N14, N15, N17, N18, N19, N20,
         N21, N22, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n33, n36, n39, n42, n43, \add_29/carry[5] , \add_29/carry[4] ,
         \add_29/carry[3] , \add_29/carry[2] , n2, n3, n4, n5, n6, n7, n8, n9,
         n10, n11, n12, n13, n14, n15, n16, n17, n18, n31, n32, n34, n35, n37,
         n38, n40, n41, n44;
  wire   [5:0] Duty;
  wire   [5:0] Counter;

  AOI221X4M U34 ( .A0(Counter[0]), .A1(n20), .B0(N17), .B1(n21), .C0(n10), .Y(
        n22) );
  NOR2X12M U36 ( .A(n10), .B(N1), .Y(n21) );
  CLK_Divider_DW01_sub_0 sub_25 ( .A({1'b0, i_div_ratio}), .B(Duty), .CI(1'b0), 
        .DIFF({N15, N14, N13, N12, N11, N10}) );
  DFFRQX2M out_seq_reg ( .D(n24), .CK(i_ref_clk), .RN(n11), .Q(out_seq) );
  DFFSRHQX2M \Duty_reg[2]  ( .D(n33), .CK(i_ref_clk), .SN(n3), .RN(n7), .Q(
        Duty[2]) );
  DFFSRHQX2M \Duty_reg[3]  ( .D(n30), .CK(i_ref_clk), .SN(n2), .RN(n6), .Q(
        Duty[3]) );
  DFFRQX2M \Duty_reg[4]  ( .D(n29), .CK(i_ref_clk), .RN(n11), .Q(Duty[4]) );
  DFFRQX2M \Counter_reg[5]  ( .D(n43), .CK(i_ref_clk), .RN(n11), .Q(Counter[5]) );
  DFFRQX2M \Duty_reg[5]  ( .D(n42), .CK(i_ref_clk), .RN(n11), .Q(Duty[5]) );
  DFFSRHQX4M \Duty_reg[0]  ( .D(n39), .CK(i_ref_clk), .SN(n5), .RN(n9), .Q(
        Duty[0]) );
  DFFSRHQX4M \Duty_reg[1]  ( .D(n36), .CK(i_ref_clk), .SN(n4), .RN(n8), .Q(
        Duty[1]) );
  DFFRQX4M \Counter_reg[1]  ( .D(n28), .CK(i_ref_clk), .RN(n11), .Q(Counter[1]) );
  DFFRQX2M \Counter_reg[4]  ( .D(n25), .CK(i_ref_clk), .RN(n11), .Q(Counter[4]) );
  DFFRQX2M \Counter_reg[3]  ( .D(n26), .CK(i_ref_clk), .RN(n11), .Q(Counter[3]) );
  DFFRQX2M \Counter_reg[2]  ( .D(n27), .CK(i_ref_clk), .RN(n11), .Q(Counter[2]) );
  DFFSX4M \Counter_reg[0]  ( .D(n37), .CK(i_ref_clk), .SN(i_rst_n), .Q(
        Counter[0]), .QN(N17) );
  OAI2B2X1M U3 ( .A1N(Duty[1]), .A0(n13), .B0(Counter[1]), .B1(n13), .Y(n17)
         );
  OAI2B2X1M U4 ( .A1N(Counter[1]), .A0(n14), .B0(Duty[1]), .B1(n14), .Y(n16)
         );
  NOR2BX4M U6 ( .AN(Duty[0]), .B(Counter[0]), .Y(n14) );
  NOR4X2M U7 ( .A(n34), .B(n32), .C(n31), .D(n18), .Y(N4) );
  NOR2BX4M U8 ( .AN(Counter[0]), .B(Duty[0]), .Y(n13) );
  CLKBUFX8M U9 ( .A(n19), .Y(n10) );
  ADDHX1M U10 ( .A(Counter[2]), .B(\add_29/carry[2] ), .CO(\add_29/carry[3] ), 
        .S(N19) );
  ADDHX1M U11 ( .A(Counter[3]), .B(\add_29/carry[3] ), .CO(\add_29/carry[4] ), 
        .S(N20) );
  ADDHX1M U12 ( .A(Counter[1]), .B(Counter[0]), .CO(\add_29/carry[2] ), .S(N18) );
  ADDHX1M U13 ( .A(Counter[4]), .B(\add_29/carry[4] ), .CO(\add_29/carry[5] ), 
        .S(N21) );
  CLKINVX12M U14 ( .A(n12), .Y(n11) );
  NOR2X8M U15 ( .A(n10), .B(n21), .Y(n20) );
  INVX4M U16 ( .A(n10), .Y(n35) );
  INVX2M U17 ( .A(i_rst_n), .Y(n12) );
  OR2X2M U18 ( .A(n11), .B(n38), .Y(n2) );
  OR2X2M U19 ( .A(n11), .B(n40), .Y(n3) );
  OR2X2M U20 ( .A(n11), .B(n41), .Y(n4) );
  OR2X2M U21 ( .A(n11), .B(n44), .Y(n5) );
  CLKMX2X4M U22 ( .A(out_seq), .B(i_ref_clk), .S0(N1), .Y(o_div_clk) );
  CLKXOR2X2M U23 ( .A(out_seq), .B(n10), .Y(n24) );
  NOR2BX1M U24 ( .AN(N4), .B(N1), .Y(n19) );
  INVX2M U25 ( .A(n22), .Y(n37) );
  AO22X1M U26 ( .A0(Counter[1]), .A1(n20), .B0(N18), .B1(n21), .Y(n28) );
  AO22X1M U27 ( .A0(Counter[2]), .A1(n20), .B0(N19), .B1(n21), .Y(n27) );
  AO22X1M U28 ( .A0(Counter[3]), .A1(n20), .B0(N20), .B1(n21), .Y(n26) );
  AO22X1M U29 ( .A0(Counter[4]), .A1(n20), .B0(N21), .B1(n21), .Y(n25) );
  AO22X1M U30 ( .A0(Counter[5]), .A1(n20), .B0(N22), .B1(n21), .Y(n43) );
  AO22X1M U31 ( .A0(N14), .A1(n10), .B0(Duty[4]), .B1(n35), .Y(n29) );
  AO22X1M U32 ( .A0(N15), .A1(n10), .B0(Duty[5]), .B1(n35), .Y(n42) );
  AO22X1M U33 ( .A0(N13), .A1(n10), .B0(Duty[3]), .B1(n35), .Y(n30) );
  AO22X1M U35 ( .A0(N12), .A1(n10), .B0(Duty[2]), .B1(n35), .Y(n33) );
  AO22X1M U37 ( .A0(N11), .A1(n10), .B0(Duty[1]), .B1(n35), .Y(n36) );
  AO22X1M U38 ( .A0(N10), .A1(n10), .B0(Duty[0]), .B1(n35), .Y(n39) );
  NAND2X4M U39 ( .A(i_clk_en), .B(n23), .Y(N1) );
  NAND4X2M U40 ( .A(n44), .B(n41), .C(n40), .D(n38), .Y(n23) );
  INVX2M U41 ( .A(i_div_ratio[1]), .Y(n44) );
  INVX2M U42 ( .A(i_div_ratio[2]), .Y(n41) );
  INVX2M U43 ( .A(i_div_ratio[4]), .Y(n38) );
  INVX2M U44 ( .A(i_div_ratio[3]), .Y(n40) );
  OR2X2M U45 ( .A(n11), .B(i_div_ratio[4]), .Y(n6) );
  OR2X2M U46 ( .A(n11), .B(i_div_ratio[3]), .Y(n7) );
  OR2X2M U47 ( .A(n11), .B(i_div_ratio[2]), .Y(n8) );
  OR2X2M U48 ( .A(n11), .B(i_div_ratio[1]), .Y(n9) );
  CLKXOR2X2M U49 ( .A(\add_29/carry[5] ), .B(Counter[5]), .Y(N22) );
  XNOR2X1M U50 ( .A(Duty[5]), .B(Counter[5]), .Y(n15) );
  NAND3X1M U51 ( .A(n17), .B(n16), .C(n15), .Y(n34) );
  CLKXOR2X2M U52 ( .A(Duty[4]), .B(Counter[4]), .Y(n32) );
  CLKXOR2X2M U53 ( .A(Duty[2]), .B(Counter[2]), .Y(n31) );
  CLKXOR2X2M U54 ( .A(Duty[3]), .B(Counter[3]), .Y(n18) );
endmodule


module CLK_Gate ( Enable, CLK, Gated_CLK );
  input Enable, CLK;
  output Gated_CLK;
  wire   enable_latch;

  CLKAND2X16M U2 ( .A(enable_latch), .B(CLK), .Y(Gated_CLK) );
  TLATNX2M enable_latch_reg ( .D(Enable), .GN(CLK), .Q(enable_latch) );
endmodule


module Decoder2X4 ( Enable, ALU_FUN, Arith_Enable, Logic_Enable, CMP_Enable, 
        Shift_Enable );
  input [1:0] ALU_FUN;
  output [0:0] Arith_Enable;
  output [0:0] Logic_Enable;
  output [0:0] CMP_Enable;
  output [0:0] Shift_Enable;
  input Enable;
  wire   n5, n2, n3, n4;

  INVX4M U3 ( .A(n5), .Y(Logic_Enable[0]) );
  OR3X2M U4 ( .A(n4), .B(ALU_FUN[1]), .C(n2), .Y(n5) );
  NOR3X6M U5 ( .A(n4), .B(n2), .C(n3), .Y(Shift_Enable[0]) );
  NOR3X4M U6 ( .A(n4), .B(ALU_FUN[0]), .C(n3), .Y(CMP_Enable[0]) );
  INVX4M U7 ( .A(Enable), .Y(n4) );
  INVX2M U8 ( .A(ALU_FUN[0]), .Y(n2) );
  INVX2M U9 ( .A(ALU_FUN[1]), .Y(n3) );
  NOR3X2M U10 ( .A(n4), .B(ALU_FUN[1]), .C(ALU_FUN[0]), .Y(Arith_Enable[0]) );
endmodule


module Decoder2X4_ALU_OUT_Width16 ( ALU_FUN, Arith_OUT, Logic_OUT, CMP_OUT, 
        Shift_OUT, ALU_OUT );
  input [1:0] ALU_FUN;
  input [15:0] Arith_OUT;
  input [15:0] Logic_OUT;
  input [15:0] CMP_OUT;
  input [15:0] Shift_OUT;
  output [15:0] ALU_OUT;
  wire   n2, n3, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n1, n4, n5, n6, n7, n38, n39, n40, n41, n42, n43, n44,
         n45;

  NAND2X2M U1 ( .A(ALU_FUN[1]), .B(n45), .Y(n1) );
  NAND2X2M U2 ( .A(ALU_FUN[1]), .B(ALU_FUN[0]), .Y(n4) );
  OR2X2M U3 ( .A(n45), .B(ALU_FUN[1]), .Y(n5) );
  OR2X2M U4 ( .A(ALU_FUN[0]), .B(ALU_FUN[1]), .Y(n6) );
  INVX6M U5 ( .A(n5), .Y(n38) );
  INVX6M U6 ( .A(n5), .Y(n7) );
  INVX6M U7 ( .A(n6), .Y(n40) );
  INVX6M U8 ( .A(n6), .Y(n39) );
  INVX6M U9 ( .A(n4), .Y(n42) );
  INVX6M U10 ( .A(n4), .Y(n41) );
  INVX6M U11 ( .A(n1), .Y(n44) );
  INVX6M U12 ( .A(n1), .Y(n43) );
  INVX2M U13 ( .A(ALU_FUN[0]), .Y(n45) );
  NAND2X2M U14 ( .A(n36), .B(n37), .Y(ALU_OUT[0]) );
  AOI22X1M U15 ( .A0(Logic_OUT[0]), .A1(n7), .B0(Arith_OUT[0]), .B1(n39), .Y(
        n36) );
  AOI22X1M U16 ( .A0(Shift_OUT[0]), .A1(n41), .B0(CMP_OUT[0]), .B1(n43), .Y(
        n37) );
  NAND2X2M U17 ( .A(n22), .B(n23), .Y(ALU_OUT[1]) );
  AOI22X1M U18 ( .A0(Logic_OUT[1]), .A1(n38), .B0(Arith_OUT[1]), .B1(n40), .Y(
        n22) );
  AOI22X1M U19 ( .A0(Shift_OUT[1]), .A1(n42), .B0(CMP_OUT[1]), .B1(n44), .Y(
        n23) );
  NAND2X2M U20 ( .A(n20), .B(n21), .Y(ALU_OUT[2]) );
  AOI22X1M U21 ( .A0(Shift_OUT[2]), .A1(n41), .B0(CMP_OUT[2]), .B1(n43), .Y(
        n21) );
  AOI22X1M U22 ( .A0(Logic_OUT[2]), .A1(n7), .B0(Arith_OUT[2]), .B1(n39), .Y(
        n20) );
  NAND2X2M U23 ( .A(n18), .B(n19), .Y(ALU_OUT[3]) );
  AOI22X1M U24 ( .A0(Shift_OUT[3]), .A1(n42), .B0(CMP_OUT[3]), .B1(n44), .Y(
        n19) );
  AOI22X1M U25 ( .A0(Logic_OUT[3]), .A1(n38), .B0(Arith_OUT[3]), .B1(n40), .Y(
        n18) );
  NAND2X2M U26 ( .A(n16), .B(n17), .Y(ALU_OUT[4]) );
  AOI22X1M U27 ( .A0(Shift_OUT[4]), .A1(n41), .B0(CMP_OUT[4]), .B1(n43), .Y(
        n17) );
  AOI22X1M U28 ( .A0(Logic_OUT[4]), .A1(n7), .B0(Arith_OUT[4]), .B1(n39), .Y(
        n16) );
  NAND2X2M U29 ( .A(n14), .B(n15), .Y(ALU_OUT[5]) );
  AOI22X1M U30 ( .A0(Shift_OUT[5]), .A1(n42), .B0(CMP_OUT[5]), .B1(n44), .Y(
        n15) );
  AOI22X1M U31 ( .A0(Logic_OUT[5]), .A1(n38), .B0(Arith_OUT[5]), .B1(n40), .Y(
        n14) );
  NAND2X2M U32 ( .A(n12), .B(n13), .Y(ALU_OUT[6]) );
  AOI22X1M U33 ( .A0(Shift_OUT[6]), .A1(n41), .B0(CMP_OUT[6]), .B1(n43), .Y(
        n13) );
  AOI22X1M U34 ( .A0(Logic_OUT[6]), .A1(n7), .B0(Arith_OUT[6]), .B1(n39), .Y(
        n12) );
  NAND2X2M U35 ( .A(n10), .B(n11), .Y(ALU_OUT[7]) );
  AOI22X1M U36 ( .A0(Shift_OUT[7]), .A1(n42), .B0(CMP_OUT[7]), .B1(n44), .Y(
        n11) );
  AOI22X1M U37 ( .A0(Logic_OUT[7]), .A1(n38), .B0(Arith_OUT[7]), .B1(n40), .Y(
        n10) );
  NAND2X2M U38 ( .A(n8), .B(n9), .Y(ALU_OUT[8]) );
  AOI22X1M U39 ( .A0(Shift_OUT[8]), .A1(n41), .B0(CMP_OUT[8]), .B1(n43), .Y(n9) );
  AOI22X1M U40 ( .A0(Logic_OUT[8]), .A1(n7), .B0(Arith_OUT[8]), .B1(n39), .Y(
        n8) );
  NAND2X2M U41 ( .A(n2), .B(n3), .Y(ALU_OUT[9]) );
  AOI22X1M U42 ( .A0(Shift_OUT[9]), .A1(n42), .B0(CMP_OUT[9]), .B1(n44), .Y(n3) );
  AOI22X1M U43 ( .A0(Logic_OUT[9]), .A1(n38), .B0(Arith_OUT[9]), .B1(n40), .Y(
        n2) );
  NAND2X2M U44 ( .A(n34), .B(n35), .Y(ALU_OUT[10]) );
  AOI22X1M U45 ( .A0(Shift_OUT[10]), .A1(n42), .B0(CMP_OUT[10]), .B1(n44), .Y(
        n35) );
  AOI22X1M U46 ( .A0(Logic_OUT[10]), .A1(n38), .B0(Arith_OUT[10]), .B1(n40), 
        .Y(n34) );
  NAND2X2M U47 ( .A(n32), .B(n33), .Y(ALU_OUT[11]) );
  AOI22X1M U48 ( .A0(Shift_OUT[11]), .A1(n41), .B0(CMP_OUT[11]), .B1(n43), .Y(
        n33) );
  AOI22X1M U49 ( .A0(Logic_OUT[11]), .A1(n7), .B0(Arith_OUT[11]), .B1(n39), 
        .Y(n32) );
  NAND2X2M U50 ( .A(n30), .B(n31), .Y(ALU_OUT[12]) );
  AOI22X1M U51 ( .A0(Shift_OUT[12]), .A1(n42), .B0(CMP_OUT[12]), .B1(n44), .Y(
        n31) );
  AOI22X1M U52 ( .A0(Logic_OUT[12]), .A1(n38), .B0(Arith_OUT[12]), .B1(n40), 
        .Y(n30) );
  NAND2X2M U53 ( .A(n28), .B(n29), .Y(ALU_OUT[13]) );
  AOI22X1M U54 ( .A0(Shift_OUT[13]), .A1(n41), .B0(CMP_OUT[13]), .B1(n43), .Y(
        n29) );
  AOI22X1M U55 ( .A0(Logic_OUT[13]), .A1(n7), .B0(Arith_OUT[13]), .B1(n39), 
        .Y(n28) );
  NAND2X2M U56 ( .A(n26), .B(n27), .Y(ALU_OUT[14]) );
  AOI22X1M U57 ( .A0(Shift_OUT[14]), .A1(n42), .B0(CMP_OUT[14]), .B1(n44), .Y(
        n27) );
  AOI22X1M U58 ( .A0(Logic_OUT[14]), .A1(n38), .B0(Arith_OUT[14]), .B1(n40), 
        .Y(n26) );
  NAND2X2M U59 ( .A(n24), .B(n25), .Y(ALU_OUT[15]) );
  AOI22X1M U60 ( .A0(Shift_OUT[15]), .A1(n41), .B0(CMP_OUT[15]), .B1(n43), .Y(
        n25) );
  AOI22X1M U61 ( .A0(Logic_OUT[15]), .A1(n7), .B0(Arith_OUT[15]), .B1(n39), 
        .Y(n24) );
endmodule


module Arithmatic_Unit_Width16_DW_div_uns_0 ( a, b, quotient, remainder, 
        divide_by_0 );
  input [7:0] a;
  input [7:0] b;
  output [7:0] quotient;
  output [7:0] remainder;
  output divide_by_0;
  wire   n14, \u_div/SumTmp[1][0] , \u_div/SumTmp[1][1] , \u_div/SumTmp[1][2] ,
         \u_div/SumTmp[1][3] , \u_div/SumTmp[1][4] , \u_div/SumTmp[1][5] ,
         \u_div/SumTmp[1][6] , \u_div/SumTmp[2][0] , \u_div/SumTmp[2][1] ,
         \u_div/SumTmp[2][2] , \u_div/SumTmp[2][3] , \u_div/SumTmp[2][4] ,
         \u_div/SumTmp[2][5] , \u_div/SumTmp[3][0] , \u_div/SumTmp[3][1] ,
         \u_div/SumTmp[3][2] , \u_div/SumTmp[3][3] , \u_div/SumTmp[3][4] ,
         \u_div/SumTmp[4][0] , \u_div/SumTmp[4][1] , \u_div/SumTmp[4][2] ,
         \u_div/SumTmp[4][3] , \u_div/SumTmp[5][0] , \u_div/SumTmp[5][1] ,
         \u_div/SumTmp[5][2] , \u_div/SumTmp[6][0] , \u_div/SumTmp[6][1] ,
         \u_div/SumTmp[7][0] , \u_div/CryTmp[0][1] , \u_div/CryTmp[0][2] ,
         \u_div/CryTmp[0][3] , \u_div/CryTmp[0][4] , \u_div/CryTmp[0][5] ,
         \u_div/CryTmp[0][6] , \u_div/CryTmp[0][7] , \u_div/CryTmp[1][1] ,
         \u_div/CryTmp[1][2] , \u_div/CryTmp[1][3] , \u_div/CryTmp[1][4] ,
         \u_div/CryTmp[1][5] , \u_div/CryTmp[1][6] , \u_div/CryTmp[1][7] ,
         \u_div/CryTmp[2][1] , \u_div/CryTmp[2][2] , \u_div/CryTmp[2][3] ,
         \u_div/CryTmp[2][4] , \u_div/CryTmp[2][5] , \u_div/CryTmp[2][6] ,
         \u_div/CryTmp[3][1] , \u_div/CryTmp[3][2] , \u_div/CryTmp[3][3] ,
         \u_div/CryTmp[3][4] , \u_div/CryTmp[3][5] , \u_div/CryTmp[4][1] ,
         \u_div/CryTmp[4][2] , \u_div/CryTmp[4][3] , \u_div/CryTmp[4][4] ,
         \u_div/CryTmp[5][1] , \u_div/CryTmp[5][2] , \u_div/CryTmp[5][3] ,
         \u_div/CryTmp[6][1] , \u_div/CryTmp[6][2] , \u_div/CryTmp[7][1] ,
         \u_div/PartRem[1][1] , \u_div/PartRem[1][2] , \u_div/PartRem[1][3] ,
         \u_div/PartRem[1][4] , \u_div/PartRem[1][5] , \u_div/PartRem[1][6] ,
         \u_div/PartRem[1][7] , \u_div/PartRem[2][1] , \u_div/PartRem[2][2] ,
         \u_div/PartRem[2][3] , \u_div/PartRem[2][4] , \u_div/PartRem[2][5] ,
         \u_div/PartRem[2][6] , \u_div/PartRem[3][1] , \u_div/PartRem[3][2] ,
         \u_div/PartRem[3][3] , \u_div/PartRem[3][4] , \u_div/PartRem[3][5] ,
         \u_div/PartRem[4][1] , \u_div/PartRem[4][2] , \u_div/PartRem[4][3] ,
         \u_div/PartRem[4][4] , \u_div/PartRem[5][1] , \u_div/PartRem[5][2] ,
         \u_div/PartRem[5][3] , \u_div/PartRem[6][1] , \u_div/PartRem[6][2] ,
         \u_div/PartRem[7][1] , n1, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12,
         n13;

  ADDFX2M \u_div/u_fa_PartRem_0_6_1  ( .A(\u_div/PartRem[7][1] ), .B(n9), .CI(
        \u_div/CryTmp[6][1] ), .CO(\u_div/CryTmp[6][2] ), .S(
        \u_div/SumTmp[6][1] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_0_1  ( .A(\u_div/PartRem[1][1] ), .B(n9), .CI(
        \u_div/CryTmp[0][1] ), .CO(\u_div/CryTmp[0][2] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_1_1  ( .A(\u_div/PartRem[2][1] ), .B(n9), .CI(
        \u_div/CryTmp[1][1] ), .CO(\u_div/CryTmp[1][2] ), .S(
        \u_div/SumTmp[1][1] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_2_1  ( .A(\u_div/PartRem[3][1] ), .B(n9), .CI(
        \u_div/CryTmp[2][1] ), .CO(\u_div/CryTmp[2][2] ), .S(
        \u_div/SumTmp[2][1] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_3_1  ( .A(\u_div/PartRem[4][1] ), .B(n9), .CI(
        \u_div/CryTmp[3][1] ), .CO(\u_div/CryTmp[3][2] ), .S(
        \u_div/SumTmp[3][1] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_4_1  ( .A(\u_div/PartRem[5][1] ), .B(n9), .CI(
        \u_div/CryTmp[4][1] ), .CO(\u_div/CryTmp[4][2] ), .S(
        \u_div/SumTmp[4][1] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_5_1  ( .A(\u_div/PartRem[6][1] ), .B(n9), .CI(
        \u_div/CryTmp[5][1] ), .CO(\u_div/CryTmp[5][2] ), .S(
        \u_div/SumTmp[5][1] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_1_6  ( .A(\u_div/PartRem[2][6] ), .B(n4), .CI(
        \u_div/CryTmp[1][6] ), .CO(\u_div/CryTmp[1][7] ), .S(
        \u_div/SumTmp[1][6] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_3_4  ( .A(\u_div/PartRem[4][4] ), .B(n6), .CI(
        \u_div/CryTmp[3][4] ), .CO(\u_div/CryTmp[3][5] ), .S(
        \u_div/SumTmp[3][4] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_4_3  ( .A(\u_div/PartRem[5][3] ), .B(n7), .CI(
        \u_div/CryTmp[4][3] ), .CO(\u_div/CryTmp[4][4] ), .S(
        \u_div/SumTmp[4][3] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_5_2  ( .A(\u_div/PartRem[6][2] ), .B(n8), .CI(
        \u_div/CryTmp[5][2] ), .CO(\u_div/CryTmp[5][3] ), .S(
        \u_div/SumTmp[5][2] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_0_6  ( .A(\u_div/PartRem[1][6] ), .B(n4), .CI(
        \u_div/CryTmp[0][6] ), .CO(\u_div/CryTmp[0][7] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_0_7  ( .A(\u_div/PartRem[1][7] ), .B(n3), .CI(
        \u_div/CryTmp[0][7] ), .CO(quotient[0]) );
  ADDFX2M \u_div/u_fa_PartRem_0_0_4  ( .A(\u_div/PartRem[1][4] ), .B(n6), .CI(
        \u_div/CryTmp[0][4] ), .CO(\u_div/CryTmp[0][5] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_0_5  ( .A(\u_div/PartRem[1][5] ), .B(n5), .CI(
        \u_div/CryTmp[0][5] ), .CO(\u_div/CryTmp[0][6] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_1_5  ( .A(\u_div/PartRem[2][5] ), .B(n5), .CI(
        \u_div/CryTmp[1][5] ), .CO(\u_div/CryTmp[1][6] ), .S(
        \u_div/SumTmp[1][5] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_1_4  ( .A(\u_div/PartRem[2][4] ), .B(n6), .CI(
        \u_div/CryTmp[1][4] ), .CO(\u_div/CryTmp[1][5] ), .S(
        \u_div/SumTmp[1][4] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_2_4  ( .A(\u_div/PartRem[3][4] ), .B(n6), .CI(
        \u_div/CryTmp[2][4] ), .CO(\u_div/CryTmp[2][5] ), .S(
        \u_div/SumTmp[2][4] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_0_2  ( .A(\u_div/PartRem[1][2] ), .B(n8), .CI(
        \u_div/CryTmp[0][2] ), .CO(\u_div/CryTmp[0][3] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_0_3  ( .A(\u_div/PartRem[1][3] ), .B(n7), .CI(
        \u_div/CryTmp[0][3] ), .CO(\u_div/CryTmp[0][4] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_1_3  ( .A(\u_div/PartRem[2][3] ), .B(n7), .CI(
        \u_div/CryTmp[1][3] ), .CO(\u_div/CryTmp[1][4] ), .S(
        \u_div/SumTmp[1][3] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_2_3  ( .A(\u_div/PartRem[3][3] ), .B(n7), .CI(
        \u_div/CryTmp[2][3] ), .CO(\u_div/CryTmp[2][4] ), .S(
        \u_div/SumTmp[2][3] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_3_3  ( .A(\u_div/PartRem[4][3] ), .B(n7), .CI(
        \u_div/CryTmp[3][3] ), .CO(\u_div/CryTmp[3][4] ), .S(
        \u_div/SumTmp[3][3] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_1_2  ( .A(\u_div/PartRem[2][2] ), .B(n8), .CI(
        \u_div/CryTmp[1][2] ), .CO(\u_div/CryTmp[1][3] ), .S(
        \u_div/SumTmp[1][2] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_2_2  ( .A(\u_div/PartRem[3][2] ), .B(n8), .CI(
        \u_div/CryTmp[2][2] ), .CO(\u_div/CryTmp[2][3] ), .S(
        \u_div/SumTmp[2][2] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_3_2  ( .A(\u_div/PartRem[4][2] ), .B(n8), .CI(
        \u_div/CryTmp[3][2] ), .CO(\u_div/CryTmp[3][3] ), .S(
        \u_div/SumTmp[3][2] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_4_2  ( .A(\u_div/PartRem[5][2] ), .B(n8), .CI(
        \u_div/CryTmp[4][2] ), .CO(\u_div/CryTmp[4][3] ), .S(
        \u_div/SumTmp[4][2] ) );
  ADDFX2M \u_div/u_fa_PartRem_0_2_5  ( .A(\u_div/PartRem[3][5] ), .B(n5), .CI(
        \u_div/CryTmp[2][5] ), .CO(\u_div/CryTmp[2][6] ), .S(
        \u_div/SumTmp[2][5] ) );
  INVX4M U1 ( .A(b[5]), .Y(n5) );
  INVX6M U2 ( .A(b[1]), .Y(n9) );
  CLKINVX6M U3 ( .A(b[2]), .Y(n8) );
  NOR2X5M U4 ( .A(b[6]), .B(b[7]), .Y(n13) );
  CLKINVX12M U5 ( .A(b[0]), .Y(n10) );
  MX2X1M U6 ( .A(a[7]), .B(\u_div/SumTmp[7][0] ), .S0(quotient[7]), .Y(
        \u_div/PartRem[7][1] ) );
  CLKAND2X3M U7 ( .A(\u_div/CryTmp[2][6] ), .B(n13), .Y(quotient[2]) );
  MX2X1M U8 ( .A(a[6]), .B(\u_div/SumTmp[6][0] ), .S0(quotient[6]), .Y(
        \u_div/PartRem[6][1] ) );
  CLKAND2X4M U9 ( .A(\u_div/CryTmp[4][4] ), .B(n12), .Y(quotient[4]) );
  CLKAND2X4M U10 ( .A(\u_div/CryTmp[5][3] ), .B(n11), .Y(quotient[5]) );
  MX2X2M U11 ( .A(\u_div/PartRem[4][2] ), .B(\u_div/SumTmp[3][2] ), .S0(
        quotient[3]), .Y(\u_div/PartRem[3][3] ) );
  CLKAND2X6M U12 ( .A(\u_div/CryTmp[1][7] ), .B(n3), .Y(quotient[1]) );
  AND3X2M U13 ( .A(n11), .B(n8), .C(\u_div/CryTmp[6][2] ), .Y(quotient[6]) );
  AND2X2M U14 ( .A(n12), .B(n7), .Y(n11) );
  INVX4M U15 ( .A(b[3]), .Y(n7) );
  INVX4M U16 ( .A(b[4]), .Y(n6) );
  MX2X1M U17 ( .A(\u_div/PartRem[3][5] ), .B(\u_div/SumTmp[2][5] ), .S0(
        quotient[2]), .Y(\u_div/PartRem[2][6] ) );
  MX2X1M U18 ( .A(\u_div/PartRem[3][2] ), .B(\u_div/SumTmp[2][2] ), .S0(
        quotient[2]), .Y(\u_div/PartRem[2][3] ) );
  MX2X1M U19 ( .A(\u_div/PartRem[3][4] ), .B(\u_div/SumTmp[2][4] ), .S0(
        quotient[2]), .Y(\u_div/PartRem[2][5] ) );
  MX2X1M U20 ( .A(\u_div/PartRem[3][3] ), .B(\u_div/SumTmp[2][3] ), .S0(
        quotient[2]), .Y(\u_div/PartRem[2][4] ) );
  MX2X1M U21 ( .A(\u_div/PartRem[5][2] ), .B(\u_div/SumTmp[4][2] ), .S0(
        quotient[4]), .Y(\u_div/PartRem[4][3] ) );
  MX2X1M U22 ( .A(\u_div/PartRem[5][3] ), .B(\u_div/SumTmp[4][3] ), .S0(
        quotient[4]), .Y(\u_div/PartRem[4][4] ) );
  MX2X1M U23 ( .A(\u_div/PartRem[6][2] ), .B(\u_div/SumTmp[5][2] ), .S0(
        quotient[5]), .Y(\u_div/PartRem[5][3] ) );
  MX2X1M U24 ( .A(\u_div/PartRem[3][1] ), .B(\u_div/SumTmp[2][1] ), .S0(n14), 
        .Y(\u_div/PartRem[2][2] ) );
  MX2X1M U25 ( .A(\u_div/PartRem[5][1] ), .B(\u_div/SumTmp[4][1] ), .S0(
        quotient[4]), .Y(\u_div/PartRem[4][2] ) );
  MX2X1M U26 ( .A(\u_div/PartRem[6][1] ), .B(\u_div/SumTmp[5][1] ), .S0(
        quotient[5]), .Y(\u_div/PartRem[5][2] ) );
  MX2X1M U27 ( .A(\u_div/PartRem[7][1] ), .B(\u_div/SumTmp[6][1] ), .S0(
        quotient[6]), .Y(\u_div/PartRem[6][2] ) );
  MX2X1M U28 ( .A(\u_div/PartRem[4][1] ), .B(\u_div/SumTmp[3][1] ), .S0(
        quotient[3]), .Y(\u_div/PartRem[3][2] ) );
  CLKAND2X4M U29 ( .A(\u_div/CryTmp[3][5] ), .B(n1), .Y(quotient[3]) );
  INVX1M U30 ( .A(b[6]), .Y(n4) );
  AND2X1M U31 ( .A(n5), .B(n13), .Y(n1) );
  MX2X1M U32 ( .A(\u_div/PartRem[4][4] ), .B(\u_div/SumTmp[3][4] ), .S0(
        quotient[3]), .Y(\u_div/PartRem[3][5] ) );
  MX2X1M U33 ( .A(a[3]), .B(\u_div/SumTmp[3][0] ), .S0(quotient[3]), .Y(
        \u_div/PartRem[3][1] ) );
  MX2X1M U34 ( .A(\u_div/PartRem[4][3] ), .B(\u_div/SumTmp[3][3] ), .S0(
        quotient[3]), .Y(\u_div/PartRem[3][4] ) );
  MX2XLM U35 ( .A(a[1]), .B(\u_div/SumTmp[1][0] ), .S0(quotient[1]), .Y(
        \u_div/PartRem[1][1] ) );
  MX2XLM U36 ( .A(\u_div/PartRem[2][1] ), .B(\u_div/SumTmp[1][1] ), .S0(
        quotient[1]), .Y(\u_div/PartRem[1][2] ) );
  MX2XLM U37 ( .A(\u_div/PartRem[2][2] ), .B(\u_div/SumTmp[1][2] ), .S0(
        quotient[1]), .Y(\u_div/PartRem[1][3] ) );
  MX2XLM U38 ( .A(\u_div/PartRem[2][3] ), .B(\u_div/SumTmp[1][3] ), .S0(
        quotient[1]), .Y(\u_div/PartRem[1][4] ) );
  MX2XLM U39 ( .A(\u_div/PartRem[2][4] ), .B(\u_div/SumTmp[1][4] ), .S0(
        quotient[1]), .Y(\u_div/PartRem[1][5] ) );
  MX2XLM U40 ( .A(\u_div/PartRem[2][5] ), .B(\u_div/SumTmp[1][5] ), .S0(
        quotient[1]), .Y(\u_div/PartRem[1][6] ) );
  OR2X1M U41 ( .A(a[7]), .B(n10), .Y(\u_div/CryTmp[7][1] ) );
  XNOR2X1M U42 ( .A(n10), .B(a[2]), .Y(\u_div/SumTmp[2][0] ) );
  XNOR2X1M U43 ( .A(n10), .B(a[3]), .Y(\u_div/SumTmp[3][0] ) );
  XNOR2X1M U44 ( .A(n10), .B(a[4]), .Y(\u_div/SumTmp[4][0] ) );
  XNOR2X1M U45 ( .A(n10), .B(a[5]), .Y(\u_div/SumTmp[5][0] ) );
  XNOR2X1M U46 ( .A(n10), .B(a[6]), .Y(\u_div/SumTmp[6][0] ) );
  XNOR2X1M U47 ( .A(n10), .B(a[7]), .Y(\u_div/SumTmp[7][0] ) );
  OR2X1M U48 ( .A(a[5]), .B(n10), .Y(\u_div/CryTmp[5][1] ) );
  OR2X1M U49 ( .A(a[4]), .B(n10), .Y(\u_div/CryTmp[4][1] ) );
  OR2X1M U50 ( .A(a[3]), .B(n10), .Y(\u_div/CryTmp[3][1] ) );
  OR2X1M U51 ( .A(a[2]), .B(n10), .Y(\u_div/CryTmp[2][1] ) );
  OR2X1M U52 ( .A(a[1]), .B(n10), .Y(\u_div/CryTmp[1][1] ) );
  OR2X1M U53 ( .A(a[0]), .B(n10), .Y(\u_div/CryTmp[0][1] ) );
  XNOR2X1M U54 ( .A(n10), .B(a[1]), .Y(\u_div/SumTmp[1][0] ) );
  OR2X1M U55 ( .A(a[6]), .B(n10), .Y(\u_div/CryTmp[6][1] ) );
  INVX1M U56 ( .A(b[7]), .Y(n3) );
  CLKMX2X2M U57 ( .A(\u_div/PartRem[2][6] ), .B(\u_div/SumTmp[1][6] ), .S0(
        quotient[1]), .Y(\u_div/PartRem[1][7] ) );
  CLKMX2X2M U58 ( .A(a[5]), .B(\u_div/SumTmp[5][0] ), .S0(quotient[5]), .Y(
        \u_div/PartRem[5][1] ) );
  CLKMX2X2M U59 ( .A(a[4]), .B(\u_div/SumTmp[4][0] ), .S0(quotient[4]), .Y(
        \u_div/PartRem[4][1] ) );
  CLKMX2X2M U60 ( .A(a[2]), .B(\u_div/SumTmp[2][0] ), .S0(n14), .Y(
        \u_div/PartRem[2][1] ) );
  AND4X1M U61 ( .A(\u_div/CryTmp[7][1] ), .B(n11), .C(n9), .D(n8), .Y(
        quotient[7]) );
  AND3X1M U62 ( .A(n13), .B(n6), .C(n5), .Y(n12) );
  AND2X1M U63 ( .A(\u_div/CryTmp[2][6] ), .B(n13), .Y(n14) );
endmodule


module Arithmatic_Unit_Width16_DW01_sub_0 ( A, B, CI, DIFF, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] DIFF;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8;
  wire   [9:0] carry;

  ADDFX2M U2_5 ( .A(A[5]), .B(n3), .CI(carry[5]), .CO(carry[6]), .S(DIFF[5])
         );
  ADDFX2M U2_4 ( .A(A[4]), .B(n4), .CI(carry[4]), .CO(carry[5]), .S(DIFF[4])
         );
  ADDFX2M U2_3 ( .A(A[3]), .B(n5), .CI(carry[3]), .CO(carry[4]), .S(DIFF[3])
         );
  ADDFX2M U2_2 ( .A(A[2]), .B(n6), .CI(carry[2]), .CO(carry[3]), .S(DIFF[2])
         );
  ADDFX2M U2_6 ( .A(A[6]), .B(n2), .CI(carry[6]), .CO(carry[7]), .S(DIFF[6])
         );
  ADDFX2M U2_7 ( .A(A[7]), .B(n1), .CI(carry[7]), .CO(carry[8]), .S(DIFF[7])
         );
  ADDFX2M U2_1 ( .A(A[1]), .B(n7), .CI(carry[1]), .CO(carry[2]), .S(DIFF[1])
         );
  XNOR2X1M U1 ( .A(n8), .B(A[0]), .Y(DIFF[0]) );
  CLKINVX1M U2 ( .A(B[0]), .Y(n8) );
  INVXLM U3 ( .A(B[2]), .Y(n6) );
  INVXLM U4 ( .A(B[3]), .Y(n5) );
  INVXLM U5 ( .A(B[6]), .Y(n2) );
  INVXLM U6 ( .A(B[1]), .Y(n7) );
  OR2X1M U7 ( .A(A[0]), .B(n8), .Y(carry[1]) );
  INVXLM U8 ( .A(B[4]), .Y(n4) );
  INVXLM U9 ( .A(B[5]), .Y(n3) );
  INVXLM U10 ( .A(B[7]), .Y(n1) );
  CLKINVX1M U11 ( .A(carry[8]), .Y(DIFF[8]) );
endmodule


module Arithmatic_Unit_Width16_DW01_add_0 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;

  wire   [8:1] carry;

  ADDFX2M U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(SUM[8]), .S(SUM[7]) );
  ADDFX2M U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFX2M U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFX2M U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFX2M U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFX2M U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFX2M U1_1 ( .A(A[1]), .B(B[1]), .CI(carry[1]), .CO(carry[2]), .S(SUM[1])
         );
  CLKXOR2X2M U1 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
  AND2X1M U2 ( .A(B[0]), .B(A[0]), .Y(carry[1]) );
endmodule


module Arithmatic_Unit_Width16_DW01_add_1 ( A, B, CI, SUM, CO );
  input [13:0] A;
  input [13:0] B;
  output [13:0] SUM;
  input CI;
  output CO;
  wire   n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n22, n23, n24, n25, n26;

  NOR2X4M U2 ( .A(B[10]), .B(A[10]), .Y(n22) );
  NOR2X4M U3 ( .A(B[11]), .B(A[11]), .Y(n18) );
  NOR2X4M U4 ( .A(B[8]), .B(A[8]), .Y(n13) );
  AOI2BB1X4M U5 ( .A0N(n8), .A1N(n11), .B0(n10), .Y(n23) );
  NOR2X4M U6 ( .A(B[9]), .B(A[9]), .Y(n11) );
  OAI21BX4M U7 ( .A0(n18), .A1(n19), .B0N(n20), .Y(n16) );
  NAND2X2M U8 ( .A(A[7]), .B(B[7]), .Y(n26) );
  CLKXOR2X2M U9 ( .A(B[13]), .B(n15), .Y(SUM[13]) );
  CLKXOR2X2M U10 ( .A(A[7]), .B(B[7]), .Y(SUM[7]) );
  CLKBUFX2M U11 ( .A(A[0]), .Y(SUM[0]) );
  CLKBUFX2M U12 ( .A(A[1]), .Y(SUM[1]) );
  CLKBUFX2M U13 ( .A(A[2]), .Y(SUM[2]) );
  CLKBUFX2M U14 ( .A(A[3]), .Y(SUM[3]) );
  CLKBUFX2M U15 ( .A(A[4]), .Y(SUM[4]) );
  CLKBUFX2M U16 ( .A(A[5]), .Y(SUM[5]) );
  CLKBUFX2M U17 ( .A(A[6]), .Y(SUM[6]) );
  XNOR2X1M U18 ( .A(n8), .B(n9), .Y(SUM[9]) );
  NOR2X1M U19 ( .A(n10), .B(n11), .Y(n9) );
  CLKXOR2X2M U20 ( .A(n12), .B(n26), .Y(SUM[8]) );
  NAND2BX1M U21 ( .AN(n13), .B(n14), .Y(n12) );
  OAI2BB1X1M U22 ( .A0N(n16), .A1N(A[12]), .B0(n17), .Y(n15) );
  OAI21X1M U23 ( .A0(A[12]), .A1(n16), .B0(B[12]), .Y(n17) );
  XOR3XLM U24 ( .A(B[12]), .B(A[12]), .C(n16), .Y(SUM[12]) );
  XNOR2X1M U25 ( .A(n19), .B(n21), .Y(SUM[11]) );
  NOR2X1M U26 ( .A(n20), .B(n18), .Y(n21) );
  AND2X1M U27 ( .A(B[11]), .B(A[11]), .Y(n20) );
  OA21X1M U28 ( .A0(n22), .A1(n23), .B0(n24), .Y(n19) );
  CLKXOR2X2M U29 ( .A(n25), .B(n23), .Y(SUM[10]) );
  AND2X1M U30 ( .A(B[9]), .B(A[9]), .Y(n10) );
  OA21X1M U31 ( .A0(n26), .A1(n13), .B0(n14), .Y(n8) );
  CLKNAND2X2M U32 ( .A(B[8]), .B(A[8]), .Y(n14) );
  NAND2BX1M U33 ( .AN(n22), .B(n24), .Y(n25) );
  CLKNAND2X2M U34 ( .A(B[10]), .B(A[10]), .Y(n24) );
endmodule


module Arithmatic_Unit_Width16_DW02_mult_0 ( A, B, TC, PRODUCT );
  input [7:0] A;
  input [7:0] B;
  output [15:0] PRODUCT;
  input TC;
  wire   \ab[7][7] , \ab[7][6] , \ab[7][5] , \ab[7][4] , \ab[7][3] ,
         \ab[7][2] , \ab[7][1] , \ab[7][0] , \ab[6][7] , \ab[6][6] ,
         \ab[6][5] , \ab[6][4] , \ab[6][3] , \ab[6][2] , \ab[6][1] ,
         \ab[6][0] , \ab[5][7] , \ab[5][6] , \ab[5][5] , \ab[5][4] ,
         \ab[5][3] , \ab[5][2] , \ab[5][1] , \ab[5][0] , \ab[4][7] ,
         \ab[4][6] , \ab[4][5] , \ab[4][4] , \ab[4][3] , \ab[4][2] ,
         \ab[4][1] , \ab[4][0] , \ab[3][7] , \ab[3][6] , \ab[3][5] ,
         \ab[3][4] , \ab[3][3] , \ab[3][2] , \ab[3][1] , \ab[3][0] ,
         \ab[2][7] , \ab[2][6] , \ab[2][5] , \ab[2][4] , \ab[2][3] ,
         \ab[2][2] , \ab[2][1] , \ab[2][0] , \ab[1][7] , \ab[1][6] ,
         \ab[1][5] , \ab[1][4] , \ab[1][3] , \ab[1][2] , \ab[1][1] ,
         \ab[1][0] , \ab[0][7] , \ab[0][6] , \ab[0][5] , \ab[0][4] ,
         \ab[0][3] , \ab[0][2] , \ab[0][1] , \CARRYB[7][6] , \CARRYB[7][5] ,
         \CARRYB[7][4] , \CARRYB[7][3] , \CARRYB[7][2] , \CARRYB[7][1] ,
         \CARRYB[7][0] , \CARRYB[6][6] , \CARRYB[6][5] , \CARRYB[6][4] ,
         \CARRYB[6][3] , \CARRYB[6][2] , \CARRYB[6][1] , \CARRYB[6][0] ,
         \CARRYB[5][6] , \CARRYB[5][5] , \CARRYB[5][4] , \CARRYB[5][3] ,
         \CARRYB[5][2] , \CARRYB[5][1] , \CARRYB[5][0] , \CARRYB[4][6] ,
         \CARRYB[4][5] , \CARRYB[4][4] , \CARRYB[4][3] , \CARRYB[4][2] ,
         \CARRYB[4][1] , \CARRYB[4][0] , \CARRYB[3][6] , \CARRYB[3][5] ,
         \CARRYB[3][4] , \CARRYB[3][3] , \CARRYB[3][2] , \CARRYB[3][1] ,
         \CARRYB[3][0] , \CARRYB[2][6] , \CARRYB[2][5] , \CARRYB[2][4] ,
         \CARRYB[2][3] , \CARRYB[2][2] , \CARRYB[2][1] , \CARRYB[2][0] ,
         \CARRYB[1][6] , \CARRYB[1][5] , \CARRYB[1][4] , \CARRYB[1][3] ,
         \CARRYB[1][2] , \CARRYB[1][1] , \CARRYB[1][0] , \SUMB[7][6] ,
         \SUMB[7][5] , \SUMB[7][4] , \SUMB[7][3] , \SUMB[7][2] , \SUMB[7][1] ,
         \SUMB[7][0] , \SUMB[6][6] , \SUMB[6][5] , \SUMB[6][4] , \SUMB[6][3] ,
         \SUMB[6][2] , \SUMB[6][1] , \SUMB[5][6] , \SUMB[5][5] , \SUMB[5][4] ,
         \SUMB[5][3] , \SUMB[5][2] , \SUMB[5][1] , \SUMB[4][6] , \SUMB[4][5] ,
         \SUMB[4][4] , \SUMB[4][3] , \SUMB[4][2] , \SUMB[4][1] , \SUMB[3][6] ,
         \SUMB[3][5] , \SUMB[3][4] , \SUMB[3][3] , \SUMB[3][2] , \SUMB[3][1] ,
         \SUMB[2][6] , \SUMB[2][5] , \SUMB[2][4] , \SUMB[2][3] , \SUMB[2][2] ,
         \SUMB[2][1] , \SUMB[1][6] , \SUMB[1][5] , \SUMB[1][4] , \SUMB[1][3] ,
         \SUMB[1][2] , \SUMB[1][1] , \A1[12] , \A1[11] , \A1[10] , \A1[9] ,
         \A1[8] , \A1[7] , \A1[6] , \A1[4] , \A1[3] , \A1[2] , \A1[1] ,
         \A1[0] , \A2[13] , \A2[12] , \A2[11] , \A2[10] , \A2[9] , \A2[8] ,
         \A2[7] , n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15,
         n16, n17, n18;

  Arithmatic_Unit_Width16_DW01_add_1 FS_1 ( .A({1'b0, \A1[12] , \A1[11] , 
        \A1[10] , \A1[9] , \A1[8] , \A1[7] , \A1[6] , \SUMB[7][0] , \A1[4] , 
        \A1[3] , \A1[2] , \A1[1] , \A1[0] }), .B({\A2[13] , \A2[12] , \A2[11] , 
        \A2[10] , \A2[9] , \A2[8] , \A2[7] , 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0}), .CI(1'b0), .SUM(PRODUCT[15:2]) );
  ADDFX2M S5_6 ( .A(\ab[7][6] ), .B(\CARRYB[6][6] ), .CI(\ab[6][7] ), .CO(
        \CARRYB[7][6] ), .S(\SUMB[7][6] ) );
  ADDFX2M S1_6_0 ( .A(\ab[6][0] ), .B(\CARRYB[5][0] ), .CI(\SUMB[5][1] ), .CO(
        \CARRYB[6][0] ), .S(\A1[4] ) );
  ADDFX2M S1_5_0 ( .A(\ab[5][0] ), .B(\CARRYB[4][0] ), .CI(\SUMB[4][1] ), .CO(
        \CARRYB[5][0] ), .S(\A1[3] ) );
  ADDFX2M S1_4_0 ( .A(\ab[4][0] ), .B(\CARRYB[3][0] ), .CI(\SUMB[3][1] ), .CO(
        \CARRYB[4][0] ), .S(\A1[2] ) );
  ADDFX2M S1_3_0 ( .A(\ab[3][0] ), .B(\CARRYB[2][0] ), .CI(\SUMB[2][1] ), .CO(
        \CARRYB[3][0] ), .S(\A1[1] ) );
  ADDFX2M S1_2_0 ( .A(\ab[2][0] ), .B(\CARRYB[1][0] ), .CI(\SUMB[1][1] ), .CO(
        \CARRYB[2][0] ), .S(\A1[0] ) );
  ADDFX2M S3_6_6 ( .A(\ab[6][6] ), .B(\CARRYB[5][6] ), .CI(\ab[5][7] ), .CO(
        \CARRYB[6][6] ), .S(\SUMB[6][6] ) );
  ADDFX2M S3_5_6 ( .A(\ab[5][6] ), .B(\CARRYB[4][6] ), .CI(\ab[4][7] ), .CO(
        \CARRYB[5][6] ), .S(\SUMB[5][6] ) );
  ADDFX2M S4_0 ( .A(\ab[7][0] ), .B(\CARRYB[6][0] ), .CI(\SUMB[6][1] ), .CO(
        \CARRYB[7][0] ), .S(\SUMB[7][0] ) );
  ADDFX2M S4_5 ( .A(\ab[7][5] ), .B(\CARRYB[6][5] ), .CI(\SUMB[6][6] ), .CO(
        \CARRYB[7][5] ), .S(\SUMB[7][5] ) );
  ADDFX2M S2_6_1 ( .A(\ab[6][1] ), .B(\CARRYB[5][1] ), .CI(\SUMB[5][2] ), .CO(
        \CARRYB[6][1] ), .S(\SUMB[6][1] ) );
  ADDFX2M S2_5_1 ( .A(\ab[5][1] ), .B(\CARRYB[4][1] ), .CI(\SUMB[4][2] ), .CO(
        \CARRYB[5][1] ), .S(\SUMB[5][1] ) );
  ADDFX2M S2_4_1 ( .A(\ab[4][1] ), .B(\CARRYB[3][1] ), .CI(\SUMB[3][2] ), .CO(
        \CARRYB[4][1] ), .S(\SUMB[4][1] ) );
  ADDFX2M S2_3_1 ( .A(\ab[3][1] ), .B(\CARRYB[2][1] ), .CI(\SUMB[2][2] ), .CO(
        \CARRYB[3][1] ), .S(\SUMB[3][1] ) );
  ADDFX2M S2_6_2 ( .A(\ab[6][2] ), .B(\CARRYB[5][2] ), .CI(\SUMB[5][3] ), .CO(
        \CARRYB[6][2] ), .S(\SUMB[6][2] ) );
  ADDFX2M S2_6_3 ( .A(\ab[6][3] ), .B(\CARRYB[5][3] ), .CI(\SUMB[5][4] ), .CO(
        \CARRYB[6][3] ), .S(\SUMB[6][3] ) );
  ADDFX2M S2_5_3 ( .A(\ab[5][3] ), .B(\CARRYB[4][3] ), .CI(\SUMB[4][4] ), .CO(
        \CARRYB[5][3] ), .S(\SUMB[5][3] ) );
  ADDFX2M S2_5_2 ( .A(\ab[5][2] ), .B(\CARRYB[4][2] ), .CI(\SUMB[4][3] ), .CO(
        \CARRYB[5][2] ), .S(\SUMB[5][2] ) );
  ADDFX2M S2_5_4 ( .A(\ab[5][4] ), .B(\CARRYB[4][4] ), .CI(\SUMB[4][5] ), .CO(
        \CARRYB[5][4] ), .S(\SUMB[5][4] ) );
  ADDFX2M S2_4_4 ( .A(\ab[4][4] ), .B(\CARRYB[3][4] ), .CI(\SUMB[3][5] ), .CO(
        \CARRYB[4][4] ), .S(\SUMB[4][4] ) );
  ADDFX2M S2_4_3 ( .A(\ab[4][3] ), .B(\CARRYB[3][3] ), .CI(\SUMB[3][4] ), .CO(
        \CARRYB[4][3] ), .S(\SUMB[4][3] ) );
  ADDFX2M S2_4_2 ( .A(\ab[4][2] ), .B(\CARRYB[3][2] ), .CI(\SUMB[3][3] ), .CO(
        \CARRYB[4][2] ), .S(\SUMB[4][2] ) );
  ADDFX2M S2_4_5 ( .A(\ab[4][5] ), .B(\CARRYB[3][5] ), .CI(\SUMB[3][6] ), .CO(
        \CARRYB[4][5] ), .S(\SUMB[4][5] ) );
  ADDFX2M S2_3_5 ( .A(\ab[3][5] ), .B(\CARRYB[2][5] ), .CI(\SUMB[2][6] ), .CO(
        \CARRYB[3][5] ), .S(\SUMB[3][5] ) );
  ADDFX2M S2_3_4 ( .A(\ab[3][4] ), .B(\CARRYB[2][4] ), .CI(\SUMB[2][5] ), .CO(
        \CARRYB[3][4] ), .S(\SUMB[3][4] ) );
  ADDFX2M S2_3_3 ( .A(\ab[3][3] ), .B(\CARRYB[2][3] ), .CI(\SUMB[2][4] ), .CO(
        \CARRYB[3][3] ), .S(\SUMB[3][3] ) );
  ADDFX2M S2_3_2 ( .A(\ab[3][2] ), .B(\CARRYB[2][2] ), .CI(\SUMB[2][3] ), .CO(
        \CARRYB[3][2] ), .S(\SUMB[3][2] ) );
  ADDFX2M S2_6_5 ( .A(\ab[6][5] ), .B(\CARRYB[5][5] ), .CI(\SUMB[5][6] ), .CO(
        \CARRYB[6][5] ), .S(\SUMB[6][5] ) );
  ADDFX2M S2_6_4 ( .A(\ab[6][4] ), .B(\CARRYB[5][4] ), .CI(\SUMB[5][5] ), .CO(
        \CARRYB[6][4] ), .S(\SUMB[6][4] ) );
  ADDFX2M S2_5_5 ( .A(\ab[5][5] ), .B(\CARRYB[4][5] ), .CI(\SUMB[4][6] ), .CO(
        \CARRYB[5][5] ), .S(\SUMB[5][5] ) );
  ADDFX2M S3_4_6 ( .A(\ab[4][6] ), .B(\CARRYB[3][6] ), .CI(\ab[3][7] ), .CO(
        \CARRYB[4][6] ), .S(\SUMB[4][6] ) );
  ADDFX2M S3_3_6 ( .A(\ab[3][6] ), .B(\CARRYB[2][6] ), .CI(\ab[2][7] ), .CO(
        \CARRYB[3][6] ), .S(\SUMB[3][6] ) );
  ADDFX2M S3_2_6 ( .A(\ab[2][6] ), .B(\CARRYB[1][6] ), .CI(\ab[1][7] ), .CO(
        \CARRYB[2][6] ), .S(\SUMB[2][6] ) );
  ADDFX2M S2_2_4 ( .A(\ab[2][4] ), .B(\CARRYB[1][4] ), .CI(\SUMB[1][5] ), .CO(
        \CARRYB[2][4] ), .S(\SUMB[2][4] ) );
  ADDFX2M S2_2_3 ( .A(\ab[2][3] ), .B(\CARRYB[1][3] ), .CI(\SUMB[1][4] ), .CO(
        \CARRYB[2][3] ), .S(\SUMB[2][3] ) );
  ADDFX2M S2_2_2 ( .A(\ab[2][2] ), .B(\CARRYB[1][2] ), .CI(\SUMB[1][3] ), .CO(
        \CARRYB[2][2] ), .S(\SUMB[2][2] ) );
  ADDFX2M S4_1 ( .A(\ab[7][1] ), .B(\CARRYB[6][1] ), .CI(\SUMB[6][2] ), .CO(
        \CARRYB[7][1] ), .S(\SUMB[7][1] ) );
  ADDFX2M S4_4 ( .A(\ab[7][4] ), .B(\CARRYB[6][4] ), .CI(\SUMB[6][5] ), .CO(
        \CARRYB[7][4] ), .S(\SUMB[7][4] ) );
  ADDFX2M S4_3 ( .A(\ab[7][3] ), .B(\CARRYB[6][3] ), .CI(\SUMB[6][4] ), .CO(
        \CARRYB[7][3] ), .S(\SUMB[7][3] ) );
  ADDFX2M S4_2 ( .A(\ab[7][2] ), .B(\CARRYB[6][2] ), .CI(\SUMB[6][3] ), .CO(
        \CARRYB[7][2] ), .S(\SUMB[7][2] ) );
  ADDFX2M S2_2_1 ( .A(\ab[2][1] ), .B(\CARRYB[1][1] ), .CI(\SUMB[1][2] ), .CO(
        \CARRYB[2][1] ), .S(\SUMB[2][1] ) );
  ADDFX2M S2_2_5 ( .A(\ab[2][5] ), .B(\CARRYB[1][5] ), .CI(\SUMB[1][6] ), .CO(
        \CARRYB[2][5] ), .S(\SUMB[2][5] ) );
  NOR2X4M U2 ( .A(n9), .B(n18), .Y(\ab[0][1] ) );
  NOR2X4M U3 ( .A(n6), .B(n18), .Y(\ab[0][4] ) );
  NOR2X3M U4 ( .A(n5), .B(n18), .Y(\ab[0][5] ) );
  INVX6M U5 ( .A(A[0]), .Y(n18) );
  NOR2X4M U6 ( .A(n4), .B(n18), .Y(\ab[0][6] ) );
  NOR2X4M U7 ( .A(n8), .B(n18), .Y(\ab[0][2] ) );
  NOR2X4M U8 ( .A(n7), .B(n18), .Y(\ab[0][3] ) );
  NOR2X4M U9 ( .A(n3), .B(n18), .Y(\ab[0][7] ) );
  INVX6M U10 ( .A(B[7]), .Y(n3) );
  NOR2X4M U11 ( .A(n5), .B(n17), .Y(\ab[1][5] ) );
  NOR2X4M U12 ( .A(n10), .B(n17), .Y(\ab[1][0] ) );
  INVX6M U13 ( .A(B[0]), .Y(n10) );
  NOR2X4M U14 ( .A(n7), .B(n17), .Y(\ab[1][3] ) );
  NOR2X4M U15 ( .A(n8), .B(n17), .Y(\ab[1][2] ) );
  INVX6M U16 ( .A(B[2]), .Y(n8) );
  NOR2X4M U17 ( .A(n6), .B(n17), .Y(\ab[1][4] ) );
  INVX6M U18 ( .A(B[4]), .Y(n6) );
  NOR2X4M U19 ( .A(n9), .B(n17), .Y(\ab[1][1] ) );
  INVX6M U20 ( .A(B[1]), .Y(n9) );
  NOR2X4M U21 ( .A(n4), .B(n17), .Y(\ab[1][6] ) );
  INVX6M U22 ( .A(B[6]), .Y(n4) );
  INVX6M U23 ( .A(A[1]), .Y(n17) );
  NOR2X4M U24 ( .A(n11), .B(n3), .Y(\ab[7][7] ) );
  CLKINVX6M U25 ( .A(B[3]), .Y(n7) );
  CLKXOR2X2M U26 ( .A(\CARRYB[7][1] ), .B(\SUMB[7][2] ), .Y(\A1[7] ) );
  CLKXOR2X2M U27 ( .A(\CARRYB[7][2] ), .B(\SUMB[7][3] ), .Y(\A1[8] ) );
  CLKXOR2X2M U28 ( .A(\CARRYB[7][3] ), .B(\SUMB[7][4] ), .Y(\A1[9] ) );
  AND2X2M U29 ( .A(\CARRYB[7][0] ), .B(\SUMB[7][1] ), .Y(\A2[7] ) );
  AND2X2M U30 ( .A(\CARRYB[7][1] ), .B(\SUMB[7][2] ), .Y(\A2[8] ) );
  AND2X2M U31 ( .A(\CARRYB[7][2] ), .B(\SUMB[7][3] ), .Y(\A2[9] ) );
  AND2X1M U32 ( .A(\CARRYB[7][6] ), .B(\ab[7][7] ), .Y(\A2[13] ) );
  CLKXOR2X2M U33 ( .A(\CARRYB[7][4] ), .B(\SUMB[7][5] ), .Y(\A1[10] ) );
  AND2X2M U34 ( .A(\CARRYB[7][3] ), .B(\SUMB[7][4] ), .Y(\A2[10] ) );
  CLKXOR2X2M U35 ( .A(\CARRYB[7][5] ), .B(\SUMB[7][6] ), .Y(\A1[11] ) );
  AND2X2M U36 ( .A(\CARRYB[7][4] ), .B(\SUMB[7][5] ), .Y(\A2[11] ) );
  CLKXOR2X2M U37 ( .A(\CARRYB[7][6] ), .B(\ab[7][7] ), .Y(\A1[12] ) );
  AND2X2M U38 ( .A(\CARRYB[7][5] ), .B(\SUMB[7][6] ), .Y(\A2[12] ) );
  CLKXOR2X2M U39 ( .A(\ab[1][0] ), .B(\ab[0][1] ), .Y(PRODUCT[1]) );
  AND2X1M U40 ( .A(\ab[0][6] ), .B(\ab[1][5] ), .Y(\CARRYB[1][5] ) );
  CLKXOR2X2M U41 ( .A(\ab[1][6] ), .B(\ab[0][7] ), .Y(\SUMB[1][6] ) );
  AND2X1M U42 ( .A(\ab[0][2] ), .B(\ab[1][1] ), .Y(\CARRYB[1][1] ) );
  CLKXOR2X2M U43 ( .A(\ab[1][2] ), .B(\ab[0][3] ), .Y(\SUMB[1][2] ) );
  AND2X1M U44 ( .A(\ab[0][3] ), .B(\ab[1][2] ), .Y(\CARRYB[1][2] ) );
  CLKXOR2X2M U45 ( .A(\ab[1][3] ), .B(\ab[0][4] ), .Y(\SUMB[1][3] ) );
  AND2X1M U46 ( .A(\ab[0][4] ), .B(\ab[1][3] ), .Y(\CARRYB[1][3] ) );
  CLKXOR2X2M U47 ( .A(\ab[1][4] ), .B(\ab[0][5] ), .Y(\SUMB[1][4] ) );
  AND2X1M U48 ( .A(\ab[0][5] ), .B(\ab[1][4] ), .Y(\CARRYB[1][4] ) );
  CLKXOR2X2M U49 ( .A(\ab[1][5] ), .B(\ab[0][6] ), .Y(\SUMB[1][5] ) );
  AND2X1M U50 ( .A(\ab[0][7] ), .B(\ab[1][6] ), .Y(\CARRYB[1][6] ) );
  CLKXOR2X2M U51 ( .A(\ab[1][1] ), .B(\ab[0][2] ), .Y(\SUMB[1][1] ) );
  AND2X1M U52 ( .A(\ab[0][1] ), .B(\ab[1][0] ), .Y(\CARRYB[1][0] ) );
  CLKXOR2X2M U53 ( .A(\CARRYB[7][0] ), .B(\SUMB[7][1] ), .Y(\A1[6] ) );
  CLKINVX6M U54 ( .A(A[2]), .Y(n16) );
  INVX6M U55 ( .A(B[5]), .Y(n5) );
  CLKINVX6M U56 ( .A(A[6]), .Y(n12) );
  CLKINVX6M U57 ( .A(A[3]), .Y(n15) );
  CLKINVX6M U58 ( .A(A[4]), .Y(n14) );
  CLKINVX6M U59 ( .A(A[5]), .Y(n13) );
  CLKINVX6M U60 ( .A(A[7]), .Y(n11) );
  NOR2X1M U62 ( .A(n11), .B(n4), .Y(\ab[7][6] ) );
  NOR2X1M U63 ( .A(n11), .B(n5), .Y(\ab[7][5] ) );
  NOR2X1M U64 ( .A(n11), .B(n6), .Y(\ab[7][4] ) );
  NOR2X1M U65 ( .A(n11), .B(n7), .Y(\ab[7][3] ) );
  NOR2X1M U66 ( .A(n11), .B(n8), .Y(\ab[7][2] ) );
  NOR2X1M U67 ( .A(n11), .B(n9), .Y(\ab[7][1] ) );
  NOR2X1M U68 ( .A(n11), .B(n10), .Y(\ab[7][0] ) );
  NOR2X1M U69 ( .A(n3), .B(n12), .Y(\ab[6][7] ) );
  NOR2X1M U70 ( .A(n4), .B(n12), .Y(\ab[6][6] ) );
  NOR2X1M U71 ( .A(n5), .B(n12), .Y(\ab[6][5] ) );
  NOR2X1M U72 ( .A(n6), .B(n12), .Y(\ab[6][4] ) );
  NOR2X1M U73 ( .A(n7), .B(n12), .Y(\ab[6][3] ) );
  NOR2X1M U74 ( .A(n8), .B(n12), .Y(\ab[6][2] ) );
  NOR2X1M U75 ( .A(n9), .B(n12), .Y(\ab[6][1] ) );
  NOR2X1M U76 ( .A(n10), .B(n12), .Y(\ab[6][0] ) );
  NOR2X1M U77 ( .A(n3), .B(n13), .Y(\ab[5][7] ) );
  NOR2X1M U78 ( .A(n4), .B(n13), .Y(\ab[5][6] ) );
  NOR2X1M U79 ( .A(n5), .B(n13), .Y(\ab[5][5] ) );
  NOR2X1M U80 ( .A(n6), .B(n13), .Y(\ab[5][4] ) );
  NOR2X1M U81 ( .A(n7), .B(n13), .Y(\ab[5][3] ) );
  NOR2X1M U82 ( .A(n8), .B(n13), .Y(\ab[5][2] ) );
  NOR2X1M U83 ( .A(n9), .B(n13), .Y(\ab[5][1] ) );
  NOR2X1M U84 ( .A(n10), .B(n13), .Y(\ab[5][0] ) );
  NOR2X1M U85 ( .A(n3), .B(n14), .Y(\ab[4][7] ) );
  NOR2X1M U86 ( .A(n4), .B(n14), .Y(\ab[4][6] ) );
  NOR2X1M U87 ( .A(n5), .B(n14), .Y(\ab[4][5] ) );
  NOR2X1M U88 ( .A(n6), .B(n14), .Y(\ab[4][4] ) );
  NOR2X1M U89 ( .A(n7), .B(n14), .Y(\ab[4][3] ) );
  NOR2X1M U90 ( .A(n8), .B(n14), .Y(\ab[4][2] ) );
  NOR2X1M U91 ( .A(n9), .B(n14), .Y(\ab[4][1] ) );
  NOR2X1M U92 ( .A(n10), .B(n14), .Y(\ab[4][0] ) );
  NOR2X1M U93 ( .A(n3), .B(n15), .Y(\ab[3][7] ) );
  NOR2X1M U94 ( .A(n4), .B(n15), .Y(\ab[3][6] ) );
  NOR2X1M U95 ( .A(n5), .B(n15), .Y(\ab[3][5] ) );
  NOR2X1M U96 ( .A(n6), .B(n15), .Y(\ab[3][4] ) );
  NOR2X1M U97 ( .A(n7), .B(n15), .Y(\ab[3][3] ) );
  NOR2X1M U98 ( .A(n8), .B(n15), .Y(\ab[3][2] ) );
  NOR2X1M U99 ( .A(n9), .B(n15), .Y(\ab[3][1] ) );
  NOR2X1M U100 ( .A(n10), .B(n15), .Y(\ab[3][0] ) );
  NOR2X1M U101 ( .A(n3), .B(n16), .Y(\ab[2][7] ) );
  NOR2X1M U102 ( .A(n4), .B(n16), .Y(\ab[2][6] ) );
  NOR2X1M U103 ( .A(n5), .B(n16), .Y(\ab[2][5] ) );
  NOR2X1M U104 ( .A(n6), .B(n16), .Y(\ab[2][4] ) );
  NOR2X1M U105 ( .A(n7), .B(n16), .Y(\ab[2][3] ) );
  NOR2X1M U106 ( .A(n8), .B(n16), .Y(\ab[2][2] ) );
  NOR2X1M U107 ( .A(n9), .B(n16), .Y(\ab[2][1] ) );
  NOR2X1M U108 ( .A(n10), .B(n16), .Y(\ab[2][0] ) );
  NOR2X1M U109 ( .A(n3), .B(n17), .Y(\ab[1][7] ) );
  NOR2X1M U110 ( .A(n10), .B(n18), .Y(PRODUCT[0]) );
endmodule


module Arithmatic_Unit_Width16 ( A, B, ALU_FUN, CLK, RST, Arith_Enable, 
        Arith_OUT, Carry_OUT, Arith_Flag );
  input [7:0] A;
  input [7:0] B;
  input [1:0] ALU_FUN;
  output [15:0] Arith_OUT;
  input CLK, RST, Arith_Enable;
  output Carry_OUT, Arith_Flag;
  wire   N12, N13, N14, N15, N16, N17, N18, N19, N20, Carry_OUT_Comb, N21, N22,
         N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36,
         N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49, N50,
         N51, N52, N53, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18,
         n19, n20, n21, n22, n23, n24, n25, n26, n27, n3, n4, n5, n6, n7, n28,
         n29, n30, n31, n32, n33;
  wire   [15:0] Arith_OUT_Comb;

  AOI221X4M U4 ( .A0(N20), .A1(n6), .B0(N38), .B1(n28), .C0(n9), .Y(n10) );
  NOR2BX12M U38 ( .AN(ALU_FUN[1]), .B(n33), .Y(n14) );
  Arithmatic_Unit_Width16_DW_div_uns_0 div_35 ( .a(A), .b(B), .quotient({N53, 
        N52, N51, N50, N49, N48, N47, N46}) );
  Arithmatic_Unit_Width16_DW01_sub_0 sub_25 ( .A({1'b0, A}), .B({1'b0, B}), 
        .CI(1'b0), .DIFF({N29, N28, N27, N26, N25, N24, N23, N22, N21}) );
  Arithmatic_Unit_Width16_DW01_add_0 add_20 ( .A({1'b0, A}), .B({1'b0, B}), 
        .CI(1'b0), .SUM({N20, N19, N18, N17, N16, N15, N14, N13, N12}) );
  Arithmatic_Unit_Width16_DW02_mult_0 mult_30 ( .A(A), .B(B), .TC(1'b0), 
        .PRODUCT({N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, N35, N34, 
        N33, N32, N31, N30}) );
  DFFRQX2M \Arith_OUT_reg[15]  ( .D(Arith_OUT_Comb[15]), .CK(CLK), .RN(n30), 
        .Q(Arith_OUT[15]) );
  DFFRQX2M \Arith_OUT_reg[14]  ( .D(Arith_OUT_Comb[14]), .CK(CLK), .RN(n30), 
        .Q(Arith_OUT[14]) );
  DFFRQX2M \Arith_OUT_reg[13]  ( .D(Arith_OUT_Comb[13]), .CK(CLK), .RN(n30), 
        .Q(Arith_OUT[13]) );
  DFFRQX2M \Arith_OUT_reg[12]  ( .D(Arith_OUT_Comb[12]), .CK(CLK), .RN(n30), 
        .Q(Arith_OUT[12]) );
  DFFRQX2M \Arith_OUT_reg[11]  ( .D(Arith_OUT_Comb[11]), .CK(CLK), .RN(n30), 
        .Q(Arith_OUT[11]) );
  DFFRQX2M \Arith_OUT_reg[10]  ( .D(Arith_OUT_Comb[10]), .CK(CLK), .RN(n30), 
        .Q(Arith_OUT[10]) );
  DFFRQX2M \Arith_OUT_reg[9]  ( .D(Arith_OUT_Comb[9]), .CK(CLK), .RN(n30), .Q(
        Arith_OUT[9]) );
  DFFRQX2M \Arith_OUT_reg[8]  ( .D(n32), .CK(CLK), .RN(n30), .Q(Arith_OUT[8])
         );
  DFFRQX2M \Arith_OUT_reg[7]  ( .D(Arith_OUT_Comb[7]), .CK(CLK), .RN(n30), .Q(
        Arith_OUT[7]) );
  DFFRQX2M \Arith_OUT_reg[6]  ( .D(Arith_OUT_Comb[6]), .CK(CLK), .RN(n30), .Q(
        Arith_OUT[6]) );
  DFFRQX2M \Arith_OUT_reg[5]  ( .D(Arith_OUT_Comb[5]), .CK(CLK), .RN(n31), .Q(
        Arith_OUT[5]) );
  DFFRQX2M \Arith_OUT_reg[4]  ( .D(Arith_OUT_Comb[4]), .CK(CLK), .RN(n31), .Q(
        Arith_OUT[4]) );
  DFFRQX2M \Arith_OUT_reg[3]  ( .D(Arith_OUT_Comb[3]), .CK(CLK), .RN(n31), .Q(
        Arith_OUT[3]) );
  DFFRQX2M \Arith_OUT_reg[2]  ( .D(Arith_OUT_Comb[2]), .CK(CLK), .RN(n31), .Q(
        Arith_OUT[2]) );
  DFFRQX2M \Arith_OUT_reg[1]  ( .D(Arith_OUT_Comb[1]), .CK(CLK), .RN(n31), .Q(
        Arith_OUT[1]) );
  DFFRQX2M \Arith_OUT_reg[0]  ( .D(Carry_OUT_Comb), .CK(CLK), .RN(n31), .Q(
        Arith_OUT[0]) );
  DFFRQX2M Arith_Flag_reg ( .D(Arith_Enable), .CK(CLK), .RN(n30), .Q(
        Arith_Flag) );
  DFFRQX2M Carry_OUT_reg ( .D(Carry_OUT_Comb), .CK(CLK), .RN(n30), .Q(
        Carry_OUT) );
  AO22X1M U3 ( .A0(N46), .A1(n14), .B0(N30), .B1(n28), .Y(n4) );
  OR2X2M U5 ( .A(n3), .B(n4), .Y(Carry_OUT_Comb) );
  INVX2M U8 ( .A(n8), .Y(n7) );
  AO22X1M U9 ( .A0(N21), .A1(n5), .B0(N12), .B1(n6), .Y(n3) );
  INVX6M U10 ( .A(n7), .Y(n28) );
  INVX6M U11 ( .A(n7), .Y(n29) );
  CLKBUFX8M U12 ( .A(RST), .Y(n30) );
  BUFX4M U13 ( .A(RST), .Y(n31) );
  AO21XLM U14 ( .A0(N45), .A1(n28), .B0(n9), .Y(Arith_OUT_Comb[15]) );
  AO21XLM U15 ( .A0(N43), .A1(n28), .B0(n9), .Y(Arith_OUT_Comb[13]) );
  AO21XLM U16 ( .A0(N44), .A1(n29), .B0(n9), .Y(Arith_OUT_Comb[14]) );
  AO21XLM U17 ( .A0(N42), .A1(n29), .B0(n9), .Y(Arith_OUT_Comb[12]) );
  AO21XLM U18 ( .A0(N41), .A1(n28), .B0(n9), .Y(Arith_OUT_Comb[11]) );
  AO21XLM U19 ( .A0(N40), .A1(n29), .B0(n9), .Y(Arith_OUT_Comb[10]) );
  AO21XLM U20 ( .A0(N39), .A1(n29), .B0(n9), .Y(Arith_OUT_Comb[9]) );
  CLKINVX2M U21 ( .A(ALU_FUN[0]), .Y(n33) );
  CLKBUFX6M U22 ( .A(n15), .Y(n5) );
  NOR2X1M U23 ( .A(n33), .B(ALU_FUN[1]), .Y(n15) );
  CLKBUFX6M U24 ( .A(n11), .Y(n6) );
  NOR2X1M U25 ( .A(ALU_FUN[0]), .B(ALU_FUN[1]), .Y(n11) );
  NOR2BX1M U26 ( .AN(ALU_FUN[1]), .B(ALU_FUN[0]), .Y(n8) );
  NAND2X2M U27 ( .A(n26), .B(n27), .Y(Arith_OUT_Comb[1]) );
  AOI22X1M U28 ( .A0(N22), .A1(n5), .B0(N13), .B1(n6), .Y(n26) );
  AOI22X1M U29 ( .A0(N47), .A1(n14), .B0(N31), .B1(n29), .Y(n27) );
  NAND2X2M U30 ( .A(n24), .B(n25), .Y(Arith_OUT_Comb[2]) );
  AOI22X1M U31 ( .A0(N23), .A1(n5), .B0(N14), .B1(n6), .Y(n24) );
  AOI22X1M U32 ( .A0(N48), .A1(n14), .B0(N32), .B1(n28), .Y(n25) );
  NAND2X2M U33 ( .A(n22), .B(n23), .Y(Arith_OUT_Comb[3]) );
  AOI22X1M U34 ( .A0(N24), .A1(n5), .B0(N15), .B1(n6), .Y(n22) );
  AOI22X1M U35 ( .A0(N49), .A1(n14), .B0(N33), .B1(n29), .Y(n23) );
  NAND2X2M U36 ( .A(n20), .B(n21), .Y(Arith_OUT_Comb[4]) );
  AOI22X1M U37 ( .A0(N25), .A1(n5), .B0(N16), .B1(n6), .Y(n20) );
  AOI22X1M U39 ( .A0(N50), .A1(n14), .B0(N34), .B1(n28), .Y(n21) );
  NAND2X2M U40 ( .A(n18), .B(n19), .Y(Arith_OUT_Comb[5]) );
  AOI22X1M U41 ( .A0(N26), .A1(n5), .B0(N17), .B1(n6), .Y(n18) );
  AOI22X1M U42 ( .A0(N51), .A1(n14), .B0(N35), .B1(n29), .Y(n19) );
  NAND2X2M U43 ( .A(n16), .B(n17), .Y(Arith_OUT_Comb[6]) );
  AOI22X1M U44 ( .A0(N27), .A1(n5), .B0(N18), .B1(n6), .Y(n16) );
  AOI22X1M U45 ( .A0(N52), .A1(n14), .B0(N36), .B1(n28), .Y(n17) );
  INVX2M U46 ( .A(n10), .Y(n32) );
  NAND2X2M U47 ( .A(n12), .B(n13), .Y(Arith_OUT_Comb[7]) );
  AOI22X1M U48 ( .A0(N28), .A1(n5), .B0(N19), .B1(n6), .Y(n12) );
  AOI22X1M U49 ( .A0(N53), .A1(n14), .B0(N37), .B1(n29), .Y(n13) );
  CLKAND2X6M U50 ( .A(N29), .B(n5), .Y(n9) );
endmodule


module Logic_Unit_Width16 ( A, B, ALU_FUN, CLK, Logic_Enable, RST, Logic_OUT, 
        Logic_Flag );
  input [7:0] A;
  input [7:0] B;
  input [1:0] ALU_FUN;
  output [15:0] Logic_OUT;
  input CLK, Logic_Enable, RST;
  output Logic_Flag;
  wire   N48, N49, N50, N51, N52, N53, N54, N55, N63, n18, n19, n20, n21, n22,
         n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n1, n2, n3, n4, n5, n6,
         n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n46, n47, n48,
         n49;

  DFFRQX2M \Logic_OUT_reg[15]  ( .D(N63), .CK(CLK), .RN(n3), .Q(Logic_OUT[15])
         );
  DFFRQX2M \Logic_OUT_reg[14]  ( .D(N63), .CK(CLK), .RN(n3), .Q(Logic_OUT[14])
         );
  DFFRQX2M \Logic_OUT_reg[13]  ( .D(N63), .CK(CLK), .RN(n3), .Q(Logic_OUT[13])
         );
  DFFRQX2M \Logic_OUT_reg[12]  ( .D(N63), .CK(CLK), .RN(n3), .Q(Logic_OUT[12])
         );
  DFFRQX2M \Logic_OUT_reg[11]  ( .D(N63), .CK(CLK), .RN(n3), .Q(Logic_OUT[11])
         );
  DFFRQX2M \Logic_OUT_reg[10]  ( .D(N63), .CK(CLK), .RN(n3), .Q(Logic_OUT[10])
         );
  DFFRQX2M \Logic_OUT_reg[9]  ( .D(N63), .CK(CLK), .RN(n3), .Q(Logic_OUT[9])
         );
  DFFRQX2M \Logic_OUT_reg[8]  ( .D(N63), .CK(CLK), .RN(n3), .Q(Logic_OUT[8])
         );
  DFFRQX2M \Logic_OUT_reg[7]  ( .D(N55), .CK(CLK), .RN(n3), .Q(Logic_OUT[7])
         );
  DFFRQX2M \Logic_OUT_reg[6]  ( .D(N54), .CK(CLK), .RN(n3), .Q(Logic_OUT[6])
         );
  DFFRQX2M \Logic_OUT_reg[5]  ( .D(N53), .CK(CLK), .RN(n3), .Q(Logic_OUT[5])
         );
  DFFRQX2M \Logic_OUT_reg[4]  ( .D(N52), .CK(CLK), .RN(n4), .Q(Logic_OUT[4])
         );
  DFFRQX2M \Logic_OUT_reg[3]  ( .D(N51), .CK(CLK), .RN(n4), .Q(Logic_OUT[3])
         );
  DFFRQX2M \Logic_OUT_reg[2]  ( .D(N50), .CK(CLK), .RN(n4), .Q(Logic_OUT[2])
         );
  DFFRQX2M \Logic_OUT_reg[1]  ( .D(N49), .CK(CLK), .RN(n4), .Q(Logic_OUT[1])
         );
  DFFRQX2M \Logic_OUT_reg[0]  ( .D(N48), .CK(CLK), .RN(n4), .Q(Logic_OUT[0])
         );
  DFFRQX2M Logic_Flag_reg ( .D(Logic_Enable), .CK(CLK), .RN(n3), .Q(Logic_Flag) );
  BUFX10M U3 ( .A(n18), .Y(n1) );
  OAI221X2M U4 ( .A0(A[5]), .A1(n1), .B0(n2), .B1(n16), .C0(n28), .Y(N53) );
  OAI221X2M U5 ( .A0(A[4]), .A1(n1), .B0(n2), .B1(n17), .C0(n31), .Y(N52) );
  OAI221X2M U6 ( .A0(A[3]), .A1(n1), .B0(n2), .B1(n46), .C0(n34), .Y(N51) );
  OAI221X2M U7 ( .A0(A[2]), .A1(n1), .B0(n2), .B1(n47), .C0(n37), .Y(N50) );
  OAI221X2M U8 ( .A0(A[0]), .A1(n1), .B0(n2), .B1(n49), .C0(n43), .Y(N48) );
  OAI221X2M U9 ( .A0(A[7]), .A1(n1), .B0(n14), .B1(n2), .C0(n20), .Y(N55) );
  OAI221X2M U10 ( .A0(A[6]), .A1(n1), .B0(n2), .B1(n15), .C0(n25), .Y(N54) );
  OAI221X2M U11 ( .A0(A[1]), .A1(n1), .B0(n2), .B1(n48), .C0(n40), .Y(N49) );
  NAND3X1M U12 ( .A(Logic_Enable), .B(n5), .C(ALU_FUN[0]), .Y(n19) );
  CLKINVX1M U13 ( .A(A[0]), .Y(n49) );
  CLKINVX1M U14 ( .A(A[1]), .Y(n48) );
  CLKINVX1M U15 ( .A(A[2]), .Y(n47) );
  CLKINVX1M U16 ( .A(A[3]), .Y(n46) );
  CLKINVX1M U17 ( .A(A[4]), .Y(n17) );
  CLKINVX1M U18 ( .A(A[5]), .Y(n16) );
  CLKINVX1M U19 ( .A(A[6]), .Y(n15) );
  INVXLM U20 ( .A(B[1]), .Y(n12) );
  INVXLM U21 ( .A(B[2]), .Y(n11) );
  INVXLM U22 ( .A(B[3]), .Y(n10) );
  INVXLM U23 ( .A(B[4]), .Y(n9) );
  INVXLM U24 ( .A(B[0]), .Y(n13) );
  CLKINVX1M U25 ( .A(A[7]), .Y(n14) );
  NAND2X6M U26 ( .A(Logic_Enable), .B(n5), .Y(n23) );
  CLKBUFX8M U27 ( .A(RST), .Y(n3) );
  BUFX4M U28 ( .A(RST), .Y(n4) );
  NAND2X5M U29 ( .A(Logic_Enable), .B(ALU_FUN[1]), .Y(n24) );
  INVX1M U30 ( .A(ALU_FUN[1]), .Y(n5) );
  BUFX10M U31 ( .A(n19), .Y(n2) );
  NAND3BXLM U32 ( .AN(ALU_FUN[0]), .B(ALU_FUN[1]), .C(Logic_Enable), .Y(n18)
         );
  CLKAND2X6M U33 ( .A(Logic_Enable), .B(ALU_FUN[1]), .Y(N63) );
  OAI21X2M U34 ( .A0(n23), .A1(n49), .B0(n2), .Y(n45) );
  OAI21X2M U35 ( .A0(n23), .A1(n48), .B0(n2), .Y(n42) );
  OAI21X2M U36 ( .A0(n23), .A1(n47), .B0(n2), .Y(n39) );
  OAI21X2M U37 ( .A0(n23), .A1(n46), .B0(n2), .Y(n36) );
  OAI21X2M U38 ( .A0(n23), .A1(n17), .B0(n2), .Y(n33) );
  OAI21X2M U39 ( .A0(n23), .A1(n16), .B0(n2), .Y(n30) );
  OAI21X2M U40 ( .A0(n23), .A1(n15), .B0(n2), .Y(n27) );
  OAI21X2M U41 ( .A0(n23), .A1(n14), .B0(n2), .Y(n22) );
  AOI22X1M U42 ( .A0(n26), .A1(n7), .B0(B[6]), .B1(n27), .Y(n25) );
  INVXLM U43 ( .A(B[6]), .Y(n7) );
  OAI21X1M U44 ( .A0(A[6]), .A1(n24), .B0(n1), .Y(n26) );
  AOI22X1M U45 ( .A0(n41), .A1(n12), .B0(B[1]), .B1(n42), .Y(n40) );
  OAI21X1M U46 ( .A0(A[1]), .A1(n24), .B0(n1), .Y(n41) );
  AOI22X1M U47 ( .A0(n38), .A1(n11), .B0(B[2]), .B1(n39), .Y(n37) );
  OAI21X1M U48 ( .A0(A[2]), .A1(n24), .B0(n1), .Y(n38) );
  AOI22X1M U49 ( .A0(n35), .A1(n10), .B0(B[3]), .B1(n36), .Y(n34) );
  OAI21X1M U50 ( .A0(A[3]), .A1(n24), .B0(n1), .Y(n35) );
  AOI22X1M U51 ( .A0(n32), .A1(n9), .B0(B[4]), .B1(n33), .Y(n31) );
  OAI21X1M U52 ( .A0(A[4]), .A1(n24), .B0(n1), .Y(n32) );
  AOI22X1M U53 ( .A0(n29), .A1(n8), .B0(B[5]), .B1(n30), .Y(n28) );
  INVX2M U54 ( .A(B[5]), .Y(n8) );
  OAI21X1M U55 ( .A0(A[5]), .A1(n24), .B0(n1), .Y(n29) );
  AOI22X1M U56 ( .A0(n44), .A1(n13), .B0(B[0]), .B1(n45), .Y(n43) );
  OAI21X1M U57 ( .A0(A[0]), .A1(n24), .B0(n1), .Y(n44) );
  AOI22X1M U58 ( .A0(n21), .A1(n6), .B0(B[7]), .B1(n22), .Y(n20) );
  INVXLM U59 ( .A(B[7]), .Y(n6) );
  OAI21X1M U60 ( .A0(A[7]), .A1(n24), .B0(n1), .Y(n21) );
endmodule


module CMP_Unit_Width16 ( A, B, ALU_FUN, CMP_Enable, CLK, RST, CMP_OUT, 
        CMP_Flag );
  input [7:0] A;
  input [7:0] B;
  input [1:0] ALU_FUN;
  output [15:0] CMP_OUT;
  input CMP_Enable, CLK, RST;
  output CMP_Flag;
  wire   N14, N16, N19, N20, n8, n9, n31, n32, n33, n34, n35, n36, n37, n38,
         n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52,
         n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66,
         n67, n68, n69, n70;

  DFFRQX2M \CMP_OUT_reg[1]  ( .D(N20), .CK(CLK), .RN(n31), .Q(CMP_OUT[1]) );
  DFFRQX2M \CMP_OUT_reg[0]  ( .D(N19), .CK(CLK), .RN(n31), .Q(CMP_OUT[0]) );
  DFFRQX2M CMP_Flag_reg ( .D(CMP_Enable), .CK(CLK), .RN(n31), .Q(CMP_Flag) );
  INVX2M U5 ( .A(1'b1), .Y(CMP_OUT[2]) );
  INVX2M U19 ( .A(1'b1), .Y(CMP_OUT[3]) );
  INVX2M U21 ( .A(1'b1), .Y(CMP_OUT[4]) );
  INVX2M U23 ( .A(1'b1), .Y(CMP_OUT[5]) );
  INVX2M U25 ( .A(1'b1), .Y(CMP_OUT[6]) );
  INVX2M U27 ( .A(1'b1), .Y(CMP_OUT[7]) );
  INVX2M U29 ( .A(1'b1), .Y(CMP_OUT[8]) );
  INVX2M U31 ( .A(1'b1), .Y(CMP_OUT[9]) );
  INVX2M U33 ( .A(1'b1), .Y(CMP_OUT[10]) );
  INVX2M U35 ( .A(1'b1), .Y(CMP_OUT[11]) );
  INVX2M U37 ( .A(1'b1), .Y(CMP_OUT[12]) );
  INVX2M U39 ( .A(1'b1), .Y(CMP_OUT[13]) );
  INVX2M U41 ( .A(1'b1), .Y(CMP_OUT[14]) );
  INVX2M U43 ( .A(1'b1), .Y(CMP_OUT[15]) );
  AOI2B1X1M U45 ( .A1N(n56), .A0(n55), .B0(n54), .Y(n57) );
  INVX2M U46 ( .A(n57), .Y(n67) );
  NOR2X4M U47 ( .A(n61), .B(A[0]), .Y(n32) );
  INVX2M U48 ( .A(B[0]), .Y(n61) );
  OAI31X4M U49 ( .A0(n44), .A1(n35), .A2(n34), .B0(n45), .Y(n37) );
  NOR2X3M U50 ( .A(n63), .B(A[2]), .Y(n35) );
  NOR2X3M U51 ( .A(n60), .B(B[7]), .Y(n54) );
  AOI211X4M U52 ( .A0(A[1]), .A1(n62), .B0(n41), .C0(n33), .Y(n34) );
  AOI211X2M U53 ( .A0(n42), .A1(n58), .B0(n41), .C0(n40), .Y(n43) );
  OAI21X4M U54 ( .A0(n54), .A1(n39), .B0(n55), .Y(N16) );
  AOI32X2M U55 ( .A0(n38), .A1(n48), .A2(n51), .B0(B[6]), .B1(n59), .Y(n39) );
  NOR2X3M U56 ( .A(n65), .B(A[3]), .Y(n44) );
  XNOR2X4M U57 ( .A(A[6]), .B(B[6]), .Y(n51) );
  NAND2X1M U58 ( .A(A[2]), .B(n63), .Y(n46) );
  NAND2X1M U59 ( .A(A[0]), .B(n61), .Y(n42) );
  NAND2X1M U60 ( .A(A[3]), .B(n65), .Y(n45) );
  CLKINVX1M U61 ( .A(B[2]), .Y(n63) );
  CLKINVX1M U62 ( .A(B[3]), .Y(n65) );
  NAND2X1M U63 ( .A(B[7]), .B(n60), .Y(n55) );
  INVX2M U64 ( .A(CMP_Enable), .Y(n70) );
  CLKINVX1M U65 ( .A(ALU_FUN[1]), .Y(n69) );
  CLKINVX1M U66 ( .A(ALU_FUN[0]), .Y(n68) );
  CLKBUFX2M U67 ( .A(RST), .Y(n31) );
  NOR3X2M U68 ( .A(n70), .B(n8), .C(n69), .Y(N20) );
  AOI22X1M U69 ( .A0(n67), .A1(n68), .B0(N16), .B1(ALU_FUN[0]), .Y(n8) );
  NOR3X2M U70 ( .A(n70), .B(n9), .C(n68), .Y(N19) );
  AOI22X1M U71 ( .A0(N14), .A1(n69), .B0(ALU_FUN[1]), .B1(N16), .Y(n9) );
  INVXLM U72 ( .A(A[6]), .Y(n59) );
  INVXLM U73 ( .A(n32), .Y(n62) );
  INVXLM U74 ( .A(B[6]), .Y(n66) );
  INVXLM U75 ( .A(n43), .Y(n64) );
  CLKINVX2M U76 ( .A(A[1]), .Y(n58) );
  CLKINVX1M U77 ( .A(A[7]), .Y(n60) );
  NAND2BX1M U78 ( .AN(B[4]), .B(A[4]), .Y(n47) );
  NAND2BX1M U79 ( .AN(A[4]), .B(B[4]), .Y(n36) );
  CLKNAND2X2M U80 ( .A(n47), .B(n36), .Y(n49) );
  NAND2BX1M U81 ( .AN(n35), .B(n46), .Y(n41) );
  AOI21X1M U82 ( .A0(n32), .A1(n58), .B0(B[1]), .Y(n33) );
  NAND2BX1M U83 ( .AN(A[5]), .B(B[5]), .Y(n52) );
  OAI211X1M U84 ( .A0(n49), .A1(n37), .B0(n36), .C0(n52), .Y(n38) );
  NAND2BX1M U85 ( .AN(B[5]), .B(A[5]), .Y(n48) );
  OA21X1M U86 ( .A0(n42), .A1(n58), .B0(B[1]), .Y(n40) );
  AOI31X1M U87 ( .A0(n64), .A1(n46), .A2(n45), .B0(n44), .Y(n50) );
  OAI2B11X1M U88 ( .A1N(n50), .A0(n49), .B0(n48), .C0(n47), .Y(n53) );
  AOI32X1M U89 ( .A0(n53), .A1(n52), .A2(n51), .B0(A[6]), .B1(n66), .Y(n56) );
  NOR2X1M U90 ( .A(N16), .B(n67), .Y(N14) );
endmodule


module Shift_Unit_Width16 ( A, B, ALU_FUN, CLK, RST, Shift_Enable, Shift_OUT, 
        Shift_Flag );
  input [7:0] A;
  input [7:0] B;
  input [1:0] ALU_FUN;
  output [15:0] Shift_OUT;
  input CLK, RST, Shift_Enable;
  output Shift_Flag;
  wire   N16, N17, N18, N19, N20, N21, N22, N23, N24, n4, n5, n6, n7, n8, n9,
         n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n34,
         n35, n36, n37, n38;

  NOR2X12M U31 ( .A(n37), .B(n36), .Y(n5) );
  NOR2X12M U33 ( .A(n36), .B(ALU_FUN[1]), .Y(n6) );
  NOR2X12M U36 ( .A(ALU_FUN[0]), .B(ALU_FUN[1]), .Y(n11) );
  NOR2X12M U37 ( .A(n37), .B(ALU_FUN[0]), .Y(n10) );
  DFFRQX2M \Shift_OUT_reg[8]  ( .D(N24), .CK(CLK), .RN(n34), .Q(Shift_OUT[8])
         );
  DFFRQX2M \Shift_OUT_reg[7]  ( .D(N23), .CK(CLK), .RN(n34), .Q(Shift_OUT[7])
         );
  DFFRQX2M \Shift_OUT_reg[6]  ( .D(N22), .CK(CLK), .RN(n34), .Q(Shift_OUT[6])
         );
  DFFRQX2M \Shift_OUT_reg[5]  ( .D(N21), .CK(CLK), .RN(n34), .Q(Shift_OUT[5])
         );
  DFFRQX2M \Shift_OUT_reg[4]  ( .D(N20), .CK(CLK), .RN(n34), .Q(Shift_OUT[4])
         );
  DFFRQX2M \Shift_OUT_reg[3]  ( .D(N19), .CK(CLK), .RN(n34), .Q(Shift_OUT[3])
         );
  DFFRQX2M \Shift_OUT_reg[2]  ( .D(N18), .CK(CLK), .RN(n34), .Q(Shift_OUT[2])
         );
  DFFRQX2M \Shift_OUT_reg[1]  ( .D(N17), .CK(CLK), .RN(n34), .Q(Shift_OUT[1])
         );
  DFFRQX2M \Shift_OUT_reg[0]  ( .D(N16), .CK(CLK), .RN(n34), .Q(Shift_OUT[0])
         );
  DFFRQX2M Shift_Flag_reg ( .D(Shift_Enable), .CK(CLK), .RN(n34), .Q(
        Shift_Flag) );
  INVX2M U10 ( .A(1'b1), .Y(Shift_OUT[9]) );
  INVX2M U12 ( .A(1'b1), .Y(Shift_OUT[10]) );
  INVX2M U14 ( .A(1'b1), .Y(Shift_OUT[11]) );
  INVX2M U16 ( .A(1'b1), .Y(Shift_OUT[12]) );
  INVX2M U18 ( .A(1'b1), .Y(Shift_OUT[13]) );
  INVX2M U20 ( .A(1'b1), .Y(Shift_OUT[14]) );
  INVX2M U22 ( .A(1'b1), .Y(Shift_OUT[15]) );
  INVX6M U24 ( .A(Shift_Enable), .Y(n38) );
  CLKINVX2M U25 ( .A(ALU_FUN[1]), .Y(n37) );
  CLKINVX2M U26 ( .A(ALU_FUN[0]), .Y(n36) );
  CLKINVX6M U27 ( .A(n35), .Y(n34) );
  INVX2M U28 ( .A(RST), .Y(n35) );
  AOI21X2M U29 ( .A0(n16), .A1(n17), .B0(n38), .Y(N19) );
  AOI22X1M U30 ( .A0(A[2]), .A1(n6), .B0(A[4]), .B1(n11), .Y(n16) );
  AOI22X1M U32 ( .A0(B[2]), .A1(n5), .B0(B[4]), .B1(n10), .Y(n17) );
  AOI21X2M U34 ( .A0(n18), .A1(n19), .B0(n38), .Y(N18) );
  AOI22X1M U35 ( .A0(A[1]), .A1(n6), .B0(A[3]), .B1(n11), .Y(n18) );
  AOI22X1M U38 ( .A0(B[1]), .A1(n5), .B0(B[3]), .B1(n10), .Y(n19) );
  AOI21X2M U39 ( .A0(n12), .A1(n13), .B0(n38), .Y(N21) );
  AOI22X1M U40 ( .A0(A[4]), .A1(n6), .B0(n11), .B1(A[6]), .Y(n12) );
  AOI22X1M U41 ( .A0(B[4]), .A1(n5), .B0(n10), .B1(B[6]), .Y(n13) );
  AOI21X2M U42 ( .A0(n8), .A1(n9), .B0(n38), .Y(N22) );
  AOI22X1M U43 ( .A0(A[5]), .A1(n6), .B0(n11), .B1(A[7]), .Y(n8) );
  AOI22X1M U44 ( .A0(B[5]), .A1(n5), .B0(n10), .B1(B[7]), .Y(n9) );
  AOI21X2M U45 ( .A0(n20), .A1(n21), .B0(n38), .Y(N17) );
  AOI22X1M U46 ( .A0(A[0]), .A1(n6), .B0(A[2]), .B1(n11), .Y(n20) );
  AOI22X1M U47 ( .A0(B[0]), .A1(n5), .B0(B[2]), .B1(n10), .Y(n21) );
  AOI21X2M U48 ( .A0(n14), .A1(n15), .B0(n38), .Y(N20) );
  AOI22X1M U49 ( .A0(A[3]), .A1(n6), .B0(n11), .B1(A[5]), .Y(n14) );
  AOI22X1M U50 ( .A0(B[3]), .A1(n5), .B0(n10), .B1(B[5]), .Y(n15) );
  NOR2X2M U51 ( .A(n7), .B(n38), .Y(N23) );
  AOI22X1M U52 ( .A0(B[6]), .A1(n5), .B0(A[6]), .B1(n6), .Y(n7) );
  NOR2X2M U53 ( .A(n22), .B(n38), .Y(N16) );
  AOI22X1M U54 ( .A0(B[1]), .A1(n10), .B0(A[1]), .B1(n11), .Y(n22) );
  NOR2X2M U55 ( .A(n4), .B(n38), .Y(N24) );
  AOI22X1M U56 ( .A0(B[7]), .A1(n5), .B0(A[7]), .B1(n6), .Y(n4) );
endmodule


module OR_Gate ( Arith_Flag, Logic_Flag, CMP_Flag, Shift_Flag, OUT_VALID );
  input Arith_Flag, Logic_Flag, CMP_Flag, Shift_Flag;
  output OUT_VALID;


  OR4X1M U1 ( .A(CMP_Flag), .B(Arith_Flag), .C(Shift_Flag), .D(Logic_Flag), 
        .Y(OUT_VALID) );
endmodule


module ALU ( A, B, ALU_FUN, CLK, RST, Enable, ALU_OUT, OUT_VALID );
  input [7:0] A;
  input [7:0] B;
  input [3:0] ALU_FUN;
  output [15:0] ALU_OUT;
  input CLK, RST, Enable;
  output OUT_VALID;
  wire   Arith_Enable, Logic_Enable, CMP_Enable, Shift_Enable, Arith_Flag,
         Logic_Flag, CMP_Flag, Shift_Flag, n1, n2;
  wire   [15:0] Arith_OUT;
  wire   [15:0] Logic_OUT;
  wire   [15:0] CMP_OUT;
  wire   [15:0] Shift_OUT;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3, 
        SYNOPSYS_UNCONNECTED__4, SYNOPSYS_UNCONNECTED__5, 
        SYNOPSYS_UNCONNECTED__6, SYNOPSYS_UNCONNECTED__7, 
        SYNOPSYS_UNCONNECTED__8, SYNOPSYS_UNCONNECTED__9, 
        SYNOPSYS_UNCONNECTED__10, SYNOPSYS_UNCONNECTED__11, 
        SYNOPSYS_UNCONNECTED__12, SYNOPSYS_UNCONNECTED__13, 
        SYNOPSYS_UNCONNECTED__14, SYNOPSYS_UNCONNECTED__15, 
        SYNOPSYS_UNCONNECTED__16, SYNOPSYS_UNCONNECTED__17, 
        SYNOPSYS_UNCONNECTED__18, SYNOPSYS_UNCONNECTED__19, 
        SYNOPSYS_UNCONNECTED__20;

  Decoder2X4 U1 ( .Enable(Enable), .ALU_FUN(ALU_FUN[3:2]), .Arith_Enable(
        Arith_Enable), .Logic_Enable(Logic_Enable), .CMP_Enable(CMP_Enable), 
        .Shift_Enable(Shift_Enable) );
  Decoder2X4_ALU_OUT_Width16 U7 ( .ALU_FUN(ALU_FUN[3:2]), .Arith_OUT(Arith_OUT), .Logic_OUT(Logic_OUT), .CMP_OUT({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, CMP_OUT[1:0]}), .Shift_OUT({
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, Shift_OUT[8:0]}), .ALU_OUT(
        ALU_OUT) );
  Arithmatic_Unit_Width16 U2 ( .A(A), .B(B), .ALU_FUN(ALU_FUN[1:0]), .CLK(CLK), 
        .RST(n1), .Arith_Enable(Arith_Enable), .Arith_OUT(Arith_OUT), 
        .Arith_Flag(Arith_Flag) );
  Logic_Unit_Width16 U3 ( .A(A), .B(B), .ALU_FUN(ALU_FUN[1:0]), .CLK(CLK), 
        .Logic_Enable(Logic_Enable), .RST(n1), .Logic_OUT(Logic_OUT), 
        .Logic_Flag(Logic_Flag) );
  CMP_Unit_Width16 U4 ( .A(A), .B(B), .ALU_FUN(ALU_FUN[1:0]), .CMP_Enable(
        CMP_Enable), .CLK(CLK), .RST(n1), .CMP_OUT({SYNOPSYS_UNCONNECTED__0, 
        SYNOPSYS_UNCONNECTED__1, SYNOPSYS_UNCONNECTED__2, 
        SYNOPSYS_UNCONNECTED__3, SYNOPSYS_UNCONNECTED__4, 
        SYNOPSYS_UNCONNECTED__5, SYNOPSYS_UNCONNECTED__6, 
        SYNOPSYS_UNCONNECTED__7, SYNOPSYS_UNCONNECTED__8, 
        SYNOPSYS_UNCONNECTED__9, SYNOPSYS_UNCONNECTED__10, 
        SYNOPSYS_UNCONNECTED__11, SYNOPSYS_UNCONNECTED__12, 
        SYNOPSYS_UNCONNECTED__13, CMP_OUT[1:0]}), .CMP_Flag(CMP_Flag) );
  Shift_Unit_Width16 U5 ( .A(A), .B(B), .ALU_FUN(ALU_FUN[1:0]), .CLK(CLK), 
        .RST(n1), .Shift_Enable(Shift_Enable), .Shift_OUT({
        SYNOPSYS_UNCONNECTED__14, SYNOPSYS_UNCONNECTED__15, 
        SYNOPSYS_UNCONNECTED__16, SYNOPSYS_UNCONNECTED__17, 
        SYNOPSYS_UNCONNECTED__18, SYNOPSYS_UNCONNECTED__19, 
        SYNOPSYS_UNCONNECTED__20, Shift_OUT[8:0]}), .Shift_Flag(Shift_Flag) );
  OR_Gate U6 ( .Arith_Flag(Arith_Flag), .Logic_Flag(Logic_Flag), .CMP_Flag(
        CMP_Flag), .Shift_Flag(Shift_Flag), .OUT_VALID(OUT_VALID) );
  INVX4M U8 ( .A(n2), .Y(n1) );
  INVX2M U9 ( .A(RST), .Y(n2) );
endmodule


module Reg_File ( CLK, RST, RdEn, WrEn, Address, WrData, RdData, Reg0, Reg1, 
        Reg2, Reg3, RdData_Valid );
  input [3:0] Address;
  input [7:0] WrData;
  output [7:0] RdData;
  output [7:0] Reg0;
  output [7:0] Reg1;
  output [7:0] Reg2;
  output [7:0] Reg3;
  input CLK, RST, RdEn, WrEn;
  output RdData_Valid;
  wire   N10, N11, N12, N13, n279, n280, n281, n282, n283, n284, n285, n286,
         n287, n288, \MEM[15][7] , \MEM[15][6] , \MEM[15][5] , \MEM[15][4] ,
         \MEM[15][3] , \MEM[15][2] , \MEM[15][1] , \MEM[15][0] , \MEM[14][7] ,
         \MEM[14][6] , \MEM[14][5] , \MEM[14][4] , \MEM[14][3] , \MEM[14][2] ,
         \MEM[14][1] , \MEM[14][0] , \MEM[13][7] , \MEM[13][6] , \MEM[13][5] ,
         \MEM[13][4] , \MEM[13][3] , \MEM[13][2] , \MEM[13][1] , \MEM[13][0] ,
         \MEM[12][7] , \MEM[12][6] , \MEM[12][5] , \MEM[12][4] , \MEM[12][3] ,
         \MEM[12][2] , \MEM[12][1] , \MEM[12][0] , \MEM[11][7] , \MEM[11][6] ,
         \MEM[11][5] , \MEM[11][4] , \MEM[11][3] , \MEM[11][2] , \MEM[11][1] ,
         \MEM[11][0] , \MEM[10][7] , \MEM[10][6] , \MEM[10][5] , \MEM[10][4] ,
         \MEM[10][3] , \MEM[10][2] , \MEM[10][1] , \MEM[10][0] , \MEM[9][7] ,
         \MEM[9][6] , \MEM[9][5] , \MEM[9][4] , \MEM[9][3] , \MEM[9][2] ,
         \MEM[9][1] , \MEM[9][0] , \MEM[8][7] , \MEM[8][6] , \MEM[8][5] ,
         \MEM[8][4] , \MEM[8][3] , \MEM[8][2] , \MEM[8][1] , \MEM[8][0] ,
         \MEM[7][7] , \MEM[7][6] , \MEM[7][5] , \MEM[7][4] , \MEM[7][3] ,
         \MEM[7][2] , \MEM[7][1] , \MEM[7][0] , \MEM[6][7] , \MEM[6][6] ,
         \MEM[6][5] , \MEM[6][4] , \MEM[6][3] , \MEM[6][2] , \MEM[6][1] ,
         \MEM[6][0] , \MEM[5][7] , \MEM[5][6] , \MEM[5][5] , \MEM[5][4] ,
         \MEM[5][3] , \MEM[5][2] , \MEM[5][1] , \MEM[5][0] , \MEM[4][7] ,
         \MEM[4][6] , \MEM[4][5] , \MEM[4][4] , \MEM[4][3] , \MEM[4][2] ,
         \MEM[4][1] , \MEM[4][0] , N19, N20, N21, N22, N23, N24, N25, N26, n12,
         n13, n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26,
         n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40,
         n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54,
         n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68,
         n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82,
         n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96,
         n97, n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108,
         n109, n110, n111, n112, n113, n114, n115, n116, n117, n118, n119,
         n120, n121, n122, n123, n124, n125, n126, n127, n128, n129, n130,
         n131, n132, n133, n134, n135, n136, n137, n138, n139, n140, n141,
         n142, n143, n144, n145, n146, n147, n148, n149, n150, n151, n152,
         n153, n154, n155, n156, n157, n158, n159, n160, n161, n162, n163,
         n164, n165, n166, n167, n168, n169, n170, n171, n172, n173, n174,
         n175, n1, n3, n5, n7, n9, n178, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197,
         n198, n199, n200, n201, n202, n203, n204, n205, n206, n207, n208,
         n209, n210, n211, n212, n213, n214, n215, n216, n217, n218, n219,
         n220, n221, n222, n223, n224, n225, n226, n227, n228, n229, n230,
         n231, n232, n233, n234, n235, n236, n237, n238, n239, n240, n241,
         n242, n243, n244, n245, n246, n247, n248, n249, n250, n251, n252,
         n253, n254, n255, n256, n257, n258, n259, n260, n261, n262, n263,
         n264, n265, n266, n267, n268, n269, n270, n271, n272, n273, n274,
         n275, n276, n277, n278;
  assign N10 = Address[0];
  assign N11 = Address[1];
  assign N12 = Address[2];
  assign N13 = Address[3];

  DFFRHQX8M \MEM_reg[2][4]  ( .D(n68), .CK(CLK), .RN(n257), .Q(Reg2[4]) );
  DFFRHQX8M \MEM_reg[1][5]  ( .D(n61), .CK(CLK), .RN(n259), .Q(Reg1[5]) );
  DFFRHQX8M \MEM_reg[1][4]  ( .D(n60), .CK(CLK), .RN(n257), .Q(Reg1[4]) );
  DFFRHQX8M \MEM_reg[1][3]  ( .D(n59), .CK(CLK), .RN(n258), .Q(Reg1[3]) );
  DFFRHQX8M \MEM_reg[1][2]  ( .D(n58), .CK(CLK), .RN(n259), .Q(Reg1[2]) );
  DFFRHQX8M \MEM_reg[1][1]  ( .D(n57), .CK(CLK), .RN(n257), .Q(Reg1[1]) );
  DFFRHQX8M \MEM_reg[1][0]  ( .D(n56), .CK(CLK), .RN(n258), .Q(Reg1[0]) );
  DFFRQX2M \RdData_reg[7]  ( .D(n47), .CK(CLK), .RN(n256), .Q(RdData[7]) );
  DFFRQX2M \RdData_reg[6]  ( .D(n46), .CK(CLK), .RN(n256), .Q(RdData[6]) );
  DFFRQX2M \RdData_reg[5]  ( .D(n45), .CK(CLK), .RN(n256), .Q(RdData[5]) );
  DFFRQX2M \RdData_reg[4]  ( .D(n44), .CK(CLK), .RN(n256), .Q(RdData[4]) );
  DFFRQX2M \RdData_reg[3]  ( .D(n43), .CK(CLK), .RN(n256), .Q(RdData[3]) );
  DFFRQX2M \RdData_reg[2]  ( .D(n42), .CK(CLK), .RN(n256), .Q(RdData[2]) );
  DFFRQX2M \RdData_reg[1]  ( .D(n41), .CK(CLK), .RN(n256), .Q(RdData[1]) );
  DFFRQX2M \RdData_reg[0]  ( .D(n40), .CK(CLK), .RN(n256), .Q(RdData[0]) );
  DFFRQX2M RdData_Valid_reg ( .D(n270), .CK(CLK), .RN(n260), .Q(RdData_Valid)
         );
  DFFRQX2M \MEM_reg[13][7]  ( .D(n159), .CK(CLK), .RN(n264), .Q(\MEM[13][7] )
         );
  DFFRQX2M \MEM_reg[13][6]  ( .D(n158), .CK(CLK), .RN(n264), .Q(\MEM[13][6] )
         );
  DFFRQX2M \MEM_reg[13][5]  ( .D(n157), .CK(CLK), .RN(n264), .Q(\MEM[13][5] )
         );
  DFFRQX2M \MEM_reg[13][4]  ( .D(n156), .CK(CLK), .RN(n264), .Q(\MEM[13][4] )
         );
  DFFRQX2M \MEM_reg[13][3]  ( .D(n155), .CK(CLK), .RN(n264), .Q(\MEM[13][3] )
         );
  DFFRQX2M \MEM_reg[13][2]  ( .D(n154), .CK(CLK), .RN(n263), .Q(\MEM[13][2] )
         );
  DFFRQX2M \MEM_reg[13][1]  ( .D(n153), .CK(CLK), .RN(n263), .Q(\MEM[13][1] )
         );
  DFFRQX2M \MEM_reg[13][0]  ( .D(n152), .CK(CLK), .RN(n263), .Q(\MEM[13][0] )
         );
  DFFRQX2M \MEM_reg[9][7]  ( .D(n127), .CK(CLK), .RN(n261), .Q(\MEM[9][7] ) );
  DFFRQX2M \MEM_reg[9][6]  ( .D(n126), .CK(CLK), .RN(n261), .Q(\MEM[9][6] ) );
  DFFRQX2M \MEM_reg[9][5]  ( .D(n125), .CK(CLK), .RN(n261), .Q(\MEM[9][5] ) );
  DFFRQX2M \MEM_reg[9][4]  ( .D(n124), .CK(CLK), .RN(n261), .Q(\MEM[9][4] ) );
  DFFRQX2M \MEM_reg[9][3]  ( .D(n123), .CK(CLK), .RN(n261), .Q(\MEM[9][3] ) );
  DFFRQX2M \MEM_reg[9][2]  ( .D(n122), .CK(CLK), .RN(n261), .Q(\MEM[9][2] ) );
  DFFRQX2M \MEM_reg[9][1]  ( .D(n121), .CK(CLK), .RN(n261), .Q(\MEM[9][1] ) );
  DFFRQX2M \MEM_reg[9][0]  ( .D(n120), .CK(CLK), .RN(n261), .Q(\MEM[9][0] ) );
  DFFRQX2M \MEM_reg[5][7]  ( .D(n95), .CK(CLK), .RN(n259), .Q(\MEM[5][7] ) );
  DFFRQX2M \MEM_reg[5][6]  ( .D(n94), .CK(CLK), .RN(n259), .Q(\MEM[5][6] ) );
  DFFRQX2M \MEM_reg[5][5]  ( .D(n93), .CK(CLK), .RN(n259), .Q(\MEM[5][5] ) );
  DFFRQX2M \MEM_reg[5][4]  ( .D(n92), .CK(CLK), .RN(n259), .Q(\MEM[5][4] ) );
  DFFRQX2M \MEM_reg[5][3]  ( .D(n91), .CK(CLK), .RN(n259), .Q(\MEM[5][3] ) );
  DFFRQX2M \MEM_reg[5][2]  ( .D(n90), .CK(CLK), .RN(n258), .Q(\MEM[5][2] ) );
  DFFRQX2M \MEM_reg[5][1]  ( .D(n89), .CK(CLK), .RN(n258), .Q(\MEM[5][1] ) );
  DFFRQX2M \MEM_reg[5][0]  ( .D(n88), .CK(CLK), .RN(n258), .Q(\MEM[5][0] ) );
  DFFRQX2M \MEM_reg[15][7]  ( .D(n175), .CK(CLK), .RN(n256), .Q(\MEM[15][7] )
         );
  DFFRQX2M \MEM_reg[15][6]  ( .D(n174), .CK(CLK), .RN(n256), .Q(\MEM[15][6] )
         );
  DFFRQX2M \MEM_reg[15][5]  ( .D(n173), .CK(CLK), .RN(n260), .Q(\MEM[15][5] )
         );
  DFFRQX2M \MEM_reg[15][4]  ( .D(n172), .CK(CLK), .RN(n261), .Q(\MEM[15][4] )
         );
  DFFRQX2M \MEM_reg[15][3]  ( .D(n171), .CK(CLK), .RN(n262), .Q(\MEM[15][3] )
         );
  DFFRQX2M \MEM_reg[15][2]  ( .D(n170), .CK(CLK), .RN(n263), .Q(\MEM[15][2] )
         );
  DFFRQX2M \MEM_reg[15][1]  ( .D(n169), .CK(CLK), .RN(n264), .Q(\MEM[15][1] )
         );
  DFFRQX2M \MEM_reg[15][0]  ( .D(n168), .CK(CLK), .RN(n265), .Q(\MEM[15][0] )
         );
  DFFRQX2M \MEM_reg[11][7]  ( .D(n143), .CK(CLK), .RN(n263), .Q(\MEM[11][7] )
         );
  DFFRQX2M \MEM_reg[11][6]  ( .D(n142), .CK(CLK), .RN(n263), .Q(\MEM[11][6] )
         );
  DFFRQX2M \MEM_reg[11][5]  ( .D(n141), .CK(CLK), .RN(n262), .Q(\MEM[11][5] )
         );
  DFFRQX2M \MEM_reg[11][4]  ( .D(n140), .CK(CLK), .RN(n262), .Q(\MEM[11][4] )
         );
  DFFRQX2M \MEM_reg[11][3]  ( .D(n139), .CK(CLK), .RN(n262), .Q(\MEM[11][3] )
         );
  DFFRQX2M \MEM_reg[11][2]  ( .D(n138), .CK(CLK), .RN(n262), .Q(\MEM[11][2] )
         );
  DFFRQX2M \MEM_reg[11][1]  ( .D(n137), .CK(CLK), .RN(n262), .Q(\MEM[11][1] )
         );
  DFFRQX2M \MEM_reg[11][0]  ( .D(n136), .CK(CLK), .RN(n262), .Q(\MEM[11][0] )
         );
  DFFRQX2M \MEM_reg[7][7]  ( .D(n111), .CK(CLK), .RN(n260), .Q(\MEM[7][7] ) );
  DFFRQX2M \MEM_reg[7][6]  ( .D(n110), .CK(CLK), .RN(n260), .Q(\MEM[7][6] ) );
  DFFRQX2M \MEM_reg[7][5]  ( .D(n109), .CK(CLK), .RN(n260), .Q(\MEM[7][5] ) );
  DFFRQX2M \MEM_reg[7][4]  ( .D(n108), .CK(CLK), .RN(n260), .Q(\MEM[7][4] ) );
  DFFRQX2M \MEM_reg[7][3]  ( .D(n107), .CK(CLK), .RN(n260), .Q(\MEM[7][3] ) );
  DFFRQX2M \MEM_reg[7][2]  ( .D(n106), .CK(CLK), .RN(n260), .Q(\MEM[7][2] ) );
  DFFRQX2M \MEM_reg[7][1]  ( .D(n105), .CK(CLK), .RN(n260), .Q(\MEM[7][1] ) );
  DFFRQX2M \MEM_reg[7][0]  ( .D(n104), .CK(CLK), .RN(n260), .Q(\MEM[7][0] ) );
  DFFRQX2M \MEM_reg[3][7]  ( .D(n79), .CK(CLK), .RN(n258), .Q(Reg3[7]) );
  DFFRQX2M \MEM_reg[3][6]  ( .D(n78), .CK(CLK), .RN(n258), .Q(Reg3[6]) );
  DFFRQX2M \MEM_reg[3][5]  ( .D(n77), .CK(CLK), .RN(n257), .Q(Reg3[5]) );
  DFFRQX2M \MEM_reg[14][7]  ( .D(n167), .CK(CLK), .RN(n264), .Q(\MEM[14][7] )
         );
  DFFRQX2M \MEM_reg[14][6]  ( .D(n166), .CK(CLK), .RN(n264), .Q(\MEM[14][6] )
         );
  DFFRQX2M \MEM_reg[14][5]  ( .D(n165), .CK(CLK), .RN(n264), .Q(\MEM[14][5] )
         );
  DFFRQX2M \MEM_reg[14][4]  ( .D(n164), .CK(CLK), .RN(n264), .Q(\MEM[14][4] )
         );
  DFFRQX2M \MEM_reg[14][3]  ( .D(n163), .CK(CLK), .RN(n264), .Q(\MEM[14][3] )
         );
  DFFRQX2M \MEM_reg[14][2]  ( .D(n162), .CK(CLK), .RN(n264), .Q(\MEM[14][2] )
         );
  DFFRQX2M \MEM_reg[14][1]  ( .D(n161), .CK(CLK), .RN(n264), .Q(\MEM[14][1] )
         );
  DFFRQX2M \MEM_reg[14][0]  ( .D(n160), .CK(CLK), .RN(n264), .Q(\MEM[14][0] )
         );
  DFFRQX2M \MEM_reg[10][7]  ( .D(n135), .CK(CLK), .RN(n262), .Q(\MEM[10][7] )
         );
  DFFRQX2M \MEM_reg[10][6]  ( .D(n134), .CK(CLK), .RN(n262), .Q(\MEM[10][6] )
         );
  DFFRQX2M \MEM_reg[10][5]  ( .D(n133), .CK(CLK), .RN(n262), .Q(\MEM[10][5] )
         );
  DFFRQX2M \MEM_reg[10][4]  ( .D(n132), .CK(CLK), .RN(n262), .Q(\MEM[10][4] )
         );
  DFFRQX2M \MEM_reg[10][3]  ( .D(n131), .CK(CLK), .RN(n262), .Q(\MEM[10][3] )
         );
  DFFRQX2M \MEM_reg[10][2]  ( .D(n130), .CK(CLK), .RN(n262), .Q(\MEM[10][2] )
         );
  DFFRQX2M \MEM_reg[10][1]  ( .D(n129), .CK(CLK), .RN(n262), .Q(\MEM[10][1] )
         );
  DFFRQX2M \MEM_reg[10][0]  ( .D(n128), .CK(CLK), .RN(n261), .Q(\MEM[10][0] )
         );
  DFFRQX2M \MEM_reg[6][7]  ( .D(n103), .CK(CLK), .RN(n259), .Q(\MEM[6][7] ) );
  DFFRQX2M \MEM_reg[6][6]  ( .D(n102), .CK(CLK), .RN(n259), .Q(\MEM[6][6] ) );
  DFFRQX2M \MEM_reg[6][5]  ( .D(n101), .CK(CLK), .RN(n259), .Q(\MEM[6][5] ) );
  DFFRQX2M \MEM_reg[6][4]  ( .D(n100), .CK(CLK), .RN(n259), .Q(\MEM[6][4] ) );
  DFFRQX2M \MEM_reg[6][3]  ( .D(n99), .CK(CLK), .RN(n259), .Q(\MEM[6][3] ) );
  DFFRQX2M \MEM_reg[6][2]  ( .D(n98), .CK(CLK), .RN(n259), .Q(\MEM[6][2] ) );
  DFFRQX2M \MEM_reg[6][1]  ( .D(n97), .CK(CLK), .RN(n259), .Q(\MEM[6][1] ) );
  DFFRQX2M \MEM_reg[6][0]  ( .D(n96), .CK(CLK), .RN(n259), .Q(\MEM[6][0] ) );
  DFFRQX2M \MEM_reg[2][7]  ( .D(n71), .CK(CLK), .RN(n257), .Q(Reg2[7]) );
  DFFRQX2M \MEM_reg[2][6]  ( .D(n70), .CK(CLK), .RN(n257), .Q(Reg2[6]) );
  DFFRQX2M \MEM_reg[2][2]  ( .D(n66), .CK(CLK), .RN(n257), .Q(Reg2[2]) );
  DFFRQX2M \MEM_reg[12][7]  ( .D(n151), .CK(CLK), .RN(n263), .Q(\MEM[12][7] )
         );
  DFFRQX2M \MEM_reg[12][6]  ( .D(n150), .CK(CLK), .RN(n263), .Q(\MEM[12][6] )
         );
  DFFRQX2M \MEM_reg[12][5]  ( .D(n149), .CK(CLK), .RN(n263), .Q(\MEM[12][5] )
         );
  DFFRQX2M \MEM_reg[12][4]  ( .D(n148), .CK(CLK), .RN(n263), .Q(\MEM[12][4] )
         );
  DFFRQX2M \MEM_reg[12][3]  ( .D(n147), .CK(CLK), .RN(n263), .Q(\MEM[12][3] )
         );
  DFFRQX2M \MEM_reg[12][2]  ( .D(n146), .CK(CLK), .RN(n263), .Q(\MEM[12][2] )
         );
  DFFRQX2M \MEM_reg[12][1]  ( .D(n145), .CK(CLK), .RN(n263), .Q(\MEM[12][1] )
         );
  DFFRQX2M \MEM_reg[12][0]  ( .D(n144), .CK(CLK), .RN(n263), .Q(\MEM[12][0] )
         );
  DFFRQX2M \MEM_reg[8][7]  ( .D(n119), .CK(CLK), .RN(n261), .Q(\MEM[8][7] ) );
  DFFRQX2M \MEM_reg[8][6]  ( .D(n118), .CK(CLK), .RN(n261), .Q(\MEM[8][6] ) );
  DFFRQX2M \MEM_reg[8][5]  ( .D(n117), .CK(CLK), .RN(n261), .Q(\MEM[8][5] ) );
  DFFRQX2M \MEM_reg[8][4]  ( .D(n116), .CK(CLK), .RN(n261), .Q(\MEM[8][4] ) );
  DFFRQX2M \MEM_reg[8][3]  ( .D(n115), .CK(CLK), .RN(n260), .Q(\MEM[8][3] ) );
  DFFRQX2M \MEM_reg[8][2]  ( .D(n114), .CK(CLK), .RN(n260), .Q(\MEM[8][2] ) );
  DFFRQX2M \MEM_reg[8][1]  ( .D(n113), .CK(CLK), .RN(n260), .Q(\MEM[8][1] ) );
  DFFRQX2M \MEM_reg[8][0]  ( .D(n112), .CK(CLK), .RN(n260), .Q(\MEM[8][0] ) );
  DFFRQX2M \MEM_reg[4][7]  ( .D(n87), .CK(CLK), .RN(n258), .Q(\MEM[4][7] ) );
  DFFRQX2M \MEM_reg[4][6]  ( .D(n86), .CK(CLK), .RN(n258), .Q(\MEM[4][6] ) );
  DFFRQX2M \MEM_reg[4][5]  ( .D(n85), .CK(CLK), .RN(n258), .Q(\MEM[4][5] ) );
  DFFRQX2M \MEM_reg[4][4]  ( .D(n84), .CK(CLK), .RN(n258), .Q(\MEM[4][4] ) );
  DFFRQX2M \MEM_reg[4][3]  ( .D(n83), .CK(CLK), .RN(n258), .Q(\MEM[4][3] ) );
  DFFRQX2M \MEM_reg[4][2]  ( .D(n82), .CK(CLK), .RN(n258), .Q(\MEM[4][2] ) );
  DFFRQX2M \MEM_reg[4][1]  ( .D(n81), .CK(CLK), .RN(n258), .Q(\MEM[4][1] ) );
  DFFRQX2M \MEM_reg[4][0]  ( .D(n80), .CK(CLK), .RN(n258), .Q(\MEM[4][0] ) );
  DFFRQX2M \MEM_reg[2][3]  ( .D(n67), .CK(CLK), .RN(n257), .Q(Reg2[3]) );
  DFFSQX4M \MEM_reg[3][3]  ( .D(n75), .CK(CLK), .SN(n256), .Q(Reg3[3]) );
  DFFSQX4M \MEM_reg[2][0]  ( .D(n64), .CK(CLK), .SN(n256), .Q(Reg2[0]) );
  DFFRQX2M \MEM_reg[0][7]  ( .D(n55), .CK(CLK), .RN(n262), .Q(n279) );
  DFFRQX2M \MEM_reg[0][1]  ( .D(n49), .CK(CLK), .RN(n256), .Q(n285) );
  DFFRQX2M \MEM_reg[1][6]  ( .D(n62), .CK(CLK), .RN(n257), .Q(n288) );
  DFFRQX2M \MEM_reg[1][7]  ( .D(n63), .CK(CLK), .RN(n257), .Q(n287) );
  DFFSHQX8M \MEM_reg[2][5]  ( .D(n69), .CK(CLK), .SN(RST), .Q(Reg2[5]) );
  DFFRQX2M \MEM_reg[0][3]  ( .D(n51), .CK(CLK), .RN(n261), .Q(n283) );
  DFFRQX2M \MEM_reg[0][2]  ( .D(n50), .CK(CLK), .RN(n260), .Q(n284) );
  DFFRQX2M \MEM_reg[0][4]  ( .D(n52), .CK(CLK), .RN(n256), .Q(n282) );
  DFFRQX2M \MEM_reg[0][5]  ( .D(n53), .CK(CLK), .RN(n256), .Q(n281) );
  DFFRQX4M \MEM_reg[3][4]  ( .D(n76), .CK(CLK), .RN(n257), .Q(Reg3[4]) );
  DFFRQX4M \MEM_reg[3][2]  ( .D(n74), .CK(CLK), .RN(n257), .Q(Reg3[2]) );
  DFFRQX4M \MEM_reg[3][1]  ( .D(n73), .CK(CLK), .RN(n257), .Q(Reg3[1]) );
  DFFRQX4M \MEM_reg[3][0]  ( .D(n72), .CK(CLK), .RN(n257), .Q(Reg3[0]) );
  DFFRQX4M \MEM_reg[2][1]  ( .D(n65), .CK(CLK), .RN(n257), .Q(Reg2[1]) );
  DFFRQX2M \MEM_reg[0][6]  ( .D(n54), .CK(CLK), .RN(n256), .Q(n280) );
  DFFRQX2M \MEM_reg[0][0]  ( .D(n48), .CK(CLK), .RN(n268), .Q(n286) );
  CLKINVX12M U3 ( .A(n3), .Y(Reg0[5]) );
  CLKINVX12M U4 ( .A(n5), .Y(Reg0[4]) );
  CLKINVX12M U5 ( .A(n7), .Y(Reg0[2]) );
  CLKINVX12M U6 ( .A(n9), .Y(Reg0[3]) );
  BUFX10M U7 ( .A(n285), .Y(Reg0[1]) );
  CLKINVX12M U8 ( .A(n178), .Y(Reg0[7]) );
  INVX8M U9 ( .A(n1), .Y(Reg0[0]) );
  BUFX10M U10 ( .A(n280), .Y(Reg0[6]) );
  INVX2M U11 ( .A(n286), .Y(n1) );
  INVX2M U12 ( .A(n281), .Y(n3) );
  INVX2M U13 ( .A(n282), .Y(n5) );
  INVX2M U14 ( .A(n284), .Y(n7) );
  INVX2M U15 ( .A(n283), .Y(n9) );
  BUFX10M U16 ( .A(n287), .Y(Reg1[7]) );
  BUFX10M U17 ( .A(n288), .Y(Reg1[6]) );
  INVX2M U18 ( .A(n279), .Y(n178) );
  CLKBUFX2M U19 ( .A(n269), .Y(n266) );
  CLKBUFX2M U20 ( .A(n269), .Y(n267) );
  CLKBUFX2M U21 ( .A(n268), .Y(n265) );
  NOR2X6M U22 ( .A(n255), .B(N12), .Y(n19) );
  NOR2X6M U23 ( .A(n214), .B(N12), .Y(n14) );
  CLKBUFX6M U24 ( .A(n12), .Y(n219) );
  BUFX10M U25 ( .A(N11), .Y(n214) );
  BUFX10M U26 ( .A(N11), .Y(n215) );
  CLKBUFX6M U27 ( .A(n215), .Y(n213) );
  BUFX10M U28 ( .A(n252), .Y(n217) );
  BUFX10M U29 ( .A(n252), .Y(n218) );
  BUFX6M U30 ( .A(n252), .Y(n216) );
  CLKBUFX6M U31 ( .A(n16), .Y(n249) );
  CLKBUFX6M U32 ( .A(n29), .Y(n235) );
  CLKBUFX6M U33 ( .A(n31), .Y(n233) );
  CLKBUFX6M U34 ( .A(n33), .Y(n231) );
  CLKBUFX6M U35 ( .A(n34), .Y(n229) );
  CLKBUFX6M U36 ( .A(n18), .Y(n247) );
  CLKBUFX6M U37 ( .A(n20), .Y(n245) );
  CLKBUFX6M U38 ( .A(n21), .Y(n243) );
  CLKBUFX6M U39 ( .A(n23), .Y(n241) );
  CLKBUFX6M U40 ( .A(n24), .Y(n239) );
  CLKBUFX6M U41 ( .A(n27), .Y(n237) );
  CLKBUFX6M U42 ( .A(n35), .Y(n227) );
  CLKBUFX6M U43 ( .A(n36), .Y(n225) );
  CLKBUFX6M U44 ( .A(n37), .Y(n223) );
  CLKBUFX6M U45 ( .A(n39), .Y(n221) );
  CLKBUFX6M U46 ( .A(n13), .Y(n251) );
  CLKBUFX4M U47 ( .A(n16), .Y(n248) );
  CLKBUFX4M U48 ( .A(n29), .Y(n234) );
  CLKBUFX4M U49 ( .A(n31), .Y(n232) );
  CLKBUFX4M U50 ( .A(n33), .Y(n230) );
  CLKBUFX4M U51 ( .A(n34), .Y(n228) );
  CLKBUFX4M U52 ( .A(n18), .Y(n246) );
  CLKBUFX4M U53 ( .A(n20), .Y(n244) );
  CLKBUFX4M U54 ( .A(n35), .Y(n226) );
  CLKBUFX4M U55 ( .A(n36), .Y(n224) );
  CLKBUFX4M U56 ( .A(n37), .Y(n222) );
  CLKBUFX4M U57 ( .A(n39), .Y(n220) );
  CLKBUFX4M U58 ( .A(n21), .Y(n242) );
  CLKBUFX4M U59 ( .A(n23), .Y(n240) );
  CLKBUFX4M U60 ( .A(n24), .Y(n238) );
  CLKBUFX4M U61 ( .A(n27), .Y(n236) );
  CLKBUFX4M U62 ( .A(n13), .Y(n250) );
  BUFX10M U63 ( .A(n268), .Y(n256) );
  BUFX10M U64 ( .A(n267), .Y(n257) );
  BUFX10M U65 ( .A(n267), .Y(n258) );
  BUFX10M U66 ( .A(n267), .Y(n259) );
  BUFX10M U67 ( .A(n266), .Y(n260) );
  BUFX10M U68 ( .A(n266), .Y(n261) );
  BUFX10M U69 ( .A(n266), .Y(n262) );
  BUFX10M U70 ( .A(n265), .Y(n263) );
  BUFX10M U71 ( .A(n265), .Y(n264) );
  NOR2BX8M U72 ( .AN(n26), .B(n252), .Y(n15) );
  NOR2BX8M U73 ( .AN(n38), .B(n252), .Y(n30) );
  NAND2X2M U74 ( .A(n14), .B(n15), .Y(n13) );
  NAND2X2M U75 ( .A(n19), .B(n15), .Y(n18) );
  NAND2X2M U76 ( .A(n19), .B(n17), .Y(n20) );
  NAND2X2M U77 ( .A(n17), .B(n14), .Y(n16) );
  NAND2X2M U78 ( .A(n22), .B(n15), .Y(n21) );
  NAND2X2M U79 ( .A(n22), .B(n17), .Y(n23) );
  NAND2X2M U80 ( .A(n25), .B(n15), .Y(n24) );
  NAND2X2M U81 ( .A(n25), .B(n17), .Y(n27) );
  NAND2X2M U82 ( .A(n32), .B(n14), .Y(n31) );
  NAND2X2M U83 ( .A(n32), .B(n19), .Y(n34) );
  NAND2X2M U84 ( .A(n32), .B(n22), .Y(n36) );
  NAND2X2M U85 ( .A(n32), .B(n25), .Y(n39) );
  NAND2X2M U86 ( .A(n30), .B(n14), .Y(n29) );
  NAND2X2M U87 ( .A(n30), .B(n19), .Y(n33) );
  NAND2X2M U88 ( .A(n30), .B(n22), .Y(n35) );
  NAND2X2M U89 ( .A(n30), .B(n25), .Y(n37) );
  INVX6M U90 ( .A(n219), .Y(n270) );
  CLKBUFX2M U91 ( .A(n269), .Y(n268) );
  NOR2BX8M U92 ( .AN(n26), .B(n253), .Y(n17) );
  NOR2BX8M U93 ( .AN(N12), .B(n215), .Y(n22) );
  NOR2BX8M U94 ( .AN(N12), .B(n255), .Y(n25) );
  NOR2BX8M U95 ( .AN(n38), .B(n253), .Y(n32) );
  NOR2BX4M U96 ( .AN(n28), .B(N13), .Y(n26) );
  NOR2BX4M U97 ( .AN(WrEn), .B(RdEn), .Y(n28) );
  AND2X2M U98 ( .A(N13), .B(n28), .Y(n38) );
  INVX4M U99 ( .A(n253), .Y(n252) );
  INVX2M U100 ( .A(N11), .Y(n255) );
  NAND2BX2M U101 ( .AN(WrEn), .B(RdEn), .Y(n12) );
  CLKINVX12M U102 ( .A(WrData[0]), .Y(n278) );
  CLKINVX12M U103 ( .A(WrData[1]), .Y(n277) );
  CLKINVX12M U104 ( .A(WrData[2]), .Y(n276) );
  CLKINVX12M U105 ( .A(WrData[3]), .Y(n275) );
  CLKINVX12M U106 ( .A(WrData[4]), .Y(n274) );
  CLKINVX12M U107 ( .A(WrData[5]), .Y(n273) );
  CLKINVX12M U108 ( .A(WrData[6]), .Y(n272) );
  BUFX4M U109 ( .A(n254), .Y(n253) );
  INVX2M U110 ( .A(N10), .Y(n254) );
  CLKBUFX2M U111 ( .A(RST), .Y(n269) );
  CLKINVX12M U112 ( .A(WrData[7]), .Y(n271) );
  OAI2BB2X1M U113 ( .B0(n251), .B1(n278), .A0N(n286), .A1N(n251), .Y(n48) );
  OAI2BB2X1M U114 ( .B0(n250), .B1(n277), .A0N(Reg0[1]), .A1N(n251), .Y(n49)
         );
  OAI2BB2X1M U115 ( .B0(n250), .B1(n276), .A0N(Reg0[2]), .A1N(n251), .Y(n50)
         );
  OAI2BB2X1M U116 ( .B0(n250), .B1(n275), .A0N(Reg0[3]), .A1N(n251), .Y(n51)
         );
  OAI2BB2X1M U117 ( .B0(n250), .B1(n274), .A0N(Reg0[4]), .A1N(n251), .Y(n52)
         );
  OAI2BB2X1M U118 ( .B0(n250), .B1(n273), .A0N(Reg0[5]), .A1N(n251), .Y(n53)
         );
  OAI2BB2X1M U119 ( .B0(n250), .B1(n272), .A0N(Reg0[6]), .A1N(n251), .Y(n54)
         );
  OAI2BB2X1M U120 ( .B0(n250), .B1(n271), .A0N(Reg0[7]), .A1N(n251), .Y(n55)
         );
  OAI2BB2X1M U121 ( .B0(n278), .B1(n249), .A0N(Reg1[0]), .A1N(n249), .Y(n56)
         );
  OAI2BB2X1M U122 ( .B0(n277), .B1(n248), .A0N(Reg1[1]), .A1N(n249), .Y(n57)
         );
  OAI2BB2X1M U123 ( .B0(n276), .B1(n248), .A0N(Reg1[2]), .A1N(n249), .Y(n58)
         );
  OAI2BB2X1M U124 ( .B0(n275), .B1(n248), .A0N(Reg1[3]), .A1N(n249), .Y(n59)
         );
  OAI2BB2X1M U125 ( .B0(n274), .B1(n248), .A0N(Reg1[4]), .A1N(n249), .Y(n60)
         );
  OAI2BB2X1M U126 ( .B0(n273), .B1(n248), .A0N(Reg1[5]), .A1N(n249), .Y(n61)
         );
  OAI2BB2X1M U127 ( .B0(n272), .B1(n248), .A0N(Reg1[6]), .A1N(n249), .Y(n62)
         );
  OAI2BB2X1M U128 ( .B0(n277), .B1(n246), .A0N(Reg2[1]), .A1N(n247), .Y(n65)
         );
  OAI2BB2X1M U129 ( .B0(n276), .B1(n246), .A0N(Reg2[2]), .A1N(n247), .Y(n66)
         );
  OAI2BB2X1M U130 ( .B0(n275), .B1(n246), .A0N(Reg2[3]), .A1N(n247), .Y(n67)
         );
  OAI2BB2X1M U131 ( .B0(n274), .B1(n246), .A0N(Reg2[4]), .A1N(n247), .Y(n68)
         );
  OAI2BB2X1M U132 ( .B0(n272), .B1(n246), .A0N(Reg2[6]), .A1N(n247), .Y(n70)
         );
  OAI2BB2X1M U133 ( .B0(n278), .B1(n245), .A0N(Reg3[0]), .A1N(n245), .Y(n72)
         );
  OAI2BB2X1M U134 ( .B0(n277), .B1(n244), .A0N(Reg3[1]), .A1N(n245), .Y(n73)
         );
  OAI2BB2X1M U135 ( .B0(n276), .B1(n244), .A0N(Reg3[2]), .A1N(n245), .Y(n74)
         );
  OAI2BB2X1M U136 ( .B0(n274), .B1(n244), .A0N(Reg3[4]), .A1N(n245), .Y(n76)
         );
  OAI2BB2X1M U137 ( .B0(n273), .B1(n244), .A0N(Reg3[5]), .A1N(n245), .Y(n77)
         );
  OAI2BB2X1M U138 ( .B0(n272), .B1(n244), .A0N(Reg3[6]), .A1N(n245), .Y(n78)
         );
  OAI2BB2X1M U139 ( .B0(n278), .B1(n243), .A0N(\MEM[4][0] ), .A1N(n243), .Y(
        n80) );
  OAI2BB2X1M U140 ( .B0(n277), .B1(n242), .A0N(\MEM[4][1] ), .A1N(n243), .Y(
        n81) );
  OAI2BB2X1M U141 ( .B0(n276), .B1(n242), .A0N(\MEM[4][2] ), .A1N(n243), .Y(
        n82) );
  OAI2BB2X1M U142 ( .B0(n275), .B1(n242), .A0N(\MEM[4][3] ), .A1N(n243), .Y(
        n83) );
  OAI2BB2X1M U143 ( .B0(n274), .B1(n242), .A0N(\MEM[4][4] ), .A1N(n243), .Y(
        n84) );
  OAI2BB2X1M U144 ( .B0(n273), .B1(n242), .A0N(\MEM[4][5] ), .A1N(n243), .Y(
        n85) );
  OAI2BB2X1M U145 ( .B0(n272), .B1(n242), .A0N(\MEM[4][6] ), .A1N(n243), .Y(
        n86) );
  OAI2BB2X1M U146 ( .B0(n278), .B1(n241), .A0N(\MEM[5][0] ), .A1N(n241), .Y(
        n88) );
  OAI2BB2X1M U147 ( .B0(n277), .B1(n240), .A0N(\MEM[5][1] ), .A1N(n241), .Y(
        n89) );
  OAI2BB2X1M U148 ( .B0(n276), .B1(n240), .A0N(\MEM[5][2] ), .A1N(n241), .Y(
        n90) );
  OAI2BB2X1M U149 ( .B0(n275), .B1(n240), .A0N(\MEM[5][3] ), .A1N(n241), .Y(
        n91) );
  OAI2BB2X1M U150 ( .B0(n274), .B1(n240), .A0N(\MEM[5][4] ), .A1N(n241), .Y(
        n92) );
  OAI2BB2X1M U151 ( .B0(n273), .B1(n240), .A0N(\MEM[5][5] ), .A1N(n241), .Y(
        n93) );
  OAI2BB2X1M U152 ( .B0(n272), .B1(n240), .A0N(\MEM[5][6] ), .A1N(n241), .Y(
        n94) );
  OAI2BB2X1M U153 ( .B0(n278), .B1(n239), .A0N(\MEM[6][0] ), .A1N(n239), .Y(
        n96) );
  OAI2BB2X1M U154 ( .B0(n277), .B1(n238), .A0N(\MEM[6][1] ), .A1N(n239), .Y(
        n97) );
  OAI2BB2X1M U155 ( .B0(n276), .B1(n238), .A0N(\MEM[6][2] ), .A1N(n239), .Y(
        n98) );
  OAI2BB2X1M U156 ( .B0(n275), .B1(n238), .A0N(\MEM[6][3] ), .A1N(n239), .Y(
        n99) );
  OAI2BB2X1M U157 ( .B0(n274), .B1(n238), .A0N(\MEM[6][4] ), .A1N(n239), .Y(
        n100) );
  OAI2BB2X1M U158 ( .B0(n273), .B1(n238), .A0N(\MEM[6][5] ), .A1N(n239), .Y(
        n101) );
  OAI2BB2X1M U159 ( .B0(n272), .B1(n238), .A0N(\MEM[6][6] ), .A1N(n239), .Y(
        n102) );
  OAI2BB2X1M U160 ( .B0(n278), .B1(n237), .A0N(\MEM[7][0] ), .A1N(n237), .Y(
        n104) );
  OAI2BB2X1M U161 ( .B0(n277), .B1(n236), .A0N(\MEM[7][1] ), .A1N(n237), .Y(
        n105) );
  OAI2BB2X1M U162 ( .B0(n276), .B1(n236), .A0N(\MEM[7][2] ), .A1N(n237), .Y(
        n106) );
  OAI2BB2X1M U163 ( .B0(n275), .B1(n236), .A0N(\MEM[7][3] ), .A1N(n237), .Y(
        n107) );
  OAI2BB2X1M U164 ( .B0(n274), .B1(n236), .A0N(\MEM[7][4] ), .A1N(n237), .Y(
        n108) );
  OAI2BB2X1M U165 ( .B0(n273), .B1(n236), .A0N(\MEM[7][5] ), .A1N(n237), .Y(
        n109) );
  OAI2BB2X1M U166 ( .B0(n272), .B1(n236), .A0N(\MEM[7][6] ), .A1N(n237), .Y(
        n110) );
  OAI2BB2X1M U167 ( .B0(n278), .B1(n235), .A0N(\MEM[8][0] ), .A1N(n235), .Y(
        n112) );
  OAI2BB2X1M U168 ( .B0(n277), .B1(n234), .A0N(\MEM[8][1] ), .A1N(n235), .Y(
        n113) );
  OAI2BB2X1M U169 ( .B0(n276), .B1(n234), .A0N(\MEM[8][2] ), .A1N(n235), .Y(
        n114) );
  OAI2BB2X1M U170 ( .B0(n275), .B1(n234), .A0N(\MEM[8][3] ), .A1N(n235), .Y(
        n115) );
  OAI2BB2X1M U171 ( .B0(n274), .B1(n234), .A0N(\MEM[8][4] ), .A1N(n235), .Y(
        n116) );
  OAI2BB2X1M U172 ( .B0(n273), .B1(n234), .A0N(\MEM[8][5] ), .A1N(n235), .Y(
        n117) );
  OAI2BB2X1M U173 ( .B0(n272), .B1(n234), .A0N(\MEM[8][6] ), .A1N(n235), .Y(
        n118) );
  OAI2BB2X1M U174 ( .B0(n278), .B1(n233), .A0N(\MEM[9][0] ), .A1N(n233), .Y(
        n120) );
  OAI2BB2X1M U175 ( .B0(n277), .B1(n232), .A0N(\MEM[9][1] ), .A1N(n233), .Y(
        n121) );
  OAI2BB2X1M U176 ( .B0(n276), .B1(n232), .A0N(\MEM[9][2] ), .A1N(n233), .Y(
        n122) );
  OAI2BB2X1M U177 ( .B0(n275), .B1(n232), .A0N(\MEM[9][3] ), .A1N(n233), .Y(
        n123) );
  OAI2BB2X1M U178 ( .B0(n274), .B1(n232), .A0N(\MEM[9][4] ), .A1N(n233), .Y(
        n124) );
  OAI2BB2X1M U179 ( .B0(n273), .B1(n232), .A0N(\MEM[9][5] ), .A1N(n233), .Y(
        n125) );
  OAI2BB2X1M U180 ( .B0(n272), .B1(n232), .A0N(\MEM[9][6] ), .A1N(n233), .Y(
        n126) );
  OAI2BB2X1M U181 ( .B0(n278), .B1(n231), .A0N(\MEM[10][0] ), .A1N(n231), .Y(
        n128) );
  OAI2BB2X1M U182 ( .B0(n277), .B1(n230), .A0N(\MEM[10][1] ), .A1N(n231), .Y(
        n129) );
  OAI2BB2X1M U183 ( .B0(n276), .B1(n230), .A0N(\MEM[10][2] ), .A1N(n231), .Y(
        n130) );
  OAI2BB2X1M U184 ( .B0(n275), .B1(n230), .A0N(\MEM[10][3] ), .A1N(n231), .Y(
        n131) );
  OAI2BB2X1M U185 ( .B0(n274), .B1(n230), .A0N(\MEM[10][4] ), .A1N(n231), .Y(
        n132) );
  OAI2BB2X1M U186 ( .B0(n273), .B1(n230), .A0N(\MEM[10][5] ), .A1N(n231), .Y(
        n133) );
  OAI2BB2X1M U187 ( .B0(n272), .B1(n230), .A0N(\MEM[10][6] ), .A1N(n231), .Y(
        n134) );
  OAI2BB2X1M U188 ( .B0(n278), .B1(n229), .A0N(\MEM[11][0] ), .A1N(n229), .Y(
        n136) );
  OAI2BB2X1M U189 ( .B0(n277), .B1(n228), .A0N(\MEM[11][1] ), .A1N(n229), .Y(
        n137) );
  OAI2BB2X1M U190 ( .B0(n276), .B1(n228), .A0N(\MEM[11][2] ), .A1N(n229), .Y(
        n138) );
  OAI2BB2X1M U191 ( .B0(n275), .B1(n228), .A0N(\MEM[11][3] ), .A1N(n229), .Y(
        n139) );
  OAI2BB2X1M U192 ( .B0(n274), .B1(n228), .A0N(\MEM[11][4] ), .A1N(n229), .Y(
        n140) );
  OAI2BB2X1M U193 ( .B0(n273), .B1(n228), .A0N(\MEM[11][5] ), .A1N(n229), .Y(
        n141) );
  OAI2BB2X1M U194 ( .B0(n272), .B1(n228), .A0N(\MEM[11][6] ), .A1N(n229), .Y(
        n142) );
  OAI2BB2X1M U195 ( .B0(n278), .B1(n227), .A0N(\MEM[12][0] ), .A1N(n227), .Y(
        n144) );
  OAI2BB2X1M U196 ( .B0(n277), .B1(n226), .A0N(\MEM[12][1] ), .A1N(n227), .Y(
        n145) );
  OAI2BB2X1M U197 ( .B0(n276), .B1(n226), .A0N(\MEM[12][2] ), .A1N(n227), .Y(
        n146) );
  OAI2BB2X1M U198 ( .B0(n275), .B1(n226), .A0N(\MEM[12][3] ), .A1N(n227), .Y(
        n147) );
  OAI2BB2X1M U199 ( .B0(n274), .B1(n226), .A0N(\MEM[12][4] ), .A1N(n227), .Y(
        n148) );
  OAI2BB2X1M U200 ( .B0(n273), .B1(n226), .A0N(\MEM[12][5] ), .A1N(n227), .Y(
        n149) );
  OAI2BB2X1M U201 ( .B0(n272), .B1(n226), .A0N(\MEM[12][6] ), .A1N(n227), .Y(
        n150) );
  OAI2BB2X1M U202 ( .B0(n278), .B1(n225), .A0N(\MEM[13][0] ), .A1N(n225), .Y(
        n152) );
  OAI2BB2X1M U203 ( .B0(n277), .B1(n224), .A0N(\MEM[13][1] ), .A1N(n225), .Y(
        n153) );
  OAI2BB2X1M U204 ( .B0(n276), .B1(n224), .A0N(\MEM[13][2] ), .A1N(n225), .Y(
        n154) );
  OAI2BB2X1M U205 ( .B0(n275), .B1(n224), .A0N(\MEM[13][3] ), .A1N(n225), .Y(
        n155) );
  OAI2BB2X1M U206 ( .B0(n274), .B1(n224), .A0N(\MEM[13][4] ), .A1N(n225), .Y(
        n156) );
  OAI2BB2X1M U207 ( .B0(n273), .B1(n224), .A0N(\MEM[13][5] ), .A1N(n225), .Y(
        n157) );
  OAI2BB2X1M U208 ( .B0(n272), .B1(n224), .A0N(\MEM[13][6] ), .A1N(n225), .Y(
        n158) );
  OAI2BB2X1M U209 ( .B0(n278), .B1(n223), .A0N(\MEM[14][0] ), .A1N(n223), .Y(
        n160) );
  OAI2BB2X1M U210 ( .B0(n277), .B1(n222), .A0N(\MEM[14][1] ), .A1N(n223), .Y(
        n161) );
  OAI2BB2X1M U211 ( .B0(n276), .B1(n222), .A0N(\MEM[14][2] ), .A1N(n223), .Y(
        n162) );
  OAI2BB2X1M U212 ( .B0(n275), .B1(n222), .A0N(\MEM[14][3] ), .A1N(n223), .Y(
        n163) );
  OAI2BB2X1M U213 ( .B0(n274), .B1(n222), .A0N(\MEM[14][4] ), .A1N(n223), .Y(
        n164) );
  OAI2BB2X1M U214 ( .B0(n273), .B1(n222), .A0N(\MEM[14][5] ), .A1N(n223), .Y(
        n165) );
  OAI2BB2X1M U215 ( .B0(n272), .B1(n222), .A0N(\MEM[14][6] ), .A1N(n223), .Y(
        n166) );
  OAI2BB2X1M U216 ( .B0(n278), .B1(n221), .A0N(\MEM[15][0] ), .A1N(n221), .Y(
        n168) );
  OAI2BB2X1M U217 ( .B0(n277), .B1(n220), .A0N(\MEM[15][1] ), .A1N(n221), .Y(
        n169) );
  OAI2BB2X1M U218 ( .B0(n276), .B1(n220), .A0N(\MEM[15][2] ), .A1N(n221), .Y(
        n170) );
  OAI2BB2X1M U219 ( .B0(n275), .B1(n220), .A0N(\MEM[15][3] ), .A1N(n221), .Y(
        n171) );
  OAI2BB2X1M U220 ( .B0(n274), .B1(n220), .A0N(\MEM[15][4] ), .A1N(n221), .Y(
        n172) );
  OAI2BB2X1M U221 ( .B0(n273), .B1(n220), .A0N(\MEM[15][5] ), .A1N(n221), .Y(
        n173) );
  OAI2BB2X1M U222 ( .B0(n272), .B1(n220), .A0N(\MEM[15][6] ), .A1N(n221), .Y(
        n174) );
  OAI2BB2X1M U223 ( .B0(n271), .B1(n248), .A0N(Reg1[7]), .A1N(n249), .Y(n63)
         );
  OAI2BB2X1M U224 ( .B0(n271), .B1(n246), .A0N(Reg2[7]), .A1N(n247), .Y(n71)
         );
  OAI2BB2X1M U225 ( .B0(n271), .B1(n244), .A0N(Reg3[7]), .A1N(n245), .Y(n79)
         );
  OAI2BB2X1M U226 ( .B0(n271), .B1(n242), .A0N(\MEM[4][7] ), .A1N(n243), .Y(
        n87) );
  OAI2BB2X1M U227 ( .B0(n271), .B1(n240), .A0N(\MEM[5][7] ), .A1N(n241), .Y(
        n95) );
  OAI2BB2X1M U228 ( .B0(n271), .B1(n238), .A0N(\MEM[6][7] ), .A1N(n239), .Y(
        n103) );
  OAI2BB2X1M U229 ( .B0(n271), .B1(n236), .A0N(\MEM[7][7] ), .A1N(n237), .Y(
        n111) );
  OAI2BB2X1M U230 ( .B0(n271), .B1(n234), .A0N(\MEM[8][7] ), .A1N(n235), .Y(
        n119) );
  OAI2BB2X1M U231 ( .B0(n271), .B1(n232), .A0N(\MEM[9][7] ), .A1N(n233), .Y(
        n127) );
  OAI2BB2X1M U232 ( .B0(n271), .B1(n230), .A0N(\MEM[10][7] ), .A1N(n231), .Y(
        n135) );
  OAI2BB2X1M U233 ( .B0(n271), .B1(n228), .A0N(\MEM[11][7] ), .A1N(n229), .Y(
        n143) );
  OAI2BB2X1M U234 ( .B0(n271), .B1(n226), .A0N(\MEM[12][7] ), .A1N(n227), .Y(
        n151) );
  OAI2BB2X1M U235 ( .B0(n271), .B1(n224), .A0N(\MEM[13][7] ), .A1N(n225), .Y(
        n159) );
  OAI2BB2X1M U236 ( .B0(n271), .B1(n222), .A0N(\MEM[14][7] ), .A1N(n223), .Y(
        n167) );
  OAI2BB2X1M U237 ( .B0(n271), .B1(n220), .A0N(\MEM[15][7] ), .A1N(n221), .Y(
        n175) );
  OAI2BB2X1M U238 ( .B0(n278), .B1(n247), .A0N(Reg2[0]), .A1N(n247), .Y(n64)
         );
  OAI2BB2X1M U239 ( .B0(n273), .B1(n246), .A0N(Reg2[5]), .A1N(n247), .Y(n69)
         );
  OAI2BB2X1M U240 ( .B0(n275), .B1(n244), .A0N(Reg3[3]), .A1N(n245), .Y(n75)
         );
  MX4X1M U241 ( .A(\MEM[4][2] ), .B(\MEM[5][2] ), .C(\MEM[6][2] ), .D(
        \MEM[7][2] ), .S0(n217), .S1(n214), .Y(n191) );
  MX4X1M U242 ( .A(\MEM[4][3] ), .B(\MEM[5][3] ), .C(\MEM[6][3] ), .D(
        \MEM[7][3] ), .S0(n217), .S1(n214), .Y(n195) );
  MX4X1M U243 ( .A(\MEM[4][4] ), .B(\MEM[5][4] ), .C(\MEM[6][4] ), .D(
        \MEM[7][4] ), .S0(n217), .S1(n214), .Y(n199) );
  MX4X1M U244 ( .A(\MEM[4][5] ), .B(\MEM[5][5] ), .C(\MEM[6][5] ), .D(
        \MEM[7][5] ), .S0(n218), .S1(n215), .Y(n203) );
  MX4X1M U245 ( .A(\MEM[4][6] ), .B(\MEM[5][6] ), .C(\MEM[6][6] ), .D(
        \MEM[7][6] ), .S0(n218), .S1(n215), .Y(n207) );
  MX4X1M U246 ( .A(\MEM[4][7] ), .B(\MEM[5][7] ), .C(\MEM[6][7] ), .D(
        \MEM[7][7] ), .S0(n218), .S1(n215), .Y(n211) );
  MX4X1M U247 ( .A(\MEM[12][2] ), .B(\MEM[13][2] ), .C(\MEM[14][2] ), .D(
        \MEM[15][2] ), .S0(n217), .S1(n214), .Y(n189) );
  MX4X1M U248 ( .A(\MEM[12][3] ), .B(\MEM[13][3] ), .C(\MEM[14][3] ), .D(
        \MEM[15][3] ), .S0(n217), .S1(n214), .Y(n193) );
  MX4X1M U249 ( .A(\MEM[12][4] ), .B(\MEM[13][4] ), .C(\MEM[14][4] ), .D(
        \MEM[15][4] ), .S0(n217), .S1(n214), .Y(n197) );
  MX4X1M U250 ( .A(\MEM[12][5] ), .B(\MEM[13][5] ), .C(\MEM[14][5] ), .D(
        \MEM[15][5] ), .S0(n218), .S1(n215), .Y(n201) );
  MX4X1M U251 ( .A(\MEM[12][6] ), .B(\MEM[13][6] ), .C(\MEM[14][6] ), .D(
        \MEM[15][6] ), .S0(n218), .S1(n215), .Y(n205) );
  MX4X1M U252 ( .A(\MEM[12][7] ), .B(\MEM[13][7] ), .C(\MEM[14][7] ), .D(
        \MEM[15][7] ), .S0(n218), .S1(n215), .Y(n209) );
  MX4X1M U253 ( .A(\MEM[4][0] ), .B(\MEM[5][0] ), .C(\MEM[6][0] ), .D(
        \MEM[7][0] ), .S0(n216), .S1(n213), .Y(n183) );
  MX4X1M U254 ( .A(\MEM[4][1] ), .B(\MEM[5][1] ), .C(\MEM[6][1] ), .D(
        \MEM[7][1] ), .S0(n216), .S1(n213), .Y(n187) );
  MX4X1M U255 ( .A(\MEM[12][0] ), .B(\MEM[13][0] ), .C(\MEM[14][0] ), .D(
        \MEM[15][0] ), .S0(n216), .S1(n213), .Y(n181) );
  MX4X1M U256 ( .A(\MEM[12][1] ), .B(\MEM[13][1] ), .C(\MEM[14][1] ), .D(
        \MEM[15][1] ), .S0(n216), .S1(n213), .Y(n185) );
  AO22X1M U257 ( .A0(N26), .A1(n270), .B0(RdData[0]), .B1(n219), .Y(n40) );
  MX4XLM U258 ( .A(n184), .B(n182), .C(n183), .D(n181), .S0(N13), .S1(N12), 
        .Y(N26) );
  MX4XLM U259 ( .A(Reg0[0]), .B(Reg1[0]), .C(Reg2[0]), .D(Reg3[0]), .S0(n216), 
        .S1(n213), .Y(n184) );
  MX4X1M U260 ( .A(\MEM[8][0] ), .B(\MEM[9][0] ), .C(\MEM[10][0] ), .D(
        \MEM[11][0] ), .S0(n216), .S1(n213), .Y(n182) );
  AO22X1M U261 ( .A0(N25), .A1(n270), .B0(RdData[1]), .B1(n219), .Y(n41) );
  MX4XLM U262 ( .A(n188), .B(n186), .C(n187), .D(n185), .S0(N13), .S1(N12), 
        .Y(N25) );
  MX4XLM U263 ( .A(Reg0[1]), .B(Reg1[1]), .C(Reg2[1]), .D(Reg3[1]), .S0(n216), 
        .S1(n213), .Y(n188) );
  MX4X1M U264 ( .A(\MEM[8][1] ), .B(\MEM[9][1] ), .C(\MEM[10][1] ), .D(
        \MEM[11][1] ), .S0(n216), .S1(n213), .Y(n186) );
  AO22X1M U265 ( .A0(N24), .A1(n270), .B0(RdData[2]), .B1(n219), .Y(n42) );
  MX4XLM U266 ( .A(n192), .B(n190), .C(n191), .D(n189), .S0(N13), .S1(N12), 
        .Y(N24) );
  MX4XLM U267 ( .A(Reg0[2]), .B(Reg1[2]), .C(Reg2[2]), .D(Reg3[2]), .S0(n217), 
        .S1(n214), .Y(n192) );
  MX4X1M U268 ( .A(\MEM[8][2] ), .B(\MEM[9][2] ), .C(\MEM[10][2] ), .D(
        \MEM[11][2] ), .S0(n217), .S1(n214), .Y(n190) );
  AO22X1M U269 ( .A0(N23), .A1(n270), .B0(RdData[3]), .B1(n219), .Y(n43) );
  MX4XLM U270 ( .A(n196), .B(n194), .C(n195), .D(n193), .S0(N13), .S1(N12), 
        .Y(N23) );
  MX4XLM U271 ( .A(Reg0[3]), .B(Reg1[3]), .C(Reg2[3]), .D(Reg3[3]), .S0(n217), 
        .S1(n214), .Y(n196) );
  MX4X1M U272 ( .A(\MEM[8][3] ), .B(\MEM[9][3] ), .C(\MEM[10][3] ), .D(
        \MEM[11][3] ), .S0(n217), .S1(n214), .Y(n194) );
  AO22X1M U273 ( .A0(N22), .A1(n270), .B0(RdData[4]), .B1(n219), .Y(n44) );
  MX4XLM U274 ( .A(n200), .B(n198), .C(n199), .D(n197), .S0(N13), .S1(N12), 
        .Y(N22) );
  MX4XLM U275 ( .A(Reg0[4]), .B(Reg1[4]), .C(Reg2[4]), .D(Reg3[4]), .S0(n217), 
        .S1(n214), .Y(n200) );
  MX4X1M U276 ( .A(\MEM[8][4] ), .B(\MEM[9][4] ), .C(\MEM[10][4] ), .D(
        \MEM[11][4] ), .S0(n217), .S1(n214), .Y(n198) );
  AO22X1M U277 ( .A0(N21), .A1(n270), .B0(RdData[5]), .B1(n219), .Y(n45) );
  MX4XLM U278 ( .A(n204), .B(n202), .C(n203), .D(n201), .S0(N13), .S1(N12), 
        .Y(N21) );
  MX4XLM U279 ( .A(Reg0[5]), .B(Reg1[5]), .C(Reg2[5]), .D(Reg3[5]), .S0(n218), 
        .S1(n215), .Y(n204) );
  MX4X1M U280 ( .A(\MEM[8][5] ), .B(\MEM[9][5] ), .C(\MEM[10][5] ), .D(
        \MEM[11][5] ), .S0(n218), .S1(n215), .Y(n202) );
  AO22X1M U281 ( .A0(N20), .A1(n270), .B0(RdData[6]), .B1(n219), .Y(n46) );
  MX4XLM U282 ( .A(n208), .B(n206), .C(n207), .D(n205), .S0(N13), .S1(N12), 
        .Y(N20) );
  MX4XLM U283 ( .A(Reg0[6]), .B(Reg1[6]), .C(Reg2[6]), .D(Reg3[6]), .S0(n218), 
        .S1(n215), .Y(n208) );
  MX4X1M U284 ( .A(\MEM[8][6] ), .B(\MEM[9][6] ), .C(\MEM[10][6] ), .D(
        \MEM[11][6] ), .S0(n218), .S1(n215), .Y(n206) );
  AO22X1M U285 ( .A0(N19), .A1(n270), .B0(RdData[7]), .B1(n219), .Y(n47) );
  MX4XLM U286 ( .A(n212), .B(n210), .C(n211), .D(n209), .S0(N13), .S1(N12), 
        .Y(N19) );
  MX4XLM U287 ( .A(Reg0[7]), .B(Reg1[7]), .C(Reg2[7]), .D(Reg3[7]), .S0(n218), 
        .S1(n215), .Y(n212) );
  MX4X1M U288 ( .A(\MEM[8][7] ), .B(\MEM[9][7] ), .C(\MEM[10][7] ), .D(
        \MEM[11][7] ), .S0(n218), .S1(n215), .Y(n210) );
endmodule


module Controller_FSM_TX ( ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST, ALU_OUT, 
        RdData, TX_P_Data, TX_D_VLD, CLK_div_en );
  input [15:0] ALU_OUT;
  input [7:0] RdData;
  output [7:0] TX_P_Data;
  input ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST;
  output TX_D_VLD, CLK_div_en;
  wire   n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n32, n33, n34, n35,
         n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49,
         n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, n71, n3, n4, n5, n6, n31, n72, n73,
         n74, n75, n76, n77, n78, n79, n80, n81, n82;
  wire   [2:0] Current_State;
  wire   [2:0] Next_State;

  NOR2X12M U35 ( .A(n37), .B(n3), .Y(n36) );
  NOR2X12M U36 ( .A(n38), .B(n39), .Y(n35) );
  NOR2X12M U37 ( .A(n78), .B(n5), .Y(n34) );
  OAI32X4M U39 ( .A0(n78), .A1(TX_D_VLD), .A2(n43), .B0(n79), .B1(n77), .Y(n42) );
  DFFRX1M \REG_ALU_OUT_reg[7]  ( .D(n63), .CK(CLK), .RN(n72), .QN(n15) );
  DFFRX1M \REG_ALU_OUT_reg[6]  ( .D(n62), .CK(CLK), .RN(n72), .QN(n16) );
  DFFRX1M \REG_ALU_OUT_reg[5]  ( .D(n61), .CK(CLK), .RN(n72), .QN(n17) );
  DFFRX1M \REG_ALU_OUT_reg[4]  ( .D(n60), .CK(CLK), .RN(n72), .QN(n18) );
  DFFRX1M \REG_ALU_OUT_reg[3]  ( .D(n59), .CK(CLK), .RN(n73), .QN(n19) );
  DFFRX1M \REG_ALU_OUT_reg[2]  ( .D(n58), .CK(CLK), .RN(n73), .QN(n20) );
  DFFRX1M \REG_ALU_OUT_reg[1]  ( .D(n57), .CK(CLK), .RN(n73), .QN(n21) );
  DFFRX1M \REG_ALU_OUT_reg[0]  ( .D(n56), .CK(CLK), .RN(n73), .QN(n22) );
  DFFRX1M \REG_ALU_OUT_reg[15]  ( .D(n71), .CK(CLK), .RN(n72), .QN(n7) );
  DFFRX1M \REG_ALU_OUT_reg[14]  ( .D(n70), .CK(CLK), .RN(n72), .QN(n8) );
  DFFRX1M \REG_ALU_OUT_reg[13]  ( .D(n69), .CK(CLK), .RN(n72), .QN(n9) );
  DFFRX1M \REG_ALU_OUT_reg[12]  ( .D(n68), .CK(CLK), .RN(n72), .QN(n10) );
  DFFRX1M \REG_ALU_OUT_reg[11]  ( .D(n67), .CK(CLK), .RN(n72), .QN(n11) );
  DFFRX1M \REG_ALU_OUT_reg[10]  ( .D(n66), .CK(CLK), .RN(n72), .QN(n12) );
  DFFRX1M \REG_ALU_OUT_reg[9]  ( .D(n65), .CK(CLK), .RN(n72), .QN(n13) );
  DFFRX1M \REG_ALU_OUT_reg[8]  ( .D(n64), .CK(CLK), .RN(n72), .QN(n14) );
  DFFRX1M \REG_RdData_reg[7]  ( .D(n55), .CK(CLK), .RN(n73), .QN(n23) );
  DFFRX1M \REG_RdData_reg[6]  ( .D(n54), .CK(CLK), .RN(n73), .QN(n24) );
  DFFRX1M \REG_RdData_reg[5]  ( .D(n53), .CK(CLK), .RN(n73), .QN(n25) );
  DFFRX1M \REG_RdData_reg[4]  ( .D(n52), .CK(CLK), .RN(n73), .QN(n26) );
  DFFRX1M \REG_RdData_reg[3]  ( .D(n51), .CK(CLK), .RN(n73), .QN(n27) );
  DFFRX1M \REG_RdData_reg[2]  ( .D(n50), .CK(CLK), .RN(n73), .QN(n28) );
  DFFRX1M \REG_RdData_reg[1]  ( .D(n49), .CK(CLK), .RN(n73), .QN(n29) );
  DFFRX1M \REG_RdData_reg[0]  ( .D(n48), .CK(CLK), .RN(n73), .QN(n30) );
  DFFRQX2M \Current_State_reg[0]  ( .D(Next_State[0]), .CK(CLK), .RN(n74), .Q(
        Current_State[0]) );
  DFFRQX2M \Current_State_reg[2]  ( .D(n76), .CK(CLK), .RN(n74), .Q(
        Current_State[2]) );
  DFFRX4M \Current_State_reg[1]  ( .D(Next_State[1]), .CK(CLK), .RN(RST), .Q(
        Current_State[1]), .QN(n81) );
  INVX2M U3 ( .A(1'b0), .Y(CLK_div_en) );
  NOR3X2M U5 ( .A(n80), .B(Current_State[1]), .C(n82), .Y(n32) );
  NOR3X8M U6 ( .A(n80), .B(Current_State[2]), .C(n81), .Y(n38) );
  NOR3X8M U7 ( .A(n82), .B(Current_State[0]), .C(n81), .Y(n37) );
  CLKINVX3M U8 ( .A(Current_State[0]), .Y(n80) );
  CLKBUFX2M U9 ( .A(RST), .Y(n75) );
  CLKBUFX12M U10 ( .A(n32), .Y(n3) );
  CLKBUFX2M U11 ( .A(n33), .Y(n4) );
  NOR3X6M U12 ( .A(Current_State[0]), .B(Current_State[1]), .C(n82), .Y(n39)
         );
  CLKBUFX8M U13 ( .A(n75), .Y(n73) );
  CLKBUFX8M U14 ( .A(n75), .Y(n72) );
  CLKBUFX2M U15 ( .A(n75), .Y(n74) );
  NAND2X4M U16 ( .A(n79), .B(n44), .Y(TX_D_VLD) );
  CLKINVX4M U17 ( .A(Busy), .Y(n77) );
  OAI2B11X1M U18 ( .A1N(ALU_OUT_VLD), .A0(Busy), .B0(n43), .C0(n47), .Y(
        Next_State[0]) );
  OAI21X2M U19 ( .A0(TX_D_VLD), .A1(n78), .B0(n77), .Y(n47) );
  BUFX10M U20 ( .A(n4), .Y(n5) );
  OAI211X2M U21 ( .A0(n44), .A1(n77), .B0(n45), .C0(n46), .Y(Next_State[1]) );
  AOI22X1M U22 ( .A0(n37), .A1(Busy), .B0(n38), .B1(n77), .Y(n46) );
  NOR2X4M U23 ( .A(n5), .B(n3), .Y(n44) );
  INVX2M U24 ( .A(n38), .Y(n79) );
  INVX2M U25 ( .A(n40), .Y(n76) );
  NOR3BX2M U26 ( .AN(n41), .B(n3), .C(n42), .Y(n40) );
  OAI21X1M U27 ( .A0(n37), .A1(n39), .B0(Busy), .Y(n41) );
  BUFX10M U28 ( .A(n4), .Y(n6) );
  INVX4M U29 ( .A(n45), .Y(n78) );
  BUFX4M U30 ( .A(n4), .Y(n31) );
  OAI2BB2X1M U31 ( .B0(n5), .B1(n22), .A0N(ALU_OUT[0]), .A1N(n6), .Y(n56) );
  OAI2BB2X1M U32 ( .B0(n5), .B1(n21), .A0N(ALU_OUT[1]), .A1N(n6), .Y(n57) );
  OAI2BB2X1M U33 ( .B0(n5), .B1(n20), .A0N(ALU_OUT[2]), .A1N(n6), .Y(n58) );
  OAI2BB2X1M U34 ( .B0(n5), .B1(n19), .A0N(ALU_OUT[3]), .A1N(n6), .Y(n59) );
  OAI2BB2X1M U38 ( .B0(n6), .B1(n18), .A0N(ALU_OUT[4]), .A1N(n6), .Y(n60) );
  OAI2BB2X1M U40 ( .B0(n6), .B1(n17), .A0N(ALU_OUT[5]), .A1N(n6), .Y(n61) );
  OAI2BB2X1M U41 ( .B0(n6), .B1(n16), .A0N(ALU_OUT[6]), .A1N(n6), .Y(n62) );
  OAI2BB2X1M U42 ( .B0(n6), .B1(n15), .A0N(ALU_OUT[7]), .A1N(n6), .Y(n63) );
  OAI2BB2X1M U43 ( .B0(n5), .B1(n14), .A0N(ALU_OUT[8]), .A1N(n6), .Y(n64) );
  OAI2BB2X1M U44 ( .B0(n5), .B1(n13), .A0N(ALU_OUT[9]), .A1N(n6), .Y(n65) );
  OAI2BB2X1M U45 ( .B0(n5), .B1(n12), .A0N(ALU_OUT[10]), .A1N(n31), .Y(n66) );
  OAI2BB2X1M U46 ( .B0(n5), .B1(n11), .A0N(ALU_OUT[11]), .A1N(n31), .Y(n67) );
  OAI2BB2X1M U47 ( .B0(n5), .B1(n10), .A0N(ALU_OUT[12]), .A1N(n6), .Y(n68) );
  OAI2BB2X1M U48 ( .B0(n5), .B1(n9), .A0N(ALU_OUT[13]), .A1N(n31), .Y(n69) );
  OAI2BB2X1M U49 ( .B0(n5), .B1(n8), .A0N(ALU_OUT[14]), .A1N(n31), .Y(n70) );
  OAI2BB2X1M U50 ( .B0(n5), .B1(n7), .A0N(ALU_OUT[15]), .A1N(n6), .Y(n71) );
  INVX4M U51 ( .A(Current_State[2]), .Y(n82) );
  NAND2X2M U52 ( .A(RdData_VLD), .B(n77), .Y(n43) );
  NOR3X2M U53 ( .A(Current_State[1]), .B(Current_State[2]), .C(n80), .Y(n33)
         );
  OAI2BB2X1M U54 ( .B0(n3), .B1(n30), .A0N(RdData[0]), .A1N(n3), .Y(n48) );
  OAI2BB2X1M U55 ( .B0(n3), .B1(n29), .A0N(RdData[1]), .A1N(n3), .Y(n49) );
  OAI2BB2X1M U56 ( .B0(n3), .B1(n28), .A0N(RdData[2]), .A1N(n3), .Y(n50) );
  OAI2BB2X1M U57 ( .B0(n3), .B1(n27), .A0N(RdData[3]), .A1N(n3), .Y(n51) );
  OAI2BB2X1M U58 ( .B0(n3), .B1(n26), .A0N(RdData[4]), .A1N(n3), .Y(n52) );
  OAI2BB2X1M U59 ( .B0(n3), .B1(n25), .A0N(RdData[5]), .A1N(n3), .Y(n53) );
  OAI2BB2X1M U60 ( .B0(n3), .B1(n24), .A0N(RdData[6]), .A1N(n3), .Y(n54) );
  OAI2BB2X1M U61 ( .B0(n3), .B1(n23), .A0N(RdData[7]), .A1N(n3), .Y(n55) );
  NAND3X2M U62 ( .A(n80), .B(n82), .C(Current_State[1]), .Y(n45) );
  OAI222X2M U63 ( .A0(n34), .A1(n22), .B0(n35), .B1(n14), .C0(n36), .C1(n30), 
        .Y(TX_P_Data[0]) );
  OAI222X2M U64 ( .A0(n34), .A1(n21), .B0(n35), .B1(n13), .C0(n36), .C1(n29), 
        .Y(TX_P_Data[1]) );
  OAI222X2M U65 ( .A0(n34), .A1(n20), .B0(n35), .B1(n12), .C0(n36), .C1(n28), 
        .Y(TX_P_Data[2]) );
  OAI222X2M U66 ( .A0(n34), .A1(n19), .B0(n35), .B1(n11), .C0(n36), .C1(n27), 
        .Y(TX_P_Data[3]) );
  OAI222X2M U67 ( .A0(n34), .A1(n18), .B0(n35), .B1(n10), .C0(n36), .C1(n26), 
        .Y(TX_P_Data[4]) );
  OAI222X2M U68 ( .A0(n34), .A1(n17), .B0(n35), .B1(n9), .C0(n36), .C1(n25), 
        .Y(TX_P_Data[5]) );
  OAI222X2M U69 ( .A0(n34), .A1(n16), .B0(n35), .B1(n8), .C0(n36), .C1(n24), 
        .Y(TX_P_Data[6]) );
  OAI222X2M U70 ( .A0(n34), .A1(n15), .B0(n35), .B1(n7), .C0(n36), .C1(n23), 
        .Y(TX_P_Data[7]) );
endmodule


module Controller_FSM_RX ( Data_valid, CLK, RST, ALU_OUT_Valid, P_Data_RX, 
        ALU_EN, CLK_EN, WrEn, RdEn, ALU_FUN, Address, WrData );
  input [7:0] P_Data_RX;
  output [3:0] ALU_FUN;
  output [3:0] Address;
  output [7:0] WrData;
  input Data_valid, CLK, RST, ALU_OUT_Valid;
  output ALU_EN, CLK_EN, WrEn, RdEn;
  wire   n98, n99, n100, n16, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n1,
         n3, n4, n7, n8, n9, n10, n12, n13, n14, n15, n17, n18, n19, n20, n21,
         n22, n23, n24, n90, n91, n92, n93, n94, n95, n96, n97;
  wire   [4:0] Current_State;
  wire   [4:0] Next_State;
  wire   [3:0] P_Data_Addr;

  AOI221X4M U24 ( .A0(Data_valid), .A1(n19), .B0(n50), .B1(n97), .C0(n10), .Y(
        n44) );
  AOI211X4M U27 ( .A0(n55), .A1(n97), .B0(n43), .C0(n56), .Y(n54) );
  NOR3BX4M U38 ( .AN(n70), .B(n92), .C(n96), .Y(n33) );
  NOR4BX4M U40 ( .AN(n71), .B(P_Data_RX[1]), .C(P_Data_RX[5]), .D(n94), .Y(n70) );
  CLKINVX8M U65 ( .A(n25), .Y(Address[3]) );
  AOI22X4M U66 ( .A0(n19), .A1(P_Data_Addr[3]), .B0(n68), .B1(P_Data_RX[3]), 
        .Y(n25) );
  CLKINVX8M U67 ( .A(n27), .Y(Address[2]) );
  AOI22X4M U68 ( .A0(n19), .A1(P_Data_Addr[2]), .B0(n68), .B1(P_Data_RX[2]), 
        .Y(n27) );
  AOI22X4M U70 ( .A0(n19), .A1(P_Data_Addr[1]), .B0(n68), .B1(P_Data_RX[1]), 
        .Y(n28) );
  NOR3X12M U74 ( .A(Current_State[1]), .B(Current_State[4]), .C(n24), .Y(n80)
         );
  NOR2X12M U80 ( .A(n85), .B(n93), .Y(ALU_FUN[3]) );
  DFFRHQX8M \Current_State_reg[0]  ( .D(Next_State[0]), .CK(CLK), .RN(n7), .Q(
        Current_State[0]) );
  DFFRHQX8M \Current_State_reg[4]  ( .D(Next_State[4]), .CK(CLK), .RN(n7), .Q(
        Current_State[4]) );
  DFFRQX2M \P_Data_Addr_reg[3]  ( .D(n86), .CK(CLK), .RN(n7), .Q(
        P_Data_Addr[3]) );
  DFFRQX2M \P_Data_Addr_reg[2]  ( .D(n87), .CK(CLK), .RN(n7), .Q(
        P_Data_Addr[2]) );
  DFFRQX2M \P_Data_Addr_reg[1]  ( .D(n88), .CK(CLK), .RN(n7), .Q(
        P_Data_Addr[1]) );
  DFFRQX2M \Current_State_reg[3]  ( .D(Next_State[3]), .CK(CLK), .RN(n7), .Q(
        Current_State[3]) );
  DFFRX1M \P_Data_Addr_reg[0]  ( .D(n89), .CK(CLK), .RN(n7), .QN(n16) );
  DFFRQX2M \Current_State_reg[2]  ( .D(Next_State[2]), .CK(CLK), .RN(n7), .Q(
        Current_State[2]) );
  DFFRQX4M \Current_State_reg[1]  ( .D(Next_State[1]), .CK(CLK), .RN(n7), .Q(
        Current_State[1]) );
  NOR2X4M U3 ( .A(Current_State[3]), .B(Current_State[2]), .Y(n84) );
  NOR2X6M U4 ( .A(ALU_EN), .B(n15), .Y(n85) );
  INVX2M U5 ( .A(Current_State[1]), .Y(n22) );
  NOR2X8M U6 ( .A(n22), .B(Current_State[4]), .Y(n79) );
  INVX8M U7 ( .A(n99), .Y(ALU_FUN[0]) );
  CLKINVX12M U8 ( .A(n98), .Y(ALU_FUN[1]) );
  NOR2X8M U9 ( .A(n85), .B(n94), .Y(ALU_FUN[2]) );
  NAND2X2M U10 ( .A(n48), .B(n82), .Y(n57) );
  OR2X2M U11 ( .A(P_Data_RX[0]), .B(P_Data_RX[4]), .Y(n1) );
  NOR3X8M U12 ( .A(Current_State[2]), .B(Current_State[4]), .C(
        Current_State[1]), .Y(n76) );
  NOR3X4M U13 ( .A(n60), .B(P_Data_RX[4]), .C(P_Data_RX[0]), .Y(n65) );
  OR2X2M U14 ( .A(n85), .B(n96), .Y(n99) );
  CLKBUFX2M U15 ( .A(n33), .Y(n3) );
  NOR2X4M U16 ( .A(n4), .B(n1), .Y(n39) );
  CLKINVX1M U17 ( .A(n70), .Y(n4) );
  OR2X2M U18 ( .A(n85), .B(n95), .Y(n98) );
  NAND4X1M U19 ( .A(n35), .B(n36), .C(n37), .D(n38), .Y(Next_State[3]) );
  NAND2X2M U20 ( .A(n49), .B(n76), .Y(n29) );
  OAI211X1M U21 ( .A0(n62), .A1(n97), .B0(n63), .C0(n64), .Y(Next_State[0]) );
  NAND2X2M U22 ( .A(n78), .B(n79), .Y(n53) );
  NOR2X6M U23 ( .A(n23), .B(Current_State[0]), .Y(n49) );
  NOR2BX4M U25 ( .AN(n84), .B(Current_State[0]), .Y(n78) );
  INVX2M U26 ( .A(Current_State[0]), .Y(n14) );
  NAND3X6M U28 ( .A(n79), .B(n84), .C(Current_State[0]), .Y(n26) );
  INVX2M U29 ( .A(P_Data_RX[3]), .Y(n93) );
  INVX4M U30 ( .A(Data_valid), .Y(n97) );
  INVX2M U31 ( .A(P_Data_RX[6]), .Y(n90) );
  INVX2M U32 ( .A(n57), .Y(ALU_EN) );
  INVX6M U33 ( .A(WrEn), .Y(n13) );
  CLKAND2X4M U34 ( .A(n66), .B(n67), .Y(n34) );
  NOR4X2M U35 ( .A(n10), .B(n9), .C(n21), .D(n68), .Y(n66) );
  NOR4BX2M U36 ( .AN(n53), .B(CLK_EN), .C(n19), .D(n20), .Y(n67) );
  NOR2BX4M U37 ( .AN(n36), .B(n17), .Y(n51) );
  INVX2M U39 ( .A(n29), .Y(RdEn) );
  INVX2M U41 ( .A(n69), .Y(n10) );
  INVX2M U42 ( .A(n58), .Y(n9) );
  NAND3X2M U43 ( .A(n69), .B(n53), .C(n77), .Y(n74) );
  INVX6M U44 ( .A(n8), .Y(n7) );
  INVX2M U45 ( .A(RST), .Y(n8) );
  NOR2BX8M U46 ( .AN(n79), .B(n24), .Y(n48) );
  NOR2X6M U47 ( .A(n23), .B(n14), .Y(n82) );
  NAND2X4M U48 ( .A(n82), .B(n80), .Y(n46) );
  NAND2X2M U49 ( .A(n80), .B(n49), .Y(n45) );
  NAND4X2M U50 ( .A(n77), .B(n81), .C(n36), .D(n46), .Y(CLK_EN) );
  NAND2X2M U51 ( .A(n57), .B(n52), .Y(n30) );
  AND4X2M U52 ( .A(n35), .B(n31), .C(n37), .D(n83), .Y(n77) );
  NOR2BX2M U53 ( .AN(n45), .B(n30), .Y(n83) );
  NAND3X4M U54 ( .A(n79), .B(n24), .C(n82), .Y(n36) );
  NAND2X2M U55 ( .A(n49), .B(n79), .Y(n37) );
  NAND2X2M U56 ( .A(n82), .B(n76), .Y(n35) );
  NAND2X4M U57 ( .A(n26), .B(n29), .Y(n68) );
  INVX4M U58 ( .A(n75), .Y(n19) );
  NOR2X2M U59 ( .A(n13), .B(n96), .Y(WrData[0]) );
  NOR2X2M U60 ( .A(n13), .B(n95), .Y(WrData[1]) );
  NOR2X2M U61 ( .A(n13), .B(n94), .Y(WrData[2]) );
  NOR2X2M U62 ( .A(n13), .B(n93), .Y(WrData[3]) );
  NOR2X2M U63 ( .A(n13), .B(n92), .Y(WrData[4]) );
  NOR2X2M U64 ( .A(n13), .B(n91), .Y(WrData[5]) );
  NOR2X2M U69 ( .A(n13), .B(n90), .Y(WrData[6]) );
  NAND3X4M U71 ( .A(n46), .B(n75), .C(n36), .Y(WrEn) );
  OAI21X2M U72 ( .A0(n21), .A1(n9), .B0(n97), .Y(n63) );
  NOR4X2M U73 ( .A(n74), .B(n20), .C(WrEn), .D(n17), .Y(n62) );
  OAI31X2M U75 ( .A0(n65), .A1(n39), .A2(n3), .B0(n34), .Y(n64) );
  INVX2M U76 ( .A(n42), .Y(n21) );
  INVX2M U77 ( .A(n28), .Y(Address[1]) );
  INVX2M U78 ( .A(n81), .Y(n15) );
  AOI211X2M U79 ( .A0(n39), .A1(n34), .B0(n40), .C0(n41), .Y(n38) );
  AOI21X2M U81 ( .A0(n42), .A1(n29), .B0(n97), .Y(n41) );
  NAND4X2M U82 ( .A(n52), .B(n37), .C(n53), .D(n54), .Y(Next_State[1]) );
  NAND4X2M U83 ( .A(n42), .B(n61), .C(n31), .D(n46), .Y(n55) );
  AOI21X2M U84 ( .A0(n51), .A1(n57), .B0(n97), .Y(n56) );
  INVX4M U85 ( .A(n26), .Y(n17) );
  NAND2X2M U86 ( .A(n80), .B(n14), .Y(n69) );
  NAND3X2M U87 ( .A(n14), .B(n23), .C(n48), .Y(n58) );
  INVX2M U88 ( .A(n61), .Y(n20) );
  INVX4M U89 ( .A(Current_State[2]), .Y(n24) );
  INVX4M U90 ( .A(Current_State[3]), .Y(n23) );
  NAND4X4M U91 ( .A(Current_State[4]), .B(Current_State[0]), .C(n84), .D(n22), 
        .Y(n31) );
  NAND3X2M U92 ( .A(Current_State[4]), .B(Current_State[1]), .C(n78), .Y(n52)
         );
  NAND3X2M U93 ( .A(Current_State[4]), .B(n22), .C(n78), .Y(n81) );
  OAI2B11X2M U94 ( .A1N(n30), .A0(Data_valid), .B0(n31), .C0(n32), .Y(
        Next_State[4]) );
  AOI22X1M U95 ( .A0(n33), .A1(n34), .B0(ALU_OUT_Valid), .B1(n15), .Y(n32) );
  INVX4M U96 ( .A(P_Data_RX[2]), .Y(n94) );
  NAND3X4M U97 ( .A(Current_State[0]), .B(n23), .C(n48), .Y(n42) );
  NOR2BX2M U98 ( .AN(P_Data_RX[7]), .B(n13), .Y(WrData[7]) );
  NAND3X4M U99 ( .A(Current_State[0]), .B(n23), .C(n80), .Y(n75) );
  NAND3BX2M U100 ( .AN(n43), .B(n44), .C(n12), .Y(Next_State[2]) );
  INVX2M U101 ( .A(n40), .Y(n12) );
  NAND2X2M U102 ( .A(n51), .B(n42), .Y(n50) );
  NAND2X2M U103 ( .A(n58), .B(n59), .Y(n43) );
  NAND4BX1M U104 ( .AN(n60), .B(n34), .C(P_Data_RX[4]), .D(P_Data_RX[0]), .Y(
        n59) );
  CLKBUFX2M U105 ( .A(n100), .Y(Address[0]) );
  OAI221X2M U106 ( .A0(n18), .A1(n96), .B0(n75), .B1(n16), .C0(n46), .Y(n100)
         );
  INVX2M U107 ( .A(n68), .Y(n18) );
  NOR2X2M U108 ( .A(n90), .B(n72), .Y(n71) );
  INVX4M U109 ( .A(P_Data_RX[0]), .Y(n96) );
  NAND2X2M U110 ( .A(n76), .B(Current_State[0]), .Y(n61) );
  OAI2BB2X1M U111 ( .B0(n28), .B1(n26), .A0N(n26), .A1N(P_Data_Addr[1]), .Y(
        n88) );
  OAI2BB2X1M U112 ( .B0(n27), .B1(n26), .A0N(n26), .A1N(P_Data_Addr[2]), .Y(
        n87) );
  OAI2BB2X1M U113 ( .B0(n25), .B1(n26), .A0N(n26), .A1N(P_Data_Addr[3]), .Y(
        n86) );
  OAI2BB2X1M U114 ( .B0(n17), .B1(n16), .A0N(Address[0]), .A1N(n17), .Y(n89)
         );
  INVX2M U115 ( .A(P_Data_RX[1]), .Y(n95) );
  NAND3X2M U116 ( .A(n45), .B(n46), .C(n47), .Y(n40) );
  AOI22X1M U117 ( .A0(n48), .A1(n49), .B0(Data_valid), .B1(n30), .Y(n47) );
  NAND3X2M U118 ( .A(P_Data_RX[7]), .B(P_Data_RX[3]), .C(Data_valid), .Y(n72)
         );
  NAND4X2M U119 ( .A(n94), .B(n90), .C(P_Data_RX[1]), .D(n73), .Y(n60) );
  NOR2X2M U120 ( .A(n91), .B(n72), .Y(n73) );
  INVX2M U121 ( .A(P_Data_RX[4]), .Y(n92) );
  INVX2M U122 ( .A(P_Data_RX[5]), .Y(n91) );
endmodule


module SYS_CTRL ( ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST, ALU_OUT, RdData, 
        TX_P_Data, TX_D_VLD, CLK_div_en, Data_valid, P_Data_RX, ALU_EN, CLK_EN, 
        WrEn, RdEn, ALU_FUN, Address, WrData );
  input [15:0] ALU_OUT;
  input [7:0] RdData;
  output [7:0] TX_P_Data;
  input [7:0] P_Data_RX;
  output [3:0] ALU_FUN;
  output [3:0] Address;
  output [7:0] WrData;
  input ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST, Data_valid;
  output TX_D_VLD, CLK_div_en, ALU_EN, CLK_EN, WrEn, RdEn;
  wire   n8, n9, n5, n6;

  Controller_FSM_TX TX_Control ( .ALU_OUT_VLD(ALU_OUT_VLD), .RdData_VLD(
        RdData_VLD), .Busy(Busy), .CLK(CLK), .RST(n5), .ALU_OUT(ALU_OUT), 
        .RdData(RdData), .TX_P_Data(TX_P_Data), .TX_D_VLD(TX_D_VLD) );
  Controller_FSM_RX RX_Control ( .Data_valid(Data_valid), .CLK(CLK), .RST(n5), 
        .ALU_OUT_Valid(ALU_OUT_VLD), .P_Data_RX(P_Data_RX), .ALU_EN(ALU_EN), 
        .CLK_EN(CLK_EN), .WrEn(WrEn), .RdEn(RdEn), .ALU_FUN(ALU_FUN), 
        .Address({Address[3:2], n8, n9}), .WrData(WrData) );
  INVX2M U1 ( .A(1'b0), .Y(CLK_div_en) );
  INVX2M U3 ( .A(n6), .Y(n5) );
  CLKBUFX2M U4 ( .A(n8), .Y(Address[1]) );
  CLKBUFX2M U5 ( .A(n9), .Y(Address[0]) );
  INVX2M U6 ( .A(RST), .Y(n6) );
endmodule


module SYS_TOP ( REF_CLK, UART_CLK, RST, RX_IN, TX_OUT, Parity_error, 
        Framing_error );
  input REF_CLK, UART_CLK, RST, RX_IN;
  output TX_OUT, Parity_error, Framing_error;
  wire   o_div_clk, SYNC_RST2, bus_enable_RX, Data_Valid_TX_SYNC, SYNC_Busy,
         SYNC_RST1, enable_pulse_RX, Data_Valid_TX_ASYNC, Gate_Enable, ALU_CLK,
         ALU_Enable, ALU_OUT_Valid, RdEn, WrEn, RdData_Valid, n2, n3, n4, n5,
         n6, n7, n8, n9, n10;
  wire   [7:0] Reg2;
  wire   [7:0] Unsync_bus_RX;
  wire   [7:0] sync_bus_TX;
  wire   [7:0] sync_bus_RX;
  wire   [7:0] Unsync_bus_TX;
  wire   [7:0] Reg3;
  wire   [7:0] Reg0;
  wire   [7:0] Reg1;
  wire   [3:0] ALU_FUN;
  wire   [15:0] ALU_OUT;
  wire   [3:0] Reg_Address;
  wire   [7:0] WrData;
  wire   [7:0] RdData;
  wire   SYNOPSYS_UNCONNECTED__0, SYNOPSYS_UNCONNECTED__1, 
        SYNOPSYS_UNCONNECTED__2, SYNOPSYS_UNCONNECTED__3, 
        SYNOPSYS_UNCONNECTED__4;

  UART U1 ( .RX_IN(n2), .PAR_EN(Reg2[0]), .PAR_TYP(Reg2[1]), .RX_CLK(UART_CLK), 
        .TX_CLK(o_div_clk), .RST(n7), .Prescale(Reg2[5:2]), .data_valid_RX(
        bus_enable_RX), .Parity_error(Parity_error), .Framing_error(
        Framing_error), .P_DATA_RX(Unsync_bus_RX), .Data_Valid_TX(
        Data_Valid_TX_SYNC), .P_DATA_TX(sync_bus_TX), .TX_OUT(TX_OUT), .Busy(
        n9) );
  DATA_SYNC_NUM_STAGES2_BUS_WIDTH8_1 SYNC_RX1 ( .Unsync_bus(Unsync_bus_RX), 
        .bus_enable(bus_enable_RX), .CLK(REF_CLK), .RST(n5), .enable_pulse(
        enable_pulse_RX), .sync_bus(sync_bus_RX) );
  BIT_SYNC_NUM_STAGES2_BUS_WIDTH1_1 BUSY_SYNC1 ( .ASYNC(1'b0), .CLK(REF_CLK), 
        .RST(n5), .SYNC(n10) );
  BIT_SYNC_NUM_STAGES2_BUS_WIDTH1_0 Data_Valid_TX_SYNC1 ( .ASYNC(
        Data_Valid_TX_ASYNC), .CLK(UART_CLK), .RST(n7), .SYNC(
        Data_Valid_TX_SYNC) );
  DATA_SYNC_NUM_STAGES2_BUS_WIDTH8_0 SYNC_TX1 ( .Unsync_bus(Unsync_bus_TX), 
        .bus_enable(Data_Valid_TX_ASYNC), .CLK(UART_CLK), .RST(n7), .sync_bus(
        sync_bus_TX) );
  RST_SYNC_1 RST_SYNC1 ( .RST(RST), .CLK(REF_CLK), .SYNC_RST(SYNC_RST1) );
  RST_SYNC_0 RST_SYNC2 ( .RST(RST), .CLK(UART_CLK), .SYNC_RST(SYNC_RST2) );
  CLK_Divider TX_DIV1 ( .i_ref_clk(UART_CLK), .i_rst_n(n7), .i_clk_en(1'b1), 
        .i_div_ratio(Reg3[4:0]), .o_div_clk(o_div_clk) );
  CLK_Gate CLK_Gate1 ( .Enable(Gate_Enable), .CLK(REF_CLK), .Gated_CLK(ALU_CLK) );
  ALU ALU1 ( .A(Reg0), .B(Reg1), .ALU_FUN(ALU_FUN), .CLK(ALU_CLK), .RST(n5), 
        .Enable(ALU_Enable), .ALU_OUT(ALU_OUT), .OUT_VALID(ALU_OUT_Valid) );
  Reg_File REG_FILE1 ( .CLK(REF_CLK), .RST(n5), .RdEn(RdEn), .WrEn(WrEn), 
        .Address({Reg_Address[3:2], n4, n3}), .WrData(WrData), .RdData(RdData), 
        .Reg0(Reg0), .Reg1(Reg1), .Reg2({SYNOPSYS_UNCONNECTED__0, 
        SYNOPSYS_UNCONNECTED__1, Reg2[5:0]}), .Reg3({SYNOPSYS_UNCONNECTED__2, 
        SYNOPSYS_UNCONNECTED__3, SYNOPSYS_UNCONNECTED__4, Reg3[4:0]}), 
        .RdData_Valid(RdData_Valid) );
  SYS_CTRL SYS_CTRL1 ( .ALU_OUT_VLD(ALU_OUT_Valid), .RdData_VLD(RdData_Valid), 
        .Busy(SYNC_Busy), .CLK(REF_CLK), .RST(n5), .ALU_OUT(ALU_OUT), .RdData(
        RdData), .TX_P_Data(Unsync_bus_TX), .TX_D_VLD(Data_Valid_TX_ASYNC), 
        .Data_valid(enable_pulse_RX), .P_Data_RX(sync_bus_RX), .ALU_EN(
        ALU_Enable), .CLK_EN(Gate_Enable), .WrEn(WrEn), .RdEn(RdEn), .ALU_FUN(
        ALU_FUN), .Address(Reg_Address), .WrData(WrData) );
  CLKAND2X4M U2 ( .A(n9), .B(n10), .Y(SYNC_Busy) );
  INVX4M U3 ( .A(n6), .Y(n5) );
  INVX4M U4 ( .A(n8), .Y(n7) );
  CLKBUFX2M U5 ( .A(Reg_Address[1]), .Y(n4) );
  CLKBUFX2M U6 ( .A(Reg_Address[0]), .Y(n3) );
  CLKBUFX2M U7 ( .A(RX_IN), .Y(n2) );
  INVX2M U8 ( .A(SYNC_RST1), .Y(n6) );
  INVX2M U9 ( .A(SYNC_RST2), .Y(n8) );
endmodule


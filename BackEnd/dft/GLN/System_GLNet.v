/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Thu Oct 13 00:00:54 2022
/////////////////////////////////////////////////////////////


module FSM_TX_test_1 ( PAR_EN, ser_done, Data_Valid, CLK, RST, ser_en, busy, 
        mux_sel, test_si, test_se );
  output [1:0] mux_sel;
  input PAR_EN, ser_done, Data_Valid, CLK, RST, test_si, test_se;
  output ser_en, busy;
  wire   busy_c, n11, n12, n14, n15, n16, n17, n18, n19, n9, n10, n13, n20,
         n21, n22, n23, n24, n27;
  wire   [1:0] Current_state;
  wire   [2:0] Next_state;

  OAI32X4M U16 ( .A0(n10), .A1(mux_sel[1]), .A2(n21), .B0(n16), .B1(n19), .Y(
        Next_state[0]) );
  SDFFRX1M Current_state_reg_1_ ( .D(Next_state[1]), .SI(Current_state[0]), 
        .SE(test_se), .CK(CLK), .RN(RST), .Q(Current_state[1]), .QN(n22) );
  SDFFRX1M busy_reg ( .D(busy_c), .SI(n24), .SE(test_se), .CK(CLK), .RN(n9), 
        .Q(busy) );
  SDFFRX4M Current_state_reg_2_ ( .D(Next_state[2]), .SI(n27), .SE(test_se), 
        .CK(CLK), .RN(n9), .Q(n24), .QN(n23) );
  SDFFRX2M Current_state_reg_0_ ( .D(Next_state[0]), .SI(test_si), .SE(test_se), .CK(CLK), .RN(n9), .Q(Current_state[0]), .QN(n20) );
  CLKBUFX2M U7 ( .A(RST), .Y(n9) );
  NAND3X4M U8 ( .A(Current_state[1]), .B(n20), .C(n23), .Y(n16) );
  NAND2X1M U9 ( .A(PAR_EN), .B(ser_done), .Y(n19) );
  INVX2M U14 ( .A(mux_sel[0]), .Y(ser_en) );
  NAND2X2M U15 ( .A(n23), .B(n12), .Y(mux_sel[0]) );
  NOR2X4M U17 ( .A(n22), .B(n20), .Y(n14) );
  NAND2X2M U18 ( .A(n14), .B(n23), .Y(n15) );
  NAND2X2M U19 ( .A(n16), .B(n15), .Y(mux_sel[1]) );
  OAI2B1X2M U20 ( .A1N(n11), .A0(n12), .B0(mux_sel[0]), .Y(busy_c) );
  OAI21X2M U21 ( .A0(n14), .A1(n23), .B0(n15), .Y(n11) );
  INVX2M U22 ( .A(n18), .Y(n21) );
  INVX2M U23 ( .A(Data_Valid), .Y(n10) );
  XNOR2X4M U24 ( .A(n20), .B(Current_state[1]), .Y(n12) );
  OAI31X2M U25 ( .A0(n13), .A1(PAR_EN), .A2(n16), .B0(n15), .Y(Next_state[2])
         );
  INVX2M U26 ( .A(ser_done), .Y(n13) );
  NAND3X2M U27 ( .A(Current_state[0]), .B(n27), .C(n23), .Y(n18) );
  OAI21X2M U28 ( .A0(n17), .A1(n16), .B0(n18), .Y(Next_state[1]) );
  AND2X2M U29 ( .A(n19), .B(ser_done), .Y(n17) );
  DLY1X1M U30 ( .A(n22), .Y(n27) );
endmodule


module MUX4x1_test_1 ( ser_data, par_bit, CLK, RST, mux_sel, TX_OUT, test_si, 
        test_so, test_se );
  input [1:0] mux_sel;
  input ser_data, par_bit, CLK, RST, test_si, test_se;
  output TX_OUT, test_so;
  wire   n7, TX_OUT_c, n3, n4, n6;

  SDFFRX1M TX_OUT_reg ( .D(TX_OUT_c), .SI(test_si), .SE(test_se), .CK(CLK), 
        .RN(RST), .Q(n7), .QN(test_so) );
  BUFX10M U5 ( .A(n7), .Y(TX_OUT) );
  OAI21X2M U6 ( .A0(n3), .A1(n6), .B0(n4), .Y(TX_OUT_c) );
  NAND3X2M U7 ( .A(mux_sel[1]), .B(n6), .C(ser_data), .Y(n4) );
  NOR2BX2M U8 ( .AN(mux_sel[1]), .B(par_bit), .Y(n3) );
  INVX2M U9 ( .A(mux_sel[0]), .Y(n6) );
endmodule


module Parity_Calc_test_1 ( P_DATA, Data_Valid, PAR_TYP, CLK, RST, par_bit, 
        test_si, test_so, test_se );
  input [7:0] P_DATA;
  input Data_Valid, PAR_TYP, CLK, RST, test_si, test_se;
  output par_bit, test_so;
  wire   n1, n3, n4, n5, n6, n8, n9;

  SDFFRX1M par_bit_reg ( .D(n8), .SI(test_si), .SE(test_se), .CK(CLK), .RN(RST), .Q(par_bit), .QN(test_so) );
  CLKXOR2X2M U2 ( .A(P_DATA[7]), .B(P_DATA[6]), .Y(n6) );
  XNOR2X1M U3 ( .A(P_DATA[3]), .B(P_DATA[2]), .Y(n5) );
  OAI2BB2X1M U5 ( .B0(n1), .B1(n9), .A0N(par_bit), .A1N(n9), .Y(n8) );
  INVX2M U6 ( .A(Data_Valid), .Y(n9) );
  XOR3XLM U7 ( .A(n3), .B(PAR_TYP), .C(n4), .Y(n1) );
  XOR3XLM U8 ( .A(P_DATA[1]), .B(P_DATA[0]), .C(n5), .Y(n4) );
  XOR3XLM U10 ( .A(P_DATA[5]), .B(P_DATA[4]), .C(n6), .Y(n3) );
endmodule


module Serializer_test_1 ( P_DATA, ser_en, CLK, RST, ser_done, ser_data, 
        test_si, test_se );
  input [7:0] P_DATA;
  input ser_en, CLK, RST, test_si, test_se;
  output ser_done, ser_data;
  wire   N1, N2, N3, N4, n9, n10, n11, n12, n13, n14, n15, n16, n17, n20, n21,
         n22, n23, n24, n25;

  AOI2B1X8M U14 ( .A1N(ser_done), .A0(ser_en), .B0(n13), .Y(n10) );
  SDFFRX1M ser_data_reg ( .D(n16), .SI(n25), .SE(test_se), .CK(CLK), .RN(n20), 
        .Q(ser_data), .QN(n24) );
  SDFFRX2M Counter_reg_2_ ( .D(n14), .SI(N2), .SE(test_se), .CK(CLK), .RN(n20), 
        .Q(N3), .QN(n25) );
  SDFFRQX4M Counter_reg_0_ ( .D(n17), .SI(test_si), .SE(test_se), .CK(CLK), 
        .RN(n20), .Q(N1) );
  SDFFRQX4M Counter_reg_1_ ( .D(n15), .SI(N1), .SE(test_se), .CK(CLK), .RN(n20), .Q(N2) );
  SDFFRQX4M ser_done_reg ( .D(n13), .SI(n24), .SE(test_se), .CK(CLK), .RN(RST), 
        .Q(ser_done) );
  NAND2X1M U8 ( .A(N2), .B(N1), .Y(n11) );
  MX4XLM U9 ( .A(P_DATA[0]), .B(P_DATA[1]), .C(P_DATA[2]), .D(P_DATA[3]), .S0(
        N1), .S1(N2), .Y(n22) );
  MX4XLM U10 ( .A(P_DATA[4]), .B(P_DATA[5]), .C(P_DATA[6]), .D(P_DATA[7]), 
        .S0(N1), .S1(N2), .Y(n21) );
  BUFX4M U17 ( .A(RST), .Y(n20) );
  AO2B2X2M U18 ( .B0(ser_data), .B1(n10), .A0(N4), .A1N(n10), .Y(n16) );
  MX2X2M U19 ( .A(n22), .B(n21), .S0(N3), .Y(N4) );
  AND3X2M U20 ( .A(n23), .B(N3), .C(ser_en), .Y(n13) );
  INVX2M U21 ( .A(n11), .Y(n23) );
  CLKXOR2X2M U22 ( .A(N2), .B(n12), .Y(n15) );
  NOR2BX2M U23 ( .AN(N1), .B(n10), .Y(n12) );
  XNOR2X2M U24 ( .A(N1), .B(n10), .Y(n17) );
  CLKXOR2X2M U25 ( .A(N3), .B(n9), .Y(n14) );
  NOR2X2M U26 ( .A(n10), .B(n11), .Y(n9) );
endmodule


module UART_TX_test_1 ( CLK, RST, PAR_TYP, PAR_EN, Data_Valid, P_DATA, TX_OUT, 
        Busy, test_si, test_so, test_se );
  input [7:0] P_DATA;
  input CLK, RST, PAR_TYP, PAR_EN, Data_Valid, test_si, test_se;
  output TX_OUT, Busy, test_so;
  wire   ser_en, ser_data, par_bit, n1, n2, n3, n4, n7, n8, n9;
  wire   [1:0] mux_sel;

  INVX4M U5 ( .A(n2), .Y(n1) );
  INVX2M U6 ( .A(RST), .Y(n2) );
  DLY1X1M U7 ( .A(n9), .Y(n7) );
  DLY1X1M U8 ( .A(P_DATA[7]), .Y(n8) );
  DLY1X1M U9 ( .A(Data_Valid), .Y(n9) );
  FSM_TX_test_1 U1 ( .PAR_EN(PAR_EN), .ser_done(test_so), .Data_Valid(n7), 
        .CLK(CLK), .RST(n1), .ser_en(ser_en), .busy(Busy), .mux_sel(mux_sel), 
        .test_si(test_si), .test_se(test_se) );
  MUX4x1_test_1 U2 ( .ser_data(ser_data), .par_bit(par_bit), .CLK(CLK), .RST(
        n1), .mux_sel(mux_sel), .TX_OUT(TX_OUT), .test_si(Busy), .test_so(n4), 
        .test_se(test_se) );
  Parity_Calc_test_1 U3 ( .P_DATA({n8, P_DATA[6:0]}), .Data_Valid(n9), 
        .PAR_TYP(PAR_TYP), .CLK(CLK), .RST(n1), .par_bit(par_bit), .test_si(n4), .test_so(n3), .test_se(test_se) );
  Serializer_test_1 U4 ( .P_DATA({n8, P_DATA[6:0]}), .ser_en(ser_en), .CLK(CLK), .RST(n1), .ser_done(test_so), .ser_data(ser_data), .test_si(n3), .test_se(
        test_se) );
endmodule


module FSM_RX_test_1 ( CLK, RST, RX_IN, PAR_EN, par_err, strt_glitch, stp_err, 
        bit_cnt, par_chk_en, strt_chk_en, stp_chk_en, data_valid, deser_en, 
        cnt_en, data_sample_en, test_si, test_se );
  input [3:0] bit_cnt;
  input CLK, RST, RX_IN, PAR_EN, par_err, strt_glitch, stp_err, test_si,
         test_se;
  output par_chk_en, strt_chk_en, stp_chk_en, data_valid, deser_en, cnt_en,
         data_sample_en;
  wire   n5, data_valid_c, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n22, n23, n24, n25, n9, n11, n26, n27, n28, n30, n31, n32, n1, n3, n4
;
  wire   [2:0] Curr_state;
  wire   [2:0] Next_state;

  NOR3X12M U18 ( .A(n31), .B(Curr_state[2]), .C(n30), .Y(deser_en) );
  CLKBUFX2M U7 ( .A(RST), .Y(n11) );
  NAND3X2M U8 ( .A(n30), .B(n4), .C(Curr_state[1]), .Y(n12) );
  XNOR2X1M U9 ( .A(PAR_EN), .B(bit_cnt[0]), .Y(n22) );
  NOR3BX4M U10 ( .AN(bit_cnt[0]), .B(bit_cnt[1]), .C(bit_cnt[2]), .Y(n16) );
  INVXLM U15 ( .A(n27), .Y(n9) );
  CLKINVX3M U16 ( .A(n16), .Y(n27) );
  AOI21X1M U17 ( .A0(strt_chk_en), .A1(n18), .B0(deser_en), .Y(n17) );
  NAND3BXLM U19 ( .AN(bit_cnt[2]), .B(bit_cnt[1]), .C(bit_cnt[3]), .Y(n25) );
  OAI211X1M U20 ( .A0(RX_IN), .A1(n19), .B0(n20), .C0(n21), .Y(Next_state[0])
         );
  NAND2X2M U21 ( .A(n24), .B(stp_chk_en), .Y(n14) );
  INVX2M U22 ( .A(n12), .Y(par_chk_en) );
  NAND3X2M U23 ( .A(n12), .B(n14), .C(n17), .Y(Next_state[1]) );
  INVX2M U24 ( .A(n14), .Y(n26) );
  NOR3X8M U26 ( .A(n31), .B(Curr_state[0]), .C(n4), .Y(stp_chk_en) );
  OAI31X2M U30 ( .A0(n27), .A1(bit_cnt[3]), .A2(n18), .B0(strt_chk_en), .Y(n20) );
  AOI31X1M U31 ( .A0(n26), .A1(n28), .A2(n22), .B0(n23), .Y(n21) );
  NOR3X4M U34 ( .A(strt_glitch), .B(bit_cnt[3]), .C(n27), .Y(n18) );
  AOI31X1M U35 ( .A0(bit_cnt[0]), .A1(n28), .A2(par_err), .B0(stp_err), .Y(n24) );
  OAI211X2M U36 ( .A0(n13), .A1(n12), .B0(n14), .C0(n15), .Y(Next_state[2]) );
  AOI2B1X1M U37 ( .A1N(bit_cnt[0]), .A0(n28), .B0(par_err), .Y(n13) );
  NAND4BX1M U38 ( .AN(PAR_EN), .B(deser_en), .C(n9), .D(bit_cnt[3]), .Y(n15)
         );
  INVX2M U39 ( .A(n25), .Y(n28) );
  AOI21BX1M U40 ( .A0(n16), .A1(bit_cnt[3]), .B0N(deser_en), .Y(n23) );
  CLKBUFX2M U41 ( .A(cnt_en), .Y(data_sample_en) );
  OR4X4M U42 ( .A(deser_en), .B(par_chk_en), .C(stp_chk_en), .D(strt_chk_en), 
        .Y(cnt_en) );
  SDFFRX1M Curr_state_reg_2_ ( .D(Next_state[2]), .SI(n31), .SE(test_se), .CK(
        CLK), .RN(n11), .Q(Curr_state[2]), .QN(n32) );
  SDFFRX4M Curr_state_reg_0_ ( .D(Next_state[0]), .SI(test_si), .SE(test_se), 
        .CK(CLK), .RN(n11), .Q(Curr_state[0]), .QN(n30) );
  SDFFRX4M Curr_state_reg_1_ ( .D(Next_state[1]), .SI(n30), .SE(test_se), .CK(
        CLK), .RN(n11), .Q(Curr_state[1]), .QN(n31) );
  SDFFRHQX1M data_valid_reg ( .D(data_valid_c), .SI(n4), .SE(test_se), .CK(CLK), .RN(RST), .Q(data_valid) );
  AOI31X1M U3 ( .A0(n31), .A1(n4), .A2(n30), .B0(data_valid_c), .Y(n19) );
  NOR3X4M U4 ( .A(n4), .B(n31), .C(n30), .Y(data_valid_c) );
  INVXLM U5 ( .A(n5), .Y(n1) );
  INVX4M U6 ( .A(n1), .Y(strt_chk_en) );
  INVXLM U11 ( .A(n32), .Y(n3) );
  INVX4M U12 ( .A(n3), .Y(n4) );
  AOI21X2M U13 ( .A0(n4), .A1(n30), .B0(Curr_state[1]), .Y(n5) );
endmodule


module Edge_Bit_Counter_test_1 ( cnt_en, CLK, RST, edge_cnt, bit_cnt, test_si, 
        test_so, test_se );
  output [2:0] edge_cnt;
  output [3:0] bit_cnt;
  input cnt_en, CLK, RST, test_si, test_se;
  output test_so;
  wire   n55, n59, N8, N9, N10, n16, n17, n18, n19, n20, n21, n22, n23, n24,
         n25, n26, n27, n28, n29, n8, n10, n12, n14, n5, n30, n32, n34, n46,
         n47, n48, n49, n51, n52, n53, n62, n63, n64, n1, n2, n3;

  SDFFRQX1M edge_cnt_reg_1_ ( .D(N9), .SI(edge_cnt[0]), .SE(test_se), .CK(CLK), 
        .RN(RST), .Q(n55) );
  INVX4M U10 ( .A(n2), .Y(bit_cnt[0]) );
  OAI22X1M U11 ( .A0(n2), .A1(n23), .B0(n49), .B1(n62), .Y(n29) );
  OAI22X1M U12 ( .A0(edge_cnt[2]), .A1(n24), .B0(n26), .B1(test_so), .Y(N10)
         );
  INVX6M U14 ( .A(n8), .Y(bit_cnt[2]) );
  CLKINVX1M U16 ( .A(bit_cnt[2]), .Y(n52) );
  INVX6M U18 ( .A(n12), .Y(bit_cnt[1]) );
  OA21X1M U21 ( .A0(n59), .A1(n49), .B0(n23), .Y(n22) );
  CLKINVX6M U23 ( .A(n30), .Y(edge_cnt[2]) );
  INVX8M U25 ( .A(n32), .Y(edge_cnt[0]) );
  INVXLM U26 ( .A(n55), .Y(n34) );
  INVX8M U27 ( .A(n34), .Y(edge_cnt[1]) );
  INVX4M U36 ( .A(n47), .Y(n46) );
  INVX2M U37 ( .A(RST), .Y(n47) );
  INVX4M U38 ( .A(n19), .Y(n49) );
  NAND2X2M U39 ( .A(cnt_en), .B(n49), .Y(n23) );
  INVX2M U40 ( .A(cnt_en), .Y(n53) );
  NOR2X4M U41 ( .A(n2), .B(n49), .Y(n18) );
  NOR2X4M U42 ( .A(test_so), .B(n24), .Y(n19) );
  OAI21X4M U43 ( .A0(bit_cnt[1]), .A1(n49), .B0(n22), .Y(n20) );
  NAND3X2M U44 ( .A(edge_cnt[0]), .B(cnt_en), .C(edge_cnt[1]), .Y(n24) );
  OAI21X2M U45 ( .A0(n16), .A1(n64), .B0(n17), .Y(n27) );
  NAND4X2M U46 ( .A(bit_cnt[2]), .B(bit_cnt[1]), .C(n18), .D(n14), .Y(n17) );
  AOI21X2M U47 ( .A0(n19), .A1(n63), .B0(n20), .Y(n16) );
  INVX2M U48 ( .A(n21), .Y(n48) );
  AOI32X1M U49 ( .A0(bit_cnt[1]), .A1(n18), .A2(n52), .B0(n20), .B1(bit_cnt[2]), .Y(n21) );
  INVX2M U50 ( .A(edge_cnt[2]), .Y(test_so) );
  AOI2BB1X1M U51 ( .A0N(edge_cnt[1]), .A1N(n53), .B0(N8), .Y(n26) );
  NOR2X3M U52 ( .A(n53), .B(edge_cnt[0]), .Y(N8) );
  OAI2BB2X1M U53 ( .B0(n22), .B1(n51), .A0N(n51), .A1N(n18), .Y(n28) );
  INVX2M U54 ( .A(bit_cnt[1]), .Y(n51) );
  NOR2X2M U55 ( .A(n25), .B(n53), .Y(N9) );
  XNOR2X2M U56 ( .A(edge_cnt[0]), .B(edge_cnt[1]), .Y(n25) );
  DLY1X1M U57 ( .A(n59), .Y(n62) );
  DLY1X1M U58 ( .A(n52), .Y(n63) );
  DLY1X1M U59 ( .A(n14), .Y(n64) );
  SDFFRX1M bit_cnt_reg_3_ ( .D(n27), .SI(n63), .SE(test_se), .CK(CLK), .RN(n46), .Q(n5), .QN(n14) );
  SDFFRX1M edge_cnt_reg_0_ ( .D(N8), .SI(n64), .SE(test_se), .CK(CLK), .RN(RST), .QN(n32) );
  SDFFRX1M edge_cnt_reg_2_ ( .D(N10), .SI(edge_cnt[1]), .SE(test_se), .CK(CLK), 
        .RN(n46), .QN(n30) );
  SDFFRX1M bit_cnt_reg_0_ ( .D(n29), .SI(test_si), .SE(test_se), .CK(CLK), 
        .RN(n46), .Q(n59), .QN(n10) );
  SDFFRX1M bit_cnt_reg_1_ ( .D(n28), .SI(n62), .SE(test_se), .CK(CLK), .RN(n46), .QN(n12) );
  SDFFRX1M bit_cnt_reg_2_ ( .D(n48), .SI(n51), .SE(test_se), .CK(CLK), .RN(n46), .QN(n8) );
  INVXLM U3 ( .A(n10), .Y(n1) );
  INVX2M U4 ( .A(n1), .Y(n2) );
  INVXLM U5 ( .A(n5), .Y(n3) );
  INVX6M U6 ( .A(n3), .Y(bit_cnt[3]) );
endmodule


module Data_Sampling_test_1 ( data_sample_en, RX_IN, CLK, RST, edge_cnt, 
        Prescale, sampled_bit, test_si, test_se );
  input [2:0] edge_cnt;
  input [3:0] Prescale;
  input data_sample_en, RX_IN, CLK, RST, test_si, test_se;
  output sampled_bit;
  wire   N44, N45, N46, N47, N60, N61, N62, N63, N91, n13, n14, n16, n17, n19,
         n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n44, n49, n50, n51, N59, N58,
         N56, n1, n6, n7, n8, n9, n10, n11, n12, n15, n18, n20, n48, n52, n53,
         n54, n57, n58, n59, n2, n3, n4, n5;
  wire   [2:0] buffer;
  wire   [3:1] sub_22_2_carry;

  SDFFRQX1M buffer_reg_2_ ( .D(n51), .SI(n58), .SE(test_se), .CK(CLK), .RN(n10), .Q(buffer[2]) );
  SDFFRQX4M sampled_bit_reg ( .D(n44), .SI(n59), .SE(test_se), .CK(CLK), .RN(
        RST), .Q(sampled_bit) );
  CLKBUFX2M U3 ( .A(RST), .Y(n10) );
  CLKBUFX6M U4 ( .A(Prescale[1]), .Y(n6) );
  CLKXOR2X2M U5 ( .A(Prescale[2]), .B(n6), .Y(n1) );
  AOI21X2M U6 ( .A0(n5), .A1(n3), .B0(n16), .Y(n13) );
  OA21X1M U7 ( .A0(n5), .A1(n3), .B0(buffer[2]), .Y(n16) );
  NOR4X2M U12 ( .A(N46), .B(n20), .C(n18), .D(n15), .Y(N47) );
  XNOR2X2M U13 ( .A(N59), .B(sub_22_2_carry[3]), .Y(N63) );
  XNOR2X4M U14 ( .A(edge_cnt[0]), .B(n11), .Y(N60) );
  INVX1M U15 ( .A(N60), .Y(n48) );
  NAND2BX1M U16 ( .AN(N59), .B(n54), .Y(N58) );
  CLKBUFX6M U17 ( .A(n9), .Y(n8) );
  BUFX4M U18 ( .A(n9), .Y(n7) );
  CLKBUFX2M U19 ( .A(N91), .Y(n9) );
  NOR2X2M U21 ( .A(n7), .B(n8), .Y(n39) );
  NOR2X2M U22 ( .A(n8), .B(n7), .Y(n40) );
  NOR2X2M U23 ( .A(n8), .B(n7), .Y(n38) );
  AND4X2M U24 ( .A(n33), .B(n34), .C(n35), .D(n36), .Y(n23) );
  NOR2X2M U25 ( .A(n8), .B(n7), .Y(n34) );
  NOR2X2M U26 ( .A(n8), .B(n7), .Y(n33) );
  AND4X2M U27 ( .A(n37), .B(n38), .C(n39), .D(n40), .Y(n36) );
  INVX2M U28 ( .A(RX_IN), .Y(n53) );
  NAND3BX2M U29 ( .AN(N61), .B(n22), .C(n23), .Y(n19) );
  NOR4BX2M U30 ( .AN(n41), .B(n9), .C(N62), .D(N63), .Y(n35) );
  NOR2X2M U31 ( .A(n8), .B(n7), .Y(n41) );
  INVX2M U32 ( .A(N56), .Y(n11) );
  INVX2M U33 ( .A(n6), .Y(N56) );
  OAI2BB2X1M U34 ( .B0(n53), .B1(n21), .A0N(n58), .A1N(n21), .Y(n50) );
  NAND2BX1M U35 ( .AN(n19), .B(N60), .Y(n21) );
  OAI2BB2X1M U36 ( .B0(n17), .B1(n53), .A0N(n57), .A1N(n17), .Y(n49) );
  NAND2BX2M U37 ( .AN(n19), .B(n48), .Y(n17) );
  OAI2BB2X1M U38 ( .B0(n53), .B1(n24), .A0N(n59), .A1N(n24), .Y(n51) );
  NAND4X2M U39 ( .A(N61), .B(n23), .C(n22), .D(n48), .Y(n24) );
  AOI31X1M U40 ( .A0(n29), .A1(n30), .A2(n31), .B0(N47), .Y(n28) );
  AOI21X2M U41 ( .A0(Prescale[3]), .A1(n32), .B0(edge_cnt[0]), .Y(n31) );
  CLKXOR2X2M U46 ( .A(N44), .B(edge_cnt[1]), .Y(n30) );
  XNOR2X2M U47 ( .A(n32), .B(n27), .Y(n29) );
  ADDFX2M U48 ( .A(edge_cnt[2]), .B(n12), .CI(sub_22_2_carry[2]), .CO(
        sub_22_2_carry[3]), .S(N62) );
  INVX2M U49 ( .A(N58), .Y(n12) );
  OAI21X2M U50 ( .A0(n6), .A1(Prescale[2]), .B0(Prescale[3]), .Y(n54) );
  ADDFX2M U51 ( .A(edge_cnt[1]), .B(n1), .CI(sub_22_2_carry[1]), .CO(
        sub_22_2_carry[2]), .S(N61) );
  AND2X2M U52 ( .A(data_sample_en), .B(n25), .Y(n22) );
  OAI31X2M U53 ( .A0(n26), .A1(n52), .A2(n27), .B0(n28), .Y(n25) );
  XOR2X2M U54 ( .A(edge_cnt[1]), .B(Prescale[2]), .Y(n26) );
  CLKXOR2X2M U55 ( .A(edge_cnt[2]), .B(Prescale[3]), .Y(n27) );
  INVX1M U56 ( .A(edge_cnt[0]), .Y(n52) );
  OAI2BB2X1M U57 ( .B0(n13), .B1(n14), .A0N(sampled_bit), .A1N(n14), .Y(n44)
         );
  NAND3X1M U58 ( .A(edge_cnt[1]), .B(n52), .C(edge_cnt[2]), .Y(n14) );
  NOR3X8M U59 ( .A(Prescale[2]), .B(Prescale[3]), .C(n6), .Y(N59) );
  NOR3X4M U60 ( .A(Prescale[2]), .B(Prescale[3]), .C(n6), .Y(N46) );
  OAI21BX4M U61 ( .A0(Prescale[2]), .A1(n6), .B0N(n32), .Y(N44) );
  AND2X2M U62 ( .A(Prescale[2]), .B(n6), .Y(n32) );
  NAND2BX2M U63 ( .AN(N46), .B(n42), .Y(N45) );
  OAI21X1M U64 ( .A0(n6), .A1(Prescale[2]), .B0(Prescale[3]), .Y(n42) );
  OR2X1M U65 ( .A(n11), .B(edge_cnt[0]), .Y(sub_22_2_carry[1]) );
  NOR2X1M U66 ( .A(sub_22_2_carry[3]), .B(N59), .Y(N91) );
  CLKXOR2X2M U67 ( .A(N56), .B(edge_cnt[0]), .Y(n20) );
  CLKXOR2X2M U68 ( .A(N45), .B(edge_cnt[2]), .Y(n18) );
  CLKXOR2X2M U69 ( .A(N44), .B(edge_cnt[1]), .Y(n15) );
  DLY1X1M U70 ( .A(n3), .Y(n57) );
  DLY1X1M U71 ( .A(n5), .Y(n58) );
  DLY1X1M U72 ( .A(buffer[2]), .Y(n59) );
  SDFFRX1M buffer_reg_1_ ( .D(n50), .SI(n57), .SE(test_se), .CK(CLK), .RN(n10), 
        .Q(buffer[1]) );
  SDFFRX1M buffer_reg_0_ ( .D(n49), .SI(test_si), .SE(test_se), .CK(CLK), .RN(
        n10), .Q(buffer[0]) );
  INVXLM U8 ( .A(buffer[0]), .Y(n2) );
  INVX2M U9 ( .A(n2), .Y(n3) );
  INVXLM U10 ( .A(buffer[1]), .Y(n4) );
  INVX2M U11 ( .A(n4), .Y(n5) );
  CLKINVX8M U20 ( .A(n8), .Y(n37) );
endmodule


module Parity_Check_test_1 ( par_chk_en, PAR_TYP, sampled_bit, P_DATA, 
        edge_cnt, bit_cnt, CLK, RST, par_err, test_si, test_se );
  input [7:0] P_DATA;
  input [2:0] edge_cnt;
  input [3:0] bit_cnt;
  input par_chk_en, PAR_TYP, sampled_bit, CLK, RST, test_si, test_se;
  output par_err;
  wire   n16, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15;

  SDFFRQX1M par_err_reg ( .D(n14), .SI(test_si), .SE(test_se), .CK(CLK), .RN(
        RST), .Q(n16) );
  XOR2X2M U4 ( .A(sampled_bit), .B(PAR_TYP), .Y(n8) );
  NOR4BBX2M U5 ( .AN(bit_cnt[3]), .BN(bit_cnt[0]), .C(bit_cnt[2]), .D(
        bit_cnt[1]), .Y(n13) );
  CLKBUFX12M U7 ( .A(n16), .Y(par_err) );
  INVX2M U8 ( .A(n7), .Y(n15) );
  NAND4X2M U9 ( .A(edge_cnt[1]), .B(edge_cnt[0]), .C(edge_cnt[2]), .D(n13), 
        .Y(n7) );
  INVX2M U10 ( .A(n4), .Y(n14) );
  AOI33X2M U11 ( .A0(n15), .A1(n5), .A2(par_chk_en), .B0(n6), .B1(n7), .B2(
        par_err), .Y(n4) );
  OR4X1M U12 ( .A(bit_cnt[0]), .B(bit_cnt[1]), .C(bit_cnt[2]), .D(bit_cnt[3]), 
        .Y(n6) );
  XNOR2X2M U13 ( .A(P_DATA[7]), .B(P_DATA[6]), .Y(n12) );
  XNOR2X2M U14 ( .A(P_DATA[3]), .B(P_DATA[2]), .Y(n11) );
  XOR3XLM U15 ( .A(n8), .B(n9), .C(n10), .Y(n5) );
  XOR3XLM U16 ( .A(P_DATA[1]), .B(P_DATA[0]), .C(n11), .Y(n10) );
  XOR3XLM U17 ( .A(P_DATA[5]), .B(P_DATA[4]), .C(n12), .Y(n9) );
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


module Deserializer_test_1 ( deser_en, sampled_bit, CLK, RST, edge_cnt, 
        bit_cnt, P_DATA, test_si, test_so, test_se );
  input [2:0] edge_cnt;
  input [3:0] bit_cnt;
  output [7:0] P_DATA;
  input deser_en, sampled_bit, CLK, RST, test_si, test_se;
  output test_so;
  wire   n3, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20, n21,
         n22, n23, n24, n25, n26, n27, n43, n44, n45, n46, n47, n48, n49, n52,
         n54, n55, n56, n57, n58, n59, n1;

  BUFX6M U11 ( .A(n17), .Y(n47) );
  AND2X2M U13 ( .A(n44), .B(n45), .Y(n27) );
  OAI22X2M U14 ( .A0(n16), .A1(n59), .B0(n47), .B1(test_so), .Y(n21) );
  OAI22X2M U15 ( .A0(n16), .A1(n54), .B0(n47), .B1(n14), .Y(n26) );
  OAI22X2M U16 ( .A0(n16), .A1(n55), .B0(n47), .B1(n13), .Y(n25) );
  OAI22X2M U17 ( .A0(n16), .A1(n56), .B0(n47), .B1(n12), .Y(n24) );
  OAI22X2M U18 ( .A0(n16), .A1(n57), .B0(n47), .B1(n11), .Y(n23) );
  NAND2X6M U19 ( .A(n43), .B(n47), .Y(n16) );
  OAI22X2M U20 ( .A0(n16), .A1(n58), .B0(n47), .B1(n10), .Y(n22) );
  INVXLM U21 ( .A(bit_cnt[2]), .Y(n44) );
  NAND2BXLM U22 ( .AN(bit_cnt[1]), .B(bit_cnt[0]), .Y(n18) );
  INVXLM U38 ( .A(bit_cnt[3]), .Y(n45) );
  CLKINVX1M U39 ( .A(n18), .Y(n46) );
  NAND2XLM U40 ( .A(n46), .B(n27), .Y(n43) );
  OAI2B2X1M U42 ( .A1N(n52), .A0(n16), .B0(n47), .B1(n15), .Y(n19) );
  OAI2B2X1M U43 ( .A1N(sampled_bit), .A0(n47), .B0(n16), .B1(n9), .Y(n20) );
  NAND4X1M U44 ( .A(edge_cnt[2]), .B(edge_cnt[1]), .C(edge_cnt[0]), .D(
        deser_en), .Y(n17) );
  DLY1X1M U45 ( .A(P_DATA[0]), .Y(n52) );
  DLY1X1M U46 ( .A(n9), .Y(test_so) );
  DLY1X1M U47 ( .A(n15), .Y(n54) );
  DLY1X1M U48 ( .A(n14), .Y(n55) );
  DLY1X1M U49 ( .A(n13), .Y(n56) );
  DLY1X1M U50 ( .A(n12), .Y(n57) );
  DLY1X1M U51 ( .A(n11), .Y(n58) );
  DLY1X1M U52 ( .A(n10), .Y(n59) );
  SDFFRX1M P_DATA_reg_6_ ( .D(n21), .SI(n58), .SE(test_se), .CK(CLK), .RN(RST), 
        .Q(P_DATA[6]), .QN(n10) );
  SDFFRX1M P_DATA_reg_5_ ( .D(n22), .SI(n57), .SE(test_se), .CK(CLK), .RN(n48), 
        .Q(P_DATA[5]), .QN(n11) );
  SDFFRX1M P_DATA_reg_4_ ( .D(n23), .SI(n56), .SE(test_se), .CK(CLK), .RN(n48), 
        .Q(P_DATA[4]), .QN(n12) );
  SDFFRX1M P_DATA_reg_3_ ( .D(n24), .SI(n55), .SE(test_se), .CK(CLK), .RN(n48), 
        .Q(P_DATA[3]), .QN(n13) );
  SDFFRX1M P_DATA_reg_2_ ( .D(n25), .SI(n54), .SE(test_se), .CK(CLK), .RN(n48), 
        .Q(P_DATA[2]), .QN(n14) );
  SDFFRX1M P_DATA_reg_1_ ( .D(n26), .SI(n52), .SE(test_se), .CK(CLK), .RN(n48), 
        .Q(P_DATA[1]), .QN(n15) );
  SDFFRX1M P_DATA_reg_7_ ( .D(n20), .SI(n59), .SE(test_se), .CK(CLK), .RN(n48), 
        .Q(P_DATA[7]), .QN(n9) );
  SDFFRX1M P_DATA_reg_0_ ( .D(n19), .SI(test_si), .SE(test_se), .CK(CLK), .RN(
        n48), .Q(n3) );
  INVX6M U3 ( .A(n49), .Y(n48) );
  INVX1M U4 ( .A(RST), .Y(n49) );
  INVXLM U5 ( .A(n3), .Y(n1) );
  INVX2M U6 ( .A(n1), .Y(P_DATA[0]) );
endmodule


module UART_RX_test_1 ( RX_IN, PAR_EN, PAR_TYP, CLK, RST, Prescale, data_valid, 
        Parity_error, Framing_error, P_DATA, test_si, test_so, test_se );
  input [3:0] Prescale;
  output [7:0] P_DATA;
  input RX_IN, PAR_EN, PAR_TYP, CLK, RST, test_si, test_se;
  output data_valid, Parity_error, Framing_error, test_so;
  wire   strt_glitch, par_chk_en, strt_chk_en, stp_chk_en, deser_en, cnt_en,
         data_sample_en, n1, n2, n3, n4;
  wire   [3:0] bit_cnt;
  wire   [2:0] edge_cnt;

  INVX6M U1 ( .A(n2), .Y(n1) );
  INVX2M U2 ( .A(RST), .Y(n2) );
  FSM_RX_test_1 FSM1 ( .CLK(CLK), .RST(n1), .RX_IN(RX_IN), .PAR_EN(PAR_EN), 
        .par_err(Parity_error), .strt_glitch(strt_glitch), .stp_err(
        Framing_error), .bit_cnt(bit_cnt), .par_chk_en(par_chk_en), 
        .strt_chk_en(strt_chk_en), .stp_chk_en(stp_chk_en), .data_valid(
        data_valid), .deser_en(deser_en), .cnt_en(cnt_en), .data_sample_en(
        data_sample_en), .test_si(n3), .test_se(test_se) );
  Edge_Bit_Counter_test_1 Counter1 ( .cnt_en(cnt_en), .CLK(CLK), .RST(n1), 
        .edge_cnt(edge_cnt), .bit_cnt(bit_cnt), .test_si(Parity_error), 
        .test_so(n4), .test_se(test_se) );
  Data_Sampling_test_1 Sample1 ( .data_sample_en(data_sample_en), .RX_IN(RX_IN), .CLK(CLK), .RST(n1), .edge_cnt(edge_cnt), .Prescale(Prescale), .sampled_bit(
        test_so), .test_si(data_valid), .test_se(test_se) );
  Parity_Check_test_1 Check2 ( .par_chk_en(par_chk_en), .PAR_TYP(PAR_TYP), 
        .sampled_bit(test_so), .P_DATA(P_DATA), .edge_cnt(edge_cnt), .bit_cnt(
        bit_cnt), .CLK(CLK), .RST(n1), .par_err(Parity_error), .test_si(
        test_si), .test_se(test_se) );
  Start_Check Check1 ( .strt_chk_en(strt_chk_en), .sampled_bit(test_so), 
        .edge_cnt(edge_cnt), .strt_glitch(strt_glitch) );
  Stop_Check Check3 ( .stp_chk_en(stp_chk_en), .sampled_bit(test_so), 
        .edge_cnt(edge_cnt), .stp_err(Framing_error) );
  Deserializer_test_1 Deserializer1 ( .deser_en(deser_en), .sampled_bit(
        test_so), .CLK(CLK), .RST(n1), .edge_cnt(edge_cnt), .bit_cnt(bit_cnt), 
        .P_DATA(P_DATA), .test_si(n4), .test_so(n3), .test_se(test_se) );
endmodule


module UART_test_1 ( RX_IN, PAR_EN, PAR_TYP, RX_CLK, TX_CLK, RST, Prescale, 
        data_valid_RX, Parity_error, Framing_error, P_DATA_RX, Data_Valid_TX, 
        P_DATA_TX, TX_OUT, Busy, test_si, test_so, test_se );
  input [3:0] Prescale;
  output [7:0] P_DATA_RX;
  input [7:0] P_DATA_TX;
  input RX_IN, PAR_EN, PAR_TYP, RX_CLK, TX_CLK, RST, Data_Valid_TX, test_si,
         test_se;
  output data_valid_RX, Parity_error, Framing_error, TX_OUT, Busy, test_so;
  wire   n1, n2, n4;

  INVX2M U1 ( .A(n2), .Y(n1) );
  INVX2M U2 ( .A(RST), .Y(n2) );
  UART_TX_test_1 UARTTX ( .CLK(TX_CLK), .RST(n1), .PAR_TYP(PAR_TYP), .PAR_EN(
        PAR_EN), .Data_Valid(Data_Valid_TX), .P_DATA(P_DATA_TX), .TX_OUT(
        TX_OUT), .Busy(Busy), .test_si(n4), .test_so(test_so), .test_se(
        test_se) );
  UART_RX_test_1 UARTRX ( .RX_IN(RX_IN), .PAR_EN(PAR_EN), .PAR_TYP(PAR_TYP), 
        .CLK(RX_CLK), .RST(n1), .Prescale(Prescale), .data_valid(data_valid_RX), .Parity_error(Parity_error), .Framing_error(Framing_error), .P_DATA(
        P_DATA_RX), .test_si(test_si), .test_so(n4), .test_se(test_se) );
endmodule


module DATA_SYNC_NUM_STAGES2_BUS_WIDTH8_test_0 ( Unsync_bus, bus_enable, CLK, 
        RST, enable_pulse, sync_bus, test_si, test_se );
  input [7:0] Unsync_bus;
  output [7:0] sync_bus;
  input bus_enable, CLK, RST, test_si, test_se;
  output enable_pulse;
  wire   Pulse_GenFF, n1, n4, n6, n8, n10, n12, n14, n16, n18, n33, n34, n35,
         n36, n39, n40, n41, n42;
  wire   [1:0] Multi_Flop;

  SDFFRQX2M Multi_Flop_reg_1_ ( .D(bus_enable), .SI(n41), .SE(test_se), .CK(
        CLK), .RN(n34), .Q(Multi_Flop[1]) );
  SDFFRQX2M sync_bus_reg_2_ ( .D(n8), .SI(sync_bus[1]), .SE(test_se), .CK(CLK), 
        .RN(n34), .Q(sync_bus[2]) );
  SDFFRQX2M sync_bus_reg_5_ ( .D(n14), .SI(sync_bus[4]), .SE(test_se), .CK(CLK), .RN(n34), .Q(sync_bus[5]) );
  SDFFRQX2M sync_bus_reg_7_ ( .D(n18), .SI(n42), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[7]) );
  CLKBUFX4M U3 ( .A(n1), .Y(n33) );
  AO22XLM U4 ( .A0(Unsync_bus[0]), .A1(n36), .B0(sync_bus[0]), .B1(n33), .Y(n4) );
  INVX6M U28 ( .A(n1), .Y(n36) );
  INVX8M U29 ( .A(n35), .Y(n34) );
  INVX2M U30 ( .A(RST), .Y(n35) );
  NAND2BX2M U31 ( .AN(Pulse_GenFF), .B(Multi_Flop[0]), .Y(n1) );
  AO22X1M U32 ( .A0(Unsync_bus[4]), .A1(n36), .B0(sync_bus[4]), .B1(n33), .Y(
        n12) );
  AO22X1M U33 ( .A0(Unsync_bus[1]), .A1(n36), .B0(sync_bus[1]), .B1(n1), .Y(n6) );
  AO22X1M U34 ( .A0(Unsync_bus[3]), .A1(n36), .B0(sync_bus[3]), .B1(n33), .Y(
        n10) );
  AO22X1M U35 ( .A0(Unsync_bus[7]), .A1(n36), .B0(n33), .B1(sync_bus[7]), .Y(
        n18) );
  AO22X1M U36 ( .A0(Unsync_bus[2]), .A1(n36), .B0(n33), .B1(n39), .Y(n8) );
  AO22X1M U37 ( .A0(Unsync_bus[6]), .A1(n36), .B0(n33), .B1(n42), .Y(n16) );
  AO22X1M U38 ( .A0(Unsync_bus[5]), .A1(n36), .B0(n33), .B1(n40), .Y(n14) );
  DLY1X1M U39 ( .A(sync_bus[2]), .Y(n39) );
  DLY1X1M U40 ( .A(sync_bus[5]), .Y(n40) );
  DLY1X1M U42 ( .A(sync_bus[6]), .Y(n42) );
  SDFFRQX1M sync_bus_reg_6_ ( .D(n16), .SI(n40), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[6]) );
  SDFFRQX4M sync_bus_reg_1_ ( .D(n6), .SI(sync_bus[0]), .SE(test_se), .CK(CLK), 
        .RN(n34), .Q(sync_bus[1]) );
  SDFFRQX4M sync_bus_reg_0_ ( .D(n4), .SI(enable_pulse), .SE(test_se), .CK(CLK), .RN(n34), .Q(sync_bus[0]) );
  SDFFRQX4M enable_pulse_reg ( .D(n36), .SI(Pulse_GenFF), .SE(test_se), .CK(
        CLK), .RN(n34), .Q(enable_pulse) );
  SDFFRQX4M sync_bus_reg_4_ ( .D(n12), .SI(sync_bus[3]), .SE(test_se), .CK(CLK), .RN(n34), .Q(sync_bus[4]) );
  SDFFRQX4M sync_bus_reg_3_ ( .D(n10), .SI(n39), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[3]) );
  SDFFRQX2M Multi_Flop_reg_0_ ( .D(Multi_Flop[1]), .SI(test_si), .SE(test_se), 
        .CK(CLK), .RN(RST), .Q(Multi_Flop[0]) );
  SDFFRQX2M Pulse_GenFF_reg ( .D(Multi_Flop[0]), .SI(Multi_Flop[1]), .SE(
        test_se), .CK(CLK), .RN(n34), .Q(Pulse_GenFF) );
  CLKBUFX2M U5 ( .A(Multi_Flop[0]), .Y(n41) );
endmodule


module BIT_SYNC_NUM_STAGES2_BUS_WIDTH1_test_0 ( ASYNC, CLK, RST, SYNC, test_si, 
        test_se );
  input [0:0] ASYNC;
  output [0:0] SYNC;
  input CLK, RST, test_si, test_se;
  wire   Multi_Flop_0__0_;

  SDFFRQX2M Multi_Flop_reg_0__0_ ( .D(ASYNC[0]), .SI(test_si), .SE(test_se), 
        .CK(CLK), .RN(RST), .Q(Multi_Flop_0__0_) );
  SDFFRQX1M Multi_Flop_reg_1__0_ ( .D(Multi_Flop_0__0_), .SI(Multi_Flop_0__0_), 
        .SE(test_se), .CK(CLK), .RN(RST), .Q(SYNC[0]) );
endmodule


module BIT_SYNC_NUM_STAGES2_BUS_WIDTH1_test_1 ( ASYNC, CLK, RST, SYNC, test_si, 
        test_se );
  input [0:0] ASYNC;
  output [0:0] SYNC;
  input CLK, RST, test_si, test_se;
  wire   Multi_Flop_0__0_, n4;

  SDFFRQX2M Multi_Flop_reg_0__0_ ( .D(ASYNC[0]), .SI(test_si), .SE(test_se), 
        .CK(CLK), .RN(n4), .Q(Multi_Flop_0__0_) );
  SDFFRQX1M Multi_Flop_reg_1__0_ ( .D(Multi_Flop_0__0_), .SI(Multi_Flop_0__0_), 
        .SE(test_se), .CK(CLK), .RN(n4), .Q(SYNC[0]) );
  CLKBUFX2M U6 ( .A(RST), .Y(n4) );
endmodule


module DATA_SYNC_NUM_STAGES2_BUS_WIDTH8_test_1 ( Unsync_bus, bus_enable, CLK, 
        RST, enable_pulse, sync_bus, test_si, test_se );
  input [7:0] Unsync_bus;
  output [7:0] sync_bus;
  input bus_enable, CLK, RST, test_si, test_se;
  output enable_pulse;
  wire   Pulse_GenFF, n33, n34, n35, n36, n40, n42, n44, n46, n48, n50, n52,
         n54, n57, n60, n61, n62, n63, n64, n65, n66, n67;
  wire   [1:0] Multi_Flop;

  SDFFRQX2M Multi_Flop_reg_1_ ( .D(bus_enable), .SI(n67), .SE(test_se), .CK(
        CLK), .RN(n34), .Q(Multi_Flop[1]) );
  SDFFRQX1M Multi_Flop_reg_0_ ( .D(Multi_Flop[1]), .SI(test_si), .SE(test_se), 
        .CK(CLK), .RN(RST), .Q(Multi_Flop[0]) );
  SDFFRQX1M Pulse_GenFF_reg ( .D(n67), .SI(Multi_Flop[1]), .SE(test_se), .CK(
        CLK), .RN(n34), .Q(Pulse_GenFF) );
  SDFFRQX1M enable_pulse_reg ( .D(n36), .SI(Pulse_GenFF), .SE(test_se), .CK(
        CLK), .RN(n34), .Q(enable_pulse) );
  SDFFRQX2M sync_bus_reg_2_ ( .D(n50), .SI(n60), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[2]) );
  SDFFRQX2M sync_bus_reg_4_ ( .D(n46), .SI(n62), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[4]) );
  SDFFRQX2M sync_bus_reg_0_ ( .D(n54), .SI(enable_pulse), .SE(test_se), .CK(
        CLK), .RN(n34), .Q(sync_bus[0]) );
  SDFFRQX2M sync_bus_reg_5_ ( .D(n44), .SI(n66), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[5]) );
  SDFFRQX2M sync_bus_reg_1_ ( .D(n52), .SI(n65), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[1]) );
  SDFFRQX2M sync_bus_reg_6_ ( .D(n42), .SI(n61), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[6]) );
  SDFFRQX2M sync_bus_reg_7_ ( .D(n40), .SI(n63), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[7]) );
  SDFFRQX2M sync_bus_reg_3_ ( .D(n48), .SI(n64), .SE(test_se), .CK(CLK), .RN(
        n34), .Q(sync_bus[3]) );
  CLKBUFX4M U3 ( .A(n57), .Y(n33) );
  AO22XLM U4 ( .A0(Unsync_bus[7]), .A1(n36), .B0(n33), .B1(sync_bus[7]), .Y(
        n40) );
  INVX6M U28 ( .A(n57), .Y(n36) );
  INVX8M U29 ( .A(n35), .Y(n34) );
  INVX2M U30 ( .A(RST), .Y(n35) );
  NAND2BX2M U31 ( .AN(Pulse_GenFF), .B(Multi_Flop[0]), .Y(n57) );
  AO22X1M U32 ( .A0(Unsync_bus[0]), .A1(n36), .B0(n33), .B1(n65), .Y(n54) );
  AO22X1M U33 ( .A0(Unsync_bus[1]), .A1(n36), .B0(n57), .B1(n60), .Y(n52) );
  AO22X1M U34 ( .A0(Unsync_bus[2]), .A1(n36), .B0(n33), .B1(n64), .Y(n50) );
  AO22X1M U35 ( .A0(Unsync_bus[3]), .A1(n36), .B0(n33), .B1(n62), .Y(n48) );
  AO22X1M U36 ( .A0(Unsync_bus[4]), .A1(n36), .B0(n33), .B1(n66), .Y(n46) );
  AO22X1M U37 ( .A0(Unsync_bus[5]), .A1(n36), .B0(n33), .B1(n61), .Y(n44) );
  AO22X1M U38 ( .A0(Unsync_bus[6]), .A1(n36), .B0(n33), .B1(n63), .Y(n42) );
  DLY1X1M U39 ( .A(sync_bus[1]), .Y(n60) );
  DLY1X1M U40 ( .A(sync_bus[5]), .Y(n61) );
  DLY1X1M U41 ( .A(sync_bus[3]), .Y(n62) );
  DLY1X1M U42 ( .A(sync_bus[6]), .Y(n63) );
  DLY1X1M U43 ( .A(sync_bus[2]), .Y(n64) );
  DLY1X1M U44 ( .A(sync_bus[0]), .Y(n65) );
  DLY1X1M U45 ( .A(sync_bus[4]), .Y(n66) );
  DLY1X1M U46 ( .A(Multi_Flop[0]), .Y(n67) );
endmodule


module RST_SYNC_test_0 ( RST, CLK, SYNC_RST, test_si, test_so, test_se );
  input RST, CLK, test_si, test_se;
  output SYNC_RST, test_so;


  SDFFRQX2M Multi_Flop_reg_1_ ( .D(1'b1), .SI(SYNC_RST), .SE(test_se), .CK(CLK), .RN(RST), .Q(test_so) );
  SDFFRQX1M Multi_Flop_reg_0_ ( .D(test_so), .SI(test_si), .SE(test_se), .CK(
        CLK), .RN(RST), .Q(SYNC_RST) );
endmodule


module RST_SYNC_test_1 ( RST, CLK, SYNC_RST, test_si, test_so, test_se );
  input RST, CLK, test_si, test_se;
  output SYNC_RST, test_so;


  SDFFRQX2M Multi_Flop_reg_1_ ( .D(1'b1), .SI(SYNC_RST), .SE(test_se), .CK(CLK), .RN(RST), .Q(test_so) );
  SDFFRQX1M Multi_Flop_reg_0_ ( .D(test_so), .SI(test_si), .SE(test_se), .CK(
        CLK), .RN(RST), .Q(SYNC_RST) );
endmodule


module CLK_Divider_test_1 ( i_ref_clk, i_rst_n, i_clk_en, i_div_ratio, 
        o_div_clk, test_si, test_so, test_se );
  input [4:0] i_div_ratio;
  input i_ref_clk, i_rst_n, i_clk_en, test_si, test_se;
  output o_div_clk, test_so;
  wire   N1, out_seq, N4, N10, N11, N12, N13, N14, N15, N17, N18, N19, N20,
         N21, N22, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43,
         n46, n49, n52, n55, n56, n3, n30, n31, n44, n45, n47, n48, n50, n51,
         n53, n54, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68,
         n69, n70, n71, n72, n79, n80, n81, n82, n83, n84, sub_25_n6,
         sub_25_n5, sub_25_n4, sub_25_n3, sub_25_n2, sub_25_n1, n1, n2, n4, n5,
         n6, n7, n8, n9, n10, n11, n12, n13;
  wire   [5:1] Duty;
  wire   [5:0] Counter;
  wire   [5:2] add_29_carry;
  wire   [5:1] sub_25_carry;

  AOI221X4M U47 ( .A0(n13), .A1(n33), .B0(N17), .B1(n34), .C0(n53), .Y(n35) );
  NOR2X12M U49 ( .A(n53), .B(N1), .Y(n34) );
  SDFFSRX2M Duty_reg_3_ ( .D(n43), .SI(sub_25_n4), .SE(test_se), .CK(i_ref_clk), .SN(n30), .RN(n47), .Q(Duty[3]), .QN(sub_25_n5) );
  SDFFSRX2M Duty_reg_2_ ( .D(n46), .SI(sub_25_n3), .SE(test_se), .CK(i_ref_clk), .SN(n31), .RN(n48), .Q(Duty[2]), .QN(sub_25_n4) );
  SDFFRQX1M out_seq_reg ( .D(n37), .SI(n79), .SE(test_se), .CK(i_ref_clk), 
        .RN(n54), .Q(out_seq) );
  SDFFRQX4M Counter_reg_1_ ( .D(n41), .SI(N17), .SE(test_se), .CK(i_ref_clk), 
        .RN(n54), .Q(Counter[1]) );
  SDFFSRX4M Duty_reg_1_ ( .D(n49), .SI(n2), .SE(test_se), .CK(i_ref_clk), .SN(
        n44), .RN(n50), .Q(Duty[1]), .QN(sub_25_n3) );
  OAI2B2X1M U6 ( .A1N(Counter[1]), .A0(n59), .B0(Duty[1]), .B1(n59), .Y(n61)
         );
  OAI2B2X1M U9 ( .A1N(Duty[1]), .A0(n58), .B0(Counter[1]), .B1(n58), .Y(n62)
         );
  XNOR2X2M U13 ( .A(Duty[5]), .B(n9), .Y(n60) );
  CLKXOR2X2M U15 ( .A(n11), .B(Duty[4]), .Y(n65) );
  AO22XLM U16 ( .A0(N15), .A1(n53), .B0(n67), .B1(n79), .Y(n55) );
  AO22XLM U18 ( .A0(N14), .A1(n53), .B0(n80), .B1(n67), .Y(n42) );
  NOR2BX4M U37 ( .AN(n2), .B(n13), .Y(n59) );
  NOR4X2M U38 ( .A(n66), .B(n65), .C(n64), .D(n63), .Y(N4) );
  NOR2BX4M U39 ( .AN(n13), .B(n2), .Y(n58) );
  ADDHX1M U40 ( .A(add_29_carry[2]), .B(n5), .CO(add_29_carry[3]), .S(N19) );
  ADDHX1M U41 ( .A(add_29_carry[3]), .B(n7), .CO(add_29_carry[4]), .S(N20) );
  ADDHX1M U42 ( .A(Counter[1]), .B(n13), .CO(add_29_carry[2]), .S(N18) );
  ADDHX1M U43 ( .A(add_29_carry[4]), .B(n11), .CO(add_29_carry[5]), .S(N21) );
  CLKINVX12M U44 ( .A(n57), .Y(n54) );
  NOR2X8M U45 ( .A(n53), .B(n34), .Y(n33) );
  INVX4M U46 ( .A(n53), .Y(n67) );
  INVX2M U48 ( .A(i_rst_n), .Y(n57) );
  OR2X2M U50 ( .A(n54), .B(n69), .Y(n30) );
  OR2X2M U51 ( .A(n54), .B(n70), .Y(n31) );
  OR2X2M U52 ( .A(n54), .B(n71), .Y(n44) );
  OR2X2M U53 ( .A(n54), .B(n72), .Y(n45) );
  CLKBUFX8M U54 ( .A(n32), .Y(n53) );
  NOR2BX1M U55 ( .AN(N4), .B(N1), .Y(n32) );
  INVX2M U56 ( .A(n35), .Y(n68) );
  AO22X1M U57 ( .A0(N11), .A1(n53), .B0(Duty[1]), .B1(n67), .Y(n49) );
  AO22X1M U58 ( .A0(N10), .A1(n53), .B0(n2), .B1(n67), .Y(n52) );
  AO22X1M U59 ( .A0(N13), .A1(n53), .B0(Duty[3]), .B1(n67), .Y(n43) );
  AO22X1M U60 ( .A0(N12), .A1(n53), .B0(Duty[2]), .B1(n67), .Y(n46) );
  CLKXOR2X2M U61 ( .A(n53), .B(out_seq), .Y(n37) );
  AO22X1M U62 ( .A0(Counter[1]), .A1(n33), .B0(N18), .B1(n34), .Y(n41) );
  AO22X1M U63 ( .A0(n82), .A1(n33), .B0(N19), .B1(n34), .Y(n40) );
  AO22X1M U64 ( .A0(n83), .A1(n33), .B0(N20), .B1(n34), .Y(n39) );
  AO22X1M U65 ( .A0(n81), .A1(n33), .B0(N21), .B1(n34), .Y(n38) );
  AO22X1M U66 ( .A0(n33), .A1(n84), .B0(N22), .B1(n34), .Y(n56) );
  NAND2X4M U67 ( .A(i_clk_en), .B(n36), .Y(N1) );
  NAND4X2M U68 ( .A(n72), .B(n71), .C(n70), .D(n69), .Y(n36) );
  INVX2M U69 ( .A(i_div_ratio[1]), .Y(n72) );
  INVX2M U70 ( .A(i_div_ratio[2]), .Y(n71) );
  INVX2M U71 ( .A(i_div_ratio[4]), .Y(n69) );
  INVX2M U72 ( .A(i_div_ratio[3]), .Y(n70) );
  OR2X2M U73 ( .A(n54), .B(i_div_ratio[4]), .Y(n47) );
  OR2X2M U74 ( .A(n54), .B(i_div_ratio[3]), .Y(n48) );
  OR2X2M U75 ( .A(n54), .B(i_div_ratio[2]), .Y(n50) );
  OR2X2M U76 ( .A(n54), .B(i_div_ratio[1]), .Y(n51) );
  MX2XLM U77 ( .A(test_so), .B(i_ref_clk), .S0(N1), .Y(o_div_clk) );
  CLKXOR2X2M U79 ( .A(add_29_carry[5]), .B(n9), .Y(N22) );
  NAND3X1M U80 ( .A(n62), .B(n61), .C(n60), .Y(n66) );
  CLKXOR2X2M U81 ( .A(Duty[2]), .B(n5), .Y(n64) );
  CLKXOR2X2M U82 ( .A(Duty[3]), .B(n7), .Y(n63) );
  DLY1X1M U83 ( .A(Duty[5]), .Y(n79) );
  DLY1X1M U84 ( .A(Duty[4]), .Y(n80) );
  DLY1X1M U85 ( .A(n11), .Y(n81) );
  DLY1X1M U86 ( .A(n5), .Y(n82) );
  DLY1X1M U87 ( .A(n7), .Y(n83) );
  DLY1X1M U88 ( .A(n9), .Y(n84) );
  DLY1X1M U89 ( .A(out_seq), .Y(test_so) );
  OR2X2M sub_25_U7 ( .A(i_div_ratio[0]), .B(sub_25_n2), .Y(sub_25_carry[1]) );
  CLKXOR2X2M sub_25_U4 ( .A(sub_25_n1), .B(sub_25_carry[5]), .Y(N15) );
  XNOR2X2M sub_25_U3 ( .A(sub_25_n2), .B(i_div_ratio[0]), .Y(N10) );
  ADDFX2M sub_25_U2_1 ( .A(i_div_ratio[1]), .B(sub_25_n3), .CI(sub_25_carry[1]), .CO(sub_25_carry[2]), .S(N11) );
  ADDFX2M sub_25_U2_2 ( .A(i_div_ratio[2]), .B(sub_25_n4), .CI(sub_25_carry[2]), .CO(sub_25_carry[3]), .S(N12) );
  ADDFX2M sub_25_U2_3 ( .A(i_div_ratio[3]), .B(sub_25_n5), .CI(sub_25_carry[3]), .CO(sub_25_carry[4]), .S(N13) );
  ADDFX2M sub_25_U2_4 ( .A(i_div_ratio[4]), .B(sub_25_n6), .CI(sub_25_carry[4]), .CO(sub_25_carry[5]), .S(N14) );
  SDFFSX1M Counter_reg_0_ ( .D(n68), .SI(test_si), .SE(test_se), .CK(i_ref_clk), .SN(i_rst_n), .Q(Counter[0]), .QN(N17) );
  SDFFRX1M Duty_reg_5_ ( .D(n55), .SI(n80), .SE(test_se), .CK(i_ref_clk), .RN(
        n54), .Q(Duty[5]), .QN(sub_25_n1) );
  SDFFRX1M Duty_reg_4_ ( .D(n42), .SI(sub_25_n5), .SE(test_se), .CK(i_ref_clk), 
        .RN(n54), .Q(Duty[4]), .QN(sub_25_n6) );
  SDFFRX1M Counter_reg_4_ ( .D(n38), .SI(n83), .SE(test_se), .CK(i_ref_clk), 
        .RN(n54), .Q(Counter[4]) );
  SDFFRX1M Counter_reg_3_ ( .D(n39), .SI(n82), .SE(test_se), .CK(i_ref_clk), 
        .RN(n54), .Q(Counter[3]) );
  SDFFRX1M Counter_reg_2_ ( .D(n40), .SI(Counter[1]), .SE(test_se), .CK(
        i_ref_clk), .RN(n54), .Q(Counter[2]) );
  SDFFRX1M Counter_reg_5_ ( .D(n56), .SI(n81), .SE(test_se), .CK(i_ref_clk), 
        .RN(n54), .Q(Counter[5]) );
  SDFFSRX1M Duty_reg_0_ ( .D(n52), .SI(n84), .SE(test_se), .CK(i_ref_clk), 
        .SN(n45), .RN(n51), .Q(n3), .QN(sub_25_n2) );
  INVXLM U3 ( .A(n3), .Y(n1) );
  INVX4M U4 ( .A(n1), .Y(n2) );
  INVXLM U5 ( .A(Counter[2]), .Y(n4) );
  INVX2M U7 ( .A(n4), .Y(n5) );
  INVXLM U8 ( .A(Counter[3]), .Y(n6) );
  INVX2M U10 ( .A(n6), .Y(n7) );
  INVXLM U11 ( .A(Counter[5]), .Y(n8) );
  INVX2M U12 ( .A(n8), .Y(n9) );
  INVXLM U14 ( .A(Counter[4]), .Y(n10) );
  INVX2M U17 ( .A(n10), .Y(n11) );
  INVXLM U19 ( .A(Counter[0]), .Y(n12) );
  INVX4M U20 ( .A(n12), .Y(n13) );
endmodule


module CLK_Gate ( Enable, CLK, Gated_CLK );
  input Enable, CLK;
  output Gated_CLK;
  wire   enable_latch;

  TLATNX1M enable_latch_reg ( .D(Enable), .GN(CLK), .Q(enable_latch) );
  AND2X1M U2 ( .A(enable_latch), .B(CLK), .Y(Gated_CLK) );
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

  OR3X2M U3 ( .A(n4), .B(ALU_FUN[1]), .C(n2), .Y(n5) );
  INVX4M U4 ( .A(n5), .Y(Logic_Enable[0]) );
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
  OR2X2M U3 ( .A(ALU_FUN[0]), .B(ALU_FUN[1]), .Y(n5) );
  OR2X2M U4 ( .A(n45), .B(ALU_FUN[1]), .Y(n6) );
  INVX6M U5 ( .A(n6), .Y(n38) );
  INVX6M U6 ( .A(n6), .Y(n7) );
  INVX6M U7 ( .A(n5), .Y(n40) );
  INVX6M U8 ( .A(n5), .Y(n39) );
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
  NAND2X2M U26 ( .A(n8), .B(n9), .Y(ALU_OUT[8]) );
  AOI22X1M U27 ( .A0(Shift_OUT[8]), .A1(n41), .B0(CMP_OUT[8]), .B1(n43), .Y(n9) );
  AOI22X1M U28 ( .A0(Logic_OUT[8]), .A1(n7), .B0(Arith_OUT[8]), .B1(n39), .Y(
        n8) );
  NAND2X2M U29 ( .A(n2), .B(n3), .Y(ALU_OUT[9]) );
  AOI22X1M U30 ( .A0(Shift_OUT[9]), .A1(n42), .B0(CMP_OUT[9]), .B1(n44), .Y(n3) );
  AOI22X1M U31 ( .A0(Logic_OUT[9]), .A1(n38), .B0(Arith_OUT[9]), .B1(n40), .Y(
        n2) );
  NAND2X2M U32 ( .A(n34), .B(n35), .Y(ALU_OUT[10]) );
  AOI22X1M U33 ( .A0(Shift_OUT[10]), .A1(n42), .B0(CMP_OUT[10]), .B1(n44), .Y(
        n35) );
  AOI22X1M U34 ( .A0(Logic_OUT[10]), .A1(n38), .B0(Arith_OUT[10]), .B1(n40), 
        .Y(n34) );
  NAND2X2M U35 ( .A(n32), .B(n33), .Y(ALU_OUT[11]) );
  AOI22X1M U36 ( .A0(Shift_OUT[11]), .A1(n41), .B0(CMP_OUT[11]), .B1(n43), .Y(
        n33) );
  AOI22X1M U37 ( .A0(Logic_OUT[11]), .A1(n7), .B0(Arith_OUT[11]), .B1(n39), 
        .Y(n32) );
  NAND2X2M U38 ( .A(n30), .B(n31), .Y(ALU_OUT[12]) );
  AOI22X1M U39 ( .A0(Shift_OUT[12]), .A1(n42), .B0(CMP_OUT[12]), .B1(n44), .Y(
        n31) );
  AOI22X1M U40 ( .A0(Logic_OUT[12]), .A1(n38), .B0(Arith_OUT[12]), .B1(n40), 
        .Y(n30) );
  NAND2X2M U41 ( .A(n28), .B(n29), .Y(ALU_OUT[13]) );
  AOI22X1M U42 ( .A0(Shift_OUT[13]), .A1(n41), .B0(CMP_OUT[13]), .B1(n43), .Y(
        n29) );
  AOI22X1M U43 ( .A0(Logic_OUT[13]), .A1(n7), .B0(Arith_OUT[13]), .B1(n39), 
        .Y(n28) );
  NAND2X2M U44 ( .A(n26), .B(n27), .Y(ALU_OUT[14]) );
  AOI22X1M U45 ( .A0(Shift_OUT[14]), .A1(n42), .B0(CMP_OUT[14]), .B1(n44), .Y(
        n27) );
  AOI22X1M U46 ( .A0(Logic_OUT[14]), .A1(n38), .B0(Arith_OUT[14]), .B1(n40), 
        .Y(n26) );
  NAND2X2M U47 ( .A(n24), .B(n25), .Y(ALU_OUT[15]) );
  AOI22X1M U48 ( .A0(Shift_OUT[15]), .A1(n41), .B0(CMP_OUT[15]), .B1(n43), .Y(
        n25) );
  AOI22X1M U49 ( .A0(Logic_OUT[15]), .A1(n7), .B0(Arith_OUT[15]), .B1(n39), 
        .Y(n24) );
  NAND2X2M U50 ( .A(n16), .B(n17), .Y(ALU_OUT[4]) );
  AOI22X1M U51 ( .A0(Shift_OUT[4]), .A1(n41), .B0(CMP_OUT[4]), .B1(n43), .Y(
        n17) );
  AOI22X1M U52 ( .A0(Logic_OUT[4]), .A1(n7), .B0(Arith_OUT[4]), .B1(n39), .Y(
        n16) );
  NAND2X2M U53 ( .A(n14), .B(n15), .Y(ALU_OUT[5]) );
  AOI22X1M U54 ( .A0(Shift_OUT[5]), .A1(n42), .B0(CMP_OUT[5]), .B1(n44), .Y(
        n15) );
  AOI22X1M U55 ( .A0(Logic_OUT[5]), .A1(n38), .B0(Arith_OUT[5]), .B1(n40), .Y(
        n14) );
  NAND2X2M U56 ( .A(n12), .B(n13), .Y(ALU_OUT[6]) );
  AOI22X1M U57 ( .A0(Shift_OUT[6]), .A1(n41), .B0(CMP_OUT[6]), .B1(n43), .Y(
        n13) );
  AOI22X1M U58 ( .A0(Logic_OUT[6]), .A1(n7), .B0(Arith_OUT[6]), .B1(n39), .Y(
        n12) );
  NAND2X2M U59 ( .A(n10), .B(n11), .Y(ALU_OUT[7]) );
  AOI22X1M U60 ( .A0(Shift_OUT[7]), .A1(n42), .B0(CMP_OUT[7]), .B1(n44), .Y(
        n11) );
  AOI22X1M U61 ( .A0(Logic_OUT[7]), .A1(n38), .B0(Arith_OUT[7]), .B1(n40), .Y(
        n10) );
endmodule


module Arithmatic_Unit_Width16_DW_div_uns_0 ( a, b, quotient, remainder, 
        divide_by_0 );
  input [7:0] a;
  input [7:0] b;
  output [7:0] quotient;
  output [7:0] remainder;
  output divide_by_0;
  wire   n15, u_div_SumTmp_1__0_, u_div_SumTmp_1__1_, u_div_SumTmp_1__2_,
         u_div_SumTmp_1__3_, u_div_SumTmp_1__4_, u_div_SumTmp_1__5_,
         u_div_SumTmp_1__6_, u_div_SumTmp_2__0_, u_div_SumTmp_2__1_,
         u_div_SumTmp_2__2_, u_div_SumTmp_2__3_, u_div_SumTmp_2__4_,
         u_div_SumTmp_2__5_, u_div_SumTmp_3__0_, u_div_SumTmp_3__1_,
         u_div_SumTmp_3__2_, u_div_SumTmp_3__3_, u_div_SumTmp_3__4_,
         u_div_SumTmp_4__0_, u_div_SumTmp_4__1_, u_div_SumTmp_4__2_,
         u_div_SumTmp_4__3_, u_div_SumTmp_5__0_, u_div_SumTmp_5__1_,
         u_div_SumTmp_5__2_, u_div_SumTmp_6__0_, u_div_SumTmp_6__1_,
         u_div_SumTmp_7__0_, u_div_CryTmp_0__1_, u_div_CryTmp_0__2_,
         u_div_CryTmp_0__3_, u_div_CryTmp_0__4_, u_div_CryTmp_0__5_,
         u_div_CryTmp_0__6_, u_div_CryTmp_0__7_, u_div_CryTmp_1__1_,
         u_div_CryTmp_1__2_, u_div_CryTmp_1__3_, u_div_CryTmp_1__4_,
         u_div_CryTmp_1__5_, u_div_CryTmp_1__6_, u_div_CryTmp_1__7_,
         u_div_CryTmp_2__1_, u_div_CryTmp_2__2_, u_div_CryTmp_2__3_,
         u_div_CryTmp_2__4_, u_div_CryTmp_2__5_, u_div_CryTmp_2__6_,
         u_div_CryTmp_3__1_, u_div_CryTmp_3__2_, u_div_CryTmp_3__3_,
         u_div_CryTmp_3__4_, u_div_CryTmp_3__5_, u_div_CryTmp_4__1_,
         u_div_CryTmp_4__2_, u_div_CryTmp_4__3_, u_div_CryTmp_4__4_,
         u_div_CryTmp_5__1_, u_div_CryTmp_5__2_, u_div_CryTmp_5__3_,
         u_div_CryTmp_6__1_, u_div_CryTmp_6__2_, u_div_CryTmp_7__1_,
         u_div_PartRem_1__1_, u_div_PartRem_1__2_, u_div_PartRem_1__3_,
         u_div_PartRem_1__4_, u_div_PartRem_1__5_, u_div_PartRem_1__6_,
         u_div_PartRem_1__7_, u_div_PartRem_2__1_, u_div_PartRem_2__2_,
         u_div_PartRem_2__3_, u_div_PartRem_2__4_, u_div_PartRem_2__5_,
         u_div_PartRem_2__6_, u_div_PartRem_3__1_, u_div_PartRem_3__2_,
         u_div_PartRem_3__3_, u_div_PartRem_3__4_, u_div_PartRem_3__5_,
         u_div_PartRem_4__1_, u_div_PartRem_4__2_, u_div_PartRem_4__3_,
         u_div_PartRem_4__4_, u_div_PartRem_5__1_, u_div_PartRem_5__2_,
         u_div_PartRem_5__3_, u_div_PartRem_6__1_, u_div_PartRem_6__2_,
         u_div_PartRem_7__1_, n1, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12,
         n13, n14;

  ADDFX2M u_div_u_fa_PartRem_0_6_1 ( .A(u_div_PartRem_7__1_), .B(n10), .CI(
        u_div_CryTmp_6__1_), .CO(u_div_CryTmp_6__2_), .S(u_div_SumTmp_6__1_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_0_1 ( .A(u_div_PartRem_1__1_), .B(n10), .CI(
        u_div_CryTmp_0__1_), .CO(u_div_CryTmp_0__2_) );
  ADDFX2M u_div_u_fa_PartRem_0_1_1 ( .A(u_div_PartRem_2__1_), .B(n10), .CI(
        u_div_CryTmp_1__1_), .CO(u_div_CryTmp_1__2_), .S(u_div_SumTmp_1__1_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_2_1 ( .A(u_div_PartRem_3__1_), .B(n10), .CI(
        u_div_CryTmp_2__1_), .CO(u_div_CryTmp_2__2_), .S(u_div_SumTmp_2__1_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_3_1 ( .A(u_div_PartRem_4__1_), .B(n10), .CI(
        u_div_CryTmp_3__1_), .CO(u_div_CryTmp_3__2_), .S(u_div_SumTmp_3__1_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_4_1 ( .A(u_div_PartRem_5__1_), .B(n10), .CI(
        u_div_CryTmp_4__1_), .CO(u_div_CryTmp_4__2_), .S(u_div_SumTmp_4__1_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_5_1 ( .A(u_div_PartRem_6__1_), .B(n10), .CI(
        u_div_CryTmp_5__1_), .CO(u_div_CryTmp_5__2_), .S(u_div_SumTmp_5__1_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_1_6 ( .A(u_div_PartRem_2__6_), .B(n5), .CI(
        u_div_CryTmp_1__6_), .CO(u_div_CryTmp_1__7_), .S(u_div_SumTmp_1__6_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_2_5 ( .A(u_div_PartRem_3__5_), .B(n6), .CI(
        u_div_CryTmp_2__5_), .CO(u_div_CryTmp_2__6_), .S(u_div_SumTmp_2__5_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_4_3 ( .A(u_div_PartRem_5__3_), .B(n8), .CI(
        u_div_CryTmp_4__3_), .CO(u_div_CryTmp_4__4_), .S(u_div_SumTmp_4__3_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_5_2 ( .A(u_div_PartRem_6__2_), .B(n9), .CI(
        u_div_CryTmp_5__2_), .CO(u_div_CryTmp_5__3_), .S(u_div_SumTmp_5__2_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_0_6 ( .A(u_div_PartRem_1__6_), .B(n5), .CI(
        u_div_CryTmp_0__6_), .CO(u_div_CryTmp_0__7_) );
  ADDFX2M u_div_u_fa_PartRem_0_0_7 ( .A(u_div_PartRem_1__7_), .B(n4), .CI(
        u_div_CryTmp_0__7_), .CO(quotient[0]) );
  ADDFX2M u_div_u_fa_PartRem_0_0_4 ( .A(u_div_PartRem_1__4_), .B(n7), .CI(
        u_div_CryTmp_0__4_), .CO(u_div_CryTmp_0__5_) );
  ADDFX2M u_div_u_fa_PartRem_0_0_5 ( .A(u_div_PartRem_1__5_), .B(n6), .CI(
        u_div_CryTmp_0__5_), .CO(u_div_CryTmp_0__6_) );
  ADDFX2M u_div_u_fa_PartRem_0_1_5 ( .A(u_div_PartRem_2__5_), .B(n6), .CI(
        u_div_CryTmp_1__5_), .CO(u_div_CryTmp_1__6_), .S(u_div_SumTmp_1__5_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_1_4 ( .A(u_div_PartRem_2__4_), .B(n7), .CI(
        u_div_CryTmp_1__4_), .CO(u_div_CryTmp_1__5_), .S(u_div_SumTmp_1__4_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_2_4 ( .A(u_div_PartRem_3__4_), .B(n7), .CI(
        u_div_CryTmp_2__4_), .CO(u_div_CryTmp_2__5_), .S(u_div_SumTmp_2__4_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_0_2 ( .A(u_div_PartRem_1__2_), .B(n9), .CI(
        u_div_CryTmp_0__2_), .CO(u_div_CryTmp_0__3_) );
  ADDFX2M u_div_u_fa_PartRem_0_0_3 ( .A(u_div_PartRem_1__3_), .B(n8), .CI(
        u_div_CryTmp_0__3_), .CO(u_div_CryTmp_0__4_) );
  ADDFX2M u_div_u_fa_PartRem_0_1_3 ( .A(u_div_PartRem_2__3_), .B(n8), .CI(
        u_div_CryTmp_1__3_), .CO(u_div_CryTmp_1__4_), .S(u_div_SumTmp_1__3_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_2_3 ( .A(u_div_PartRem_3__3_), .B(n8), .CI(
        u_div_CryTmp_2__3_), .CO(u_div_CryTmp_2__4_), .S(u_div_SumTmp_2__3_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_3_3 ( .A(u_div_PartRem_4__3_), .B(n8), .CI(
        u_div_CryTmp_3__3_), .CO(u_div_CryTmp_3__4_), .S(u_div_SumTmp_3__3_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_1_2 ( .A(u_div_PartRem_2__2_), .B(n9), .CI(
        u_div_CryTmp_1__2_), .CO(u_div_CryTmp_1__3_), .S(u_div_SumTmp_1__2_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_2_2 ( .A(u_div_PartRem_3__2_), .B(n9), .CI(
        u_div_CryTmp_2__2_), .CO(u_div_CryTmp_2__3_), .S(u_div_SumTmp_2__2_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_3_2 ( .A(u_div_PartRem_4__2_), .B(n9), .CI(
        u_div_CryTmp_3__2_), .CO(u_div_CryTmp_3__3_), .S(u_div_SumTmp_3__2_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_4_2 ( .A(u_div_PartRem_5__2_), .B(n9), .CI(
        u_div_CryTmp_4__2_), .CO(u_div_CryTmp_4__3_), .S(u_div_SumTmp_4__2_)
         );
  ADDFX2M u_div_u_fa_PartRem_0_3_4 ( .A(u_div_PartRem_4__4_), .B(n7), .CI(
        u_div_CryTmp_3__4_), .CO(u_div_CryTmp_3__5_), .S(u_div_SumTmp_3__4_)
         );
  AND2X2M U1 ( .A(u_div_CryTmp_2__6_), .B(n14), .Y(n15) );
  INVX4M U2 ( .A(b[5]), .Y(n6) );
  INVX6M U3 ( .A(b[1]), .Y(n10) );
  INVX6M U4 ( .A(b[2]), .Y(n9) );
  CLKINVX12M U5 ( .A(b[0]), .Y(n11) );
  MX2X1M U6 ( .A(a[5]), .B(u_div_SumTmp_5__0_), .S0(quotient[5]), .Y(
        u_div_PartRem_5__1_) );
  MX2X1M U7 ( .A(a[4]), .B(u_div_SumTmp_4__0_), .S0(quotient[4]), .Y(
        u_div_PartRem_4__1_) );
  MX2X1M U8 ( .A(a[2]), .B(u_div_SumTmp_2__0_), .S0(n15), .Y(
        u_div_PartRem_2__1_) );
  AND2X2M U9 ( .A(u_div_CryTmp_2__6_), .B(n14), .Y(quotient[2]) );
  MX2X1M U10 ( .A(a[7]), .B(u_div_SumTmp_7__0_), .S0(quotient[7]), .Y(
        u_div_PartRem_7__1_) );
  MX2X1M U11 ( .A(a[6]), .B(u_div_SumTmp_6__0_), .S0(quotient[6]), .Y(
        u_div_PartRem_6__1_) );
  CLKAND2X4M U12 ( .A(u_div_CryTmp_4__4_), .B(n13), .Y(quotient[4]) );
  CLKAND2X4M U13 ( .A(u_div_CryTmp_5__3_), .B(n12), .Y(quotient[5]) );
  MX2X2M U14 ( .A(u_div_PartRem_4__2_), .B(u_div_SumTmp_3__2_), .S0(
        quotient[3]), .Y(u_div_PartRem_3__3_) );
  MX2X2M U15 ( .A(u_div_PartRem_4__3_), .B(u_div_SumTmp_3__3_), .S0(
        quotient[3]), .Y(u_div_PartRem_3__4_) );
  AND3X2M U16 ( .A(n12), .B(n9), .C(u_div_CryTmp_6__2_), .Y(quotient[6]) );
  CLKAND2X6M U17 ( .A(u_div_CryTmp_1__7_), .B(n4), .Y(quotient[1]) );
  AND2X2M U18 ( .A(n13), .B(n8), .Y(n12) );
  NOR2X6M U19 ( .A(b[6]), .B(b[7]), .Y(n14) );
  INVX4M U20 ( .A(b[3]), .Y(n8) );
  INVX4M U21 ( .A(b[4]), .Y(n7) );
  MX2X1M U22 ( .A(u_div_PartRem_3__2_), .B(u_div_SumTmp_2__2_), .S0(
        quotient[2]), .Y(u_div_PartRem_2__3_) );
  MX2X1M U23 ( .A(u_div_PartRem_5__2_), .B(u_div_SumTmp_4__2_), .S0(
        quotient[4]), .Y(u_div_PartRem_4__3_) );
  MX2X1M U24 ( .A(u_div_PartRem_6__2_), .B(u_div_SumTmp_5__2_), .S0(
        quotient[5]), .Y(u_div_PartRem_5__3_) );
  MX2X1M U25 ( .A(u_div_PartRem_3__5_), .B(u_div_SumTmp_2__5_), .S0(n3), .Y(
        u_div_PartRem_2__6_) );
  MX2X1M U26 ( .A(u_div_PartRem_3__4_), .B(u_div_SumTmp_2__4_), .S0(
        quotient[2]), .Y(u_div_PartRem_2__5_) );
  MX2X1M U27 ( .A(u_div_PartRem_5__3_), .B(u_div_SumTmp_4__3_), .S0(
        quotient[4]), .Y(u_div_PartRem_4__4_) );
  MX2X1M U28 ( .A(u_div_PartRem_5__1_), .B(u_div_SumTmp_4__1_), .S0(
        quotient[4]), .Y(u_div_PartRem_4__2_) );
  MX2X1M U29 ( .A(u_div_PartRem_6__1_), .B(u_div_SumTmp_5__1_), .S0(
        quotient[5]), .Y(u_div_PartRem_5__2_) );
  MX2X1M U30 ( .A(u_div_PartRem_7__1_), .B(u_div_SumTmp_6__1_), .S0(
        quotient[6]), .Y(u_div_PartRem_6__2_) );
  MX2X1M U31 ( .A(u_div_PartRem_4__1_), .B(u_div_SumTmp_3__1_), .S0(
        quotient[3]), .Y(u_div_PartRem_3__2_) );
  CLKAND2X4M U32 ( .A(u_div_CryTmp_3__5_), .B(n1), .Y(quotient[3]) );
  INVX1M U33 ( .A(b[6]), .Y(n5) );
  AND2X1M U34 ( .A(n6), .B(n14), .Y(n1) );
  MX2X1M U35 ( .A(u_div_PartRem_4__4_), .B(u_div_SumTmp_3__4_), .S0(
        quotient[3]), .Y(u_div_PartRem_3__5_) );
  MX2X1M U36 ( .A(a[3]), .B(u_div_SumTmp_3__0_), .S0(quotient[3]), .Y(
        u_div_PartRem_3__1_) );
  AND2X1M U37 ( .A(u_div_CryTmp_2__6_), .B(n14), .Y(n3) );
  MX2XLM U38 ( .A(a[1]), .B(u_div_SumTmp_1__0_), .S0(quotient[1]), .Y(
        u_div_PartRem_1__1_) );
  MX2XLM U39 ( .A(u_div_PartRem_2__1_), .B(u_div_SumTmp_1__1_), .S0(
        quotient[1]), .Y(u_div_PartRem_1__2_) );
  MX2XLM U40 ( .A(u_div_PartRem_2__2_), .B(u_div_SumTmp_1__2_), .S0(
        quotient[1]), .Y(u_div_PartRem_1__3_) );
  MX2XLM U41 ( .A(u_div_PartRem_2__3_), .B(u_div_SumTmp_1__3_), .S0(
        quotient[1]), .Y(u_div_PartRem_1__4_) );
  MX2XLM U42 ( .A(u_div_PartRem_2__4_), .B(u_div_SumTmp_1__4_), .S0(
        quotient[1]), .Y(u_div_PartRem_1__5_) );
  MX2XLM U43 ( .A(u_div_PartRem_2__5_), .B(u_div_SumTmp_1__5_), .S0(
        quotient[1]), .Y(u_div_PartRem_1__6_) );
  OR2X1M U44 ( .A(a[7]), .B(n11), .Y(u_div_CryTmp_7__1_) );
  XNOR2X1M U45 ( .A(n11), .B(a[2]), .Y(u_div_SumTmp_2__0_) );
  XNOR2X1M U46 ( .A(n11), .B(a[3]), .Y(u_div_SumTmp_3__0_) );
  XNOR2X1M U47 ( .A(n11), .B(a[4]), .Y(u_div_SumTmp_4__0_) );
  XNOR2X1M U48 ( .A(n11), .B(a[5]), .Y(u_div_SumTmp_5__0_) );
  XNOR2X1M U49 ( .A(n11), .B(a[6]), .Y(u_div_SumTmp_6__0_) );
  XNOR2X1M U50 ( .A(n11), .B(a[7]), .Y(u_div_SumTmp_7__0_) );
  OR2X1M U51 ( .A(a[5]), .B(n11), .Y(u_div_CryTmp_5__1_) );
  OR2X1M U52 ( .A(a[4]), .B(n11), .Y(u_div_CryTmp_4__1_) );
  OR2X1M U53 ( .A(a[3]), .B(n11), .Y(u_div_CryTmp_3__1_) );
  OR2X1M U54 ( .A(a[2]), .B(n11), .Y(u_div_CryTmp_2__1_) );
  OR2X1M U55 ( .A(a[1]), .B(n11), .Y(u_div_CryTmp_1__1_) );
  OR2X1M U56 ( .A(a[0]), .B(n11), .Y(u_div_CryTmp_0__1_) );
  XNOR2X1M U57 ( .A(n11), .B(a[1]), .Y(u_div_SumTmp_1__0_) );
  OR2X1M U58 ( .A(a[6]), .B(n11), .Y(u_div_CryTmp_6__1_) );
  INVX1M U59 ( .A(b[7]), .Y(n4) );
  CLKMX2X2M U60 ( .A(u_div_PartRem_2__6_), .B(u_div_SumTmp_1__6_), .S0(
        quotient[1]), .Y(u_div_PartRem_1__7_) );
  CLKMX2X2M U61 ( .A(u_div_PartRem_3__3_), .B(u_div_SumTmp_2__3_), .S0(n3), 
        .Y(u_div_PartRem_2__4_) );
  CLKMX2X2M U62 ( .A(u_div_PartRem_3__1_), .B(u_div_SumTmp_2__1_), .S0(n15), 
        .Y(u_div_PartRem_2__2_) );
  AND4X1M U63 ( .A(u_div_CryTmp_7__1_), .B(n12), .C(n10), .D(n9), .Y(
        quotient[7]) );
  AND3X1M U64 ( .A(n14), .B(n7), .C(n6), .Y(n13) );
endmodule


module Arithmatic_Unit_Width16_DW01_sub_0 ( A, B, CI, DIFF, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] DIFF;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8;
  wire   [8:1] carry;

  ADDFX2M U2_5 ( .A(A[5]), .B(n3), .CI(carry[5]), .CO(carry[6]), .S(DIFF[5])
         );
  ADDFX2M U2_3 ( .A(A[3]), .B(n5), .CI(carry[3]), .CO(carry[4]), .S(DIFF[3])
         );
  ADDFX2M U2_6 ( .A(A[6]), .B(n2), .CI(carry[6]), .CO(carry[7]), .S(DIFF[6])
         );
  ADDFX2M U2_7 ( .A(A[7]), .B(n1), .CI(carry[7]), .CO(carry[8]), .S(DIFF[7])
         );
  ADDFX2M U2_4 ( .A(A[4]), .B(n4), .CI(carry[4]), .CO(carry[5]), .S(DIFF[4])
         );
  ADDFX2M U2_2 ( .A(A[2]), .B(n6), .CI(carry[2]), .CO(carry[3]), .S(DIFF[2])
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

  wire   [7:1] carry;

  ADDFX2M U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(SUM[8]), .S(SUM[7]) );
  ADDFX2M U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFX2M U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFX2M U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFX2M U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFX2M U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
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
  wire   ab_7__7_, ab_7__6_, ab_7__5_, ab_7__4_, ab_7__3_, ab_7__2_, ab_7__1_,
         ab_7__0_, ab_6__7_, ab_6__6_, ab_6__5_, ab_6__4_, ab_6__3_, ab_6__2_,
         ab_6__1_, ab_6__0_, ab_5__7_, ab_5__6_, ab_5__5_, ab_5__4_, ab_5__3_,
         ab_5__2_, ab_5__1_, ab_5__0_, ab_4__7_, ab_4__6_, ab_4__5_, ab_4__4_,
         ab_4__3_, ab_4__2_, ab_4__1_, ab_4__0_, ab_3__7_, ab_3__6_, ab_3__5_,
         ab_3__4_, ab_3__3_, ab_3__2_, ab_3__1_, ab_3__0_, ab_2__7_, ab_2__6_,
         ab_2__5_, ab_2__4_, ab_2__3_, ab_2__2_, ab_2__1_, ab_2__0_, ab_1__7_,
         ab_1__6_, ab_1__5_, ab_1__4_, ab_1__3_, ab_1__2_, ab_1__1_, ab_1__0_,
         ab_0__7_, ab_0__6_, ab_0__5_, ab_0__4_, ab_0__3_, ab_0__2_, ab_0__1_,
         CARRYB_7__6_, CARRYB_7__5_, CARRYB_7__4_, CARRYB_7__3_, CARRYB_7__2_,
         CARRYB_7__1_, CARRYB_7__0_, CARRYB_6__6_, CARRYB_6__5_, CARRYB_6__4_,
         CARRYB_6__3_, CARRYB_6__2_, CARRYB_6__1_, CARRYB_6__0_, CARRYB_5__6_,
         CARRYB_5__5_, CARRYB_5__4_, CARRYB_5__3_, CARRYB_5__2_, CARRYB_5__1_,
         CARRYB_5__0_, CARRYB_4__6_, CARRYB_4__5_, CARRYB_4__4_, CARRYB_4__3_,
         CARRYB_4__2_, CARRYB_4__1_, CARRYB_4__0_, CARRYB_3__6_, CARRYB_3__5_,
         CARRYB_3__4_, CARRYB_3__3_, CARRYB_3__2_, CARRYB_3__1_, CARRYB_3__0_,
         CARRYB_2__6_, CARRYB_2__5_, CARRYB_2__4_, CARRYB_2__3_, CARRYB_2__2_,
         CARRYB_2__1_, CARRYB_2__0_, CARRYB_1__6_, CARRYB_1__5_, CARRYB_1__4_,
         CARRYB_1__3_, CARRYB_1__2_, CARRYB_1__1_, CARRYB_1__0_, SUMB_7__6_,
         SUMB_7__5_, SUMB_7__4_, SUMB_7__3_, SUMB_7__2_, SUMB_7__1_,
         SUMB_7__0_, SUMB_6__6_, SUMB_6__5_, SUMB_6__4_, SUMB_6__3_,
         SUMB_6__2_, SUMB_6__1_, SUMB_5__6_, SUMB_5__5_, SUMB_5__4_,
         SUMB_5__3_, SUMB_5__2_, SUMB_5__1_, SUMB_4__6_, SUMB_4__5_,
         SUMB_4__4_, SUMB_4__3_, SUMB_4__2_, SUMB_4__1_, SUMB_3__6_,
         SUMB_3__5_, SUMB_3__4_, SUMB_3__3_, SUMB_3__2_, SUMB_3__1_,
         SUMB_2__6_, SUMB_2__5_, SUMB_2__4_, SUMB_2__3_, SUMB_2__2_,
         SUMB_2__1_, SUMB_1__6_, SUMB_1__5_, SUMB_1__4_, SUMB_1__3_,
         SUMB_1__2_, SUMB_1__1_, A1_12_, A1_11_, A1_10_, A1_9_, A1_8_, A1_7_,
         A1_6_, A1_4_, A1_3_, A1_2_, A1_1_, A1_0_, A2_13_, A2_12_, A2_11_,
         A2_10_, A2_9_, A2_8_, A2_7_, n3, n4, n5, n6, n7, n8, n9, n10, n11,
         n12, n13, n14, n15, n16, n17, n18;

  ADDFX2M S5_6 ( .A(ab_7__6_), .B(CARRYB_6__6_), .CI(ab_6__7_), .CO(
        CARRYB_7__6_), .S(SUMB_7__6_) );
  ADDFX2M S1_5_0 ( .A(ab_5__0_), .B(CARRYB_4__0_), .CI(SUMB_4__1_), .CO(
        CARRYB_5__0_), .S(A1_3_) );
  ADDFX2M S1_4_0 ( .A(ab_4__0_), .B(CARRYB_3__0_), .CI(SUMB_3__1_), .CO(
        CARRYB_4__0_), .S(A1_2_) );
  ADDFX2M S1_3_0 ( .A(ab_3__0_), .B(CARRYB_2__0_), .CI(SUMB_2__1_), .CO(
        CARRYB_3__0_), .S(A1_1_) );
  ADDFX2M S1_2_0 ( .A(ab_2__0_), .B(CARRYB_1__0_), .CI(SUMB_1__1_), .CO(
        CARRYB_2__0_), .S(A1_0_) );
  ADDFX2M S3_6_6 ( .A(ab_6__6_), .B(CARRYB_5__6_), .CI(ab_5__7_), .CO(
        CARRYB_6__6_), .S(SUMB_6__6_) );
  ADDFX2M S3_5_6 ( .A(ab_5__6_), .B(CARRYB_4__6_), .CI(ab_4__7_), .CO(
        CARRYB_5__6_), .S(SUMB_5__6_) );
  ADDFX2M S4_5 ( .A(ab_7__5_), .B(CARRYB_6__5_), .CI(SUMB_6__6_), .CO(
        CARRYB_7__5_), .S(SUMB_7__5_) );
  ADDFX2M S1_6_0 ( .A(ab_6__0_), .B(CARRYB_5__0_), .CI(SUMB_5__1_), .CO(
        CARRYB_6__0_), .S(A1_4_) );
  ADDFX2M S2_6_1 ( .A(ab_6__1_), .B(CARRYB_5__1_), .CI(SUMB_5__2_), .CO(
        CARRYB_6__1_), .S(SUMB_6__1_) );
  ADDFX2M S2_5_1 ( .A(ab_5__1_), .B(CARRYB_4__1_), .CI(SUMB_4__2_), .CO(
        CARRYB_5__1_), .S(SUMB_5__1_) );
  ADDFX2M S2_4_1 ( .A(ab_4__1_), .B(CARRYB_3__1_), .CI(SUMB_3__2_), .CO(
        CARRYB_4__1_), .S(SUMB_4__1_) );
  ADDFX2M S2_3_1 ( .A(ab_3__1_), .B(CARRYB_2__1_), .CI(SUMB_2__2_), .CO(
        CARRYB_3__1_), .S(SUMB_3__1_) );
  ADDFX2M S2_2_1 ( .A(ab_2__1_), .B(CARRYB_1__1_), .CI(SUMB_1__2_), .CO(
        CARRYB_2__1_), .S(SUMB_2__1_) );
  ADDFX2M S2_6_2 ( .A(ab_6__2_), .B(CARRYB_5__2_), .CI(SUMB_5__3_), .CO(
        CARRYB_6__2_), .S(SUMB_6__2_) );
  ADDFX2M S2_6_3 ( .A(ab_6__3_), .B(CARRYB_5__3_), .CI(SUMB_5__4_), .CO(
        CARRYB_6__3_), .S(SUMB_6__3_) );
  ADDFX2M S2_5_3 ( .A(ab_5__3_), .B(CARRYB_4__3_), .CI(SUMB_4__4_), .CO(
        CARRYB_5__3_), .S(SUMB_5__3_) );
  ADDFX2M S2_5_2 ( .A(ab_5__2_), .B(CARRYB_4__2_), .CI(SUMB_4__3_), .CO(
        CARRYB_5__2_), .S(SUMB_5__2_) );
  ADDFX2M S2_5_4 ( .A(ab_5__4_), .B(CARRYB_4__4_), .CI(SUMB_4__5_), .CO(
        CARRYB_5__4_), .S(SUMB_5__4_) );
  ADDFX2M S2_4_4 ( .A(ab_4__4_), .B(CARRYB_3__4_), .CI(SUMB_3__5_), .CO(
        CARRYB_4__4_), .S(SUMB_4__4_) );
  ADDFX2M S2_4_3 ( .A(ab_4__3_), .B(CARRYB_3__3_), .CI(SUMB_3__4_), .CO(
        CARRYB_4__3_), .S(SUMB_4__3_) );
  ADDFX2M S2_4_2 ( .A(ab_4__2_), .B(CARRYB_3__2_), .CI(SUMB_3__3_), .CO(
        CARRYB_4__2_), .S(SUMB_4__2_) );
  ADDFX2M S2_4_5 ( .A(ab_4__5_), .B(CARRYB_3__5_), .CI(SUMB_3__6_), .CO(
        CARRYB_4__5_), .S(SUMB_4__5_) );
  ADDFX2M S2_3_5 ( .A(ab_3__5_), .B(CARRYB_2__5_), .CI(SUMB_2__6_), .CO(
        CARRYB_3__5_), .S(SUMB_3__5_) );
  ADDFX2M S2_3_4 ( .A(ab_3__4_), .B(CARRYB_2__4_), .CI(SUMB_2__5_), .CO(
        CARRYB_3__4_), .S(SUMB_3__4_) );
  ADDFX2M S2_3_3 ( .A(ab_3__3_), .B(CARRYB_2__3_), .CI(SUMB_2__4_), .CO(
        CARRYB_3__3_), .S(SUMB_3__3_) );
  ADDFX2M S2_3_2 ( .A(ab_3__2_), .B(CARRYB_2__2_), .CI(SUMB_2__3_), .CO(
        CARRYB_3__2_), .S(SUMB_3__2_) );
  ADDFX2M S2_6_5 ( .A(ab_6__5_), .B(CARRYB_5__5_), .CI(SUMB_5__6_), .CO(
        CARRYB_6__5_), .S(SUMB_6__5_) );
  ADDFX2M S2_6_4 ( .A(ab_6__4_), .B(CARRYB_5__4_), .CI(SUMB_5__5_), .CO(
        CARRYB_6__4_), .S(SUMB_6__4_) );
  ADDFX2M S2_5_5 ( .A(ab_5__5_), .B(CARRYB_4__5_), .CI(SUMB_4__6_), .CO(
        CARRYB_5__5_), .S(SUMB_5__5_) );
  ADDFX2M S3_4_6 ( .A(ab_4__6_), .B(CARRYB_3__6_), .CI(ab_3__7_), .CO(
        CARRYB_4__6_), .S(SUMB_4__6_) );
  ADDFX2M S3_3_6 ( .A(ab_3__6_), .B(CARRYB_2__6_), .CI(ab_2__7_), .CO(
        CARRYB_3__6_), .S(SUMB_3__6_) );
  ADDFX2M S3_2_6 ( .A(ab_2__6_), .B(CARRYB_1__6_), .CI(ab_1__7_), .CO(
        CARRYB_2__6_), .S(SUMB_2__6_) );
  ADDFX2M S2_2_4 ( .A(ab_2__4_), .B(CARRYB_1__4_), .CI(SUMB_1__5_), .CO(
        CARRYB_2__4_), .S(SUMB_2__4_) );
  ADDFX2M S2_2_3 ( .A(ab_2__3_), .B(CARRYB_1__3_), .CI(SUMB_1__4_), .CO(
        CARRYB_2__3_), .S(SUMB_2__3_) );
  ADDFX2M S4_0 ( .A(ab_7__0_), .B(CARRYB_6__0_), .CI(SUMB_6__1_), .CO(
        CARRYB_7__0_), .S(SUMB_7__0_) );
  ADDFX2M S4_1 ( .A(ab_7__1_), .B(CARRYB_6__1_), .CI(SUMB_6__2_), .CO(
        CARRYB_7__1_), .S(SUMB_7__1_) );
  ADDFX2M S4_4 ( .A(ab_7__4_), .B(CARRYB_6__4_), .CI(SUMB_6__5_), .CO(
        CARRYB_7__4_), .S(SUMB_7__4_) );
  ADDFX2M S4_3 ( .A(ab_7__3_), .B(CARRYB_6__3_), .CI(SUMB_6__4_), .CO(
        CARRYB_7__3_), .S(SUMB_7__3_) );
  ADDFX2M S4_2 ( .A(ab_7__2_), .B(CARRYB_6__2_), .CI(SUMB_6__3_), .CO(
        CARRYB_7__2_), .S(SUMB_7__2_) );
  ADDFX2M S2_2_5 ( .A(ab_2__5_), .B(CARRYB_1__5_), .CI(SUMB_1__6_), .CO(
        CARRYB_2__5_), .S(SUMB_2__5_) );
  ADDFX2M S2_2_2 ( .A(ab_2__2_), .B(CARRYB_1__2_), .CI(SUMB_1__3_), .CO(
        CARRYB_2__2_), .S(SUMB_2__2_) );
  NOR2X4M U2 ( .A(n7), .B(n18), .Y(ab_0__3_) );
  INVX6M U3 ( .A(A[0]), .Y(n18) );
  NOR2X4M U4 ( .A(n4), .B(n18), .Y(ab_0__6_) );
  NOR2X4M U5 ( .A(n10), .B(n17), .Y(ab_1__0_) );
  NOR2X4M U6 ( .A(n5), .B(n18), .Y(ab_0__5_) );
  NOR2X4M U7 ( .A(n4), .B(n17), .Y(ab_1__6_) );
  INVX6M U8 ( .A(B[6]), .Y(n4) );
  NOR2X4M U9 ( .A(n6), .B(n18), .Y(ab_0__4_) );
  NOR2X4M U10 ( .A(n9), .B(n17), .Y(ab_1__1_) );
  INVX6M U11 ( .A(B[1]), .Y(n9) );
  XOR2X2M U12 ( .A(ab_1__6_), .B(ab_0__7_), .Y(SUMB_1__6_) );
  NOR2X4M U13 ( .A(n3), .B(n18), .Y(ab_0__7_) );
  NOR2X4M U14 ( .A(n6), .B(n17), .Y(ab_1__4_) );
  INVX6M U15 ( .A(B[4]), .Y(n6) );
  NOR2X4M U16 ( .A(n8), .B(n17), .Y(ab_1__2_) );
  INVX6M U17 ( .A(B[2]), .Y(n8) );
  XOR2X2M U18 ( .A(ab_1__1_), .B(ab_0__2_), .Y(SUMB_1__1_) );
  NOR2X4M U19 ( .A(n8), .B(n18), .Y(ab_0__2_) );
  NOR2X4M U20 ( .A(n11), .B(n3), .Y(ab_7__7_) );
  NOR2X4M U21 ( .A(n5), .B(n17), .Y(ab_1__5_) );
  NOR2X4M U22 ( .A(n7), .B(n17), .Y(ab_1__3_) );
  INVX6M U23 ( .A(B[3]), .Y(n7) );
  INVX6M U24 ( .A(A[1]), .Y(n17) );
  XOR2X2M U25 ( .A(ab_1__0_), .B(ab_0__1_), .Y(PRODUCT[1]) );
  NOR2X4M U26 ( .A(n9), .B(n18), .Y(ab_0__1_) );
  CLKINVX6M U27 ( .A(B[0]), .Y(n10) );
  CLKXOR2X2M U28 ( .A(CARRYB_7__1_), .B(SUMB_7__2_), .Y(A1_7_) );
  CLKXOR2X2M U29 ( .A(CARRYB_7__2_), .B(SUMB_7__3_), .Y(A1_8_) );
  CLKXOR2X2M U30 ( .A(CARRYB_7__3_), .B(SUMB_7__4_), .Y(A1_9_) );
  AND2X2M U31 ( .A(CARRYB_7__0_), .B(SUMB_7__1_), .Y(A2_7_) );
  AND2X2M U32 ( .A(CARRYB_7__1_), .B(SUMB_7__2_), .Y(A2_8_) );
  AND2X2M U33 ( .A(CARRYB_7__2_), .B(SUMB_7__3_), .Y(A2_9_) );
  AND2X1M U34 ( .A(CARRYB_7__6_), .B(ab_7__7_), .Y(A2_13_) );
  CLKXOR2X2M U35 ( .A(CARRYB_7__4_), .B(SUMB_7__5_), .Y(A1_10_) );
  AND2X2M U36 ( .A(CARRYB_7__3_), .B(SUMB_7__4_), .Y(A2_10_) );
  CLKXOR2X2M U37 ( .A(CARRYB_7__5_), .B(SUMB_7__6_), .Y(A1_11_) );
  AND2X2M U38 ( .A(CARRYB_7__4_), .B(SUMB_7__5_), .Y(A2_11_) );
  CLKXOR2X2M U39 ( .A(CARRYB_7__6_), .B(ab_7__7_), .Y(A1_12_) );
  AND2X2M U40 ( .A(CARRYB_7__5_), .B(SUMB_7__6_), .Y(A2_12_) );
  AND2X1M U41 ( .A(ab_0__3_), .B(ab_1__2_), .Y(CARRYB_1__2_) );
  CLKXOR2X2M U42 ( .A(ab_1__3_), .B(ab_0__4_), .Y(SUMB_1__3_) );
  AND2X1M U43 ( .A(ab_0__6_), .B(ab_1__5_), .Y(CARRYB_1__5_) );
  AND2X1M U44 ( .A(ab_0__4_), .B(ab_1__3_), .Y(CARRYB_1__3_) );
  CLKXOR2X2M U45 ( .A(ab_1__4_), .B(ab_0__5_), .Y(SUMB_1__4_) );
  AND2X1M U46 ( .A(ab_0__5_), .B(ab_1__4_), .Y(CARRYB_1__4_) );
  CLKXOR2X2M U47 ( .A(ab_1__5_), .B(ab_0__6_), .Y(SUMB_1__5_) );
  AND2X1M U48 ( .A(ab_0__7_), .B(ab_1__6_), .Y(CARRYB_1__6_) );
  AND2X1M U49 ( .A(ab_0__2_), .B(ab_1__1_), .Y(CARRYB_1__1_) );
  CLKXOR2X2M U50 ( .A(ab_1__2_), .B(ab_0__3_), .Y(SUMB_1__2_) );
  AND2X1M U51 ( .A(ab_0__1_), .B(ab_1__0_), .Y(CARRYB_1__0_) );
  CLKXOR2X2M U52 ( .A(CARRYB_7__0_), .B(SUMB_7__1_), .Y(A1_6_) );
  CLKINVX6M U53 ( .A(A[2]), .Y(n16) );
  CLKINVX6M U54 ( .A(B[7]), .Y(n3) );
  INVX6M U55 ( .A(B[5]), .Y(n5) );
  CLKINVX6M U56 ( .A(A[6]), .Y(n12) );
  CLKINVX6M U57 ( .A(A[3]), .Y(n15) );
  CLKINVX6M U58 ( .A(A[4]), .Y(n14) );
  CLKINVX6M U59 ( .A(A[5]), .Y(n13) );
  CLKINVX6M U60 ( .A(A[7]), .Y(n11) );
  NOR2X1M U62 ( .A(n11), .B(n4), .Y(ab_7__6_) );
  NOR2X1M U63 ( .A(n11), .B(n5), .Y(ab_7__5_) );
  NOR2X1M U64 ( .A(n11), .B(n6), .Y(ab_7__4_) );
  NOR2X1M U65 ( .A(n11), .B(n7), .Y(ab_7__3_) );
  NOR2X1M U66 ( .A(n11), .B(n8), .Y(ab_7__2_) );
  NOR2X1M U67 ( .A(n11), .B(n9), .Y(ab_7__1_) );
  NOR2X1M U68 ( .A(n11), .B(n10), .Y(ab_7__0_) );
  NOR2X1M U69 ( .A(n3), .B(n12), .Y(ab_6__7_) );
  NOR2X1M U70 ( .A(n4), .B(n12), .Y(ab_6__6_) );
  NOR2X1M U71 ( .A(n5), .B(n12), .Y(ab_6__5_) );
  NOR2X1M U72 ( .A(n6), .B(n12), .Y(ab_6__4_) );
  NOR2X1M U73 ( .A(n7), .B(n12), .Y(ab_6__3_) );
  NOR2X1M U74 ( .A(n8), .B(n12), .Y(ab_6__2_) );
  NOR2X1M U75 ( .A(n9), .B(n12), .Y(ab_6__1_) );
  NOR2X1M U76 ( .A(n10), .B(n12), .Y(ab_6__0_) );
  NOR2X1M U77 ( .A(n3), .B(n13), .Y(ab_5__7_) );
  NOR2X1M U78 ( .A(n4), .B(n13), .Y(ab_5__6_) );
  NOR2X1M U79 ( .A(n5), .B(n13), .Y(ab_5__5_) );
  NOR2X1M U80 ( .A(n6), .B(n13), .Y(ab_5__4_) );
  NOR2X1M U81 ( .A(n7), .B(n13), .Y(ab_5__3_) );
  NOR2X1M U82 ( .A(n8), .B(n13), .Y(ab_5__2_) );
  NOR2X1M U83 ( .A(n9), .B(n13), .Y(ab_5__1_) );
  NOR2X1M U84 ( .A(n10), .B(n13), .Y(ab_5__0_) );
  NOR2X1M U85 ( .A(n3), .B(n14), .Y(ab_4__7_) );
  NOR2X1M U86 ( .A(n4), .B(n14), .Y(ab_4__6_) );
  NOR2X1M U87 ( .A(n5), .B(n14), .Y(ab_4__5_) );
  NOR2X1M U88 ( .A(n6), .B(n14), .Y(ab_4__4_) );
  NOR2X1M U89 ( .A(n7), .B(n14), .Y(ab_4__3_) );
  NOR2X1M U90 ( .A(n8), .B(n14), .Y(ab_4__2_) );
  NOR2X1M U91 ( .A(n9), .B(n14), .Y(ab_4__1_) );
  NOR2X1M U92 ( .A(n10), .B(n14), .Y(ab_4__0_) );
  NOR2X1M U93 ( .A(n3), .B(n15), .Y(ab_3__7_) );
  NOR2X1M U94 ( .A(n4), .B(n15), .Y(ab_3__6_) );
  NOR2X1M U95 ( .A(n5), .B(n15), .Y(ab_3__5_) );
  NOR2X1M U96 ( .A(n6), .B(n15), .Y(ab_3__4_) );
  NOR2X1M U97 ( .A(n7), .B(n15), .Y(ab_3__3_) );
  NOR2X1M U98 ( .A(n8), .B(n15), .Y(ab_3__2_) );
  NOR2X1M U99 ( .A(n9), .B(n15), .Y(ab_3__1_) );
  NOR2X1M U100 ( .A(n10), .B(n15), .Y(ab_3__0_) );
  NOR2X1M U101 ( .A(n3), .B(n16), .Y(ab_2__7_) );
  NOR2X1M U102 ( .A(n4), .B(n16), .Y(ab_2__6_) );
  NOR2X1M U103 ( .A(n5), .B(n16), .Y(ab_2__5_) );
  NOR2X1M U104 ( .A(n6), .B(n16), .Y(ab_2__4_) );
  NOR2X1M U105 ( .A(n7), .B(n16), .Y(ab_2__3_) );
  NOR2X1M U106 ( .A(n8), .B(n16), .Y(ab_2__2_) );
  NOR2X1M U107 ( .A(n9), .B(n16), .Y(ab_2__1_) );
  NOR2X1M U108 ( .A(n10), .B(n16), .Y(ab_2__0_) );
  NOR2X1M U109 ( .A(n3), .B(n17), .Y(ab_1__7_) );
  NOR2X1M U110 ( .A(n10), .B(n18), .Y(PRODUCT[0]) );
  Arithmatic_Unit_Width16_DW01_add_1 FS_1 ( .A({1'b0, A1_12_, A1_11_, A1_10_, 
        A1_9_, A1_8_, A1_7_, A1_6_, SUMB_7__0_, A1_4_, A1_3_, A1_2_, A1_1_, 
        A1_0_}), .B({A2_13_, A2_12_, A2_11_, A2_10_, A2_9_, A2_8_, A2_7_, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .CI(1'b0), .SUM(PRODUCT[15:2])
         );
endmodule


module Arithmatic_Unit_Width16_test_1 ( A, B, ALU_FUN, CLK, RST, Arith_Enable, 
        Arith_OUT, Carry_OUT, Arith_Flag, test_si, test_se );
  input [7:0] A;
  input [7:0] B;
  input [1:0] ALU_FUN;
  output [15:0] Arith_OUT;
  input CLK, RST, Arith_Enable, test_si, test_se;
  output Carry_OUT, Arith_Flag;
  wire   N12, N13, N14, N15, N16, N17, N18, N19, N20, Carry_OUT_Comb, N21, N22,
         N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34, N35, N36,
         N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, N48, N49, N50,
         N51, N52, N53, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n59, n60, n61, n62, n63,
         n64, n65, n66, n67, n68, n69, n70, SYNOPSYS_UNCONNECTED_1,
         SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3,
         SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5,
         SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7,
         SYNOPSYS_UNCONNECTED_8;
  wire   [15:1] Arith_OUT_Comb;

  AOI221X4M U24 ( .A0(N20), .A1(n62), .B0(N38), .B1(n64), .C0(n27), .Y(n28) );
  NOR2BX12M U56 ( .AN(ALU_FUN[1]), .B(n70), .Y(n32) );
  SDFFRQX1M Arith_Flag_reg ( .D(Arith_Enable), .SI(test_si), .SE(test_se), 
        .CK(CLK), .RN(RST), .Q(Arith_Flag) );
  SDFFRQX1M Arith_OUT_reg_6_ ( .D(Arith_OUT_Comb[6]), .SI(Arith_OUT[5]), .SE(
        test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[6]) );
  SDFFRQX1M Arith_OUT_reg_7_ ( .D(Arith_OUT_Comb[7]), .SI(Arith_OUT[6]), .SE(
        test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[7]) );
  SDFFRQX1M Arith_OUT_reg_8_ ( .D(n69), .SI(Arith_OUT[7]), .SE(test_se), .CK(
        CLK), .RN(n66), .Q(Arith_OUT[8]) );
  SDFFRQX1M Arith_OUT_reg_9_ ( .D(Arith_OUT_Comb[9]), .SI(Arith_OUT[8]), .SE(
        test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[9]) );
  SDFFRQX1M Arith_OUT_reg_5_ ( .D(Arith_OUT_Comb[5]), .SI(Arith_OUT[4]), .SE(
        test_se), .CK(CLK), .RN(n67), .Q(Arith_OUT[5]) );
  SDFFRQX1M Arith_OUT_reg_10_ ( .D(Arith_OUT_Comb[10]), .SI(Arith_OUT[9]), 
        .SE(test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[10]) );
  SDFFRQX1M Arith_OUT_reg_11_ ( .D(Arith_OUT_Comb[11]), .SI(Arith_OUT[10]), 
        .SE(test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[11]) );
  SDFFRQX1M Arith_OUT_reg_12_ ( .D(Arith_OUT_Comb[12]), .SI(Arith_OUT[11]), 
        .SE(test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[12]) );
  SDFFRQX1M Arith_OUT_reg_13_ ( .D(Arith_OUT_Comb[13]), .SI(Arith_OUT[12]), 
        .SE(test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[13]) );
  SDFFRQX1M Arith_OUT_reg_14_ ( .D(Arith_OUT_Comb[14]), .SI(Arith_OUT[13]), 
        .SE(test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[14]) );
  SDFFRQX1M Arith_OUT_reg_4_ ( .D(Arith_OUT_Comb[4]), .SI(Arith_OUT[3]), .SE(
        test_se), .CK(CLK), .RN(n67), .Q(Arith_OUT[4]) );
  SDFFRQX1M Arith_OUT_reg_15_ ( .D(Arith_OUT_Comb[15]), .SI(Arith_OUT[14]), 
        .SE(test_se), .CK(CLK), .RN(n66), .Q(Arith_OUT[15]) );
  SDFFRQX1M Arith_OUT_reg_3_ ( .D(Arith_OUT_Comb[3]), .SI(Arith_OUT[2]), .SE(
        test_se), .CK(CLK), .RN(n67), .Q(Arith_OUT[3]) );
  SDFFRQX1M Arith_OUT_reg_2_ ( .D(Arith_OUT_Comb[2]), .SI(Arith_OUT[1]), .SE(
        test_se), .CK(CLK), .RN(n67), .Q(Arith_OUT[2]) );
  SDFFRQX1M Arith_OUT_reg_1_ ( .D(Arith_OUT_Comb[1]), .SI(Arith_OUT[0]), .SE(
        test_se), .CK(CLK), .RN(n67), .Q(Arith_OUT[1]) );
  SDFFRQX1M Carry_OUT_reg ( .D(Carry_OUT_Comb), .SI(Arith_OUT[15]), .SE(
        test_se), .CK(CLK), .RN(n66), .Q(Carry_OUT) );
  SDFFRQX1M Arith_OUT_reg_0_ ( .D(Carry_OUT_Comb), .SI(Arith_Flag), .SE(
        test_se), .CK(CLK), .RN(n67), .Q(Arith_OUT[0]) );
  AO22X1M U42 ( .A0(N46), .A1(n32), .B0(N30), .B1(n64), .Y(n60) );
  OR2X2M U43 ( .A(n59), .B(n60), .Y(Carry_OUT_Comb) );
  INVX2M U44 ( .A(n26), .Y(n63) );
  AO22X1M U45 ( .A0(N21), .A1(n61), .B0(N12), .B1(n62), .Y(n59) );
  INVX6M U46 ( .A(n63), .Y(n64) );
  INVX6M U47 ( .A(n63), .Y(n65) );
  CLKBUFX8M U48 ( .A(n68), .Y(n66) );
  BUFX4M U49 ( .A(n68), .Y(n67) );
  AO21XLM U50 ( .A0(N44), .A1(n65), .B0(n27), .Y(Arith_OUT_Comb[14]) );
  AO21XLM U51 ( .A0(N45), .A1(n64), .B0(n27), .Y(Arith_OUT_Comb[15]) );
  AO21XLM U52 ( .A0(N43), .A1(n64), .B0(n27), .Y(Arith_OUT_Comb[13]) );
  AO21XLM U53 ( .A0(N42), .A1(n65), .B0(n27), .Y(Arith_OUT_Comb[12]) );
  AO21XLM U54 ( .A0(N41), .A1(n64), .B0(n27), .Y(Arith_OUT_Comb[11]) );
  AO21XLM U55 ( .A0(N40), .A1(n65), .B0(n27), .Y(Arith_OUT_Comb[10]) );
  AO21XLM U57 ( .A0(N39), .A1(n65), .B0(n27), .Y(Arith_OUT_Comb[9]) );
  CLKINVX2M U58 ( .A(ALU_FUN[0]), .Y(n70) );
  CLKBUFX6M U59 ( .A(n33), .Y(n61) );
  NOR2X1M U60 ( .A(n70), .B(ALU_FUN[1]), .Y(n33) );
  CLKBUFX6M U61 ( .A(n29), .Y(n62) );
  NOR2X1M U62 ( .A(ALU_FUN[0]), .B(ALU_FUN[1]), .Y(n29) );
  NOR2BX1M U63 ( .AN(ALU_FUN[1]), .B(ALU_FUN[0]), .Y(n26) );
  CLKBUFX2M U64 ( .A(RST), .Y(n68) );
  NAND2X2M U65 ( .A(n44), .B(n45), .Y(Arith_OUT_Comb[1]) );
  AOI22X1M U66 ( .A0(N22), .A1(n61), .B0(N13), .B1(n62), .Y(n44) );
  AOI22X1M U67 ( .A0(N47), .A1(n32), .B0(N31), .B1(n65), .Y(n45) );
  NAND2X2M U68 ( .A(n42), .B(n43), .Y(Arith_OUT_Comb[2]) );
  AOI22X1M U69 ( .A0(N23), .A1(n61), .B0(N14), .B1(n62), .Y(n42) );
  AOI22X1M U70 ( .A0(N48), .A1(n32), .B0(N32), .B1(n64), .Y(n43) );
  NAND2X2M U71 ( .A(n40), .B(n41), .Y(Arith_OUT_Comb[3]) );
  AOI22X1M U72 ( .A0(N24), .A1(n61), .B0(N15), .B1(n62), .Y(n40) );
  AOI22X1M U73 ( .A0(N49), .A1(n32), .B0(N33), .B1(n65), .Y(n41) );
  NAND2X2M U74 ( .A(n38), .B(n39), .Y(Arith_OUT_Comb[4]) );
  AOI22X1M U75 ( .A0(N25), .A1(n61), .B0(N16), .B1(n62), .Y(n38) );
  AOI22X1M U76 ( .A0(N50), .A1(n32), .B0(N34), .B1(n64), .Y(n39) );
  NAND2X2M U77 ( .A(n36), .B(n37), .Y(Arith_OUT_Comb[5]) );
  AOI22X1M U78 ( .A0(N26), .A1(n61), .B0(N17), .B1(n62), .Y(n36) );
  AOI22X1M U79 ( .A0(N51), .A1(n32), .B0(N35), .B1(n65), .Y(n37) );
  NAND2X2M U80 ( .A(n34), .B(n35), .Y(Arith_OUT_Comb[6]) );
  AOI22X1M U81 ( .A0(N27), .A1(n61), .B0(N18), .B1(n62), .Y(n34) );
  AOI22X1M U82 ( .A0(N52), .A1(n32), .B0(N36), .B1(n64), .Y(n35) );
  INVX2M U83 ( .A(n28), .Y(n69) );
  NAND2X2M U84 ( .A(n30), .B(n31), .Y(Arith_OUT_Comb[7]) );
  AOI22X1M U85 ( .A0(N28), .A1(n61), .B0(N19), .B1(n62), .Y(n30) );
  AOI22X1M U86 ( .A0(N53), .A1(n32), .B0(N37), .B1(n65), .Y(n31) );
  CLKAND2X6M U87 ( .A(N29), .B(n61), .Y(n27) );
  Arithmatic_Unit_Width16_DW_div_uns_0 div_35 ( .a(A), .b(B), .quotient({N53, 
        N52, N51, N50, N49, N48, N47, N46}), .remainder({
        SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
        SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5, SYNOPSYS_UNCONNECTED_6, 
        SYNOPSYS_UNCONNECTED_7, SYNOPSYS_UNCONNECTED_8}) );
  Arithmatic_Unit_Width16_DW01_sub_0 sub_25 ( .A({1'b0, A}), .B({1'b0, B}), 
        .CI(1'b0), .DIFF({N29, N28, N27, N26, N25, N24, N23, N22, N21}) );
  Arithmatic_Unit_Width16_DW01_add_0 add_20 ( .A({1'b0, A}), .B({1'b0, B}), 
        .CI(1'b0), .SUM({N20, N19, N18, N17, N16, N15, N14, N13, N12}) );
  Arithmatic_Unit_Width16_DW02_mult_0 mult_30 ( .A(A), .B(B), .TC(1'b0), 
        .PRODUCT({N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, N35, N34, 
        N33, N32, N31, N30}) );
endmodule


module Logic_Unit_Width16_test_1 ( A, B, ALU_FUN, CLK, Logic_Enable, RST, 
        Logic_OUT, Logic_Flag, test_si, test_se );
  input [7:0] A;
  input [7:0] B;
  input [1:0] ALU_FUN;
  output [15:0] Logic_OUT;
  input CLK, Logic_Enable, RST, test_si, test_se;
  output Logic_Flag;
  wire   N48, N49, N50, N51, N52, N53, N54, N55, N63, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53,
         n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84;

  SDFFRQX1M Logic_Flag_reg ( .D(Logic_Enable), .SI(test_si), .SE(test_se), 
        .CK(CLK), .RN(RST), .Q(Logic_Flag) );
  SDFFRQX1M Logic_OUT_reg_6_ ( .D(N54), .SI(Logic_OUT[5]), .SE(test_se), .CK(
        CLK), .RN(n65), .Q(Logic_OUT[6]) );
  SDFFRQX1M Logic_OUT_reg_3_ ( .D(N51), .SI(Logic_OUT[2]), .SE(test_se), .CK(
        CLK), .RN(n66), .Q(Logic_OUT[3]) );
  SDFFRQX1M Logic_OUT_reg_0_ ( .D(N48), .SI(Logic_Flag), .SE(test_se), .CK(CLK), .RN(n66), .Q(Logic_OUT[0]) );
  SDFFRQX1M Logic_OUT_reg_2_ ( .D(N50), .SI(Logic_OUT[1]), .SE(test_se), .CK(
        CLK), .RN(n66), .Q(Logic_OUT[2]) );
  SDFFRQX1M Logic_OUT_reg_4_ ( .D(N52), .SI(Logic_OUT[3]), .SE(test_se), .CK(
        CLK), .RN(n66), .Q(Logic_OUT[4]) );
  SDFFRQX1M Logic_OUT_reg_1_ ( .D(N49), .SI(Logic_OUT[0]), .SE(test_se), .CK(
        CLK), .RN(n66), .Q(Logic_OUT[1]) );
  SDFFRQX1M Logic_OUT_reg_7_ ( .D(N55), .SI(Logic_OUT[6]), .SE(test_se), .CK(
        CLK), .RN(n65), .Q(Logic_OUT[7]) );
  SDFFRQX1M Logic_OUT_reg_5_ ( .D(N53), .SI(Logic_OUT[4]), .SE(test_se), .CK(
        CLK), .RN(n65), .Q(Logic_OUT[5]) );
  SDFFRQX1M Logic_OUT_reg_15_ ( .D(N63), .SI(Logic_OUT[14]), .SE(test_se), 
        .CK(CLK), .RN(n65), .Q(Logic_OUT[15]) );
  SDFFRQX1M Logic_OUT_reg_14_ ( .D(N63), .SI(Logic_OUT[13]), .SE(test_se), 
        .CK(CLK), .RN(n65), .Q(Logic_OUT[14]) );
  SDFFRQX1M Logic_OUT_reg_13_ ( .D(N63), .SI(Logic_OUT[12]), .SE(test_se), 
        .CK(CLK), .RN(n65), .Q(Logic_OUT[13]) );
  SDFFRQX1M Logic_OUT_reg_12_ ( .D(N63), .SI(Logic_OUT[11]), .SE(test_se), 
        .CK(CLK), .RN(n65), .Q(Logic_OUT[12]) );
  SDFFRQX1M Logic_OUT_reg_11_ ( .D(N63), .SI(Logic_OUT[10]), .SE(test_se), 
        .CK(CLK), .RN(n65), .Q(Logic_OUT[11]) );
  SDFFRQX1M Logic_OUT_reg_10_ ( .D(N63), .SI(Logic_OUT[9]), .SE(test_se), .CK(
        CLK), .RN(n65), .Q(Logic_OUT[10]) );
  SDFFRQX1M Logic_OUT_reg_9_ ( .D(N63), .SI(Logic_OUT[8]), .SE(test_se), .CK(
        CLK), .RN(n65), .Q(Logic_OUT[9]) );
  SDFFRQX1M Logic_OUT_reg_8_ ( .D(N63), .SI(Logic_OUT[7]), .SE(test_se), .CK(
        CLK), .RN(n65), .Q(Logic_OUT[8]) );
  BUFX10M U20 ( .A(n35), .Y(n63) );
  OAI221X2M U21 ( .A0(A[7]), .A1(n63), .B0(n77), .B1(n64), .C0(n37), .Y(N55)
         );
  OAI221X2M U22 ( .A0(A[5]), .A1(n63), .B0(n64), .B1(n79), .C0(n45), .Y(N53)
         );
  OAI221X2M U40 ( .A0(A[4]), .A1(n63), .B0(n64), .B1(n80), .C0(n48), .Y(N52)
         );
  OAI221X2M U41 ( .A0(A[3]), .A1(n63), .B0(n64), .B1(n81), .C0(n51), .Y(N51)
         );
  OAI221X2M U42 ( .A0(A[6]), .A1(n63), .B0(n64), .B1(n78), .C0(n42), .Y(N54)
         );
  OAI221X2M U43 ( .A0(A[1]), .A1(n63), .B0(n64), .B1(n83), .C0(n57), .Y(N49)
         );
  OAI221X2M U44 ( .A0(A[2]), .A1(n63), .B0(n64), .B1(n82), .C0(n54), .Y(N50)
         );
  OAI221X2M U45 ( .A0(A[0]), .A1(n63), .B0(n64), .B1(n84), .C0(n60), .Y(N48)
         );
  NAND3X1M U46 ( .A(Logic_Enable), .B(n68), .C(ALU_FUN[0]), .Y(n36) );
  CLKINVX1M U47 ( .A(A[0]), .Y(n84) );
  CLKINVX1M U48 ( .A(A[1]), .Y(n83) );
  CLKINVX1M U49 ( .A(A[2]), .Y(n82) );
  CLKINVX1M U50 ( .A(A[3]), .Y(n81) );
  CLKINVX1M U51 ( .A(A[4]), .Y(n80) );
  CLKINVX1M U52 ( .A(A[5]), .Y(n79) );
  CLKINVX1M U53 ( .A(A[6]), .Y(n78) );
  INVXLM U54 ( .A(B[1]), .Y(n75) );
  INVXLM U55 ( .A(B[2]), .Y(n74) );
  INVXLM U56 ( .A(B[3]), .Y(n73) );
  INVXLM U57 ( .A(B[4]), .Y(n72) );
  INVXLM U58 ( .A(B[0]), .Y(n76) );
  CLKINVX1M U59 ( .A(A[7]), .Y(n77) );
  NAND2X6M U60 ( .A(Logic_Enable), .B(n68), .Y(n40) );
  CLKBUFX8M U61 ( .A(n67), .Y(n65) );
  BUFX4M U62 ( .A(n67), .Y(n66) );
  NAND2X5M U63 ( .A(Logic_Enable), .B(ALU_FUN[1]), .Y(n41) );
  INVX1M U64 ( .A(ALU_FUN[1]), .Y(n68) );
  BUFX10M U65 ( .A(n36), .Y(n64) );
  NAND3BXLM U66 ( .AN(ALU_FUN[0]), .B(ALU_FUN[1]), .C(Logic_Enable), .Y(n35)
         );
  CLKAND2X6M U67 ( .A(Logic_Enable), .B(ALU_FUN[1]), .Y(N63) );
  CLKBUFX2M U68 ( .A(RST), .Y(n67) );
  OAI21X2M U69 ( .A0(n40), .A1(n84), .B0(n64), .Y(n62) );
  OAI21X2M U70 ( .A0(n40), .A1(n83), .B0(n64), .Y(n59) );
  OAI21X2M U71 ( .A0(n40), .A1(n82), .B0(n64), .Y(n56) );
  OAI21X2M U72 ( .A0(n40), .A1(n81), .B0(n64), .Y(n53) );
  OAI21X2M U73 ( .A0(n40), .A1(n80), .B0(n64), .Y(n50) );
  OAI21X2M U74 ( .A0(n40), .A1(n79), .B0(n64), .Y(n47) );
  OAI21X2M U75 ( .A0(n40), .A1(n78), .B0(n64), .Y(n44) );
  OAI21X2M U76 ( .A0(n40), .A1(n77), .B0(n64), .Y(n39) );
  AOI22X1M U77 ( .A0(n43), .A1(n70), .B0(B[6]), .B1(n44), .Y(n42) );
  INVXLM U78 ( .A(B[6]), .Y(n70) );
  OAI21X1M U79 ( .A0(A[6]), .A1(n41), .B0(n63), .Y(n43) );
  AOI22X1M U80 ( .A0(n58), .A1(n75), .B0(B[1]), .B1(n59), .Y(n57) );
  OAI21X1M U81 ( .A0(A[1]), .A1(n41), .B0(n63), .Y(n58) );
  AOI22X1M U82 ( .A0(n55), .A1(n74), .B0(B[2]), .B1(n56), .Y(n54) );
  OAI21X1M U83 ( .A0(A[2]), .A1(n41), .B0(n63), .Y(n55) );
  AOI22X1M U84 ( .A0(n52), .A1(n73), .B0(B[3]), .B1(n53), .Y(n51) );
  OAI21X1M U85 ( .A0(A[3]), .A1(n41), .B0(n63), .Y(n52) );
  AOI22X1M U86 ( .A0(n49), .A1(n72), .B0(B[4]), .B1(n50), .Y(n48) );
  OAI21X1M U87 ( .A0(A[4]), .A1(n41), .B0(n63), .Y(n49) );
  AOI22X1M U88 ( .A0(n46), .A1(n71), .B0(B[5]), .B1(n47), .Y(n45) );
  INVX2M U89 ( .A(B[5]), .Y(n71) );
  OAI21X1M U90 ( .A0(A[5]), .A1(n41), .B0(n63), .Y(n46) );
  AOI22X1M U91 ( .A0(n61), .A1(n76), .B0(B[0]), .B1(n62), .Y(n60) );
  OAI21X1M U92 ( .A0(A[0]), .A1(n41), .B0(n63), .Y(n61) );
  AOI22X1M U93 ( .A0(n38), .A1(n69), .B0(B[7]), .B1(n39), .Y(n37) );
  INVXLM U94 ( .A(B[7]), .Y(n69) );
  OAI21X1M U95 ( .A0(A[7]), .A1(n41), .B0(n63), .Y(n38) );
endmodule


module CMP_Unit_Width16_test_1 ( A, B, ALU_FUN, CMP_Enable, CLK, RST, CMP_OUT, 
        CMP_Flag, test_si, test_se );
  input [7:0] A;
  input [7:0] B;
  input [1:0] ALU_FUN;
  output [15:0] CMP_OUT;
  input CMP_Enable, CLK, RST, test_si, test_se;
  output CMP_Flag;
  wire   N14, N16, N19, N20, n11, n12, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72,
         n73, n74, n75, n76;

  SDFFRQX1M CMP_Flag_reg ( .D(CMP_Enable), .SI(test_si), .SE(test_se), .CK(CLK), .RN(n37), .Q(CMP_Flag) );
  SDFFRQX1M CMP_OUT_reg_1_ ( .D(N20), .SI(CMP_OUT[0]), .SE(test_se), .CK(CLK), 
        .RN(n37), .Q(CMP_OUT[1]) );
  SDFFRQX1M CMP_OUT_reg_0_ ( .D(N19), .SI(CMP_Flag), .SE(test_se), .CK(CLK), 
        .RN(n37), .Q(CMP_OUT[0]) );
  AOI2B1X1M U48 ( .A1N(n62), .A0(n61), .B0(n60), .Y(n63) );
  INVX2M U49 ( .A(n63), .Y(n73) );
  NOR2X3M U53 ( .A(n66), .B(B[7]), .Y(n60) );
  CLKINVX2M U54 ( .A(A[7]), .Y(n66) );
  AOI211X4M U55 ( .A0(A[1]), .A1(n68), .B0(n47), .C0(n39), .Y(n40) );
  NAND2BX2M U56 ( .AN(n41), .B(n52), .Y(n47) );
  AOI211X2M U57 ( .A0(n48), .A1(n64), .B0(n47), .C0(n46), .Y(n49) );
  INVX2M U58 ( .A(B[3]), .Y(n71) );
  INVX2M U59 ( .A(B[2]), .Y(n69) );
  NOR2X3M U60 ( .A(n67), .B(A[0]), .Y(n38) );
  OAI21X4M U61 ( .A0(n60), .A1(n45), .B0(n61), .Y(N16) );
  AOI32X2M U62 ( .A0(n44), .A1(n54), .A2(n57), .B0(B[6]), .B1(n65), .Y(n45) );
  NOR2X4M U63 ( .A(n69), .B(A[2]), .Y(n41) );
  NOR2X4M U64 ( .A(n71), .B(A[3]), .Y(n50) );
  OAI31X2M U65 ( .A0(n50), .A1(n41), .A2(n40), .B0(n51), .Y(n43) );
  XNOR2X4M U66 ( .A(A[6]), .B(B[6]), .Y(n57) );
  NAND2X1M U67 ( .A(A[2]), .B(n69), .Y(n52) );
  NAND2X1M U68 ( .A(A[0]), .B(n67), .Y(n48) );
  NAND2X1M U69 ( .A(A[3]), .B(n71), .Y(n51) );
  CLKINVX1M U70 ( .A(B[0]), .Y(n67) );
  NAND2X1M U71 ( .A(B[7]), .B(n66), .Y(n61) );
  INVX2M U72 ( .A(CMP_Enable), .Y(n76) );
  CLKINVX1M U73 ( .A(ALU_FUN[1]), .Y(n75) );
  CLKINVX1M U74 ( .A(ALU_FUN[0]), .Y(n74) );
  CLKBUFX2M U75 ( .A(RST), .Y(n37) );
  NOR3X2M U76 ( .A(n76), .B(n11), .C(n75), .Y(N20) );
  AOI22X1M U77 ( .A0(n73), .A1(n74), .B0(N16), .B1(ALU_FUN[0]), .Y(n11) );
  NOR3X2M U78 ( .A(n76), .B(n12), .C(n74), .Y(N19) );
  AOI22X1M U79 ( .A0(N14), .A1(n75), .B0(ALU_FUN[1]), .B1(N16), .Y(n12) );
  INVXLM U80 ( .A(A[6]), .Y(n65) );
  INVXLM U81 ( .A(n38), .Y(n68) );
  INVXLM U82 ( .A(B[6]), .Y(n72) );
  INVXLM U83 ( .A(n49), .Y(n70) );
  CLKINVX2M U84 ( .A(A[1]), .Y(n64) );
  NAND2BX1M U85 ( .AN(B[4]), .B(A[4]), .Y(n53) );
  NAND2BX1M U86 ( .AN(A[4]), .B(B[4]), .Y(n42) );
  CLKNAND2X2M U87 ( .A(n53), .B(n42), .Y(n55) );
  AOI21X1M U88 ( .A0(n38), .A1(n64), .B0(B[1]), .Y(n39) );
  NAND2BX1M U89 ( .AN(A[5]), .B(B[5]), .Y(n58) );
  OAI211X1M U90 ( .A0(n55), .A1(n43), .B0(n42), .C0(n58), .Y(n44) );
  NAND2BX1M U91 ( .AN(B[5]), .B(A[5]), .Y(n54) );
  OA21X1M U92 ( .A0(n48), .A1(n64), .B0(B[1]), .Y(n46) );
  AOI31X1M U93 ( .A0(n70), .A1(n52), .A2(n51), .B0(n50), .Y(n56) );
  OAI2B11X1M U94 ( .A1N(n56), .A0(n55), .B0(n54), .C0(n53), .Y(n59) );
  AOI32X1M U95 ( .A0(n59), .A1(n58), .A2(n57), .B0(A[6]), .B1(n72), .Y(n62) );
  NOR2X1M U96 ( .A(N16), .B(n73), .Y(N14) );
  INVX2M U3 ( .A(1'b1), .Y(CMP_OUT[2]) );
  INVX2M U5 ( .A(1'b1), .Y(CMP_OUT[3]) );
  INVX2M U7 ( .A(1'b1), .Y(CMP_OUT[4]) );
  INVX2M U9 ( .A(1'b1), .Y(CMP_OUT[5]) );
  INVX2M U11 ( .A(1'b1), .Y(CMP_OUT[6]) );
  INVX2M U13 ( .A(1'b1), .Y(CMP_OUT[7]) );
  INVX2M U15 ( .A(1'b1), .Y(CMP_OUT[8]) );
  INVX2M U17 ( .A(1'b1), .Y(CMP_OUT[9]) );
  INVX2M U19 ( .A(1'b1), .Y(CMP_OUT[10]) );
  INVX2M U21 ( .A(1'b1), .Y(CMP_OUT[11]) );
  INVX2M U23 ( .A(1'b1), .Y(CMP_OUT[12]) );
  INVX2M U25 ( .A(1'b1), .Y(CMP_OUT[13]) );
  INVX2M U27 ( .A(1'b1), .Y(CMP_OUT[14]) );
  INVX2M U29 ( .A(1'b1), .Y(CMP_OUT[15]) );
endmodule


module Shift_Unit_Width16_test_1 ( A, B, ALU_FUN, CLK, RST, Shift_Enable, 
        Shift_OUT, Shift_Flag, test_si, test_se );
  input [7:0] A;
  input [7:0] B;
  input [1:0] ALU_FUN;
  output [15:0] Shift_OUT;
  input CLK, RST, Shift_Enable, test_si, test_se;
  output Shift_Flag;
  wire   N16, N17, N18, N19, N20, N21, N22, N23, N24, n14, n15, n16, n17, n18,
         n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31, n32,
         n54, n55, n56, n57, n58;

  NOR2X12M U41 ( .A(n57), .B(n56), .Y(n15) );
  NOR2X12M U43 ( .A(n56), .B(ALU_FUN[1]), .Y(n16) );
  NOR2X12M U46 ( .A(ALU_FUN[0]), .B(ALU_FUN[1]), .Y(n21) );
  NOR2X12M U47 ( .A(n57), .B(ALU_FUN[0]), .Y(n20) );
  SDFFRQX1M Shift_Flag_reg ( .D(Shift_Enable), .SI(test_si), .SE(test_se), 
        .CK(CLK), .RN(n54), .Q(Shift_Flag) );
  SDFFRQX1M Shift_OUT_reg_0_ ( .D(N16), .SI(Shift_Flag), .SE(test_se), .CK(CLK), .RN(n54), .Q(Shift_OUT[0]) );
  SDFFRQX1M Shift_OUT_reg_2_ ( .D(N18), .SI(Shift_OUT[1]), .SE(test_se), .CK(
        CLK), .RN(n54), .Q(Shift_OUT[2]) );
  SDFFRQX1M Shift_OUT_reg_1_ ( .D(N17), .SI(Shift_OUT[0]), .SE(test_se), .CK(
        CLK), .RN(n54), .Q(Shift_OUT[1]) );
  SDFFRQX1M Shift_OUT_reg_3_ ( .D(N19), .SI(Shift_OUT[2]), .SE(test_se), .CK(
        CLK), .RN(n54), .Q(Shift_OUT[3]) );
  SDFFRQX1M Shift_OUT_reg_4_ ( .D(N20), .SI(Shift_OUT[3]), .SE(test_se), .CK(
        CLK), .RN(n54), .Q(Shift_OUT[4]) );
  SDFFRQX1M Shift_OUT_reg_5_ ( .D(N21), .SI(Shift_OUT[4]), .SE(test_se), .CK(
        CLK), .RN(n54), .Q(Shift_OUT[5]) );
  SDFFRQX1M Shift_OUT_reg_6_ ( .D(N22), .SI(Shift_OUT[5]), .SE(test_se), .CK(
        CLK), .RN(n54), .Q(Shift_OUT[6]) );
  SDFFRQX1M Shift_OUT_reg_8_ ( .D(N24), .SI(Shift_OUT[7]), .SE(test_se), .CK(
        CLK), .RN(n54), .Q(Shift_OUT[8]) );
  SDFFRQX1M Shift_OUT_reg_7_ ( .D(N23), .SI(Shift_OUT[6]), .SE(test_se), .CK(
        CLK), .RN(n54), .Q(Shift_OUT[7]) );
  CLKINVX6M U34 ( .A(n55), .Y(n54) );
  INVX6M U49 ( .A(Shift_Enable), .Y(n58) );
  CLKINVX2M U50 ( .A(ALU_FUN[1]), .Y(n57) );
  CLKINVX2M U51 ( .A(ALU_FUN[0]), .Y(n56) );
  INVX2M U52 ( .A(RST), .Y(n55) );
  AOI21X2M U53 ( .A0(n22), .A1(n23), .B0(n58), .Y(N21) );
  AOI22X1M U54 ( .A0(A[4]), .A1(n16), .B0(n21), .B1(A[6]), .Y(n22) );
  AOI22X1M U55 ( .A0(B[4]), .A1(n15), .B0(n20), .B1(B[6]), .Y(n23) );
  AOI21X2M U56 ( .A0(n26), .A1(n27), .B0(n58), .Y(N19) );
  AOI22X1M U57 ( .A0(A[2]), .A1(n16), .B0(A[4]), .B1(n21), .Y(n26) );
  AOI22X1M U58 ( .A0(B[2]), .A1(n15), .B0(B[4]), .B1(n20), .Y(n27) );
  AOI21X2M U59 ( .A0(n28), .A1(n29), .B0(n58), .Y(N18) );
  AOI22X1M U60 ( .A0(A[1]), .A1(n16), .B0(A[3]), .B1(n21), .Y(n28) );
  AOI22X1M U61 ( .A0(B[1]), .A1(n15), .B0(B[3]), .B1(n20), .Y(n29) );
  AOI21X2M U62 ( .A0(n18), .A1(n19), .B0(n58), .Y(N22) );
  AOI22X1M U63 ( .A0(A[5]), .A1(n16), .B0(n21), .B1(A[7]), .Y(n18) );
  AOI22X1M U64 ( .A0(B[5]), .A1(n15), .B0(n20), .B1(B[7]), .Y(n19) );
  AOI21X2M U65 ( .A0(n30), .A1(n31), .B0(n58), .Y(N17) );
  AOI22X1M U66 ( .A0(A[0]), .A1(n16), .B0(A[2]), .B1(n21), .Y(n30) );
  AOI22X1M U67 ( .A0(B[0]), .A1(n15), .B0(B[2]), .B1(n20), .Y(n31) );
  AOI21X2M U68 ( .A0(n24), .A1(n25), .B0(n58), .Y(N20) );
  AOI22X1M U69 ( .A0(A[3]), .A1(n16), .B0(n21), .B1(A[5]), .Y(n24) );
  AOI22X1M U70 ( .A0(B[3]), .A1(n15), .B0(n20), .B1(B[5]), .Y(n25) );
  NOR2X2M U71 ( .A(n17), .B(n58), .Y(N23) );
  AOI22X1M U72 ( .A0(B[6]), .A1(n15), .B0(A[6]), .B1(n16), .Y(n17) );
  NOR2X2M U73 ( .A(n32), .B(n58), .Y(N16) );
  AOI22X1M U74 ( .A0(B[1]), .A1(n20), .B0(A[1]), .B1(n21), .Y(n32) );
  NOR2X2M U75 ( .A(n14), .B(n58), .Y(N24) );
  AOI22X1M U76 ( .A0(B[7]), .A1(n15), .B0(A[7]), .B1(n16), .Y(n14) );
  INVX2M U3 ( .A(1'b1), .Y(Shift_OUT[9]) );
  INVX2M U5 ( .A(1'b1), .Y(Shift_OUT[10]) );
  INVX2M U7 ( .A(1'b1), .Y(Shift_OUT[11]) );
  INVX2M U9 ( .A(1'b1), .Y(Shift_OUT[12]) );
  INVX2M U11 ( .A(1'b1), .Y(Shift_OUT[13]) );
  INVX2M U13 ( .A(1'b1), .Y(Shift_OUT[14]) );
  INVX2M U15 ( .A(1'b1), .Y(Shift_OUT[15]) );
endmodule


module OR_Gate ( Arith_Flag, Logic_Flag, CMP_Flag, Shift_Flag, OUT_VALID );
  input Arith_Flag, Logic_Flag, CMP_Flag, Shift_Flag;
  output OUT_VALID;


  OR4X1M U1 ( .A(CMP_Flag), .B(Arith_Flag), .C(Shift_Flag), .D(Logic_Flag), 
        .Y(OUT_VALID) );
endmodule


module ALU_test_1 ( A, B, ALU_FUN, CLK, RST, Enable, ALU_OUT, OUT_VALID, 
        test_si, test_so, test_se );
  input [7:0] A;
  input [7:0] B;
  input [3:0] ALU_FUN;
  output [15:0] ALU_OUT;
  input CLK, RST, Enable, test_si, test_se;
  output OUT_VALID, test_so;
  wire   Arith_Enable, Logic_Enable, CMP_Enable, Shift_Enable, Shift_OUT_7_,
         Shift_OUT_6_, Shift_OUT_5_, Shift_OUT_4_, Shift_OUT_3_, Shift_OUT_2_,
         Shift_OUT_1_, Shift_OUT_0_, Arith_Flag, Logic_Flag, CMP_Flag,
         Shift_Flag, n1, n2, n3, SYNOPSYS_UNCONNECTED_1,
         SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3,
         SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5,
         SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7,
         SYNOPSYS_UNCONNECTED_8, SYNOPSYS_UNCONNECTED_9,
         SYNOPSYS_UNCONNECTED_10, SYNOPSYS_UNCONNECTED_11,
         SYNOPSYS_UNCONNECTED_12, SYNOPSYS_UNCONNECTED_13,
         SYNOPSYS_UNCONNECTED_14, SYNOPSYS_UNCONNECTED_15,
         SYNOPSYS_UNCONNECTED_16, SYNOPSYS_UNCONNECTED_17,
         SYNOPSYS_UNCONNECTED_18, SYNOPSYS_UNCONNECTED_19,
         SYNOPSYS_UNCONNECTED_20, SYNOPSYS_UNCONNECTED_21;
  wire   [15:0] Arith_OUT;
  wire   [15:0] Logic_OUT;
  wire   [15:0] CMP_OUT;

  INVX4M U8 ( .A(n2), .Y(n1) );
  INVX2M U9 ( .A(RST), .Y(n2) );
  Decoder2X4 U1 ( .Enable(Enable), .ALU_FUN(ALU_FUN[3:2]), .Arith_Enable(
        Arith_Enable), .Logic_Enable(Logic_Enable), .CMP_Enable(CMP_Enable), 
        .Shift_Enable(Shift_Enable) );
  Decoder2X4_ALU_OUT_Width16 U7 ( .ALU_FUN(ALU_FUN[3:2]), .Arith_OUT(Arith_OUT), .Logic_OUT(Logic_OUT), .CMP_OUT({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, CMP_OUT[1:0]}), .Shift_OUT({
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, test_so, Shift_OUT_7_, 
        Shift_OUT_6_, Shift_OUT_5_, Shift_OUT_4_, Shift_OUT_3_, Shift_OUT_2_, 
        Shift_OUT_1_, Shift_OUT_0_}), .ALU_OUT(ALU_OUT) );
  Arithmatic_Unit_Width16_test_1 U2 ( .A(A), .B(B), .ALU_FUN(ALU_FUN[1:0]), 
        .CLK(CLK), .RST(n1), .Arith_Enable(Arith_Enable), .Arith_OUT(Arith_OUT), .Carry_OUT(n3), .Arith_Flag(Arith_Flag), .test_si(test_si), .test_se(test_se) );
  Logic_Unit_Width16_test_1 U3 ( .A(A), .B(B), .ALU_FUN(ALU_FUN[1:0]), .CLK(
        CLK), .Logic_Enable(Logic_Enable), .RST(n1), .Logic_OUT(Logic_OUT), 
        .Logic_Flag(Logic_Flag), .test_si(n3), .test_se(test_se) );
  CMP_Unit_Width16_test_1 U4 ( .A(A), .B(B), .ALU_FUN(ALU_FUN[1:0]), 
        .CMP_Enable(CMP_Enable), .CLK(CLK), .RST(n1), .CMP_OUT({
        SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
        SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5, SYNOPSYS_UNCONNECTED_6, 
        SYNOPSYS_UNCONNECTED_7, SYNOPSYS_UNCONNECTED_8, SYNOPSYS_UNCONNECTED_9, 
        SYNOPSYS_UNCONNECTED_10, SYNOPSYS_UNCONNECTED_11, 
        SYNOPSYS_UNCONNECTED_12, SYNOPSYS_UNCONNECTED_13, 
        SYNOPSYS_UNCONNECTED_14, CMP_OUT[1:0]}), .CMP_Flag(CMP_Flag), 
        .test_si(Logic_OUT[15]), .test_se(test_se) );
  Shift_Unit_Width16_test_1 U5 ( .A(A), .B(B), .ALU_FUN(ALU_FUN[1:0]), .CLK(
        CLK), .RST(n1), .Shift_Enable(Shift_Enable), .Shift_OUT({
        SYNOPSYS_UNCONNECTED_15, SYNOPSYS_UNCONNECTED_16, 
        SYNOPSYS_UNCONNECTED_17, SYNOPSYS_UNCONNECTED_18, 
        SYNOPSYS_UNCONNECTED_19, SYNOPSYS_UNCONNECTED_20, 
        SYNOPSYS_UNCONNECTED_21, test_so, Shift_OUT_7_, Shift_OUT_6_, 
        Shift_OUT_5_, Shift_OUT_4_, Shift_OUT_3_, Shift_OUT_2_, Shift_OUT_1_, 
        Shift_OUT_0_}), .Shift_Flag(Shift_Flag), .test_si(CMP_OUT[1]), 
        .test_se(test_se) );
  OR_Gate U6 ( .Arith_Flag(Arith_Flag), .Logic_Flag(Logic_Flag), .CMP_Flag(
        CMP_Flag), .Shift_Flag(Shift_Flag), .OUT_VALID(OUT_VALID) );
endmodule


module Reg_File_test_1 ( CLK, RST, RdEn, WrEn, Address, WrData, RdData, Reg0, 
        Reg1, Reg2, Reg3, RdData_Valid, test_si3, test_si2, test_si1, test_so1, 
        test_se );
  input [3:0] Address;
  input [7:0] WrData;
  output [7:0] RdData;
  output [7:0] Reg0;
  output [7:0] Reg1;
  output [7:0] Reg2;
  output [7:0] Reg3;
  input CLK, RST, RdEn, WrEn, test_si3, test_si2, test_si1, test_se;
  output RdData_Valid, test_so1;
  wire   n669, n670, n671, n672, n673, n674, n675, n676, n538, n539, n540,
         n541, n542, n543, n544, n545, n546, n547, n677, n678, n679, n680, n3,
         n681, n682, n683, MEM_15__7_, MEM_15__6_, MEM_15__5_, MEM_15__4_,
         MEM_15__3_, MEM_15__2_, MEM_15__1_, MEM_15__0_, MEM_14__7_,
         MEM_14__6_, MEM_14__5_, MEM_14__4_, MEM_14__3_, MEM_14__2_,
         MEM_14__1_, MEM_14__0_, MEM_13__7_, MEM_13__6_, MEM_13__5_,
         MEM_13__4_, MEM_13__3_, MEM_13__2_, MEM_13__1_, MEM_13__0_,
         MEM_12__7_, MEM_12__6_, MEM_12__5_, MEM_12__4_, MEM_12__3_,
         MEM_12__2_, MEM_12__1_, MEM_12__0_, MEM_11__7_, MEM_11__6_,
         MEM_11__5_, MEM_11__4_, MEM_11__3_, MEM_11__2_, MEM_11__1_,
         MEM_11__0_, MEM_10__7_, MEM_10__6_, MEM_10__5_, MEM_10__4_,
         MEM_10__3_, MEM_10__2_, MEM_10__1_, MEM_10__0_, MEM_9__7_, MEM_9__6_,
         MEM_9__5_, MEM_9__4_, MEM_9__3_, MEM_9__2_, MEM_9__1_, MEM_9__0_,
         MEM_8__7_, MEM_8__6_, MEM_8__5_, MEM_8__4_, MEM_8__3_, MEM_8__2_,
         MEM_8__1_, MEM_8__0_, MEM_7__7_, MEM_7__6_, MEM_7__5_, MEM_7__4_,
         MEM_7__3_, MEM_7__2_, MEM_7__1_, MEM_7__0_, MEM_6__7_, MEM_6__6_,
         MEM_6__5_, MEM_6__4_, MEM_6__3_, MEM_6__2_, MEM_6__1_, MEM_6__0_,
         MEM_5__7_, MEM_5__6_, MEM_5__5_, MEM_5__4_, MEM_5__3_, MEM_5__2_,
         MEM_5__1_, MEM_5__0_, MEM_4__7_, MEM_4__6_, MEM_4__5_, MEM_4__4_,
         MEM_4__3_, MEM_4__2_, MEM_4__1_, MEM_4__0_, N19, N20, N21, N22, N23,
         N24, N25, N26, n149, n150, n151, n152, n153, n154, n155, n156, n157,
         n158, n159, n160, n161, n162, n163, n164, n165, n166, n167, n168,
         n169, n170, n171, n172, n173, n174, n175, n176, n177, n178, n179,
         n180, n181, n182, n183, n184, n185, n186, n187, n188, n189, n190,
         n191, n192, n193, n194, n195, n196, n197, n198, n199, n200, n201,
         n202, n203, n204, n205, n206, n207, n208, n209, n210, n211, n212,
         n213, n214, n215, n216, n217, n218, n219, n220, n221, n222, n223,
         n224, n225, n226, n227, n228, n229, n230, n231, n232, n233, n234,
         n235, n236, n237, n238, n239, n240, n241, n242, n243, n244, n245,
         n246, n247, n248, n249, n250, n251, n252, n253, n254, n255, n256,
         n257, n258, n259, n260, n261, n262, n263, n264, n265, n266, n267,
         n268, n269, n270, n271, n272, n273, n274, n275, n276, n277, n278,
         n279, n280, n281, n282, n283, n284, n285, n286, n287, n288, n289,
         n290, n291, n292, n293, n294, n295, n296, n297, n298, n299, n300,
         n301, n302, n303, n304, n305, n306, n307, n308, n309, n310, n311,
         n312, n138, n140, n436, n440, n441, n442, n443, n444, n445, n446,
         n447, n448, n449, n450, n451, n452, n453, n454, n455, n456, n457,
         n458, n459, n460, n461, n462, n463, n464, n465, n466, n467, n468,
         n469, n470, n471, n472, n473, n474, n475, n476, n477, n478, n479,
         n480, n481, n482, n483, n484, n485, n486, n487, n488, n489, n490,
         n491, n492, n493, n494, n495, n496, n497, n498, n499, n500, n501,
         n502, n503, n504, n505, n506, n507, n508, n509, n510, n511, n512,
         n513, n514, n515, n516, n517, n518, n519, n520, n521, n522, n523,
         n524, n525, n526, n527, n528, n529, n530, n531, n532, n533, n534,
         n535, n536, n537, n554, n555, n556, n557, n574, n575, n576, n577,
         n578, n579, n580, n581, n582, n583, n584, n585, n586, n587, n588,
         n589, n590, n591, n592, n593, n594, n595, n596, n597, n598, n599,
         n600, n601, n602, n603, n604, n605, n606, n607, n608, n609, n610,
         n611, n612, n613, n614, n615, n616, n617, n618, n619, n620, n621,
         n622, n623, n624, n625, n626, n627, n628, n629, n630, n631, n632,
         n633, n634, n635, n636, n637, n638, n639, n640, n641, n642, n643,
         n644, n645, n646, n647, n648, n649, n650, n651, n652, n653, n654,
         n655, n656, n657, n658, n659, n660, n661, n662, n663, n664, n665,
         n666, n667, n668, n1;

  SDFFRHQX8M MEM_reg_2__4_ ( .D(n205), .SI(Reg2[3]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(Reg2[4]) );
  SDFFRHQX8M MEM_reg_1__5_ ( .D(n198), .SI(n555), .SE(test_se), .CK(CLK), .RN(
        n515), .Q(Reg1[5]) );
  SDFFRHQX8M MEM_reg_1__4_ ( .D(n197), .SI(Reg1[3]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(Reg1[4]) );
  SDFFRHQX8M MEM_reg_1__3_ ( .D(n196), .SI(Reg1[2]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(Reg1[3]) );
  SDFFRHQX8M MEM_reg_1__2_ ( .D(n195), .SI(n557), .SE(test_se), .CK(CLK), .RN(
        n515), .Q(Reg1[2]) );
  SDFFRHQX8M MEM_reg_1__1_ ( .D(n194), .SI(Reg1[0]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(Reg1[1]) );
  SDFFRHQX8M MEM_reg_1__0_ ( .D(n193), .SI(Reg0[7]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(Reg1[0]) );
  SDFFRQX1M MEM_reg_6__0_ ( .D(n233), .SI(n618), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_6__0_) );
  SDFFRQX1M MEM_reg_4__0_ ( .D(n217), .SI(Reg3[7]), .SE(test_se), .CK(CLK), 
        .RN(n517), .Q(MEM_4__0_) );
  SDFFRQX1M MEM_reg_11__7_ ( .D(n280), .SI(n627), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_11__7_) );
  SDFFRQX1M MEM_reg_11__6_ ( .D(n279), .SI(n626), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_11__6_) );
  SDFFRQX1M MEM_reg_11__5_ ( .D(n278), .SI(n625), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_11__5_) );
  SDFFRQX1M MEM_reg_11__4_ ( .D(n277), .SI(n624), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_11__4_) );
  SDFFRQX1M MEM_reg_11__3_ ( .D(n276), .SI(n623), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_11__3_) );
  SDFFRQX1M MEM_reg_11__2_ ( .D(n275), .SI(n622), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_11__2_) );
  SDFFRQX1M MEM_reg_11__1_ ( .D(n274), .SI(n643), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_11__1_) );
  SDFFRQX1M MEM_reg_14__0_ ( .D(n297), .SI(n611), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_14__0_) );
  SDFFRQX1M MEM_reg_12__0_ ( .D(n281), .SI(n628), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_12__0_) );
  SDFFRQX1M MEM_reg_8__0_ ( .D(n249), .SI(n642), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_8__0_) );
  SDFFRQX1M MEM_reg_10__0_ ( .D(n265), .SI(n604), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_10__0_) );
  SDFFRQX1M MEM_reg_9__4_ ( .D(n261), .SI(n600), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_9__4_) );
  SDFFRQX1M MEM_reg_9__3_ ( .D(n260), .SI(n599), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_9__3_) );
  SDFFRQX1M MEM_reg_9__2_ ( .D(n259), .SI(n598), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_9__2_) );
  SDFFRQX1M MEM_reg_9__1_ ( .D(n258), .SI(n619), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_9__1_) );
  SDFFRQX1M MEM_reg_6__7_ ( .D(n240), .SI(n593), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_6__7_) );
  SDFFRQX1M MEM_reg_6__6_ ( .D(n239), .SI(n592), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_6__6_) );
  SDFFRQX1M MEM_reg_6__5_ ( .D(n238), .SI(n591), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_6__5_) );
  SDFFRQX1M MEM_reg_6__4_ ( .D(n237), .SI(n590), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_6__4_) );
  SDFFRQX1M MEM_reg_6__3_ ( .D(n236), .SI(n589), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_6__3_) );
  SDFFRQX1M MEM_reg_6__2_ ( .D(n235), .SI(n588), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_6__2_) );
  SDFFRQX1M MEM_reg_6__1_ ( .D(n234), .SI(n597), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_6__1_) );
  SDFFRQX1M MEM_reg_4__7_ ( .D(n224), .SI(n664), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_4__7_) );
  SDFFRQX1M MEM_reg_4__6_ ( .D(n223), .SI(n663), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_4__6_) );
  SDFFRQX1M MEM_reg_4__5_ ( .D(n222), .SI(n662), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_4__5_) );
  SDFFRQX1M MEM_reg_4__4_ ( .D(n221), .SI(n661), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_4__4_) );
  SDFFRQX1M MEM_reg_4__3_ ( .D(n220), .SI(n660), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_4__3_) );
  SDFFRQX1M MEM_reg_4__2_ ( .D(n219), .SI(n659), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_4__2_) );
  SDFFRQX1M MEM_reg_4__1_ ( .D(n218), .SI(n668), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_4__1_) );
  SDFFRQX1M MEM_reg_2__7_ ( .D(n208), .SI(Reg2[6]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(n677) );
  SDFFRQX1M MEM_reg_2__6_ ( .D(n207), .SI(Reg2[5]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(n678) );
  SDFFRQX1M MEM_reg_2__2_ ( .D(n203), .SI(Reg2[1]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(n680) );
  SDFFRQX1M MEM_reg_14__7_ ( .D(n304), .SI(n586), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_14__7_) );
  SDFFRQX1M MEM_reg_14__6_ ( .D(n303), .SI(n585), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_14__6_) );
  SDFFRQX1M MEM_reg_14__5_ ( .D(n302), .SI(n584), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_14__5_) );
  SDFFRQX1M MEM_reg_14__4_ ( .D(n301), .SI(n583), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_14__4_) );
  SDFFRQX1M MEM_reg_14__3_ ( .D(n300), .SI(n582), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_14__3_) );
  SDFFRQX1M MEM_reg_14__2_ ( .D(n299), .SI(n581), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_14__2_) );
  SDFFRQX1M MEM_reg_14__1_ ( .D(n298), .SI(n596), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_14__1_) );
  SDFFRQX1M MEM_reg_12__7_ ( .D(n288), .SI(n657), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_12__7_) );
  SDFFRQX1M MEM_reg_12__6_ ( .D(n287), .SI(n656), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_12__6_) );
  SDFFRQX1M MEM_reg_12__5_ ( .D(n286), .SI(n655), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_12__5_) );
  SDFFRQX1M MEM_reg_12__4_ ( .D(n285), .SI(n654), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_12__4_) );
  SDFFRQX1M MEM_reg_12__3_ ( .D(n284), .SI(test_si3), .SE(test_se), .CK(CLK), 
        .RN(n522), .Q(MEM_12__3_) );
  SDFFRQX1M MEM_reg_12__2_ ( .D(n283), .SI(n653), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_12__2_) );
  SDFFRQX1M MEM_reg_12__1_ ( .D(n282), .SI(n667), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_12__1_) );
  SDFFRQX1M MEM_reg_8__7_ ( .D(n256), .SI(n651), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_8__7_) );
  SDFFRQX1M MEM_reg_8__6_ ( .D(n255), .SI(n650), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_8__6_) );
  SDFFRQX1M MEM_reg_8__5_ ( .D(n254), .SI(n649), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_8__5_) );
  SDFFRQX1M MEM_reg_8__4_ ( .D(n253), .SI(n648), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_8__4_) );
  SDFFRQX1M MEM_reg_8__3_ ( .D(n252), .SI(n647), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_8__3_) );
  SDFFRQX1M MEM_reg_8__2_ ( .D(n251), .SI(n646), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_8__2_) );
  SDFFRQX1M MEM_reg_8__1_ ( .D(n250), .SI(n666), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_8__1_) );
  SDFFRQX1M MEM_reg_10__7_ ( .D(n272), .SI(n579), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_10__7_) );
  SDFFRQX1M MEM_reg_10__6_ ( .D(n271), .SI(n578), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_10__6_) );
  SDFFRQX1M MEM_reg_10__5_ ( .D(n270), .SI(n577), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_10__5_) );
  SDFFRQX1M MEM_reg_10__4_ ( .D(n269), .SI(n576), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_10__4_) );
  SDFFRQX1M MEM_reg_10__3_ ( .D(n268), .SI(n575), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_10__3_) );
  SDFFRQX1M MEM_reg_10__2_ ( .D(n267), .SI(n574), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_10__2_) );
  SDFFRQX1M MEM_reg_10__1_ ( .D(n266), .SI(n595), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_10__1_) );
  SDFFRQX1M MEM_reg_0__7_ ( .D(n192), .SI(n554), .SE(test_se), .CK(CLK), .RN(
        n515), .Q(n538) );
  SDFFRQX1M RdData_reg_7_ ( .D(n184), .SI(RdData[6]), .SE(test_se), .CK(CLK), 
        .RN(n518), .Q(n669) );
  SDFFRQX1M RdData_reg_6_ ( .D(n183), .SI(RdData[5]), .SE(test_se), .CK(CLK), 
        .RN(n517), .Q(n670) );
  SDFFRQX1M RdData_reg_5_ ( .D(n182), .SI(RdData[4]), .SE(test_se), .CK(CLK), 
        .RN(n521), .Q(n671) );
  SDFFRQX1M RdData_reg_3_ ( .D(n180), .SI(RdData[2]), .SE(test_se), .CK(CLK), 
        .RN(n520), .Q(n673) );
  SDFFRQX1M RdData_reg_4_ ( .D(n181), .SI(RdData[3]), .SE(test_se), .CK(CLK), 
        .RN(n519), .Q(n672) );
  SDFFRQX1M RdData_reg_2_ ( .D(n179), .SI(RdData[1]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(n674) );
  SDFFRQX1M RdData_reg_0_ ( .D(n177), .SI(RdData_Valid), .SE(test_se), .CK(CLK), .RN(n515), .Q(n676) );
  SDFFRQX1M RdData_reg_1_ ( .D(n178), .SI(RdData[0]), .SE(test_se), .CK(CLK), 
        .RN(n527), .Q(n675) );
  SDFFRQX4M MEM_reg_2__1_ ( .D(n202), .SI(Reg2[0]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(Reg2[1]) );
  SDFFRQX2M MEM_reg_2__3_ ( .D(n204), .SI(Reg2[2]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(n679) );
  SDFFRQX2M MEM_reg_0__6_ ( .D(n191), .SI(Reg0[5]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(n539) );
  SDFFRQX2M MEM_reg_0__5_ ( .D(n190), .SI(Reg0[4]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(n540) );
  SDFFRQX2M MEM_reg_0__4_ ( .D(n189), .SI(Reg0[3]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(n541) );
  SDFFRQX2M MEM_reg_0__3_ ( .D(n188), .SI(Reg0[2]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(n542) );
  SDFFRQX2M MEM_reg_0__2_ ( .D(n187), .SI(Reg0[1]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(n543) );
  SDFFRQX2M MEM_reg_0__1_ ( .D(n186), .SI(Reg0[0]), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(n544) );
  SDFFRQX2M MEM_reg_0__0_ ( .D(n185), .SI(test_si1), .SE(test_se), .CK(CLK), 
        .RN(n515), .Q(n545) );
  INVX6M U140 ( .A(n140), .Y(Reg2[5]) );
  CLKINVX12M U141 ( .A(n436), .Y(Reg0[7]) );
  BUFX10M U142 ( .A(n545), .Y(Reg0[0]) );
  BUFX10M U143 ( .A(n544), .Y(Reg0[1]) );
  BUFX10M U144 ( .A(n543), .Y(Reg0[2]) );
  BUFX10M U145 ( .A(n542), .Y(Reg0[3]) );
  BUFX10M U146 ( .A(n541), .Y(Reg0[4]) );
  BUFX10M U147 ( .A(n540), .Y(Reg0[5]) );
  BUFX10M U148 ( .A(n539), .Y(Reg0[6]) );
  INVX4M U150 ( .A(n138), .Y(Reg3[3]) );
  BUFX10M U275 ( .A(n546), .Y(Reg1[7]) );
  BUFX10M U276 ( .A(n547), .Y(Reg1[6]) );
  INVX2M U277 ( .A(n538), .Y(n436) );
  CLKBUFX2M U278 ( .A(n528), .Y(n525) );
  CLKBUFX2M U279 ( .A(n528), .Y(n526) );
  CLKBUFX2M U280 ( .A(n527), .Y(n524) );
  NOR2X6M U281 ( .A(n514), .B(Address[2]), .Y(n156) );
  NOR2X6M U282 ( .A(n474), .B(Address[2]), .Y(n151) );
  CLKBUFX6M U283 ( .A(n149), .Y(n478) );
  BUFX10M U284 ( .A(Address[1]), .Y(n473) );
  BUFX10M U285 ( .A(Address[1]), .Y(n474) );
  CLKBUFX6M U286 ( .A(n473), .Y(n472) );
  BUFX10M U287 ( .A(n511), .Y(n476) );
  BUFX10M U288 ( .A(n511), .Y(n477) );
  BUFX6M U289 ( .A(n511), .Y(n475) );
  CLKBUFX6M U290 ( .A(n153), .Y(n508) );
  CLKBUFX6M U291 ( .A(n166), .Y(n494) );
  CLKBUFX6M U292 ( .A(n168), .Y(n492) );
  CLKBUFX6M U293 ( .A(n170), .Y(n490) );
  CLKBUFX6M U294 ( .A(n171), .Y(n488) );
  CLKBUFX6M U295 ( .A(n155), .Y(n506) );
  CLKBUFX6M U296 ( .A(n157), .Y(n504) );
  CLKBUFX6M U297 ( .A(n158), .Y(n502) );
  CLKBUFX6M U298 ( .A(n160), .Y(n500) );
  CLKBUFX6M U299 ( .A(n161), .Y(n498) );
  CLKBUFX6M U300 ( .A(n164), .Y(n496) );
  CLKBUFX6M U301 ( .A(n172), .Y(n486) );
  CLKBUFX6M U302 ( .A(n173), .Y(n484) );
  CLKBUFX6M U303 ( .A(n174), .Y(n482) );
  CLKBUFX6M U304 ( .A(n176), .Y(n480) );
  CLKBUFX6M U305 ( .A(n150), .Y(n510) );
  CLKBUFX4M U306 ( .A(n153), .Y(n507) );
  CLKBUFX4M U307 ( .A(n166), .Y(n493) );
  CLKBUFX4M U308 ( .A(n168), .Y(n491) );
  CLKBUFX4M U309 ( .A(n170), .Y(n489) );
  CLKBUFX4M U310 ( .A(n171), .Y(n487) );
  CLKBUFX4M U311 ( .A(n155), .Y(n505) );
  CLKBUFX4M U312 ( .A(n157), .Y(n503) );
  CLKBUFX4M U313 ( .A(n172), .Y(n485) );
  CLKBUFX4M U314 ( .A(n173), .Y(n483) );
  CLKBUFX4M U315 ( .A(n174), .Y(n481) );
  CLKBUFX4M U316 ( .A(n176), .Y(n479) );
  CLKBUFX4M U317 ( .A(n158), .Y(n501) );
  CLKBUFX4M U318 ( .A(n160), .Y(n499) );
  CLKBUFX4M U319 ( .A(n161), .Y(n497) );
  CLKBUFX4M U320 ( .A(n164), .Y(n495) );
  CLKBUFX4M U321 ( .A(n150), .Y(n509) );
  BUFX10M U322 ( .A(n527), .Y(n515) );
  BUFX10M U323 ( .A(n526), .Y(n516) );
  BUFX10M U324 ( .A(n526), .Y(n517) );
  BUFX10M U325 ( .A(n526), .Y(n518) );
  BUFX10M U326 ( .A(n525), .Y(n519) );
  BUFX10M U327 ( .A(n525), .Y(n520) );
  BUFX10M U328 ( .A(n525), .Y(n521) );
  BUFX10M U329 ( .A(n524), .Y(n522) );
  BUFX10M U330 ( .A(n524), .Y(n523) );
  NOR2BX8M U331 ( .AN(n163), .B(n511), .Y(n152) );
  NOR2BX8M U332 ( .AN(n175), .B(n511), .Y(n167) );
  NAND2X2M U333 ( .A(n151), .B(n152), .Y(n150) );
  NAND2X2M U334 ( .A(n156), .B(n152), .Y(n155) );
  NAND2X2M U335 ( .A(n156), .B(n154), .Y(n157) );
  NAND2X2M U336 ( .A(n154), .B(n151), .Y(n153) );
  NAND2X2M U337 ( .A(n159), .B(n152), .Y(n158) );
  NAND2X2M U338 ( .A(n159), .B(n154), .Y(n160) );
  NAND2X2M U339 ( .A(n162), .B(n152), .Y(n161) );
  NAND2X2M U340 ( .A(n162), .B(n154), .Y(n164) );
  NAND2X2M U341 ( .A(n169), .B(n151), .Y(n168) );
  NAND2X2M U342 ( .A(n169), .B(n156), .Y(n171) );
  NAND2X2M U343 ( .A(n169), .B(n159), .Y(n173) );
  NAND2X2M U344 ( .A(n169), .B(n162), .Y(n176) );
  NAND2X2M U345 ( .A(n167), .B(n151), .Y(n166) );
  NAND2X2M U346 ( .A(n167), .B(n156), .Y(n170) );
  NAND2X2M U347 ( .A(n167), .B(n159), .Y(n172) );
  NAND2X2M U348 ( .A(n167), .B(n162), .Y(n174) );
  INVX6M U349 ( .A(n478), .Y(n529) );
  CLKBUFX2M U350 ( .A(n528), .Y(n527) );
  NOR2BX8M U351 ( .AN(n163), .B(n512), .Y(n154) );
  NOR2BX8M U352 ( .AN(Address[2]), .B(n474), .Y(n159) );
  NOR2BX8M U353 ( .AN(Address[2]), .B(n514), .Y(n162) );
  NOR2BX8M U354 ( .AN(n175), .B(n512), .Y(n169) );
  NOR2BX4M U355 ( .AN(n165), .B(Address[3]), .Y(n163) );
  NOR2BX4M U356 ( .AN(WrEn), .B(RdEn), .Y(n165) );
  AND2X2M U357 ( .A(Address[3]), .B(n165), .Y(n175) );
  INVX2M U358 ( .A(Address[1]), .Y(n514) );
  INVX4M U359 ( .A(n512), .Y(n511) );
  NAND2BX2M U360 ( .AN(WrEn), .B(RdEn), .Y(n149) );
  CLKINVX12M U361 ( .A(WrData[0]), .Y(n537) );
  CLKINVX12M U362 ( .A(WrData[1]), .Y(n536) );
  CLKINVX12M U363 ( .A(WrData[2]), .Y(n535) );
  CLKINVX12M U364 ( .A(WrData[3]), .Y(n534) );
  CLKINVX12M U365 ( .A(WrData[4]), .Y(n533) );
  CLKINVX12M U366 ( .A(WrData[5]), .Y(n532) );
  CLKINVX12M U367 ( .A(WrData[6]), .Y(n531) );
  BUFX4M U368 ( .A(n513), .Y(n512) );
  INVX2M U369 ( .A(Address[0]), .Y(n513) );
  CLKBUFX2M U370 ( .A(RST), .Y(n528) );
  CLKINVX12M U371 ( .A(WrData[7]), .Y(n530) );
  OAI2BB2X1M U372 ( .B0(n510), .B1(n537), .A0N(Reg0[0]), .A1N(n510), .Y(n185)
         );
  OAI2BB2X1M U373 ( .B0(n509), .B1(n536), .A0N(Reg0[1]), .A1N(n510), .Y(n186)
         );
  OAI2BB2X1M U374 ( .B0(n509), .B1(n535), .A0N(Reg0[2]), .A1N(n510), .Y(n187)
         );
  OAI2BB2X1M U375 ( .B0(n509), .B1(n534), .A0N(Reg0[3]), .A1N(n510), .Y(n188)
         );
  OAI2BB2X1M U376 ( .B0(n509), .B1(n533), .A0N(Reg0[4]), .A1N(n510), .Y(n189)
         );
  OAI2BB2X1M U377 ( .B0(n509), .B1(n532), .A0N(Reg0[5]), .A1N(n510), .Y(n190)
         );
  OAI2BB2X1M U378 ( .B0(n509), .B1(n531), .A0N(n554), .A1N(n510), .Y(n191) );
  OAI2BB2X1M U379 ( .B0(n509), .B1(n530), .A0N(Reg0[7]), .A1N(n510), .Y(n192)
         );
  OAI2BB2X1M U380 ( .B0(n537), .B1(n508), .A0N(Reg1[0]), .A1N(n508), .Y(n193)
         );
  OAI2BB2X1M U381 ( .B0(n536), .B1(n507), .A0N(n557), .A1N(n508), .Y(n194) );
  OAI2BB2X1M U382 ( .B0(n535), .B1(n507), .A0N(Reg1[2]), .A1N(n508), .Y(n195)
         );
  OAI2BB2X1M U383 ( .B0(n534), .B1(n507), .A0N(Reg1[3]), .A1N(n508), .Y(n196)
         );
  OAI2BB2X1M U384 ( .B0(n533), .B1(n507), .A0N(n555), .A1N(n508), .Y(n197) );
  OAI2BB2X1M U385 ( .B0(n532), .B1(n507), .A0N(n556), .A1N(n508), .Y(n198) );
  OAI2BB2X1M U386 ( .B0(n531), .B1(n507), .A0N(Reg1[6]), .A1N(n508), .Y(n199)
         );
  OAI2BB2X1M U387 ( .B0(n536), .B1(n505), .A0N(Reg2[1]), .A1N(n506), .Y(n202)
         );
  OAI2BB2X1M U388 ( .B0(n535), .B1(n505), .A0N(Reg2[2]), .A1N(n506), .Y(n203)
         );
  OAI2BB2X1M U389 ( .B0(n534), .B1(n505), .A0N(n679), .A1N(n506), .Y(n204) );
  OAI2BB2X1M U390 ( .B0(n533), .B1(n505), .A0N(Reg2[4]), .A1N(n506), .Y(n205)
         );
  OAI2BB2X1M U391 ( .B0(n531), .B1(n505), .A0N(Reg2[6]), .A1N(n506), .Y(n207)
         );
  OAI2BB2X1M U392 ( .B0(n537), .B1(n504), .A0N(Reg3[0]), .A1N(n504), .Y(n209)
         );
  OAI2BB2X1M U393 ( .B0(n536), .B1(n503), .A0N(Reg3[1]), .A1N(n504), .Y(n210)
         );
  OAI2BB2X1M U394 ( .B0(n535), .B1(n503), .A0N(Reg3[2]), .A1N(n504), .Y(n211)
         );
  OAI2BB2X1M U395 ( .B0(n533), .B1(n503), .A0N(Reg3[4]), .A1N(n504), .Y(n213)
         );
  OAI2BB2X1M U396 ( .B0(n532), .B1(n503), .A0N(Reg3[5]), .A1N(n504), .Y(n214)
         );
  OAI2BB2X1M U397 ( .B0(n531), .B1(n503), .A0N(Reg3[6]), .A1N(n504), .Y(n215)
         );
  OAI2BB2X1M U398 ( .B0(n537), .B1(n502), .A0N(n668), .A1N(n502), .Y(n217) );
  OAI2BB2X1M U399 ( .B0(n536), .B1(n501), .A0N(n659), .A1N(n502), .Y(n218) );
  OAI2BB2X1M U400 ( .B0(n535), .B1(n501), .A0N(n660), .A1N(n502), .Y(n219) );
  OAI2BB2X1M U401 ( .B0(n534), .B1(n501), .A0N(n661), .A1N(n502), .Y(n220) );
  OAI2BB2X1M U402 ( .B0(n533), .B1(n501), .A0N(n662), .A1N(n502), .Y(n221) );
  OAI2BB2X1M U403 ( .B0(n532), .B1(n501), .A0N(n663), .A1N(n502), .Y(n222) );
  OAI2BB2X1M U404 ( .B0(n531), .B1(n501), .A0N(n664), .A1N(n502), .Y(n223) );
  OAI2BB2X1M U405 ( .B0(n537), .B1(n500), .A0N(n621), .A1N(n500), .Y(n225) );
  OAI2BB2X1M U406 ( .B0(n536), .B1(n499), .A0N(n612), .A1N(n500), .Y(n226) );
  OAI2BB2X1M U407 ( .B0(n535), .B1(n499), .A0N(n613), .A1N(n500), .Y(n227) );
  OAI2BB2X1M U408 ( .B0(n534), .B1(n499), .A0N(n614), .A1N(n500), .Y(n228) );
  OAI2BB2X1M U409 ( .B0(n533), .B1(n499), .A0N(n615), .A1N(n500), .Y(n229) );
  OAI2BB2X1M U410 ( .B0(n532), .B1(n499), .A0N(n616), .A1N(n500), .Y(n230) );
  OAI2BB2X1M U411 ( .B0(n531), .B1(n499), .A0N(n617), .A1N(n500), .Y(n231) );
  OAI2BB2X1M U412 ( .B0(n537), .B1(n498), .A0N(n597), .A1N(n498), .Y(n233) );
  OAI2BB2X1M U413 ( .B0(n536), .B1(n497), .A0N(n588), .A1N(n498), .Y(n234) );
  OAI2BB2X1M U414 ( .B0(n535), .B1(n497), .A0N(n589), .A1N(n498), .Y(n235) );
  OAI2BB2X1M U415 ( .B0(n534), .B1(n497), .A0N(n590), .A1N(n498), .Y(n236) );
  OAI2BB2X1M U416 ( .B0(n533), .B1(n497), .A0N(n591), .A1N(n498), .Y(n237) );
  OAI2BB2X1M U417 ( .B0(n532), .B1(n497), .A0N(n592), .A1N(n498), .Y(n238) );
  OAI2BB2X1M U418 ( .B0(n531), .B1(n497), .A0N(n593), .A1N(n498), .Y(n239) );
  OAI2BB2X1M U419 ( .B0(n537), .B1(n496), .A0N(n645), .A1N(n496), .Y(n241) );
  OAI2BB2X1M U420 ( .B0(n536), .B1(n495), .A0N(n636), .A1N(n496), .Y(n242) );
  OAI2BB2X1M U421 ( .B0(n535), .B1(n495), .A0N(n637), .A1N(n496), .Y(n243) );
  OAI2BB2X1M U422 ( .B0(n534), .B1(n495), .A0N(n638), .A1N(n496), .Y(n244) );
  OAI2BB2X1M U423 ( .B0(n533), .B1(n495), .A0N(n639), .A1N(n496), .Y(n245) );
  OAI2BB2X1M U424 ( .B0(n532), .B1(n495), .A0N(n640), .A1N(n496), .Y(n246) );
  OAI2BB2X1M U425 ( .B0(n531), .B1(n495), .A0N(n641), .A1N(n496), .Y(n247) );
  OAI2BB2X1M U426 ( .B0(n537), .B1(n494), .A0N(n666), .A1N(n494), .Y(n249) );
  OAI2BB2X1M U427 ( .B0(n536), .B1(n493), .A0N(n646), .A1N(n494), .Y(n250) );
  OAI2BB2X1M U428 ( .B0(n535), .B1(n493), .A0N(n647), .A1N(n494), .Y(n251) );
  OAI2BB2X1M U429 ( .B0(n534), .B1(n493), .A0N(n648), .A1N(n494), .Y(n252) );
  OAI2BB2X1M U430 ( .B0(n533), .B1(n493), .A0N(n649), .A1N(n494), .Y(n253) );
  OAI2BB2X1M U431 ( .B0(n532), .B1(n493), .A0N(n650), .A1N(n494), .Y(n254) );
  OAI2BB2X1M U432 ( .B0(n531), .B1(n493), .A0N(n651), .A1N(n494), .Y(n255) );
  OAI2BB2X1M U433 ( .B0(n537), .B1(n492), .A0N(n619), .A1N(n492), .Y(n257) );
  OAI2BB2X1M U434 ( .B0(n536), .B1(n491), .A0N(n598), .A1N(n492), .Y(n258) );
  OAI2BB2X1M U435 ( .B0(n535), .B1(n491), .A0N(n599), .A1N(n492), .Y(n259) );
  OAI2BB2X1M U436 ( .B0(n534), .B1(n491), .A0N(n600), .A1N(n492), .Y(n260) );
  OAI2BB2X1M U437 ( .B0(n533), .B1(n491), .A0N(n601), .A1N(n492), .Y(n261) );
  OAI2BB2X1M U438 ( .B0(n532), .B1(n491), .A0N(n602), .A1N(n492), .Y(n262) );
  OAI2BB2X1M U439 ( .B0(n531), .B1(n491), .A0N(n603), .A1N(n492), .Y(n263) );
  OAI2BB2X1M U440 ( .B0(n537), .B1(n490), .A0N(n595), .A1N(n490), .Y(n265) );
  OAI2BB2X1M U441 ( .B0(n536), .B1(n489), .A0N(n574), .A1N(n490), .Y(n266) );
  OAI2BB2X1M U442 ( .B0(n535), .B1(n489), .A0N(n575), .A1N(n490), .Y(n267) );
  OAI2BB2X1M U443 ( .B0(n534), .B1(n489), .A0N(n576), .A1N(n490), .Y(n268) );
  OAI2BB2X1M U444 ( .B0(n533), .B1(n489), .A0N(n577), .A1N(n490), .Y(n269) );
  OAI2BB2X1M U445 ( .B0(n532), .B1(n489), .A0N(n578), .A1N(n490), .Y(n270) );
  OAI2BB2X1M U446 ( .B0(n531), .B1(n489), .A0N(n579), .A1N(n490), .Y(n271) );
  OAI2BB2X1M U447 ( .B0(n537), .B1(n488), .A0N(n643), .A1N(n488), .Y(n273) );
  OAI2BB2X1M U448 ( .B0(n536), .B1(n487), .A0N(n622), .A1N(n488), .Y(n274) );
  OAI2BB2X1M U449 ( .B0(n535), .B1(n487), .A0N(n623), .A1N(n488), .Y(n275) );
  OAI2BB2X1M U450 ( .B0(n534), .B1(n487), .A0N(n624), .A1N(n488), .Y(n276) );
  OAI2BB2X1M U451 ( .B0(n533), .B1(n487), .A0N(n625), .A1N(n488), .Y(n277) );
  OAI2BB2X1M U452 ( .B0(n532), .B1(n487), .A0N(n626), .A1N(n488), .Y(n278) );
  OAI2BB2X1M U453 ( .B0(n531), .B1(n487), .A0N(n627), .A1N(n488), .Y(n279) );
  OAI2BB2X1M U454 ( .B0(n537), .B1(n486), .A0N(n667), .A1N(n486), .Y(n281) );
  OAI2BB2X1M U455 ( .B0(n536), .B1(n485), .A0N(n653), .A1N(n486), .Y(n282) );
  OAI2BB2X1M U456 ( .B0(n535), .B1(n485), .A0N(test_so1), .A1N(n486), .Y(n283)
         );
  OAI2BB2X1M U457 ( .B0(n534), .B1(n485), .A0N(n654), .A1N(n486), .Y(n284) );
  OAI2BB2X1M U458 ( .B0(n533), .B1(n485), .A0N(n655), .A1N(n486), .Y(n285) );
  OAI2BB2X1M U459 ( .B0(n532), .B1(n485), .A0N(n656), .A1N(n486), .Y(n286) );
  OAI2BB2X1M U460 ( .B0(n531), .B1(n485), .A0N(n657), .A1N(n486), .Y(n287) );
  OAI2BB2X1M U461 ( .B0(n537), .B1(n484), .A0N(n620), .A1N(n484), .Y(n289) );
  OAI2BB2X1M U462 ( .B0(n536), .B1(n483), .A0N(n605), .A1N(n484), .Y(n290) );
  OAI2BB2X1M U463 ( .B0(n535), .B1(n483), .A0N(n606), .A1N(n484), .Y(n291) );
  OAI2BB2X1M U464 ( .B0(n534), .B1(n483), .A0N(n607), .A1N(n484), .Y(n292) );
  OAI2BB2X1M U465 ( .B0(n533), .B1(n483), .A0N(n608), .A1N(n484), .Y(n293) );
  OAI2BB2X1M U466 ( .B0(n532), .B1(n483), .A0N(n609), .A1N(n484), .Y(n294) );
  OAI2BB2X1M U467 ( .B0(n531), .B1(n483), .A0N(n610), .A1N(n484), .Y(n295) );
  OAI2BB2X1M U468 ( .B0(n537), .B1(n482), .A0N(n596), .A1N(n482), .Y(n297) );
  OAI2BB2X1M U469 ( .B0(n536), .B1(n481), .A0N(n581), .A1N(n482), .Y(n298) );
  OAI2BB2X1M U470 ( .B0(n535), .B1(n481), .A0N(n582), .A1N(n482), .Y(n299) );
  OAI2BB2X1M U471 ( .B0(n534), .B1(n481), .A0N(n583), .A1N(n482), .Y(n300) );
  OAI2BB2X1M U472 ( .B0(n533), .B1(n481), .A0N(n584), .A1N(n482), .Y(n301) );
  OAI2BB2X1M U473 ( .B0(n532), .B1(n481), .A0N(n585), .A1N(n482), .Y(n302) );
  OAI2BB2X1M U474 ( .B0(n531), .B1(n481), .A0N(n586), .A1N(n482), .Y(n303) );
  OAI2BB2X1M U475 ( .B0(n537), .B1(n480), .A0N(n644), .A1N(n480), .Y(n305) );
  OAI2BB2X1M U476 ( .B0(n536), .B1(n479), .A0N(n629), .A1N(n480), .Y(n306) );
  OAI2BB2X1M U477 ( .B0(n535), .B1(n479), .A0N(n630), .A1N(n480), .Y(n307) );
  OAI2BB2X1M U478 ( .B0(n534), .B1(n479), .A0N(n631), .A1N(n480), .Y(n308) );
  OAI2BB2X1M U479 ( .B0(n533), .B1(n479), .A0N(n632), .A1N(n480), .Y(n309) );
  OAI2BB2X1M U480 ( .B0(n532), .B1(n479), .A0N(n633), .A1N(n480), .Y(n310) );
  OAI2BB2X1M U481 ( .B0(n531), .B1(n479), .A0N(n634), .A1N(n480), .Y(n311) );
  OAI2BB2X1M U482 ( .B0(n530), .B1(n507), .A0N(Reg1[7]), .A1N(n508), .Y(n200)
         );
  OAI2BB2X1M U483 ( .B0(n530), .B1(n505), .A0N(Reg2[7]), .A1N(n506), .Y(n208)
         );
  OAI2BB2X1M U484 ( .B0(n530), .B1(n503), .A0N(Reg3[7]), .A1N(n504), .Y(n216)
         );
  OAI2BB2X1M U485 ( .B0(n530), .B1(n501), .A0N(n665), .A1N(n502), .Y(n224) );
  OAI2BB2X1M U486 ( .B0(n530), .B1(n499), .A0N(n618), .A1N(n500), .Y(n232) );
  OAI2BB2X1M U487 ( .B0(n530), .B1(n497), .A0N(n594), .A1N(n498), .Y(n240) );
  OAI2BB2X1M U488 ( .B0(n530), .B1(n495), .A0N(n642), .A1N(n496), .Y(n248) );
  OAI2BB2X1M U489 ( .B0(n530), .B1(n493), .A0N(n652), .A1N(n494), .Y(n256) );
  OAI2BB2X1M U490 ( .B0(n530), .B1(n491), .A0N(n604), .A1N(n492), .Y(n264) );
  OAI2BB2X1M U491 ( .B0(n530), .B1(n489), .A0N(n580), .A1N(n490), .Y(n272) );
  OAI2BB2X1M U492 ( .B0(n530), .B1(n487), .A0N(n628), .A1N(n488), .Y(n280) );
  OAI2BB2X1M U493 ( .B0(n530), .B1(n485), .A0N(n658), .A1N(n486), .Y(n288) );
  OAI2BB2X1M U494 ( .B0(n530), .B1(n483), .A0N(n611), .A1N(n484), .Y(n296) );
  OAI2BB2X1M U495 ( .B0(n530), .B1(n481), .A0N(n587), .A1N(n482), .Y(n304) );
  OAI2BB2X1M U496 ( .B0(n530), .B1(n479), .A0N(n635), .A1N(n480), .Y(n312) );
  OAI2BB2X1M U497 ( .B0(n537), .B1(n506), .A0N(Reg2[0]), .A1N(n506), .Y(n201)
         );
  OAI2BB2X1M U498 ( .B0(n532), .B1(n505), .A0N(Reg2[5]), .A1N(n506), .Y(n206)
         );
  OAI2BB2X1M U499 ( .B0(n534), .B1(n503), .A0N(Reg3[3]), .A1N(n504), .Y(n212)
         );
  MX4X1M U500 ( .A(MEM_4__2_), .B(MEM_5__2_), .C(MEM_6__2_), .D(MEM_7__2_), 
        .S0(n476), .S1(n473), .Y(n450) );
  MX4X1M U501 ( .A(MEM_4__3_), .B(MEM_5__3_), .C(MEM_6__3_), .D(MEM_7__3_), 
        .S0(n476), .S1(n473), .Y(n454) );
  MX4X1M U502 ( .A(MEM_4__4_), .B(MEM_5__4_), .C(MEM_6__4_), .D(MEM_7__4_), 
        .S0(n476), .S1(n473), .Y(n458) );
  MX4X1M U503 ( .A(MEM_4__5_), .B(MEM_5__5_), .C(MEM_6__5_), .D(MEM_7__5_), 
        .S0(n477), .S1(n474), .Y(n462) );
  MX4X1M U504 ( .A(MEM_4__6_), .B(MEM_5__6_), .C(MEM_6__6_), .D(MEM_7__6_), 
        .S0(n477), .S1(n474), .Y(n466) );
  MX4X1M U505 ( .A(MEM_4__7_), .B(MEM_5__7_), .C(MEM_6__7_), .D(MEM_7__7_), 
        .S0(n477), .S1(n474), .Y(n470) );
  MX4X1M U506 ( .A(MEM_12__2_), .B(MEM_13__2_), .C(MEM_14__2_), .D(MEM_15__2_), 
        .S0(n476), .S1(n473), .Y(n448) );
  MX4X1M U507 ( .A(MEM_12__3_), .B(MEM_13__3_), .C(MEM_14__3_), .D(MEM_15__3_), 
        .S0(n476), .S1(n473), .Y(n452) );
  MX4X1M U508 ( .A(MEM_12__4_), .B(MEM_13__4_), .C(MEM_14__4_), .D(MEM_15__4_), 
        .S0(n476), .S1(n473), .Y(n456) );
  MX4X1M U509 ( .A(MEM_12__5_), .B(MEM_13__5_), .C(MEM_14__5_), .D(MEM_15__5_), 
        .S0(n477), .S1(n474), .Y(n460) );
  MX4X1M U510 ( .A(MEM_12__6_), .B(MEM_13__6_), .C(MEM_14__6_), .D(MEM_15__6_), 
        .S0(n477), .S1(n474), .Y(n464) );
  MX4X1M U511 ( .A(MEM_12__7_), .B(MEM_13__7_), .C(MEM_14__7_), .D(MEM_15__7_), 
        .S0(n477), .S1(n474), .Y(n468) );
  MX4X1M U512 ( .A(MEM_4__0_), .B(MEM_5__0_), .C(MEM_6__0_), .D(MEM_7__0_), 
        .S0(n475), .S1(n472), .Y(n442) );
  MX4X1M U513 ( .A(MEM_4__1_), .B(MEM_5__1_), .C(MEM_6__1_), .D(MEM_7__1_), 
        .S0(n475), .S1(n472), .Y(n446) );
  MX4X1M U514 ( .A(MEM_12__0_), .B(MEM_13__0_), .C(MEM_14__0_), .D(MEM_15__0_), 
        .S0(n475), .S1(n472), .Y(n440) );
  MX4X1M U515 ( .A(MEM_12__1_), .B(MEM_13__1_), .C(MEM_14__1_), .D(MEM_15__1_), 
        .S0(n475), .S1(n472), .Y(n444) );
  AO22X1M U516 ( .A0(N26), .A1(n529), .B0(n478), .B1(n676), .Y(n177) );
  MX4XLM U517 ( .A(n443), .B(n441), .C(n442), .D(n440), .S0(Address[3]), .S1(
        Address[2]), .Y(N26) );
  MX4XLM U518 ( .A(Reg0[0]), .B(Reg1[0]), .C(Reg2[0]), .D(Reg3[0]), .S0(n475), 
        .S1(n472), .Y(n443) );
  MX4X1M U519 ( .A(MEM_8__0_), .B(MEM_9__0_), .C(MEM_10__0_), .D(MEM_11__0_), 
        .S0(n475), .S1(n472), .Y(n441) );
  AO22X1M U520 ( .A0(N25), .A1(n529), .B0(n478), .B1(n675), .Y(n178) );
  MX4XLM U521 ( .A(n447), .B(n445), .C(n446), .D(n444), .S0(Address[3]), .S1(
        Address[2]), .Y(N25) );
  MX4XLM U522 ( .A(Reg0[1]), .B(Reg1[1]), .C(Reg2[1]), .D(Reg3[1]), .S0(n475), 
        .S1(n472), .Y(n447) );
  MX4X1M U523 ( .A(MEM_8__1_), .B(MEM_9__1_), .C(MEM_10__1_), .D(MEM_11__1_), 
        .S0(n475), .S1(n472), .Y(n445) );
  AO22X1M U524 ( .A0(N24), .A1(n529), .B0(n478), .B1(n674), .Y(n179) );
  MX4XLM U525 ( .A(n451), .B(n449), .C(n450), .D(n448), .S0(Address[3]), .S1(
        Address[2]), .Y(N24) );
  MX4XLM U526 ( .A(Reg0[2]), .B(Reg1[2]), .C(n680), .D(Reg3[2]), .S0(n476), 
        .S1(n473), .Y(n451) );
  MX4X1M U527 ( .A(MEM_8__2_), .B(MEM_9__2_), .C(MEM_10__2_), .D(MEM_11__2_), 
        .S0(n476), .S1(n473), .Y(n449) );
  AO22X1M U528 ( .A0(N23), .A1(n529), .B0(n478), .B1(n673), .Y(n180) );
  MX4XLM U529 ( .A(n455), .B(n453), .C(n454), .D(n452), .S0(Address[3]), .S1(
        Address[2]), .Y(N23) );
  MX4XLM U530 ( .A(Reg0[3]), .B(Reg1[3]), .C(n679), .D(Reg3[3]), .S0(n476), 
        .S1(n473), .Y(n455) );
  MX4X1M U531 ( .A(MEM_8__3_), .B(MEM_9__3_), .C(MEM_10__3_), .D(MEM_11__3_), 
        .S0(n476), .S1(n473), .Y(n453) );
  AO22X1M U532 ( .A0(N22), .A1(n529), .B0(n478), .B1(n672), .Y(n181) );
  MX4XLM U533 ( .A(n459), .B(n457), .C(n458), .D(n456), .S0(Address[3]), .S1(
        Address[2]), .Y(N22) );
  MX4XLM U534 ( .A(Reg0[4]), .B(Reg1[4]), .C(Reg2[4]), .D(Reg3[4]), .S0(n476), 
        .S1(n473), .Y(n459) );
  MX4X1M U535 ( .A(MEM_8__4_), .B(MEM_9__4_), .C(MEM_10__4_), .D(MEM_11__4_), 
        .S0(n476), .S1(n473), .Y(n457) );
  AO22X1M U536 ( .A0(N21), .A1(n529), .B0(n478), .B1(n671), .Y(n182) );
  MX4XLM U537 ( .A(n463), .B(n461), .C(n462), .D(n460), .S0(Address[3]), .S1(
        Address[2]), .Y(N21) );
  MX4XLM U538 ( .A(Reg0[5]), .B(Reg1[5]), .C(Reg2[5]), .D(n683), .S0(n477), 
        .S1(n474), .Y(n463) );
  MX4X1M U539 ( .A(MEM_8__5_), .B(MEM_9__5_), .C(MEM_10__5_), .D(MEM_11__5_), 
        .S0(n477), .S1(n474), .Y(n461) );
  AO22X1M U540 ( .A0(N20), .A1(n529), .B0(n478), .B1(n670), .Y(n183) );
  MX4XLM U541 ( .A(n467), .B(n465), .C(n466), .D(n464), .S0(Address[3]), .S1(
        Address[2]), .Y(N20) );
  MX4XLM U542 ( .A(n554), .B(Reg1[6]), .C(n678), .D(n682), .S0(n477), .S1(n474), .Y(n467) );
  MX4X1M U543 ( .A(MEM_8__6_), .B(MEM_9__6_), .C(MEM_10__6_), .D(MEM_11__6_), 
        .S0(n477), .S1(n474), .Y(n465) );
  AO22X1M U544 ( .A0(N19), .A1(n529), .B0(n478), .B1(n669), .Y(n184) );
  MX4XLM U545 ( .A(n471), .B(n469), .C(n470), .D(n468), .S0(Address[3]), .S1(
        Address[2]), .Y(N19) );
  MX4XLM U546 ( .A(Reg0[7]), .B(Reg1[7]), .C(n677), .D(n681), .S0(n477), .S1(
        n474), .Y(n471) );
  MX4X1M U547 ( .A(MEM_8__7_), .B(MEM_9__7_), .C(MEM_10__7_), .D(MEM_11__7_), 
        .S0(n477), .S1(n474), .Y(n469) );
  BUFX10M U548 ( .A(n539), .Y(n554) );
  DLY1X1M U549 ( .A(Reg1[4]), .Y(n555) );
  DLY1X1M U550 ( .A(Reg1[5]), .Y(n556) );
  DLY1X1M U551 ( .A(Reg1[1]), .Y(n557) );
  DLY1X1M U552 ( .A(n679), .Y(Reg2[3]) );
  DLY1X1M U553 ( .A(n677), .Y(Reg2[7]) );
  DLY1X1M U554 ( .A(n669), .Y(RdData[7]) );
  DLY1X1M U555 ( .A(n675), .Y(RdData[1]) );
  DLY1X1M U556 ( .A(n676), .Y(RdData[0]) );
  DLY1X1M U557 ( .A(n674), .Y(RdData[2]) );
  DLY1X1M U558 ( .A(n672), .Y(RdData[4]) );
  DLY1X1M U559 ( .A(n673), .Y(RdData[3]) );
  DLY1X1M U560 ( .A(n671), .Y(RdData[5]) );
  DLY1X1M U561 ( .A(n670), .Y(RdData[6]) );
  DLY1X1M U562 ( .A(n678), .Y(Reg2[6]) );
  DLY1X1M U563 ( .A(n680), .Y(Reg2[2]) );
  DLY1X1M U564 ( .A(n683), .Y(Reg3[5]) );
  DLY1X1M U565 ( .A(n682), .Y(Reg3[6]) );
  DLY1X1M U566 ( .A(n681), .Y(Reg3[7]) );
  DLY1X1M U567 ( .A(MEM_12__2_), .Y(test_so1) );
  DLY1X1M U568 ( .A(MEM_10__1_), .Y(n574) );
  DLY1X1M U569 ( .A(MEM_10__2_), .Y(n575) );
  DLY1X1M U570 ( .A(MEM_10__3_), .Y(n576) );
  DLY1X1M U571 ( .A(MEM_10__4_), .Y(n577) );
  DLY1X1M U572 ( .A(MEM_10__5_), .Y(n578) );
  DLY1X1M U573 ( .A(MEM_10__6_), .Y(n579) );
  DLY1X1M U574 ( .A(MEM_10__7_), .Y(n580) );
  DLY1X1M U575 ( .A(MEM_14__1_), .Y(n581) );
  DLY1X1M U576 ( .A(MEM_14__2_), .Y(n582) );
  DLY1X1M U577 ( .A(MEM_14__3_), .Y(n583) );
  DLY1X1M U578 ( .A(MEM_14__4_), .Y(n584) );
  DLY1X1M U579 ( .A(MEM_14__5_), .Y(n585) );
  DLY1X1M U580 ( .A(MEM_14__6_), .Y(n586) );
  DLY1X1M U581 ( .A(MEM_14__7_), .Y(n587) );
  DLY1X1M U582 ( .A(MEM_6__1_), .Y(n588) );
  DLY1X1M U583 ( .A(MEM_6__2_), .Y(n589) );
  DLY1X1M U584 ( .A(MEM_6__3_), .Y(n590) );
  DLY1X1M U585 ( .A(MEM_6__4_), .Y(n591) );
  DLY1X1M U586 ( .A(MEM_6__5_), .Y(n592) );
  DLY1X1M U587 ( .A(MEM_6__6_), .Y(n593) );
  DLY1X1M U588 ( .A(MEM_6__7_), .Y(n594) );
  DLY1X1M U589 ( .A(MEM_10__0_), .Y(n595) );
  DLY1X1M U590 ( .A(MEM_14__0_), .Y(n596) );
  DLY1X1M U591 ( .A(MEM_6__0_), .Y(n597) );
  DLY1X1M U592 ( .A(MEM_9__1_), .Y(n598) );
  DLY1X1M U593 ( .A(MEM_9__2_), .Y(n599) );
  DLY1X1M U594 ( .A(MEM_9__3_), .Y(n600) );
  DLY1X1M U595 ( .A(MEM_9__4_), .Y(n601) );
  DLY1X1M U596 ( .A(MEM_9__5_), .Y(n602) );
  DLY1X1M U597 ( .A(MEM_9__6_), .Y(n603) );
  DLY1X1M U598 ( .A(MEM_9__7_), .Y(n604) );
  DLY1X1M U599 ( .A(MEM_13__1_), .Y(n605) );
  DLY1X1M U600 ( .A(MEM_13__2_), .Y(n606) );
  DLY1X1M U601 ( .A(MEM_13__3_), .Y(n607) );
  DLY1X1M U602 ( .A(MEM_13__4_), .Y(n608) );
  DLY1X1M U603 ( .A(MEM_13__5_), .Y(n609) );
  DLY1X1M U604 ( .A(MEM_13__6_), .Y(n610) );
  DLY1X1M U605 ( .A(MEM_13__7_), .Y(n611) );
  DLY1X1M U606 ( .A(MEM_5__1_), .Y(n612) );
  DLY1X1M U607 ( .A(MEM_5__2_), .Y(n613) );
  DLY1X1M U608 ( .A(MEM_5__3_), .Y(n614) );
  DLY1X1M U609 ( .A(MEM_5__4_), .Y(n615) );
  DLY1X1M U610 ( .A(MEM_5__5_), .Y(n616) );
  DLY1X1M U611 ( .A(MEM_5__6_), .Y(n617) );
  DLY1X1M U612 ( .A(MEM_5__7_), .Y(n618) );
  DLY1X1M U613 ( .A(MEM_9__0_), .Y(n619) );
  DLY1X1M U614 ( .A(MEM_13__0_), .Y(n620) );
  DLY1X1M U615 ( .A(MEM_5__0_), .Y(n621) );
  DLY1X1M U616 ( .A(MEM_11__1_), .Y(n622) );
  DLY1X1M U617 ( .A(MEM_11__2_), .Y(n623) );
  DLY1X1M U618 ( .A(MEM_11__3_), .Y(n624) );
  DLY1X1M U619 ( .A(MEM_11__4_), .Y(n625) );
  DLY1X1M U620 ( .A(MEM_11__5_), .Y(n626) );
  DLY1X1M U621 ( .A(MEM_11__6_), .Y(n627) );
  DLY1X1M U622 ( .A(MEM_11__7_), .Y(n628) );
  DLY1X1M U623 ( .A(MEM_15__1_), .Y(n629) );
  DLY1X1M U624 ( .A(MEM_15__2_), .Y(n630) );
  DLY1X1M U625 ( .A(MEM_15__3_), .Y(n631) );
  DLY1X1M U626 ( .A(MEM_15__4_), .Y(n632) );
  DLY1X1M U627 ( .A(MEM_15__5_), .Y(n633) );
  DLY1X1M U628 ( .A(MEM_15__6_), .Y(n634) );
  DLY1X1M U629 ( .A(MEM_15__7_), .Y(n635) );
  DLY1X1M U630 ( .A(MEM_7__1_), .Y(n636) );
  DLY1X1M U631 ( .A(MEM_7__2_), .Y(n637) );
  DLY1X1M U632 ( .A(MEM_7__3_), .Y(n638) );
  DLY1X1M U633 ( .A(MEM_7__4_), .Y(n639) );
  DLY1X1M U634 ( .A(MEM_7__5_), .Y(n640) );
  DLY1X1M U635 ( .A(MEM_7__6_), .Y(n641) );
  DLY1X1M U636 ( .A(MEM_7__7_), .Y(n642) );
  DLY1X1M U637 ( .A(MEM_11__0_), .Y(n643) );
  DLY1X1M U638 ( .A(MEM_15__0_), .Y(n644) );
  DLY1X1M U639 ( .A(MEM_7__0_), .Y(n645) );
  DLY1X1M U640 ( .A(MEM_8__1_), .Y(n646) );
  DLY1X1M U641 ( .A(MEM_8__2_), .Y(n647) );
  DLY1X1M U642 ( .A(MEM_8__3_), .Y(n648) );
  DLY1X1M U643 ( .A(MEM_8__4_), .Y(n649) );
  DLY1X1M U644 ( .A(MEM_8__5_), .Y(n650) );
  DLY1X1M U645 ( .A(MEM_8__6_), .Y(n651) );
  DLY1X1M U646 ( .A(MEM_8__7_), .Y(n652) );
  DLY1X1M U647 ( .A(MEM_12__1_), .Y(n653) );
  DLY1X1M U648 ( .A(MEM_12__3_), .Y(n654) );
  DLY1X1M U649 ( .A(MEM_12__4_), .Y(n655) );
  DLY1X1M U650 ( .A(MEM_12__5_), .Y(n656) );
  DLY1X1M U651 ( .A(MEM_12__6_), .Y(n657) );
  DLY1X1M U652 ( .A(MEM_12__7_), .Y(n658) );
  DLY1X1M U653 ( .A(MEM_4__1_), .Y(n659) );
  DLY1X1M U654 ( .A(MEM_4__2_), .Y(n660) );
  DLY1X1M U655 ( .A(MEM_4__3_), .Y(n661) );
  DLY1X1M U656 ( .A(MEM_4__4_), .Y(n662) );
  DLY1X1M U657 ( .A(MEM_4__5_), .Y(n663) );
  DLY1X1M U658 ( .A(MEM_4__6_), .Y(n664) );
  DLY1X1M U659 ( .A(MEM_4__7_), .Y(n665) );
  DLY1X1M U660 ( .A(MEM_8__0_), .Y(n666) );
  DLY1X1M U661 ( .A(MEM_12__0_), .Y(n667) );
  DLY1X1M U662 ( .A(MEM_4__0_), .Y(n668) );
  SDFFSX1M MEM_reg_3__3_ ( .D(n212), .SI(Reg3[2]), .SE(test_se), .CK(CLK), 
        .SN(RST), .QN(n138) );
  SDFFSX1M MEM_reg_2__0_ ( .D(n201), .SI(Reg1[7]), .SE(test_se), .CK(CLK), 
        .SN(n519), .Q(n3) );
  SDFFSX1M MEM_reg_2__5_ ( .D(n206), .SI(Reg2[4]), .SE(test_se), .CK(CLK), 
        .SN(RST), .QN(n140) );
  SDFFRQX1M RdData_Valid_reg ( .D(n529), .SI(n635), .SE(test_se), .CK(CLK), 
        .RN(n519), .Q(RdData_Valid) );
  SDFFRQX1M MEM_reg_5__0_ ( .D(n225), .SI(n665), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_5__0_) );
  SDFFRQX1M MEM_reg_7__0_ ( .D(n241), .SI(n594), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_7__0_) );
  SDFFRQX1M MEM_reg_15__0_ ( .D(n305), .SI(n587), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_15__0_) );
  SDFFRQX1M MEM_reg_13__0_ ( .D(n289), .SI(n658), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_13__0_) );
  SDFFRQX1M MEM_reg_9__0_ ( .D(n257), .SI(n652), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_9__0_) );
  SDFFRQX1M MEM_reg_11__0_ ( .D(n273), .SI(n580), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_11__0_) );
  SDFFRQX1M MEM_reg_5__7_ ( .D(n232), .SI(n617), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_5__7_) );
  SDFFRQX1M MEM_reg_5__6_ ( .D(n231), .SI(n616), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_5__6_) );
  SDFFRQX1M MEM_reg_5__5_ ( .D(n230), .SI(n615), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_5__5_) );
  SDFFRQX1M MEM_reg_5__4_ ( .D(n229), .SI(n614), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_5__4_) );
  SDFFRQX1M MEM_reg_5__3_ ( .D(n228), .SI(n613), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_5__3_) );
  SDFFRQX1M MEM_reg_5__2_ ( .D(n227), .SI(n612), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_5__2_) );
  SDFFRQX1M MEM_reg_5__1_ ( .D(n226), .SI(n621), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_5__1_) );
  SDFFRQX1M MEM_reg_7__7_ ( .D(n248), .SI(n641), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_7__7_) );
  SDFFRQX1M MEM_reg_7__6_ ( .D(n247), .SI(n640), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_7__6_) );
  SDFFRQX1M MEM_reg_7__5_ ( .D(n246), .SI(n639), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_7__5_) );
  SDFFRQX1M MEM_reg_7__4_ ( .D(n245), .SI(n638), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_7__4_) );
  SDFFRQX1M MEM_reg_7__3_ ( .D(n244), .SI(n637), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_7__3_) );
  SDFFRQX1M MEM_reg_7__2_ ( .D(n243), .SI(n636), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_7__2_) );
  SDFFRQX1M MEM_reg_7__1_ ( .D(n242), .SI(n645), .SE(test_se), .CK(CLK), .RN(
        n519), .Q(MEM_7__1_) );
  SDFFRQX1M MEM_reg_3__7_ ( .D(n216), .SI(Reg3[6]), .SE(test_se), .CK(CLK), 
        .RN(n517), .Q(n681) );
  SDFFRQX1M MEM_reg_3__6_ ( .D(n215), .SI(Reg3[5]), .SE(test_se), .CK(CLK), 
        .RN(n517), .Q(n682) );
  SDFFRQX1M MEM_reg_3__5_ ( .D(n214), .SI(Reg3[4]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(n683) );
  SDFFRQX1M MEM_reg_15__7_ ( .D(n312), .SI(n634), .SE(test_se), .CK(CLK), .RN(
        n516), .Q(MEM_15__7_) );
  SDFFRQX1M MEM_reg_15__6_ ( .D(n311), .SI(n633), .SE(test_se), .CK(CLK), .RN(
        n516), .Q(MEM_15__6_) );
  SDFFRQX1M MEM_reg_15__5_ ( .D(n310), .SI(n632), .SE(test_se), .CK(CLK), .RN(
        n518), .Q(MEM_15__5_) );
  SDFFRQX1M MEM_reg_15__4_ ( .D(n309), .SI(n631), .SE(test_se), .CK(CLK), .RN(
        n517), .Q(MEM_15__4_) );
  SDFFRQX1M MEM_reg_15__3_ ( .D(n308), .SI(n630), .SE(test_se), .CK(CLK), .RN(
        n521), .Q(MEM_15__3_) );
  SDFFRQX1M MEM_reg_15__2_ ( .D(n307), .SI(n629), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_15__2_) );
  SDFFRQX1M MEM_reg_15__1_ ( .D(n306), .SI(n644), .SE(test_se), .CK(CLK), .RN(
        n524), .Q(MEM_15__1_) );
  SDFFRQX1M MEM_reg_13__7_ ( .D(n296), .SI(n610), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_13__7_) );
  SDFFRQX1M MEM_reg_13__6_ ( .D(n295), .SI(n609), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_13__6_) );
  SDFFRQX1M MEM_reg_13__5_ ( .D(n294), .SI(n608), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_13__5_) );
  SDFFRQX1M MEM_reg_13__4_ ( .D(n293), .SI(n607), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_13__4_) );
  SDFFRQX1M MEM_reg_13__3_ ( .D(n292), .SI(n606), .SE(test_se), .CK(CLK), .RN(
        n523), .Q(MEM_13__3_) );
  SDFFRQX1M MEM_reg_13__2_ ( .D(n291), .SI(n605), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_13__2_) );
  SDFFRQX1M MEM_reg_13__1_ ( .D(n290), .SI(n620), .SE(test_se), .CK(CLK), .RN(
        n522), .Q(MEM_13__1_) );
  SDFFRQX1M MEM_reg_1__7_ ( .D(n200), .SI(Reg1[6]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(n546) );
  SDFFRQX1M MEM_reg_1__6_ ( .D(n199), .SI(n556), .SE(test_se), .CK(CLK), .RN(
        n516), .Q(n547) );
  SDFFRQX1M MEM_reg_9__7_ ( .D(n264), .SI(n603), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_9__7_) );
  SDFFRQX1M MEM_reg_9__6_ ( .D(n263), .SI(n602), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_9__6_) );
  SDFFRQX1M MEM_reg_9__5_ ( .D(n262), .SI(n601), .SE(test_se), .CK(CLK), .RN(
        n520), .Q(MEM_9__5_) );
  SDFFRQX4M MEM_reg_3__2_ ( .D(n211), .SI(Reg3[1]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(Reg3[2]) );
  SDFFRQX4M MEM_reg_3__4_ ( .D(n213), .SI(Reg3[3]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(Reg3[4]) );
  SDFFRQX4M MEM_reg_3__1_ ( .D(n210), .SI(Reg3[0]), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(Reg3[1]) );
  SDFFRQX4M MEM_reg_3__0_ ( .D(n209), .SI(test_si2), .SE(test_se), .CK(CLK), 
        .RN(n516), .Q(Reg3[0]) );
  INVXLM U3 ( .A(n3), .Y(n1) );
  INVX4M U4 ( .A(n1), .Y(Reg2[0]) );
endmodule


module Controller_FSM_TX_test_1 ( ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST, 
        ALU_OUT, RdData, TX_P_Data, TX_D_VLD, CLK_div_en, test_si, test_so, 
        test_se );
  input [15:0] ALU_OUT;
  input [7:0] RdData;
  output [7:0] TX_P_Data;
  input ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST, test_si, test_se;
  output TX_D_VLD, CLK_div_en, test_so;
  wire   n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90,
         n91, n92, n93, n94, n95, n96, n97, n98, n122, n123, n124, n125, n126,
         n127, n128, n129, n130, n131, n132, n133, n134, n135, n136, n138,
         n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149,
         n150, n151, n152, n153, n154, n155, n156, n157, n158, n159, n160;
  wire   [2:0] Current_State;
  wire   [1:0] Next_State;

  NOR2X12M U62 ( .A(n64), .B(n122), .Y(n63) );
  NOR2X12M U63 ( .A(n65), .B(n66), .Y(n62) );
  NOR2X12M U64 ( .A(n132), .B(n124), .Y(n61) );
  OAI32X4M U66 ( .A0(n132), .A1(TX_D_VLD), .A2(n70), .B0(n133), .B1(n131), .Y(
        n69) );
  SDFFRX1M REG_RdData_reg_7_ ( .D(n82), .SI(n138), .SE(test_se), .CK(CLK), 
        .RN(RST), .Q(test_so), .QN(n50) );
  SDFFRX1M REG_RdData_reg_6_ ( .D(n81), .SI(n139), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n138), .QN(n51) );
  SDFFRX1M REG_RdData_reg_5_ ( .D(n80), .SI(n140), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n139), .QN(n52) );
  SDFFRX1M REG_RdData_reg_4_ ( .D(n79), .SI(n141), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n140), .QN(n53) );
  SDFFRX1M REG_RdData_reg_3_ ( .D(n78), .SI(n142), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n141), .QN(n54) );
  SDFFRX1M REG_RdData_reg_2_ ( .D(n77), .SI(n143), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n142), .QN(n55) );
  SDFFRX1M REG_RdData_reg_1_ ( .D(n76), .SI(n144), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n143), .QN(n56) );
  SDFFRX1M REG_RdData_reg_0_ ( .D(n75), .SI(n145), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n144), .QN(n57) );
  SDFFRX1M REG_ALU_OUT_reg_15_ ( .D(n98), .SI(n146), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n145), .QN(n34) );
  SDFFRX1M REG_ALU_OUT_reg_14_ ( .D(n97), .SI(n147), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n146), .QN(n35) );
  SDFFRX1M REG_ALU_OUT_reg_13_ ( .D(n96), .SI(n148), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n147), .QN(n36) );
  SDFFRX1M REG_ALU_OUT_reg_12_ ( .D(n95), .SI(n149), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n148), .QN(n37) );
  SDFFRX1M REG_ALU_OUT_reg_11_ ( .D(n94), .SI(n150), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n149), .QN(n38) );
  SDFFRX1M REG_ALU_OUT_reg_10_ ( .D(n93), .SI(n151), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n150), .QN(n39) );
  SDFFRX1M REG_ALU_OUT_reg_9_ ( .D(n92), .SI(n152), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n151), .QN(n40) );
  SDFFRX1M REG_ALU_OUT_reg_8_ ( .D(n91), .SI(n153), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n152), .QN(n41) );
  SDFFRX1M REG_ALU_OUT_reg_7_ ( .D(n90), .SI(n154), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n153), .QN(n42) );
  SDFFRX1M REG_ALU_OUT_reg_6_ ( .D(n89), .SI(n155), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n154), .QN(n43) );
  SDFFRX1M REG_ALU_OUT_reg_5_ ( .D(n88), .SI(n156), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n155), .QN(n44) );
  SDFFRX1M REG_ALU_OUT_reg_4_ ( .D(n87), .SI(n157), .SE(test_se), .CK(CLK), 
        .RN(n128), .Q(n156), .QN(n45) );
  SDFFRX1M REG_ALU_OUT_reg_3_ ( .D(n86), .SI(n158), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n157), .QN(n46) );
  SDFFRX1M REG_ALU_OUT_reg_2_ ( .D(n85), .SI(n159), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n158), .QN(n47) );
  SDFFRX1M REG_ALU_OUT_reg_1_ ( .D(n84), .SI(n160), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n159), .QN(n48) );
  SDFFRX1M REG_ALU_OUT_reg_0_ ( .D(n83), .SI(n136), .SE(test_se), .CK(CLK), 
        .RN(n127), .Q(n160), .QN(n49) );
  SDFFRQX2M Current_State_reg_2_ ( .D(n130), .SI(n135), .SE(test_se), .CK(CLK), 
        .RN(RST), .Q(Current_State[2]) );
  NOR3X8M U33 ( .A(n134), .B(Current_State[2]), .C(n135), .Y(n65) );
  NOR3X8M U34 ( .A(n136), .B(Current_State[0]), .C(n135), .Y(n64) );
  CLKBUFX2M U67 ( .A(RST), .Y(n129) );
  CLKBUFX12M U68 ( .A(n59), .Y(n122) );
  CLKBUFX2M U69 ( .A(n60), .Y(n123) );
  CLKBUFX8M U71 ( .A(n129), .Y(n127) );
  CLKBUFX8M U72 ( .A(n129), .Y(n128) );
  NAND2X4M U73 ( .A(n133), .B(n71), .Y(TX_D_VLD) );
  CLKINVX4M U74 ( .A(Busy), .Y(n131) );
  OAI2B11X1M U75 ( .A1N(ALU_OUT_VLD), .A0(Busy), .B0(n70), .C0(n74), .Y(
        Next_State[0]) );
  OAI21X2M U76 ( .A0(TX_D_VLD), .A1(n132), .B0(n131), .Y(n74) );
  BUFX10M U77 ( .A(n123), .Y(n124) );
  OAI211X2M U78 ( .A0(n71), .A1(n131), .B0(n72), .C0(n73), .Y(Next_State[1])
         );
  AOI22X1M U79 ( .A0(n64), .A1(Busy), .B0(n65), .B1(n131), .Y(n73) );
  NOR2X4M U80 ( .A(n124), .B(n122), .Y(n71) );
  INVX2M U81 ( .A(n65), .Y(n133) );
  INVX2M U82 ( .A(n67), .Y(n130) );
  NOR3BX2M U83 ( .AN(n68), .B(n122), .C(n69), .Y(n67) );
  OAI21X1M U84 ( .A0(n64), .A1(n66), .B0(Busy), .Y(n68) );
  BUFX10M U85 ( .A(n123), .Y(n125) );
  INVX4M U86 ( .A(n72), .Y(n132) );
  BUFX4M U87 ( .A(n123), .Y(n126) );
  OAI2BB2X1M U88 ( .B0(n124), .B1(n49), .A0N(ALU_OUT[0]), .A1N(n125), .Y(n83)
         );
  OAI2BB2X1M U89 ( .B0(n124), .B1(n48), .A0N(ALU_OUT[1]), .A1N(n125), .Y(n84)
         );
  OAI2BB2X1M U90 ( .B0(n124), .B1(n47), .A0N(ALU_OUT[2]), .A1N(n125), .Y(n85)
         );
  OAI2BB2X1M U91 ( .B0(n124), .B1(n46), .A0N(ALU_OUT[3]), .A1N(n125), .Y(n86)
         );
  OAI2BB2X1M U92 ( .B0(n124), .B1(n41), .A0N(ALU_OUT[8]), .A1N(n125), .Y(n91)
         );
  OAI2BB2X1M U93 ( .B0(n124), .B1(n40), .A0N(ALU_OUT[9]), .A1N(n125), .Y(n92)
         );
  OAI2BB2X1M U94 ( .B0(n124), .B1(n39), .A0N(ALU_OUT[10]), .A1N(n126), .Y(n93)
         );
  OAI2BB2X1M U95 ( .B0(n124), .B1(n38), .A0N(ALU_OUT[11]), .A1N(n126), .Y(n94)
         );
  OAI2BB2X1M U96 ( .B0(n124), .B1(n37), .A0N(ALU_OUT[12]), .A1N(n125), .Y(n95)
         );
  OAI2BB2X1M U97 ( .B0(n124), .B1(n36), .A0N(ALU_OUT[13]), .A1N(n126), .Y(n96)
         );
  OAI2BB2X1M U98 ( .B0(n124), .B1(n35), .A0N(ALU_OUT[14]), .A1N(n126), .Y(n97)
         );
  OAI2BB2X1M U99 ( .B0(n124), .B1(n34), .A0N(ALU_OUT[15]), .A1N(n125), .Y(n98)
         );
  OAI2BB2X1M U100 ( .B0(n125), .B1(n45), .A0N(ALU_OUT[4]), .A1N(n125), .Y(n87)
         );
  OAI2BB2X1M U101 ( .B0(n125), .B1(n44), .A0N(ALU_OUT[5]), .A1N(n125), .Y(n88)
         );
  OAI2BB2X1M U102 ( .B0(n125), .B1(n43), .A0N(ALU_OUT[6]), .A1N(n125), .Y(n89)
         );
  OAI2BB2X1M U103 ( .B0(n125), .B1(n42), .A0N(ALU_OUT[7]), .A1N(n125), .Y(n90)
         );
  INVX4M U104 ( .A(Current_State[2]), .Y(n136) );
  INVX4M U105 ( .A(Current_State[0]), .Y(n134) );
  NAND2X2M U106 ( .A(RdData_VLD), .B(n131), .Y(n70) );
  NOR3X2M U107 ( .A(Current_State[1]), .B(Current_State[2]), .C(n134), .Y(n60)
         );
  OAI2BB2X1M U108 ( .B0(n122), .B1(n57), .A0N(RdData[0]), .A1N(n122), .Y(n75)
         );
  OAI2BB2X1M U109 ( .B0(n122), .B1(n56), .A0N(RdData[1]), .A1N(n122), .Y(n76)
         );
  OAI2BB2X1M U110 ( .B0(n122), .B1(n55), .A0N(RdData[2]), .A1N(n122), .Y(n77)
         );
  OAI2BB2X1M U111 ( .B0(n122), .B1(n54), .A0N(RdData[3]), .A1N(n122), .Y(n78)
         );
  OAI2BB2X1M U112 ( .B0(n122), .B1(n53), .A0N(RdData[4]), .A1N(n122), .Y(n79)
         );
  OAI2BB2X1M U113 ( .B0(n122), .B1(n52), .A0N(RdData[5]), .A1N(n122), .Y(n80)
         );
  OAI2BB2X1M U114 ( .B0(n122), .B1(n51), .A0N(RdData[6]), .A1N(n122), .Y(n81)
         );
  OAI2BB2X1M U115 ( .B0(n122), .B1(n50), .A0N(RdData[7]), .A1N(n122), .Y(n82)
         );
  NAND3X2M U116 ( .A(n134), .B(n136), .C(Current_State[1]), .Y(n72) );
  OAI222X2M U117 ( .A0(n61), .A1(n49), .B0(n62), .B1(n41), .C0(n63), .C1(n57), 
        .Y(TX_P_Data[0]) );
  OAI222X2M U118 ( .A0(n61), .A1(n48), .B0(n62), .B1(n40), .C0(n63), .C1(n56), 
        .Y(TX_P_Data[1]) );
  OAI222X2M U119 ( .A0(n61), .A1(n47), .B0(n62), .B1(n39), .C0(n63), .C1(n55), 
        .Y(TX_P_Data[2]) );
  OAI222X2M U120 ( .A0(n61), .A1(n46), .B0(n62), .B1(n38), .C0(n63), .C1(n54), 
        .Y(TX_P_Data[3]) );
  OAI222X2M U121 ( .A0(n61), .A1(n45), .B0(n62), .B1(n37), .C0(n63), .C1(n53), 
        .Y(TX_P_Data[4]) );
  OAI222X2M U122 ( .A0(n61), .A1(n44), .B0(n62), .B1(n36), .C0(n63), .C1(n52), 
        .Y(TX_P_Data[5]) );
  OAI222X2M U123 ( .A0(n61), .A1(n43), .B0(n62), .B1(n35), .C0(n63), .C1(n51), 
        .Y(TX_P_Data[6]) );
  OAI222X2M U124 ( .A0(n61), .A1(n42), .B0(n62), .B1(n34), .C0(n63), .C1(n50), 
        .Y(TX_P_Data[7]) );
  SDFFRQX4M Current_State_reg_0_ ( .D(Next_State[0]), .SI(test_si), .SE(
        test_se), .CK(CLK), .RN(RST), .Q(Current_State[0]) );
  SDFFRX4M Current_State_reg_1_ ( .D(Next_State[1]), .SI(n134), .SE(test_se), 
        .CK(CLK), .RN(RST), .Q(Current_State[1]), .QN(n135) );
  INVX2M U3 ( .A(1'b0), .Y(CLK_div_en) );
  NOR3X4M U5 ( .A(n134), .B(Current_State[1]), .C(n136), .Y(n59) );
  NOR3X6M U6 ( .A(Current_State[0]), .B(Current_State[1]), .C(n136), .Y(n66)
         );
endmodule


module Controller_FSM_RX_test_1 ( Data_valid, CLK, RST, ALU_OUT_Valid, 
        P_Data_RX, ALU_EN, CLK_EN, WrEn, RdEn, ALU_FUN, Address, WrData, 
        test_si, test_so, test_se );
  input [7:0] P_Data_RX;
  output [3:0] ALU_FUN;
  output [3:0] Address;
  output [7:0] WrData;
  input Data_valid, CLK, RST, ALU_OUT_Valid, test_si, test_se;
  output ALU_EN, CLK_EN, WrEn, RdEn, test_so;
  wire   n114, n115, n116, n25, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84,
         n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98,
         n10, n18, n20, n23, n24, n26, n27, n29, n30, n31, n32, n33, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n117, n120, n122, n123, n1, n2;
  wire   [4:0] Current_State;
  wire   [4:0] Next_State;
  wire   [3:1] P_Data_Addr;

  AOI221X4M U33 ( .A0(Data_valid), .A1(n100), .B0(n59), .B1(n113), .C0(n27), 
        .Y(n53) );
  AOI211X4M U36 ( .A0(n64), .A1(n113), .B0(n52), .C0(n65), .Y(n63) );
  CLKINVX8M U74 ( .A(n34), .Y(Address[3]) );
  AOI22X4M U75 ( .A0(n100), .A1(P_Data_Addr[3]), .B0(n77), .B1(P_Data_RX[3]), 
        .Y(n34) );
  CLKINVX8M U76 ( .A(n36), .Y(Address[2]) );
  AOI22X4M U77 ( .A0(n100), .A1(P_Data_Addr[2]), .B0(n77), .B1(P_Data_RX[2]), 
        .Y(n36) );
  AOI22X4M U79 ( .A0(n100), .A1(P_Data_Addr[1]), .B0(n77), .B1(P_Data_RX[1]), 
        .Y(n37) );
  NOR3X12M U83 ( .A(Current_State[1]), .B(Current_State[4]), .C(n105), .Y(n89)
         );
  NOR2X12M U89 ( .A(n94), .B(n109), .Y(ALU_FUN[3]) );
  SDFFRHQX8M Current_State_reg_4_ ( .D(Next_State[4]), .SI(n104), .SE(test_se), 
        .CK(CLK), .RN(n23), .Q(Current_State[4]) );
  SDFFRX1M P_Data_Addr_reg_0_ ( .D(n98), .SI(Current_State[4]), .SE(test_se), 
        .CK(CLK), .RN(n23), .Q(n117), .QN(n25) );
  NOR2X6M U12 ( .A(ALU_EN), .B(n32), .Y(n94) );
  INVX2M U13 ( .A(Current_State[1]), .Y(n103) );
  NOR2X8M U14 ( .A(n103), .B(Current_State[4]), .Y(n88) );
  INVX8M U15 ( .A(n115), .Y(ALU_FUN[0]) );
  CLKINVX12M U16 ( .A(n114), .Y(ALU_FUN[1]) );
  NOR2X8M U17 ( .A(n94), .B(n110), .Y(ALU_FUN[2]) );
  NAND2X2M U18 ( .A(n57), .B(n91), .Y(n66) );
  NOR3BX2M U19 ( .AN(n79), .B(n108), .C(n112), .Y(n42) );
  OR2X2M U20 ( .A(P_Data_RX[0]), .B(P_Data_RX[4]), .Y(n10) );
  NOR4BX4M U21 ( .AN(n80), .B(P_Data_RX[1]), .C(P_Data_RX[5]), .D(n110), .Y(
        n79) );
  NOR3X8M U22 ( .A(Current_State[2]), .B(Current_State[4]), .C(
        Current_State[1]), .Y(n85) );
  NOR3X4M U23 ( .A(n69), .B(P_Data_RX[4]), .C(P_Data_RX[0]), .Y(n74) );
  CLKBUFX2M U31 ( .A(n42), .Y(n18) );
  OR2X2M U32 ( .A(n94), .B(n112), .Y(n115) );
  NOR2X4M U34 ( .A(n20), .B(n10), .Y(n48) );
  CLKINVX1M U35 ( .A(n79), .Y(n20) );
  OR2X2M U37 ( .A(n94), .B(n111), .Y(n114) );
  NAND4X1M U38 ( .A(n44), .B(n45), .C(n46), .D(n47), .Y(Next_State[3]) );
  NAND2X2M U39 ( .A(n58), .B(n85), .Y(n38) );
  OAI211X1M U40 ( .A0(n71), .A1(n113), .B0(n72), .C0(n73), .Y(Next_State[0])
         );
  NAND2X2M U41 ( .A(n87), .B(n88), .Y(n62) );
  NOR2X6M U42 ( .A(n104), .B(n2), .Y(n58) );
  NOR2BX4M U43 ( .AN(n93), .B(n2), .Y(n87) );
  NAND3X6M U45 ( .A(n88), .B(n93), .C(n2), .Y(n35) );
  INVX2M U46 ( .A(P_Data_RX[3]), .Y(n109) );
  INVX4M U47 ( .A(Data_valid), .Y(n113) );
  INVX2M U48 ( .A(P_Data_RX[6]), .Y(n106) );
  INVX2M U49 ( .A(n66), .Y(ALU_EN) );
  INVX6M U50 ( .A(WrEn), .Y(n30) );
  INVX2M U51 ( .A(n67), .Y(n26) );
  CLKAND2X4M U52 ( .A(n75), .B(n76), .Y(n43) );
  NOR4X2M U53 ( .A(n27), .B(n26), .C(n102), .D(n77), .Y(n75) );
  NOR4BX2M U54 ( .AN(n62), .B(CLK_EN), .C(n100), .D(n101), .Y(n76) );
  NOR2BX4M U55 ( .AN(n45), .B(n33), .Y(n60) );
  INVX2M U56 ( .A(n38), .Y(RdEn) );
  INVX2M U57 ( .A(n78), .Y(n27) );
  NAND3X2M U58 ( .A(n78), .B(n62), .C(n86), .Y(n83) );
  INVX6M U59 ( .A(n24), .Y(n23) );
  INVX2M U60 ( .A(RST), .Y(n24) );
  NOR2BX8M U61 ( .AN(n88), .B(n105), .Y(n57) );
  NOR2X6M U62 ( .A(n104), .B(n31), .Y(n91) );
  NAND2X4M U63 ( .A(n91), .B(n89), .Y(n55) );
  NAND2X2M U64 ( .A(n89), .B(n58), .Y(n54) );
  NAND4X2M U65 ( .A(n86), .B(n90), .C(n45), .D(n55), .Y(CLK_EN) );
  NAND2X2M U66 ( .A(n66), .B(n61), .Y(n39) );
  AND4X2M U67 ( .A(n44), .B(n40), .C(n46), .D(n92), .Y(n86) );
  NOR2BX2M U68 ( .AN(n54), .B(n39), .Y(n92) );
  NAND3X4M U69 ( .A(n88), .B(n105), .C(n91), .Y(n45) );
  NAND2X2M U70 ( .A(n58), .B(n88), .Y(n46) );
  NAND2X2M U71 ( .A(n91), .B(n85), .Y(n44) );
  NAND2X4M U72 ( .A(n35), .B(n38), .Y(n77) );
  INVX4M U73 ( .A(n84), .Y(n100) );
  NOR2X2M U78 ( .A(n30), .B(n112), .Y(WrData[0]) );
  NOR2X2M U80 ( .A(n30), .B(n111), .Y(WrData[1]) );
  NOR2X2M U81 ( .A(n30), .B(n110), .Y(WrData[2]) );
  NOR2X2M U82 ( .A(n30), .B(n109), .Y(WrData[3]) );
  NOR2X2M U84 ( .A(n30), .B(n108), .Y(WrData[4]) );
  NOR2X2M U85 ( .A(n30), .B(n107), .Y(WrData[5]) );
  NOR2X2M U86 ( .A(n30), .B(n106), .Y(WrData[6]) );
  NAND3X4M U87 ( .A(n55), .B(n84), .C(n45), .Y(WrEn) );
  OAI21X2M U88 ( .A0(n102), .A1(n26), .B0(n113), .Y(n72) );
  NOR4X2M U90 ( .A(n83), .B(n101), .C(WrEn), .D(n33), .Y(n71) );
  OAI31X2M U91 ( .A0(n74), .A1(n48), .A2(n18), .B0(n43), .Y(n73) );
  INVX2M U92 ( .A(n51), .Y(n102) );
  INVX2M U93 ( .A(n37), .Y(Address[1]) );
  NAND3X2M U94 ( .A(n31), .B(n104), .C(n57), .Y(n67) );
  INVX2M U95 ( .A(n90), .Y(n32) );
  AOI211X2M U96 ( .A0(n48), .A1(n43), .B0(n49), .C0(n50), .Y(n47) );
  AOI21X2M U97 ( .A0(n51), .A1(n38), .B0(n113), .Y(n50) );
  NAND4X2M U98 ( .A(n61), .B(n46), .C(n62), .D(n63), .Y(Next_State[1]) );
  NAND4X2M U99 ( .A(n51), .B(n70), .C(n40), .D(n55), .Y(n64) );
  AOI21X2M U100 ( .A0(n60), .A1(n66), .B0(n113), .Y(n65) );
  INVX4M U101 ( .A(n35), .Y(n33) );
  NAND2X2M U102 ( .A(n89), .B(n31), .Y(n78) );
  INVX2M U103 ( .A(n70), .Y(n101) );
  INVX4M U104 ( .A(Current_State[2]), .Y(n105) );
  INVX4M U105 ( .A(Current_State[3]), .Y(n104) );
  NOR2X6M U106 ( .A(Current_State[3]), .B(Current_State[2]), .Y(n93) );
  NAND4X4M U107 ( .A(Current_State[4]), .B(n2), .C(n93), .D(n103), .Y(n40) );
  NAND3X2M U108 ( .A(Current_State[4]), .B(Current_State[1]), .C(n87), .Y(n61)
         );
  NAND3X2M U109 ( .A(Current_State[4]), .B(n103), .C(n87), .Y(n90) );
  OAI2B11X2M U110 ( .A1N(n39), .A0(Data_valid), .B0(n40), .C0(n41), .Y(
        Next_State[4]) );
  AOI22X1M U111 ( .A0(n18), .A1(n43), .B0(ALU_OUT_Valid), .B1(n32), .Y(n41) );
  INVX4M U112 ( .A(P_Data_RX[2]), .Y(n110) );
  NAND3X4M U113 ( .A(n2), .B(n104), .C(n57), .Y(n51) );
  NOR2BX2M U114 ( .AN(n120), .B(n30), .Y(WrData[7]) );
  NAND3X4M U115 ( .A(n2), .B(n104), .C(n89), .Y(n84) );
  NAND3BX2M U116 ( .AN(n52), .B(n53), .C(n29), .Y(Next_State[2]) );
  INVX2M U117 ( .A(n49), .Y(n29) );
  NAND2X2M U118 ( .A(n60), .B(n51), .Y(n59) );
  NAND2X2M U119 ( .A(n67), .B(n68), .Y(n52) );
  NAND4BX1M U120 ( .AN(n69), .B(n43), .C(P_Data_RX[4]), .D(P_Data_RX[0]), .Y(
        n68) );
  CLKBUFX2M U121 ( .A(n116), .Y(Address[0]) );
  OAI221X2M U122 ( .A0(n99), .A1(n112), .B0(n84), .B1(n25), .C0(n55), .Y(n116)
         );
  INVX2M U123 ( .A(n77), .Y(n99) );
  NOR2X2M U124 ( .A(n106), .B(n81), .Y(n80) );
  INVX4M U125 ( .A(P_Data_RX[0]), .Y(n112) );
  NAND2X2M U126 ( .A(n85), .B(n2), .Y(n70) );
  OAI2BB2X1M U127 ( .B0(n37), .B1(n35), .A0N(n123), .A1N(n35), .Y(n97) );
  OAI2BB2X1M U128 ( .B0(n36), .B1(n35), .A0N(n122), .A1N(n35), .Y(n96) );
  OAI2BB2X1M U129 ( .B0(n34), .B1(n35), .A0N(test_so), .A1N(n35), .Y(n95) );
  OAI2BB2X1M U130 ( .B0(n33), .B1(n25), .A0N(Address[0]), .A1N(n33), .Y(n98)
         );
  INVX2M U131 ( .A(P_Data_RX[1]), .Y(n111) );
  NAND3X2M U132 ( .A(n54), .B(n55), .C(n56), .Y(n49) );
  AOI22X1M U133 ( .A0(n57), .A1(n58), .B0(Data_valid), .B1(n39), .Y(n56) );
  NAND3X2M U134 ( .A(n120), .B(P_Data_RX[3]), .C(Data_valid), .Y(n81) );
  NAND4X2M U135 ( .A(n110), .B(n106), .C(P_Data_RX[1]), .D(n82), .Y(n69) );
  NOR2X2M U136 ( .A(n107), .B(n81), .Y(n82) );
  INVX2M U137 ( .A(P_Data_RX[4]), .Y(n108) );
  INVX2M U138 ( .A(P_Data_RX[5]), .Y(n107) );
  DLY1X1M U139 ( .A(P_Data_RX[7]), .Y(n120) );
  DLY1X1M U140 ( .A(P_Data_Addr[3]), .Y(test_so) );
  DLY1X1M U141 ( .A(P_Data_Addr[2]), .Y(n122) );
  DLY1X1M U142 ( .A(P_Data_Addr[1]), .Y(n123) );
  SDFFSRX2M Current_State_reg_0_ ( .D(Next_State[0]), .SI(test_si), .SE(
        test_se), .CK(CLK), .SN(1'b1), .RN(RST), .Q(Current_State[0]), .QN(n31) );
  SDFFRQX1M P_Data_Addr_reg_1_ ( .D(n97), .SI(n117), .SE(test_se), .CK(CLK), 
        .RN(n23), .Q(P_Data_Addr[1]) );
  SDFFRQX1M P_Data_Addr_reg_3_ ( .D(n95), .SI(n122), .SE(test_se), .CK(CLK), 
        .RN(n23), .Q(P_Data_Addr[3]) );
  SDFFRQX1M P_Data_Addr_reg_2_ ( .D(n96), .SI(n123), .SE(test_se), .CK(CLK), 
        .RN(n23), .Q(P_Data_Addr[2]) );
  SDFFRQX1M Current_State_reg_3_ ( .D(Next_State[3]), .SI(n105), .SE(test_se), 
        .CK(CLK), .RN(n23), .Q(Current_State[3]) );
  SDFFRQX4M Current_State_reg_1_ ( .D(Next_State[1]), .SI(n2), .SE(test_se), 
        .CK(CLK), .RN(n23), .Q(Current_State[1]) );
  SDFFRQX4M Current_State_reg_2_ ( .D(Next_State[2]), .SI(Current_State[1]), 
        .SE(test_se), .CK(CLK), .RN(n23), .Q(Current_State[2]) );
  INVXLM U3 ( .A(Current_State[0]), .Y(n1) );
  INVX6M U4 ( .A(n1), .Y(n2) );
endmodule


module SYS_CTRL_test_1 ( ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST, ALU_OUT, 
        RdData, TX_P_Data, TX_D_VLD, CLK_div_en, Data_valid, P_Data_RX, ALU_EN, 
        CLK_EN, WrEn, RdEn, ALU_FUN, Address, WrData, test_si2, test_si1, 
        test_so2, test_so1, test_se );
  input [15:0] ALU_OUT;
  input [7:0] RdData;
  output [7:0] TX_P_Data;
  input [7:0] P_Data_RX;
  output [3:0] ALU_FUN;
  output [3:0] Address;
  output [7:0] WrData;
  input ALU_OUT_VLD, RdData_VLD, Busy, CLK, RST, Data_valid, test_si2,
         test_si1, test_se;
  output TX_D_VLD, CLK_div_en, ALU_EN, CLK_EN, WrEn, RdEn, test_so2, test_so1;
  wire   n8, n9, n5, n6, n3, n4, n7;

  INVX4M U3 ( .A(n6), .Y(n5) );
  INVXLM U4 ( .A(RST), .Y(n6) );
  CLKBUFX2M U5 ( .A(n8), .Y(Address[1]) );
  CLKBUFX2M U6 ( .A(n9), .Y(Address[0]) );
  Controller_FSM_TX_test_1 TX_Control ( .ALU_OUT_VLD(ALU_OUT_VLD), 
        .RdData_VLD(RdData_VLD), .Busy(Busy), .CLK(CLK), .RST(n4), .ALU_OUT(
        ALU_OUT), .RdData(RdData), .TX_P_Data(TX_P_Data), .TX_D_VLD(TX_D_VLD), 
        .test_si(test_si2), .test_so(test_so2), .test_se(test_se) );
  Controller_FSM_RX_test_1 RX_Control ( .Data_valid(Data_valid), .CLK(CLK), 
        .RST(n7), .ALU_OUT_Valid(ALU_OUT_VLD), .P_Data_RX(P_Data_RX), .ALU_EN(
        ALU_EN), .CLK_EN(CLK_EN), .WrEn(WrEn), .RdEn(RdEn), .ALU_FUN(ALU_FUN), 
        .Address({Address[3:2], n8, n9}), .WrData(WrData), .test_si(test_si1), 
        .test_so(test_so1), .test_se(test_se) );
  INVX2M U1 ( .A(1'b0), .Y(CLK_div_en) );
  CLKINVX1M U7 ( .A(n5), .Y(n3) );
  CLKINVX4M U8 ( .A(n3), .Y(n4) );
  CLKINVX1M U9 ( .A(n3), .Y(n7) );
endmodule


module MUX2x1_6 ( IN0, IN1, Sel, OUT );
  input IN0, IN1, Sel;
  output OUT;


  AO2B2X4M U1 ( .B0(Sel), .B1(IN1), .A0(IN0), .A1N(Sel), .Y(OUT) );
endmodule


module MUX2x1_5 ( IN0, IN1, Sel, OUT );
  input IN0, IN1, Sel;
  output OUT;


  AO2B2X2M U1 ( .B0(Sel), .B1(IN1), .A0(IN0), .A1N(Sel), .Y(OUT) );
endmodule


module MUX2x1_4 ( IN0, IN1, Sel, OUT );
  input IN0, IN1, Sel;
  output OUT;


  AO2B2X4M U1 ( .B0(Sel), .B1(IN1), .A0(IN0), .A1N(Sel), .Y(OUT) );
endmodule


module MUX2x1_3 ( IN0, IN1, Sel, OUT );
  input IN0, IN1, Sel;
  output OUT;
  wire   n2;

  CLKBUFX2M U1 ( .A(n2), .Y(OUT) );
  AO2B2X2M U2 ( .B0(Sel), .B1(IN1), .A0(IN0), .A1N(Sel), .Y(n2) );
endmodule


module MUX2x1_2 ( IN0, IN1, Sel, OUT );
  input IN0, IN1, Sel;
  output OUT;


  AO2B2X4M U1 ( .B0(Sel), .B1(IN1), .A0(IN0), .A1N(Sel), .Y(OUT) );
endmodule


module MUX2x1_1 ( IN0, IN1, Sel, OUT );
  input IN0, IN1, Sel;
  output OUT;


  AO2B2X4M U1 ( .B0(Sel), .B1(IN1), .A0(IN0), .A1N(Sel), .Y(OUT) );
endmodule


module MUX2x1_0 ( IN0, IN1, Sel, OUT );
  input IN0, IN1, Sel;
  output OUT;


  AO2B2X4M U1 ( .B0(Sel), .B1(IN1), .A0(IN0), .A1N(Sel), .Y(OUT) );
endmodule


module SYS_TOP ( REF_CLK, UART_CLK, RST, RX_IN, SI, SE, Scan_clk, Scan_rst, 
        Test_mode, SO, TX_OUT, Parity_error, Framing_error, test_si2, test_so2, 
        test_si3, test_so3, test_si4, test_so4 );
  input REF_CLK, UART_CLK, RST, RX_IN, SI, SE, Scan_clk, Scan_rst, Test_mode,
         test_si2, test_si3, test_si4;
  output SO, TX_OUT, Parity_error, Framing_error, test_so2, test_so3, test_so4;
  wire   CLK_M_UART, CLK_M_TX, RST_M_UART, bus_enable_RX, Data_Valid_TX_SYNC,
         SYNC_Busy, CLK_M_REF, RST_M_REF, enable_pulse_RX, Data_Valid_TX_ASYNC,
         RST_M_SYN, SYNC_RST1, SYNC_RST2, o_div_clk, Gate_Enable, ALU_CLK,
         CLK_M_ALU, ALU_Enable, ALU_OUT_Valid, RdEn, WrEn, RdData_Valid, n1,
         n2, n3, n4, n6, n7, n8, n9, n10, n11, n12, n13, n14, n17, n18, n21,
         n22, n27, SYNOPSYS_UNCONNECTED_1, SYNOPSYS_UNCONNECTED_2,
         SYNOPSYS_UNCONNECTED_3, SYNOPSYS_UNCONNECTED_4;
  wire   [5:0] Reg2;
  wire   [7:0] Unsync_bus_RX;
  wire   [7:0] sync_bus_TX;
  wire   [7:0] sync_bus_RX;
  wire   [7:0] Unsync_bus_TX;
  wire   [4:0] Reg3;
  wire   [7:0] Reg0;
  wire   [7:0] Reg1;
  wire   [3:0] ALU_FUN;
  wire   [15:0] ALU_OUT;
  wire   [3:0] Reg_Address;
  wire   [7:0] WrData;
  wire   [7:0] RdData;

  INVX2M U2 ( .A(n9), .Y(n1) );
  INVX2M U3 ( .A(n10), .Y(n9) );
  CLKINVX2M U4 ( .A(n1), .Y(n2) );
  INVXLM U5 ( .A(n1), .Y(n3) );
  CLKINVX2M U6 ( .A(n1), .Y(n4) );
  CLKAND2X4M U7 ( .A(n13), .B(n14), .Y(SYNC_Busy) );
  INVX4M U8 ( .A(n12), .Y(n11) );
  CLKBUFX2M U9 ( .A(Reg_Address[1]), .Y(n8) );
  CLKBUFX2M U10 ( .A(Reg_Address[0]), .Y(n7) );
  CLKBUFX2M U11 ( .A(RX_IN), .Y(n6) );
  INVX2M U12 ( .A(RST_M_REF), .Y(n10) );
  INVX2M U13 ( .A(RST_M_UART), .Y(n12) );
  UART_test_1 U1 ( .RX_IN(n6), .PAR_EN(Reg2[0]), .PAR_TYP(Reg2[1]), .RX_CLK(
        CLK_M_UART), .TX_CLK(CLK_M_TX), .RST(n11), .Prescale(Reg2[5:2]), 
        .data_valid_RX(bus_enable_RX), .Parity_error(Parity_error), 
        .Framing_error(Framing_error), .P_DATA_RX(Unsync_bus_RX), 
        .Data_Valid_TX(Data_Valid_TX_SYNC), .P_DATA_TX(sync_bus_TX), .TX_OUT(
        TX_OUT), .Busy(n13), .test_si(n17), .test_so(test_so4), .test_se(SE)
         );
  DATA_SYNC_NUM_STAGES2_BUS_WIDTH8_test_0 SYNC_RX1 ( .Unsync_bus(Unsync_bus_RX), .bus_enable(bus_enable_RX), .CLK(CLK_M_REF), .RST(n2), .enable_pulse(
        enable_pulse_RX), .sync_bus(sync_bus_RX), .test_si(n21), .test_se(SE)
         );
  BIT_SYNC_NUM_STAGES2_BUS_WIDTH1_test_0 BUSY_SYNC1 ( .ASYNC(1'b0), .CLK(
        CLK_M_REF), .RST(n9), .SYNC(n14), .test_si(n27), .test_se(SE) );
  BIT_SYNC_NUM_STAGES2_BUS_WIDTH1_test_1 Data_Valid_TX_SYNC1 ( .ASYNC(
        Data_Valid_TX_ASYNC), .CLK(CLK_M_UART), .RST(n11), .SYNC(
        Data_Valid_TX_SYNC), .test_si(n14), .test_se(SE) );
  DATA_SYNC_NUM_STAGES2_BUS_WIDTH8_test_1 SYNC_TX1 ( .Unsync_bus(Unsync_bus_TX), .bus_enable(Data_Valid_TX_ASYNC), .CLK(CLK_M_UART), .RST(n11), .sync_bus(
        sync_bus_TX), .test_si(sync_bus_RX[7]), .test_se(SE) );
  RST_SYNC_test_0 RST_SYNC1 ( .RST(RST_M_SYN), .CLK(CLK_M_REF), .SYNC_RST(
        SYNC_RST1), .test_si(RdData[7]), .test_so(n22), .test_se(SE) );
  RST_SYNC_test_1 RST_SYNC2 ( .RST(RST_M_SYN), .CLK(CLK_M_UART), .SYNC_RST(
        SYNC_RST2), .test_si(n22), .test_so(n21), .test_se(SE) );
  CLK_Divider_test_1 TX_DIV1 ( .i_ref_clk(CLK_M_UART), .i_rst_n(n11), 
        .i_clk_en(1'b1), .i_div_ratio(Reg3), .o_div_clk(o_div_clk), .test_si(
        n18), .test_so(n17), .test_se(SE) );
  CLK_Gate CLK_Gate1 ( .Enable(Gate_Enable), .CLK(CLK_M_REF), .Gated_CLK(
        ALU_CLK) );
  ALU_test_1 ALU1 ( .A(Reg0), .B(Reg1), .ALU_FUN(ALU_FUN), .CLK(CLK_M_ALU), 
        .RST(n3), .Enable(ALU_Enable), .ALU_OUT(ALU_OUT), .OUT_VALID(
        ALU_OUT_Valid), .test_si(SI), .test_so(n27), .test_se(SE) );
  Reg_File_test_1 REG_FILE1 ( .CLK(CLK_M_REF), .RST(n4), .RdEn(RdEn), .WrEn(
        WrEn), .Address({Reg_Address[3:2], n8, n7}), .WrData(WrData), .RdData(
        RdData), .Reg0(Reg0), .Reg1(Reg1), .Reg2({SO, SYNOPSYS_UNCONNECTED_1, 
        Reg2}), .Reg3({SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, 
        SYNOPSYS_UNCONNECTED_4, Reg3}), .RdData_Valid(RdData_Valid), 
        .test_si3(test_si3), .test_si2(test_si2), .test_si1(Data_Valid_TX_SYNC), .test_so1(test_so2), .test_se(SE) );
  SYS_CTRL_test_1 SYS_CTRL1 ( .ALU_OUT_VLD(ALU_OUT_Valid), .RdData_VLD(
        RdData_Valid), .Busy(SYNC_Busy), .CLK(CLK_M_REF), .RST(n2), .ALU_OUT(
        ALU_OUT), .RdData(RdData), .TX_P_Data(Unsync_bus_TX), .TX_D_VLD(
        Data_Valid_TX_ASYNC), .Data_valid(enable_pulse_RX), .P_Data_RX(
        sync_bus_RX), .ALU_EN(ALU_Enable), .CLK_EN(Gate_Enable), .WrEn(WrEn), 
        .RdEn(RdEn), .ALU_FUN(ALU_FUN), .Address(Reg_Address), .WrData(WrData), 
        .test_si2(test_si4), .test_si1(sync_bus_TX[7]), .test_so2(n18), 
        .test_so1(test_so3), .test_se(SE) );
  MUX2x1_6 DFT_CLK_UART ( .IN0(UART_CLK), .IN1(Scan_clk), .Sel(Test_mode), 
        .OUT(CLK_M_UART) );
  MUX2x1_5 DFT_RST_UART ( .IN0(SYNC_RST2), .IN1(Scan_rst), .Sel(Test_mode), 
        .OUT(RST_M_UART) );
  MUX2x1_4 DFT_CLK_REF ( .IN0(REF_CLK), .IN1(Scan_clk), .Sel(Test_mode), .OUT(
        CLK_M_REF) );
  MUX2x1_3 DFT_RST_REF ( .IN0(SYNC_RST1), .IN1(Scan_rst), .Sel(Test_mode), 
        .OUT(RST_M_REF) );
  MUX2x1_2 DFT_RST_SYN ( .IN0(RST), .IN1(Scan_rst), .Sel(Test_mode), .OUT(
        RST_M_SYN) );
  MUX2x1_1 DFT_CLK_TX ( .IN0(o_div_clk), .IN1(Scan_clk), .Sel(Test_mode), 
        .OUT(CLK_M_TX) );
  MUX2x1_0 DFT_CLK_ALU ( .IN0(ALU_CLK), .IN1(Scan_clk), .Sel(Test_mode), .OUT(
        CLK_M_ALU) );
endmodule


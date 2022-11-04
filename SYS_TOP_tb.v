`timescale 1us/1ns
module SYS_TOP_tb ();
    
    reg REF_CLK_tb, UART_CLK_tb, RST_tb, RX_IN_tb;
    wire TX_OUT_tb, Parity_error_tb, Framing_error_tb;

    initial 
    begin
        RST_tb = 1'b1;
        RX_IN_tb = 1'b1;

        #104
        RST_tb = 1'b0;
        #104
        RST_tb = 1'b1;

        //--------------RF_WR_CMD------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 0 = 10101010----------//
        #832
        RX_IN_tb = 1'b0; //---------start bit------//
        #832
        RX_IN_tb = 1'b0; //---------first bit------//
        #832
        RX_IN_tb = 1'b1; //---------second bit------//
        #832
        RX_IN_tb = 1'b0; //---------third bit------//
        #832
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #832
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #832
        RX_IN_tb = 1'b1; //---------sixth bit------//
        #832
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #832
        RX_IN_tb = 1'b1; //---------eigth bit------//
        #832
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #832
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------RF_WR_Addr------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 1 = 00001010----------//
        #1664
        RX_IN_tb = 1'b0; //---------start bit------//
        #832
        RX_IN_tb = 1'b0; //---------first bit------//
        #832
        RX_IN_tb = 1'b1; //---------second bit------//
        #832
        RX_IN_tb = 1'b0; //---------third bit------//
        #832
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #832
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #832
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #832
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #832
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #832
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #832
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------RF_WR_Data------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 2 = 00001111----------//
        #1664
        RX_IN_tb = 1'b0; //---------start bit------//
        #832
        RX_IN_tb = 1'b1; //---------first bit------//
        #832
        RX_IN_tb = 1'b1; //---------second bit------//
        #832
        RX_IN_tb = 1'b1; //---------third bit------//
        #832
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #832
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #832
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #832
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #832
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #832
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #832
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------RF_Rd_CMD------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 0 = 1011_1011----------//
        #1664
        RX_IN_tb = 1'b0; //---------start bit------//
        #832
        RX_IN_tb = 1'b1; //---------first bit------//
        #832
        RX_IN_tb = 1'b1; //---------second bit------//
        #832
        RX_IN_tb = 1'b0; //---------third bit------//
        #832
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #832
        RX_IN_tb = 1'b1; //---------fifth bit------//
        #832
        RX_IN_tb = 1'b1; //---------sixth bit------//
        #832
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #832
        RX_IN_tb = 1'b1; //---------eigth bit------//
        #832
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #832
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------RF_Rd_Addr------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 1 = 00001010----------//
        #1664
        RX_IN_tb = 1'b0; //---------start bit------//
        #832
        RX_IN_tb = 1'b0; //---------first bit------//
        #832
        RX_IN_tb = 1'b1; //---------second bit------//
        #832
        RX_IN_tb = 1'b0; //---------third bit------//
        #832
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #832
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #832
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #832
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #832
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #832
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #832
        RX_IN_tb = 1'b1; //---------stop bit------//

        #9984
        $finish;


    end


    initial 
    begin
        REF_CLK_tb = 1'b0; 
        forever #0.01 REF_CLK_tb = ~REF_CLK_tb;
    end

    initial 
    begin
        UART_CLK_tb = 1'b0;
        forever #52 UART_CLK_tb = ~UART_CLK_tb;   
    end

    SYS_TOP TB1 (
            .REF_CLK(REF_CLK_tb),
            .UART_CLK(UART_CLK_tb),
            .RST(RST_tb),
            .RX_IN(RX_IN_tb),
            .TX_OUT(TX_OUT_tb),
            .Parity_error(Parity_error_tb),
            .Framing_error(Framing_error_tb)
    );

endmodule
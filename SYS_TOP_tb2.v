`timescale 1us/1ns
module SYS_TOP_tb2 ();
    
    reg REF_CLK_tb, UART_CLK_tb, RST_tb, RX_IN_tb;
    wire TX_OUT_tb, Parity_error_tb, Framing_error_tb;

    initial 
    begin
        RST_tb = 1'b1;
        RX_IN_tb = 1'b1;

        #1
        RST_tb = 1'b0;
        #1
        RST_tb = 1'b1;

        //*********************************************************************************************************//

        //--------------RF_WR_CMD------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 0 = 10101010----------//
        #8
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b0; //---------first bit------//
        #8
        RX_IN_tb = 1'b1; //---------second bit------//
        #8
        RX_IN_tb = 1'b0; //---------third bit------//
        #8
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b1; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b1; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------RF_WR_Addr------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 1 = 00001010----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b0; //---------first bit------//
        #8
        RX_IN_tb = 1'b1; //---------second bit------//
        #8
        RX_IN_tb = 1'b0; //---------third bit------//
        #8
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------RF_WR_Data------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 2 = 00001111----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b1; //---------first bit------//
        #8
        RX_IN_tb = 1'b1; //---------second bit------//
        #8
        RX_IN_tb = 1'b1; //---------third bit------//
        #8
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//
        

        //*********************************************************************************************************************//

        //--------------RF_Rd_CMD------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 0 = 1011_1011----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b1; //---------first bit------//
        #8
        RX_IN_tb = 1'b1; //---------second bit------//
        #8
        RX_IN_tb = 1'b0; //---------third bit------//
        #8
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b1; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b1; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b1; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------RF_Rd_Addr------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 1 = 00001010----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b0; //---------first bit------//
        #8
        RX_IN_tb = 1'b1; //---------second bit------//
        #8
        RX_IN_tb = 1'b0; //---------third bit------//
        #8
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//
        

        //************************************************************************************************************************//

        //--------------ALU_OPER_W_OP_CMD------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 0 = 1100_1100----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b0; //---------first bit------//
        #8
        RX_IN_tb = 1'b0; //---------second bit------//
        #8
        RX_IN_tb = 1'b1; //---------third bit------//
        #8
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b1; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b1; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//


        //------------we will do 8*4=32------------//
        //--------------Operand A = 8 ------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 1 = 0000_1000----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b0; //---------first bit------//
        #8
        RX_IN_tb = 1'b0; //---------second bit------//
        #8
        RX_IN_tb = 1'b0; //---------third bit------//
        #8
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b1; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------Operand B = 4 ------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 2 = 0000_0100----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b0; //---------first bit------//
        #8
        RX_IN_tb = 1'b0; //---------second bit------//
        #8
        RX_IN_tb = 1'b1; //---------third bit------//
        #8
        RX_IN_tb = 1'b0; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b1; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//


        //--------------ALU_FUN ------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 3 = 0000_0010----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b0; //---------first bit------//
        #8
        RX_IN_tb = 1'b1; //---------second bit------//
        #8
        RX_IN_tb = 1'b0; //---------third bit------//
        #8
        RX_IN_tb = 1'b0; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b1; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//



        //************************************************************************************************************************//
        
        #150
        //--------------ALU_OPER_W_NOP_CMD------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 0 = 1101_1101----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b1; //---------first bit------//
        #8
        RX_IN_tb = 1'b0; //---------second bit------//
        #8
        RX_IN_tb = 1'b1; //---------third bit------//
        #8
        RX_IN_tb = 1'b1; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b1; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b1; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b1; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//

        //--------------ALU_FUN ------------//
        //----------Parity is enabled and even-----------//
        //-------------frame 3 = 0000_0011 >> division----------//
        #16
        RX_IN_tb = 1'b0; //---------start bit------//
        #8
        RX_IN_tb = 1'b1; //---------first bit------//
        #8
        RX_IN_tb = 1'b1; //---------second bit------//
        #8
        RX_IN_tb = 1'b0; //---------third bit------//
        #8
        RX_IN_tb = 1'b0; //---------fourth bit------//
        #8
        RX_IN_tb = 1'b0; //---------fifth bit------//
        #8
        RX_IN_tb = 1'b0; //---------sixth bit------//
        #8
        RX_IN_tb = 1'b0; //---------seventh bit------//
        #8
        RX_IN_tb = 1'b0; //---------eigth bit------//
        #8
        RX_IN_tb = 1'b0; //---------Parity bit------//
        #8
        RX_IN_tb = 1'b1; //---------stop bit------//

        #200
        $stop;


    end


    initial 
    begin
        REF_CLK_tb = 1'b0; 
        forever #0.01 REF_CLK_tb = ~REF_CLK_tb;
    end

    initial 
    begin
        UART_CLK_tb = 1'b0;
        forever #0.5 UART_CLK_tb = ~UART_CLK_tb;   
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
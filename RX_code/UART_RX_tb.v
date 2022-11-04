`timescale 1ns/1ps
module UART_RX_tb ();

reg RX_IN_tb, PAR_EN_tb, PAR_TYP_tb, CLK_tb, RST_tb;
reg [3:0] Prescale_tb;
wire data_valid_tb, Parity_error_tb,  Framing_error_tb;
wire [7:0] P_DATA_tb;

initial 
begin
    RX_IN_tb = 1'b1;
    PAR_EN_tb = 1'b0; 
    PAR_TYP_tb = 1'b0; 
    RST_tb = 1'b1;
    Prescale_tb = 4'b1000;

    @(negedge CLK_tb)
    RST_tb = 1'b0;
    @(negedge CLK_tb)
    RST_tb = 1'b1;

    //---------defining the parity enables here
    PAR_EN_tb = 1'b1;  //   disable = 0     enable = 1
    PAR_TYP_tb = 1'b1;  // even = 0         odd = 1

    #40 
    RX_IN_tb = 1'b0;  // start bit here
    

    
    //-----data : 10010011
    #40
    RX_IN_tb = 1'b1;  // first and second bit = 1

    #80 
    RX_IN_tb = 1'b0;  // thrid and fourth bit = 0

    #80 
    RX_IN_tb = 1'b1;  // fifth bit = 1

    #40 
    RX_IN_tb = 1'b0;  // sixth and seventh bit = 0

    #80 
    RX_IN_tb = 1'b1;  // eighth bit = 1

    #40
    RX_IN_tb = 1'b1;  // parity bit should be 1 when odd

    #40 
    RX_IN_tb = 1'b1;  // stop bit = 1


    #40


    /*if (P_DATA_tb == 8'b10010011 && data_valid_tb) 
    begin
        $display("data valid signal is HIGH : success");
        $display("P_DATA is 10010011 : success");
    end
    else if(P_DATA_tb != 8'b10010011 && data_valid_tb)
    begin
        $display("data valid signal is HIGH : success");
        $display("P_DATA is not 10010011 : fail");
        $stop;
    end
    else if(P_DATA_tb == 8'b10010011 && !data_valid_tb)
    begin
        $display("data valid signal is LOW : fail");
        $display("P_DATA is 10010011 : success");
        $stop;
    end
    else
    begin
        $display("data valid signal is LOW : fail");
        $display("P_DATA is not 10010011 : fail");
        $stop;
    end

    #40*/
    //---------defining the parity enables here
    PAR_EN_tb = 1'b1;  //   disable = 0     enable = 1
    PAR_TYP_tb = 1'b0;  // even = 0         odd = 1

    //#40 
    RX_IN_tb = 1'b0;  // start bit here
    

    
    //-----data : 00001111
    #40
    RX_IN_tb = 1'b1;  // first and second bit = 1

    #80 
    RX_IN_tb = 1'b1;  // thrid and fourth bit = 1

    #80 
    RX_IN_tb = 1'b0;  // fifth bit = 0

    #40 
    RX_IN_tb = 1'b0;  // sixth and seventh bit = 0

    #80 
    RX_IN_tb = 1'b0;  // eighth bit = 0

    #40
    RX_IN_tb = 1'b0;  // parity bit should be 0 when even

    /*#40 
    RX_IN_tb = 1'b0;  // stop bit = 0 wrong one*/

    #40 
    RX_IN_tb = 1'b1;  // stop bit = 1 right one


    



    


    #200

    if (P_DATA_tb == 8'b00001111 && data_valid_tb) 
    begin
        $display("data valid signal is HIGH : success");
        $display("P_DATA is 00001111 : success");
    end
    else if(P_DATA_tb != 8'b00001111 && data_valid_tb)
    begin
        $display("data valid signal is HIGH : success");
        $display("P_DATA is not 00001111 : fail");
        $stop;
    end
    else if(P_DATA_tb == 8'b00001111 && !data_valid_tb)
    begin
        $display("data valid signal is LOW : fail");
        $display("P_DATA is 00001111 : success");
        $stop;
    end
    else
    begin
        $display("data valid signal is LOW : fail");
        $display("P_DATA is not 00001111 : fail");
        $stop;
    end
    


$finish;



end

initial 
begin
    CLK_tb = 1'b1;
    forever #2.5 CLK_tb =~CLK_tb;
end

UART_RX RX1 (
        .RX_IN(RX_IN_tb),
        .PAR_EN(PAR_EN_tb),
        .PAR_TYP(PAR_TYP_tb),
        .CLK(CLK_tb),
        .RST(RST_tb),
        .Prescale(Prescale_tb),
        .data_valid(data_valid_tb),
        .Parity_error(Parity_error_tb),
        .Framing_error(Framing_error_tb),
        .P_DATA(P_DATA_tb)
);
    
endmodule
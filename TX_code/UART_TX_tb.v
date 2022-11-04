`timescale 1ns/1ps
module UART_TX_tb ();

reg CLK_tb, RST_tb, PAR_TYP_tb, PAR_EN_tb, Data_Valid_tb;
reg [7:0]   P_DATA_tb;
wire TX_OUT_tb, Busy_tb;

initial 
begin
    RST_tb = 1'b1;

//------------------Reset the system---------//
    @(negedge CLK_tb)
    RST_tb = 1'b0;
    @(negedge CLK_tb)
    RST_tb = 1'b1;

    PAR_TYP_tb = 1'b1; // 0:even parity                     1:odd parity
    PAR_EN_tb = 1'b1; //  0:disable parity                  1:enable the parity bit
    Data_Valid_tb = 1'b0; // start in the idle state
    P_DATA_tb = 8'b11001011; // Data to be transmitted



//--------------to enable the functionality-----------//

//--------------in the idle state-------------------//
    @(negedge CLK_tb)
    Data_Valid_tb = 1'b1;
    if(!Busy_tb && TX_OUT_tb)
        begin
            $display("Busy signal is LOW at idle state : success");
            $display("TX OUT is HIGH in idle state: success");
        end
    else if (!Busy_tb && !TX_OUT_tb) 
        begin
            $display("Busy signal is LOW at idle state : success");
            $display("TX OUT is LOW in idle state: fail");
            $stop;
        end
    else if (Busy_tb && !TX_OUT_tb) 
        begin
            $display("Busy signal is HIGH at idle state : fail");
            $display("TX OUT is LOW in idle state: fail");
            $stop;
        end
    else
        begin
            $display("Busy signal is HIGH at idle state : fail");
            $display("TX OUT is HIGH in idle state: success");
            $stop;
        end
    $display("----------------------------------------------------------");



//-------------in the start state-----------//
    repeat (2) @(negedge CLK_tb)
    Data_Valid_tb = 1'b0;
    if(!Busy_tb && TX_OUT_tb)
        begin
            $display("Busy signal is LOW at start state : fail");
            $display("TX OUT is HIGH in start state: fail");
            $stop;
        end
    else if (!Busy_tb && !TX_OUT_tb) 
        begin
            $display("Busy signal is LOW at start state : fail");
            $display("TX OUT is LOW in start state: success");
            $stop;
        end
    else if (Busy_tb && !TX_OUT_tb) 
        begin
            $display("Busy signal is HIGH at start state : success");
            $display("TX OUT is LOW in start state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at start state : success");
            $display("TX OUT is HIGH in start state: fail");
            $stop;
        end
    $display("----------------------------------------------------------");



    
//----------------in the sending state------------//
    @(negedge CLK_tb)
    
    if(!Busy_tb && (TX_OUT_tb == 1'b1))
        begin
            $display("Busy signal is LOW at sending state : fail");
            $display("TX OUT sending first bit in sending state: success");
            $stop;
        end
    else if (!Busy_tb && (TX_OUT_tb != 1'b1)) 
        begin
            $display("Busy signal is LOW at sending state : fail");
            $display("TX OUT isn't sending first bit in sending state: fail");
            $stop;
        end
    else if (Busy_tb && (TX_OUT_tb == 1'b1)) 
        begin
            $display("Busy signal is HIGH at sending state : success");
            $display("TX OUT is sending first bit in sending state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at sending state : success");
            $display("TX OUT isn't sending first bit in sending state: fail");
            $stop;
        end
    $display("----------------------------------------------------------");

    

//--------------the last cycle in the sending state-------------//
    #36
    if(!Busy_tb && (TX_OUT_tb == 1'b1))
        begin
            $display("Busy signal is LOW at sending state : fail");
            $display("TX OUT sending last bit in sending state: success");
            $stop;
        end
    else if (!Busy_tb && (TX_OUT_tb != 1'b1)) 
        begin
            $display("Busy signal is LOW at sending state : fail");
            $display("TX OUT isn't sending last bit in sending state: fail");
            $stop;
        end
    else if (Busy_tb && (TX_OUT_tb == 1'b1)) 
        begin
            $display("Busy signal is HIGH at sending state : success");
            $display("TX OUT is sending last bit in sending state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at sending state : success");
            $display("TX OUT isn't sending last bit in sending state: fail");
            $stop;
        end
    $display("----------------------------------------------------------");



//--------------checking the parity bit in the parity state-------------//
    @(negedge CLK_tb)
    if(!Busy_tb && (!TX_OUT_tb))
        begin
            $display("Busy signal is LOW at parity state : fail");
            $display("TX OUT sending parity bit in parity state: success");
            $stop;
        end
    else if (!Busy_tb && (TX_OUT_tb)) 
        begin
            $display("Busy signal is LOW at parity state : fail");
            $display("TX OUT isn't sending parity bit in parity state: fail");
            $stop;
        end
    else if (Busy_tb && (!TX_OUT_tb)) 
        begin
            $display("Busy signal is HIGH at parity state : success");
            $display("TX OUT is sending parity bit in parity state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at parity state : success");
            $display("TX OUT isn't sending parity bit in parity state: fail");
            $stop;
        end
    $display("----------------------------------------------------------");




//------------- in the stop bit------------//
    @(negedge CLK_tb)
    if(!Busy_tb && (TX_OUT_tb))
        begin
            $display("Busy signal is LOW at stop state : fail");
            $display("TX OUT sending stop bit in stop state: success");
            $stop;
        end
    else if (!Busy_tb && (!TX_OUT_tb)) 
        begin
            $display("Busy signal is LOW at stop state : fail");
            $display("TX OUT isn't sending stop bit in stop state: fail");
            $stop;
        end
    else if (Busy_tb && (TX_OUT_tb)) 
        begin
            $display("Busy signal is HIGH at stop state : success");
            $display("TX OUT is sending stop bit in stop state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at stop state : success");
            $display("TX OUT isn't sending stop bit in stop state: fail");
            $stop;
        end


#50

//----------------------New data sending---------------//

    PAR_TYP_tb = 1'b1; // 0:even parity                     1:odd parity
    PAR_EN_tb = 1'b0; //  0:disable parity                  1:enable the parity bit
    Data_Valid_tb = 1'b1;
    P_DATA_tb = 8'b01101010;



    //--------------in the idle state-------------------//
    #5
    Data_Valid_tb = 1'b1;
    if(!Busy_tb && TX_OUT_tb)
        begin
            $display("Busy signal is LOW at idle state : success");
            $display("TX OUT is HIGH in idle state: success");
        end
    else if (!Busy_tb && !TX_OUT_tb) 
        begin
            $display("Busy signal is LOW at idle state : success");
            $display("TX OUT is LOW in idle state: fail");
            $stop;
        end
    else if (Busy_tb && !TX_OUT_tb) 
        begin
            $display("Busy signal is HIGH at idle state : fail");
            $display("TX OUT is LOW in idle state: fail");
            $stop;
        end
    else
        begin
            $display("Busy signal is HIGH at idle state : fail");
            $display("TX OUT is HIGH in idle state: success");
            $stop;
        end
    $display("----------------------------------------------------------");






//-------------in the start state-----------//
    #5
    Data_Valid_tb = 1'b0;
    if(!Busy_tb && TX_OUT_tb)
        begin
            $display("Busy signal is LOW at start state : fail");
            $display("TX OUT is HIGH in start state: fail");
            $stop;
        end
    else if (!Busy_tb && !TX_OUT_tb) 
        begin
            $display("Busy signal is LOW at start state : fail");
            $display("TX OUT is LOW in start state: success");
            $stop;
        end
    else if (Busy_tb && !TX_OUT_tb) 
        begin
            $display("Busy signal is HIGH at start state : success");
            $display("TX OUT is LOW in start state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at start state : success");
            $display("TX OUT is HIGH in start state: fail");
            $stop;
        end
    $display("----------------------------------------------------------");



    
//----------------in the sending state------------//
    #5
    if(!Busy_tb && (TX_OUT_tb == 1'b0))
        begin
            $display("Busy signal is LOW at sending state : fail");
            $display("TX OUT sending first bit in sending state: success");
            $stop;
        end
    else if (!Busy_tb && (TX_OUT_tb != 1'b0)) 
        begin
            $display("Busy signal is LOW at sending state : fail");
            $display("TX OUT isn't sending first bit in sending state: fail");
            $stop;
        end
    else if (Busy_tb && (TX_OUT_tb == 1'b0)) 
        begin
            $display("Busy signal is HIGH at sending state : success");
            $display("TX OUT is sending first bit in sending state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at sending state : success");
            $display("TX OUT isn't sending first bit in sending state: fail");
            $stop;
        end
    $display("----------------------------------------------------------");

    

//--------------the last cycle in the sending state-------------//
    #36
    if(!Busy_tb && (TX_OUT_tb == 1'b0))
        begin
            $display("Busy signal is LOW at sending state : fail");
            $display("TX OUT sending last bit in sending state: success");
            $stop;
        end
    else if (!Busy_tb && (TX_OUT_tb != 1'b0)) 
        begin
            $display("Busy signal is LOW at sending state : fail");
            $display("TX OUT isn't sending last bit in sending state: fail");
            $stop;
        end
    else if (Busy_tb && (TX_OUT_tb == 1'b0)) 
        begin
            $display("Busy signal is HIGH at sending state : success");
            $display("TX OUT is sending last bit in sending state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at sending state : success");
            $display("TX OUT isn't sending last bit in sending state: fail");
            $stop;
        end
    $display("----------------------------------------------------------");



/*//--------------checking the parity bit in the parity state-------------//
    #5
    if(!Busy_tb && (TX_OUT_tb))
        begin
            $display("Busy signal is LOW at parity state : fail");
            $display("TX OUT sending parity bit in parity state: success");
            $stop;
        end
    else if (!Busy_tb && (!TX_OUT_tb)) 
        begin
            $display("Busy signal is LOW at parity state : fail");
            $display("TX OUT isn't sending parity bit in parity state: fail");
            $stop;
        end
    else if (Busy_tb && (TX_OUT_tb)) 
        begin
            $display("Busy signal is HIGH at parity state : success");
            $display("TX OUT is sending parity bit in parity state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at parity state : success");
            $display("TX OUT isn't sending parity bit in parity state: fail");
            $stop;
        end
    $display("----------------------------------------------------------");
*/


//------------- in the stop bit------------//
    #5
    if(!Busy_tb && (TX_OUT_tb))
        begin
            $display("Busy signal is LOW at stop state : fail");
            $display("TX OUT sending stop bit in stop state: success");
            $stop;
        end
    else if (!Busy_tb && (!TX_OUT_tb)) 
        begin
            $display("Busy signal is LOW at stop state : fail");
            $display("TX OUT isn't sending stop bit in stop state: fail");
            $stop;
        end
    else if (Busy_tb && (TX_OUT_tb)) 
        begin
            $display("Busy signal is HIGH at stop state : success");
            $display("TX OUT is sending stop bit in stop state: success");
        end
    else
        begin
            $display("Busy signal is HIGH at stop state : success");
            $display("TX OUT isn't sending stop bit in stop state: fail");
            $stop;
        end




    #50
    $finish;

end



//--------defining the clock-----------//
initial 
begin
    CLK_tb = 1'b1;
    forever #2.5 CLK_tb = ~CLK_tb;    
end


//----------------instantiating the module---------------//
UART_TX TOP (
        .CLK(CLK_tb),
        .RST(RST_tb),
        .PAR_TYP(PAR_TYP_tb),
        .PAR_EN(PAR_EN_tb),
        .Data_Valid(Data_Valid_tb),
        .P_DATA(P_DATA_tb),
        .TX_OUT(TX_OUT_tb),
        .Busy(Busy_tb)
);
    
endmodule
`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: rx
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: Dec 1st, 2021
*
* Description: Receives signals
*
*
****************************************************************************/



module rx(
    input wire logic clk, Reset, Sin,
    output logic Receive,
    input wire logic Received,
    output logic [7:0] Dout,
    output logic parityErr
    );
    
    ////Internal Signals////
    logic clrTimer, timerDone, half, full, incBit, clrBit, bitDone, shift;
    logic [13:0] timer;
    logic [3:0] bitCounter;
    logic [9:0] register;
    
    ////Baud Timer////
    always_ff@(posedge clk)
        if(clrTimer | timerDone)
            timer <= 0;
         else
            timer <= timer+1;  
                    
    assign timerDone = (timer == 5208)?1'b1:1'b0;
    assign half = (timer == 2604)?1'b1:1'b0;
    assign full = (timer == 5208)?1'b1:1'b0;
    
    ////Bit counter////
    
    always_ff@(posedge clk)
        if (clrBit)
            bitCounter <= 0;
        else if (incBit)
            bitCounter <= bitCounter + 1;
            
    assign bitDone = (bitCounter == 10)?1'b1:1'b0;
    
    ////Shift Register////
    always_ff@(posedge clk)
        if (shift)
            register <= {Sin, register[9:1]};
        
    
    ////Parity checker////
    always_ff@(posedge clk)
        if (register[8] == 1 && Receive == 1)
            parityErr = 1;
        else
            parityErr = 0;
            
    ////Dout////
    assign Dout[7:0] = register[7:0]; 

    
    ////Finite State Machine////
    typedef enum logic[2:0] {idle, start, halfWay, load, ack, ERR='X} StateType;
    StateType ns, cs;
    
    always_comb
    begin
        ns = ERR;
        clrTimer = 0;
        shift = 0;
        incBit = 0;
        clrBit = 0;
        Receive = 0;
        
        if (Reset)
            ns = idle;
        else
            case (cs)
                idle: 
                      begin
                      clrTimer = 1;
                      if (~Sin)
                          ns = start;
                      else if (Sin)
                          ns = idle;
                      end
                start: 
                      if (~half)
                           ns = start;
                      else
                      begin
                           clrBit = 1;
                           clrTimer = 1;
                           ns = halfWay;     
                      end
                halfWay: 
                        if (~full)
                            ns = halfWay;
                         else
                            ns = load;
                load: 
                        if (~bitDone)
                        begin
                            shift = 1;
                            incBit = 1;
                            ns = halfWay;
                        end
                        else
                            ns = ack;    
                ack: 
                    begin
                        Receive = 1;
                        if (Received)
                        begin
                            Receive = 0;
                            ns = idle;
                         end
                         else
                         begin
                            ns = ack;
                         end
                     end
            endcase
    end
    
    always_ff@(posedge clk)
        cs <= ns;
    
endmodule

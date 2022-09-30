/***************************************************************************
*
* Module: tx
*
* Author: Brian Smith
* Class: EcEn 220, Section 1, Spring 2021
* Date: June 3, 2021
*
* Description: TX UART Transmitter
*
****************************************************************************/
`timescale 1ns / 1ps
`default_nettype none

module tx(
    output logic Sent, Sout,
    input wire logic clk, Reset, Send,
    input wire logic [7:0] Din);
   
    typedef enum logic [2:0] {IDLE, START, BITS, PAR, STOP, ACK, ERR='X} StateType;
    StateType ns, cs;
   
    logic [12:0] timerCount;
    logic clrTimer, timerDone;
    logic [2:0] bitCount;
    logic clrBit, incBit, bitDone;
    logic startBit, dataBit, parityBit;
   
    //FSM
    always_comb
    begin
        //Default cases
        ns = ERR;
        Sent = 0;
       
        clrTimer = 0;
        startBit = 0;
        clrBit = 0;
        incBit = 0;
        dataBit = 0;
        parityBit = 0;
       
        //States
        if (Reset)
            ns = IDLE;
        else
            case (cs)
                IDLE:
                begin
                    clrTimer = 1;
                   
                    if (~Send)
                        ns = IDLE;
                    else
                        ns = START;
                end
                START:
                begin
                    startBit = 1;
                   
                    if (~timerDone)
                        ns = START;
                    else
                    begin
                        ns = BITS;
                        clrBit = 1;
                    end
                end
                BITS:
                begin
                    dataBit = 1;
                   
                    if (~timerDone)
                        ns = BITS;
                    else if (~bitDone)
                    begin
                        ns = BITS;
                        incBit = 1;
                    end
                    else
                        ns = PAR;
                end
                PAR:
                begin
                    parityBit = 1;
                   
                    if (~timerDone)
                        ns = PAR;
                    else
                        ns = STOP;
                end
                STOP:
                begin
                    if (~timerDone)
                        ns = STOP;
                    else
                        ns = ACK;
                end
                ACK:
                begin
                    Sent = 1;
                   
                    if (Send)
                        ns = ACK;
                    else
                        ns = IDLE;
                end
            endcase        
    end
   
   assign timerDone = (timerCount == 5209)?1:0;
   
    always_ff@(posedge clk)
    begin
    //State Machine Shift
    cs <= ns;
   
    //Baud Timer
    if (clrTimer || timerDone)
        timerCount <= 0;
    else
        timerCount <= timerCount + 1;
   
    //Bit Counter
    bitDone <= 0;
    if (bitCount == 7)
        bitDone <= 1;
    if (clrBit)
        bitCount <= 0;
    else if (incBit)
        bitCount <= bitCount + 1;
   
    //Datapath
    if (startBit)
        Sout <= 0;
    else if (dataBit)
        Sout <= Din[bitCount];
    else if (parityBit)
        Sout <= ~^Din; //Parity bit calculator
    else
        Sout <= 1; //Stop and Idle bit
    end
   
endmodule

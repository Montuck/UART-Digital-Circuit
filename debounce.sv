`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: debouncer
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: 11-3-21
*
* Description: debounces input signals
*
*
****************************************************************************/


module debounce(
    input wire logic clk, reset, noisy,
    output logic debounced
    );
    
    //states definition
    typedef enum logic[1:0] {s0, s1, s2, s3, ERR='X} StateType;
    StateType ns, cs;
    
    //internal signals
    logic tDone, clrTimerDeb;
    logic [19:0] empty;
    
    //timer
    timer t0(.clk(clk), .clrTimer(clrTimerDeb), .timerDone(tDone), .count(empty));
    
    //IFL and OFL
    always_comb
        begin
            //defaults
            ns = ERR;
            debounced = 0;
            clrTimerDeb = 0;
            
            //IFL/OFL
            if (reset) 
                ns = s0;
            else 
                case (cs)
                    s0: begin
                            clrTimerDeb = 1'b1;
                            if (~noisy) 
                                ns = s0;
                            else
                                ns = s1;
                        end
                    s1: if (noisy && ~tDone) 
                            ns = s1;
                        else if (~noisy) 
                            ns = s0;
                        else if (noisy && tDone) 
                            ns = s2;
                    s2: begin
                            clrTimerDeb = 1'b1;
                            debounced = 1'b1;
                            if (noisy) 
                                ns = s2;
                            else if (~noisy) 
                                ns = s3;
                        end
                    s3: begin
                            debounced = 1'b1;
                            if (noisy) 
                                ns = s2;
                            else if (~noisy && ~tDone) 
                                ns = s3;
                            else if (~noisy && tDone) 
                                ns = s0;
                        end
                 endcase
        end
    
    //state register
    always_ff@(posedge clk)
        cs <= ns;

    
endmodule

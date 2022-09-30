`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: stopwatch
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: Nov 3, 2021
*
* Description: stopwatch
*
*
****************************************************************************/


module stopwatch(
    input wire logic clk, reset, run,
    output logic [3:0] digit0, digit1, digit2, digit3    
    );

    logic incNext1, incNext2, incNext3, incNext0, timerSig, rollSig;
    
    //0.01s instance
    mod_counter #(1000000, 20) MC01(.clk(clk), .reset(reset), .increment(run), .rolling_over(incNext0), .count(timerSig));
    
    //mod counters for each digit
    //digit0
    mod_counter MC0(.clk(clk), .reset(reset), .increment(incNext0), .rolling_over(incNext1), .count(digit0));
    //digit1
    mod_counter MC1(.clk(clk), .reset(reset), .increment(incNext1), .rolling_over(incNext2), .count(digit1));
    //digit2
    mod_counter MC2(.clk(clk), .reset(reset), .increment(incNext2), .rolling_over(incNext3), .count(digit2));
    //digit 3, has a different parameter, rolls over at 59, mod_value = 6
    mod_counter #(6, 4) MC3(.clk(clk), .reset(reset), .increment(incNext3), .rolling_over(rollSig), .count(digit3));

endmodule
`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: Timer
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: Nov 3, 2021
*
* Description: 0.01s timer
*
*
****************************************************************************/


module Timer #(parameter MOD_VALUE = 1000000, WID = 20) (
    input wire logic clk, reset, increment,
    output logic rolling_over,
    output logic [WID-1:0] count
    );
    
    //input forming logic
    always_ff @(posedge clk) 
        if (reset)
            count <= 0;
        else if (!reset && increment)
            count <= count+1;
        else if (count == MOD_VALUE-1)
            count <= 0;
            
    //roll-over statement
    assign rolling_over = (count == MOD_VALUE-1 && increment == 1)?1:0;
    
endmodule


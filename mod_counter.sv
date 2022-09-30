`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: mod_counter
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: Nov 2, 2021
*
* Description: counter from 0 to 9
*
*
****************************************************************************/


module mod_counter #(parameter MOD_VALUE = 10, WID = 4) (
    input wire logic clk, reset, increment,
    output logic rolling_over,
    output logic [WID-1:0] count
    );
    
    //input forming logic
    always_ff @(posedge clk) 
        if (reset || rolling_over)
            count <= 0;
        else if (increment && !reset)
            count <= count+1;
            
    //roll-over statement
    assign rolling_over = ((count == (MOD_VALUE-1)) && increment)?1:0;

endmodule

`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: timer
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: 11-3-21
*
* Description: 18 bit counter
*
*
****************************************************************************/


module timer #(parameter COUNTER = 500000, WID=20)(
    input wire logic clk,
    input wire logic clrTimer,
    output logic timerDone, 
    output logic [WID-1:0] count
    );
    
    //input logic
    always_ff @(posedge clk)
        if(clrTimer)
            count <= 0;
        else if (!clrTimer && !timerDone)
            count <= count+1;
        
    //timerDone statement    
    assign timerDone = (count == (COUNTER));
    
endmodule

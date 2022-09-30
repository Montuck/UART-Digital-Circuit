`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: debouncer_top
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: 11-5-21
*
* Description: top module for debouncer
*
*
****************************************************************************/


module debounce_top(
    input wire logic clk, btnu, btnc,
    output logic [3:0] anode,
    output logic [7:0] segment
    );
    
    logic sigOut0, sigOut1, debOut, F1, F2, oneShot0, oneShot1 ;
    logic [7:0] debCounter, unCounter;
    logic [15:0] conCatIn;
    
    //synchronizer
    always_ff@(posedge clk)
        sigOut0 <= btnc;
            
    always_ff@(posedge clk)
        sigOut1 <= sigOut0;
            
    //debounce fsm
    debounce d0(.clk(clk), .reset(btnu), .noisy(sigOut1), .debounced(debOut));
    
    //one shot detector debounced
    always_ff@(posedge clk)
        F1 <= debOut;
             
    assign oneShot0 = (debOut && !F1); 
    
    //one shot detector unbounced
    always_ff@(posedge clk)
        F2 <= sigOut1;
        
    assign oneShot1 = (sigOut1 && !F2);
    
    //debounced counter for debounced signal
    always_ff@(posedge clk)
        if(oneShot0)
            debCounter <= debCounter+1;
        else if (btnu)
            debCounter <= 0;
    
    //undebounced counter
    always_ff@(posedge clk)
        if(oneShot1)
            unCounter <= unCounter+1;
        else if (btnu)
            unCounter <= 0;
    
    //concatenate dataIn for 7 seg display
    assign conCatIn = {unCounter, debCounter};
    
    //instance of 7 seg controller
    SevenSegmentControl s0(.clk(clk), .reset(btnu), .dataIn(conCatIn), .digitDisplay(4'b1111), .digitPoint(4'b0000), .anode(anode), .segment(segment));
    
endmodule

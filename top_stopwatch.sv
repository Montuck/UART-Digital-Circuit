`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: top_stopwatch
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: Nov 3, 2021
*
* Description: stopwatch top module
*
*
****************************************************************************/


module top_stopwatch(
    input wire logic clk, btnc, 
    input wire logic [0:0] sw,
    output logic [3:0] anode, 
    output logic [7:0] segment
    );
    
    //internal logic for dataIn
    logic [15:0] dIn;
    //stopwatch
    stopwatch stop(.clk(clk), .reset(btnc), .run(sw), .digit0(dIn[3:0]), .digit1(dIn[7:4]), .digit2(dIn[11:8]), .digit3(dIn[15:12]));
    //display
    SevenSegmentControl SVC(.clk(clk), .reset(btnc), .dataIn(dIn), .digitDisplay(4'b1111), .digitPoint(4'b0100), .anode(anode), .segment(segment));
    
endmodule

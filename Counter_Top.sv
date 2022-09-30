`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: Counter_Top
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: October 21st, 2021
*
* Description: A simple 4-bit counter top module
*
*
****************************************************************************/


module Counter_Top(
    input wire logic btnc,
    input wire logic [1:0] sw,
    output logic [6:0] segment,
    output logic [3:0] anode,
    output logic [3:0] led
    );
    
logic [3:0] holder;

Counter C0(.CLK(btnc), .INC(sw[1]), .CLR(sw[0]), .Q(holder), .NXT(led));

seven_segment S0(.data(holder), .segment(segment[6:0]));
    
assign anode = 4'b1110;
    
endmodule

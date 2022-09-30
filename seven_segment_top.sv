`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: seven_segment_top
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: october 20th, 2021
*
* Description: implements seven segment module in the FPGA board
*
*
****************************************************************************/


module seven_segment_top(
    input wire logic [3:0] sw,
    input wire logic btnc,
    output logic [7:0] segment,
    output logic [3:0] anode
    );
    
seven_segment S0(.data(sw[3:0]), .segment(segment[6:0]));
 
not(segment[7], btnc);

assign anode = 4'b1110; 

endmodule

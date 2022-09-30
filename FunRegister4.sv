`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: FunRegister 4-bit
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: October 20th, 2021
*
* Description: A simple 4-bit register
*
*
****************************************************************************/

module FunRegister4(
    input wire logic CLK, LOAD,
    input wire logic [3:0] DIN,
    output logic [3:0] Q, [3:0] NXT
);

assign NXT = LOAD?DIN:Q;
FDCE my_ff0 (.Q(Q[0]), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT[0]));
FDCE my_ff1 (.Q(Q[1]), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT[1]));
FDCE my_ff2 (.Q(Q[2]), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT[2]));
FDCE my_ff3 (.Q(Q[3]), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT[3]));

endmodule
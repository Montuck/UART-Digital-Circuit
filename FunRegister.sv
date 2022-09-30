`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: FunRegister
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: October 20th, 2021
*
* Description: A simple 1-bit register
*
*
****************************************************************************/

module FunRegister(
    input wire logic CLK, DIN, LOAD,
    output logic Q, NXT
);

assign NXT = LOAD?DIN:Q;
FDCE my_ff (.Q(Q), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT));

endmodule
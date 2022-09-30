`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: Counter
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: October 20th, 2021
*
* Description: A simple 4-bit counter
*
*
****************************************************************************/

module Counter(
    input wire logic CLK, CLR, INC,
    output logic [3:0] Q, [3:0] NXT
);

assign NXT = (CLR == 0 && INC == 0)?(Q):
             (CLR == 0 && INC == 1)?(Q+1):
             (CLR == 1 && INC == 0)?(4'b0000):
             Q;
             
FDCE my_ff0 (.Q(Q[0]), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT[0]));
FDCE my_ff1 (.Q(Q[1]), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT[1]));
FDCE my_ff2 (.Q(Q[2]), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT[2]));
FDCE my_ff3 (.Q(Q[3]), .C(CLK), .CE(1'b1), .CLR(1'b0), .D(NXT[3]));

endmodule

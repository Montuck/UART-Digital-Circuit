`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: FullAdd
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: <Date file was created>
*
* Description: Adds binary numbers together
*
*
****************************************************************************/


module arithmetic_top(
    output logic [7:0] led, 
    output logic overflow,
    input wire logic [15:0] sw, 
    input wire logic sub
    );

logic trash, n1, n2, n3, a1, a2;
logic [7:0] b;

xor(b[0], sub, sw[8]);
xor(b[1], sub, sw[9]);
xor(b[2], sub, sw[10]);
xor(b[3], sub, sw[11]);
xor(b[4], sub, sw[12]);
xor(b[5], sub, sw[13]);
xor(b[6], sub, sw[14]);
xor(b[7], sub, sw[15]);

Add8 M0(.a(sw[7:0]),.b(b[7:0]),.s(led[7:0]),.cin(sub),.co(trash));

not(n1, b[7]);
not(n2, sw[7]);
not(n3, led[7]);
and(a1, n1, n2, led[7]);
and(a2, b[7], sw[7], n3);
or(overflow, a1, a2);

endmodule

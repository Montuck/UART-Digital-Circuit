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


module Add8(
    output logic [7:0] s, 
    output logic co,
    input wire logic [7:0] a, b, 
    input wire logic cin
    );
    
logic c1, c2, c3, c4, c5, c6, c7;

FullAdd Add0(.s(s[0]), .co(c1), .a(a[0]), .b(b[0]), .cin(cin));
FullAdd Add1(.s(s[1]), .co(c2), .a(a[1]), .b(b[1]), .cin(c1));
FullAdd Add2(.s(s[2]), .co(c3), .a(a[2]), .b(b[2]), .cin(c2));
FullAdd Add3(.s(s[3]), .co(c4), .a(a[3]), .b(b[3]), .cin(c3));
FullAdd Add4(.s(s[4]), .co(c5), .a(a[4]), .b(b[4]), .cin(c4));
FullAdd Add5(.s(s[5]), .co(c6), .a(a[5]), .b(b[5]), .cin(c5));
FullAdd Add6(.s(s[6]), .co(c7), .a(a[6]), .b(b[6]), .cin(c6));
FullAdd Add7(.s(s[7]), .co(co), .a(a[7]), .b(b[7]), .cin(c7));

endmodule

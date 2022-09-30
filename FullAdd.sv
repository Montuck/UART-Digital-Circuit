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


module FullAdd(
    output logic s, co,
    input wire logic a, b, cin
    );

//inner wires from AND to OR
logic iw1, iw2, iw3;

//ANND to OR
and(iw1, a, b);
and(iw2, b, cin);
and(iw3, a, cin);
or(co, iw1, iw2, iw3);
//XOR gate
xor(s, a, b, cin);
    
endmodule

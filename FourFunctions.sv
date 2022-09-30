`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: FourFunctions
*
* Author: Trevor Wiseman
* Class: ECEN 220, Section 2, Fall 2021
* Date: 09/22/21
*
* Description: LAB 3 Structural SV
*
*
****************************************************************************/

module FourFunctions(
    output logic O1, O2, O3, O4,
    input wire logic A, B, C
    );
    
    //local signals O1
    logic O1bara, O1barb, O1Selbar;
    //local signals O2
    logic O2bara, O2barb, O2Selbar;
    //local signals O3
    logic O3bara, O3Selbar;
    //local signals O3
    logic O4bara, O4barb, O4Selbar1, O4Selbar2;
    
    //O1 logic function
    and(O1bara, A, C);
    not(O1Selbar, A);
    and(O1barb, O1Selbar, B);
    or(O1, O1bara, O1barb);
    
    //O2 logic function
    not(O2Selbar, C);
    or(O2bara, A, O2Selbar);
    and(O2barb, B, C);
    and(O2, O2bara, O2barb);
    
    //O3 logic function
    not(O3Selbar, B);
    and(O3bara, O3Selbar, A);
    or(O3, O3bara, C);
    
    //O4 logic function
    nand(O4bara, A, B);
    not(O4Selbar1, C);
    not(O4Selbar2, B);
    nand(O4barb, O4Selbar1, O4Selbar2);
    nand(O4, O4bara, O4barb);
    
endmodule

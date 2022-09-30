`timescale 1ns / 1ps
`default_nettype none
/***************************************************************************
*
* Module: seven_segment
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: october 13th, 2021
*
* Description: changes seven segment value of clock depending on data inputs
*
*
****************************************************************************/


    module seven_segment(
    input wire logic [3:0] data,
    output logic [6:0] segment
    );
    
    //segment 0 w/ dataflow assign and ?
    assign segment[0] = 
    (data==4'b0000)?0:
    (data==4'b0001)?1:
    (data==4'b0010)?0:
    (data==4'b0011)?0:
    (data==4'b0100)?1:
    (data==4'b0101)?0:
    (data==4'b0110)?0:
    (data==4'b0111)?0:
    (data==4'b1000)?0:
    (data==4'b1001)?0:
    (data==4'b1010)?0:
    (data==4'b1011)?1:
    (data==4'b1100)?0:
    (data==4'b1101)?1:
    (data==4'b1110)?0:
    0;
    
    //segment 1 w/ dataflow assign
    assign segment[1] = (~data[3] & data[2] & ~data[1] & data[0]) | (~data[3] & data[2] & data[1] & ~data[0]) | 
                        (data[3] & ~data[2] & data[1] & data[0]) | (data[3] & data[2] & ~data[1] & ~data[0]) |
                        (data[3] & data[2] & data[1] & ~data[0]) | (data[3] & data[2] & data[1] & data[0]);
    
    //segment 2 structural design w/reduction             
    logic nt1, nt2, nt3, nt4, in1, in2, in3, in4, in5, in6, in7;
    
    not(nt1, data[0]);
    not(nt2, data[1]);
    not(nt3, data[2]);
    not(nt4, data[3]);
    and(in1, data[3], data[2], data[1]);
    and(in2, nt4, nt3, data[1], nt1);
    and(in3, data[3], data[2], nt2, nt1);
    or(segment[2], in1, in2, in3);
    
    //segments 3-6 dataflow assign
    assign segment[3] = 
    (data==4'b0000)?0:
    (data==4'b0001)?1:
    (data==4'b0010)?0:
    (data==4'b0011)?0:
    (data==4'b0100)?1:
    (data==4'b0101)?0:
    (data==4'b0110)?0:
    (data==4'b0111)?1:
    (data==4'b1000)?0:
    (data==4'b1001)?0:
    (data==4'b1010)?1:
    (data==4'b1011)?0:
    (data==4'b1100)?0:
    (data==4'b1101)?0:
    (data==4'b1110)?0:
    1;
                        
   assign segment[4] = 
    (data==4'b0000)?0:
    (data==4'b0001)?1:
    (data==4'b0010)?0:
    (data==4'b0011)?1:
    (data==4'b0100)?1:
    (data==4'b0101)?1:
    (data==4'b0110)?0:
    (data==4'b0111)?1:
    (data==4'b1000)?0:
    (data==4'b1001)?1:
    (data==4'b1010)?0:
    (data==4'b1011)?0:
    (data==4'b1100)?0:
    (data==4'b1101)?0:
    (data==4'b1110)?0:
    0;
                        
    assign segment[5] = 
    (data==4'b0000)?0:
    (data==4'b0001)?1:
    (data==4'b0010)?1:
    (data==4'b0011)?1:
    (data==4'b0100)?0:
    (data==4'b0101)?0:
    (data==4'b0110)?0:
    (data==4'b0111)?1:
    (data==4'b1000)?0:
    (data==4'b1001)?0:
    (data==4'b1010)?0:
    (data==4'b1011)?0:
    (data==4'b1100)?0:
    (data==4'b1101)?1:
    (data==4'b1110)?0:
    0;
    
    //segment 7 structural design w/out reduction
    and(in4, nt4, nt3, nt2, nt1);
    and(in5, nt4, nt3, nt2, data[0]); 
    and(in6, nt4, data[2], data[1], data[0]);
    and(in7, data[3], data[2], nt2, nt1);
    or(segment[6], in4, in5, in6, in7);
    
endmodule

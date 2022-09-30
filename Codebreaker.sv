`timescale 1ns / 1ps
/***************************************************************************
*
* Module: Codebreaker
*
* Author: Trevor Wiseman
* Class: <Class, Section, Semester> - ECEN 220, Section 2, Fall 2021
* Date: 11/17/21
*
* Description: designed to crack codes
*
*
****************************************************************************/


module Codebreaker(
    input wire logic clk, reset, start,
    output logic [15:0] key_display,
    output logic stopwatch_run, draw_plaintext,
    input wire logic done_drawing_plaintext,
    output logic [127:0] plaintext_to_draw
    );
    
    //additional logic
    logic finished, enabler, increment; 
    logic [23:0] key_in;
    logic [127:0] cyphertext;
    
    //incrementer
    always_ff@(posedge clk)
        if (reset)
            key_in <= 0;
        else if (increment)
            key_in <= key_in + 1;
        
    
    //code 
    assign cyphertext = 128'ha13a3ab3071897088f3233a58d6238bb;

    //rc implementation
    decrypt_rc4 rc4(.clk(clk), .reset(reset), .enable(enabler), .key(key_in), .bytes_in(cyphertext), .bytes_out(plaintext_to_draw), .done(finished));
    
    // Check that each byte of the plaintext is A-Z,0-9 or space.
    logic plaintext_is_ascii;
    assign plaintext_is_ascii = ((plaintext_to_draw[127:120] >= "A" && plaintext_to_draw[127:120] <= "Z") || (plaintext_to_draw[127:120] >= "0" && plaintext_to_draw[127:120] <= "9") || (plaintext_to_draw[127:120] == " ")) &&
                                ((plaintext_to_draw[119:112] >= "A" && plaintext_to_draw[119:112] <= "Z") || (plaintext_to_draw[119:112] >= "0" && plaintext_to_draw[119:112] <= "9") || (plaintext_to_draw[119:112] == " ")) &&
                                ((plaintext_to_draw[111:104] >= "A" && plaintext_to_draw[111:104] <= "Z") || (plaintext_to_draw[111:104] >= "0" && plaintext_to_draw[111:104] <= "9") || (plaintext_to_draw[111:104] == " ")) &&
                                ((plaintext_to_draw[103:96] >= "A" && plaintext_to_draw[103:96] <= "Z") || (plaintext_to_draw[103:96] >= "0" && plaintext_to_draw[103:96] <= "9") || (plaintext_to_draw[103:96] == " ")) &&
                                ((plaintext_to_draw[95:88] >= "A" && plaintext_to_draw[95:88] <= "Z") || (plaintext_to_draw[95:88] >= "0" && plaintext_to_draw[95:88] <= "9") || (plaintext_to_draw[95:88] == " ")) &&
                                ((plaintext_to_draw[87:80] >= "A" && plaintext_to_draw[87:80] <= "Z") || (plaintext_to_draw[87:80] >= "0" && plaintext_to_draw[87:80] <= "9") || (plaintext_to_draw[87:80] == " ")) &&
                                ((plaintext_to_draw[79:72] >= "A" && plaintext_to_draw[79:72] <= "Z") || (plaintext_to_draw[79:72] >= "0" && plaintext_to_draw[79:72] <= "9") || (plaintext_to_draw[79:72] == " ")) &&
                                ((plaintext_to_draw[71:64] >= "A" && plaintext_to_draw[71:64] <= "Z") || (plaintext_to_draw[71:64] >= "0" && plaintext_to_draw[71:64] <= "9") || (plaintext_to_draw[71:64] == " ")) &&
                                ((plaintext_to_draw[63:56] >= "A" && plaintext_to_draw[63:56] <= "Z") || (plaintext_to_draw[63:56] >= "0" && plaintext_to_draw[63:56] <= "9") || (plaintext_to_draw[63:56] == " ")) &&
                                ((plaintext_to_draw[55:48] >= "A" && plaintext_to_draw[55:48] <= "Z") || (plaintext_to_draw[55:48] >= "0" && plaintext_to_draw[55:48] <= "9") || (plaintext_to_draw[55:48] == " ")) &&
                                ((plaintext_to_draw[47:40] >= "A" && plaintext_to_draw[47:40] <= "Z") || (plaintext_to_draw[47:40] >= "0" && plaintext_to_draw[47:40] <= "9") || (plaintext_to_draw[47:40] == " ")) &&
                                ((plaintext_to_draw[39:32] >= "A" && plaintext_to_draw[39:32] <= "Z") || (plaintext_to_draw[39:32] >= "0" && plaintext_to_draw[39:32] <= "9") || (plaintext_to_draw[39:32] == " ")) &&
                                ((plaintext_to_draw[31:24] >= "A" && plaintext_to_draw[31:24] <= "Z") || (plaintext_to_draw[31:24] >= "0" && plaintext_to_draw[31:24] <= "9") || (plaintext_to_draw[31:24] == " ")) &&
                                ((plaintext_to_draw[23:16] >= "A" && plaintext_to_draw[23:16] <= "Z") || (plaintext_to_draw[23:16] >= "0" && plaintext_to_draw[23:16] <= "9") || (plaintext_to_draw[23:16] == " ")) &&
                                ((plaintext_to_draw[15:8] >= "A" && plaintext_to_draw[15:8] <= "Z") || (plaintext_to_draw[15:8] >= "0" && plaintext_to_draw[15:8] <= "9") || (plaintext_to_draw[15:8] == " ")) &&
                                ((plaintext_to_draw[7:0] >= "A" && plaintext_to_draw[7:0] <= "Z") || (plaintext_to_draw[7:0] >= "0" && plaintext_to_draw[7:0] <= "9") || (plaintext_to_draw[7:0] == " "));
    
    //LEDs
    assign key_display = key_in[23:8];
   
    //states
    typedef enum logic[2:0] {idle, decrypt, isDecrypted, display, terminate, ERR='X} StateType;
    StateType ns, cs;
    
    //combinational logic
    always_comb
    begin
        //state and output defaults
        ns = ERR;
        enabler = 0;
        draw_plaintext = 0;
        increment = 0;
        stopwatch_run = 0;
        //cases
        if (reset)
            ns = idle;
        else
            case (cs)
                idle: if (~start)
                        ns = idle;
                      else
                        ns = decrypt;
                decrypt:begin 
                        stopwatch_run = 1'b1;
                        enabler = 1'b1;
                         if (~finished)
                            ns = decrypt;
                         else if (finished)
                         begin
                            ns = isDecrypted;
                         end
                         end
                isDecrypted: if (~plaintext_is_ascii)
                                begin
                                    increment = 1'b1;
                                    ns = decrypt;
                                end
                             else
                                ns = display;
                display: begin
                            draw_plaintext = 1'b1;
                            if (~done_drawing_plaintext)
                                ns = display;
                            else if (done_drawing_plaintext)
                                ns = terminate;
                         end
                terminate: if (~reset)
                                ns = terminate;
                           else if (reset)
                                ns = idle;
            endcase
    end
    
    //state register
    always_ff@(posedge clk)
        cs <= ns;
    
endmodule

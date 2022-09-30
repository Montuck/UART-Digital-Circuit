`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//
//  Filename: tb_arithmetic.sv
//
//  Author: DJ Lee
//
//  Description: Provides a basic testbench for the arithmetic lab.  Is modified
//               version of tb_arithmetic v.
//
//  Version 3.1
//
//  Change Log:
//    v3.1: Added btnc to select between addition and substation. Added test case
//	    for overflow detection.
//    v2.1: Removed btnl and btnr to streamline lab for on-line semesters.
//          Converted to SystemVerilog
//    v1.1: Modified the arithmetic_top to use "port mapping by name" rather than
//          port mapping by order.
//
//////////////////////////////////////////////////////////////////////////////////

module tb_arithmetic();
	logic sub;
	logic [15:0] sw;
	logic [7:0] led;
	logic overflow;

	integer i,errors;
	logic  [31:0] rnd;
	logic signed  [7:0] A,B,result;
	logic over;

	// Instance the Seven-Segment display
	arithmetic_top dut(.sw(sw), .sub(sub), .led(led), .overflow(overflow));

	initial begin
        //shall print %t with scaled in ns (-9), with 2 precision digits, and would print the " ns" string
		$timeformat(-9, 0, " ns", 20);
		errors = 0;
		#20
		$display("*** Starting simulation ***");
		#20
        
		// Test 256 random cases
		for(i=1; i < 256; i=i+1) begin
		    sub = i%2;  // switch between addition and subtraction every iteration
			rnd = $random;
			sw[15:0] = rnd[15:0];
			B = sw[15:8];
			A = sw[7:0];
			over = 0;
			if (!sub) begin    // addition when sub = 0, subtraction when sub = 1
			     result = A+B;
			     if (A < 0 && B < 0 && result > 0) over = 1; // Overflow when negative + negative = positive
			     if (A > 0 && B > 0 && result < 0) over = 1; // Overflow when positive + positive = negative  
			end
			else begin
			     result = A-B;
				 if (A < 0 && B > 0 && result > 0) over = 1; // Overflow when negative - positive = positive
			     if (A > 0 && B < 0 && result < 0) over = 1; // Overflow when positive - negative = negative
			end
 			#20
            
			if (result != led || overflow != over) begin
			    if (!sub)
				    $display("Error: A=%b(%d), B=%b(%d), A+B=%b(%d) got %b(%d) and Overflow=%b got %b at time %0t", A,A,B,B,result,result,led,led,over,overflow, $time);
				else
				    $display("Error: A=%b(%d), B=%b(%d), A-B=%b(%d) got %b(%d) and Overflow=%b got %b at time %0t", A,A,B,B,result,result,led,led,over,overflow, $time);				
				errors = errors + 1;
			end
		end

		#20
		$display("*** Simulation done with %3d errors at time %0t ***", errors, $time);
		$finish;

	end  // end initial begin

endmodule

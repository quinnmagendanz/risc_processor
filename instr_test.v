`timescale 1ns / 1ps
// 
module instr_test ();
	`include "risc_constants.vh"
	
    reg [31:0] pc; 
    wire [31:0] id;

	instr uut(pc, id);
	
	integer i;

	initial begin
        pc = 0;

		#100;

        for (i = 0; i < 160; i=i+4) begin
            #10 pc = i;
        end

		#100;
		
		$stop;
	end
endmodule
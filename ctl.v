

// 
module ctl (	input [5:0] op, 
		input reset, irq, z,
		output [5:0] alufn,
		output [2:0] pcsel,
		output [1:0] wdsel,
		output asel, bsel, moe, ra2sel, wasel, werf);
	parameter [5:0] LD = ;
	parameter [5:0] LDR = ;
	parameter [5:0] ST = ;
	parameter [5:0] ADD = ;
	parameter [5:0] A = ;

	assign {alufn, asel, bsel, moe, mwr, pcsel, ra2sel, wasel, wdsel, werf} = 
		RESET	? {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd0, 1'b0} : (
		IRQ	? {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd4, 1'b0, 1'b1, 2'd0, 1'b1} : (
		OP 	? {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1} : (
		OPC 	? {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1} : (
		LD 	? {6'b000000, 1'b0, 1'b1, 1'b1, 1'b0, 3'd0, 1'b0, 1'b0, 2'd2, 1'b1} : (
		LDR 	? {6'b000000, 1'b1, 1'b0, 1'b1, 1'b0, 3'd0, 1'b0, 1'b0, 2'd2, 1'b1} : (
		ST	? {6'b000000, 1'b0, 1'b1, 1'b0, 1'b1, 3'd0, 1'b1, 1'b0, 2'd0, 1'b0} : (
		JMP	? {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd2, 1'b0, 1'b0, 2'd0, 1'b1} : (
		BEQ	? {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, {2'd0, z}, 1'b0, 1'b0, 2'd0, 1'b1} : (
		BNE	? {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, {2'd0, ~z}, 1'b0, 1'b0, 2'd0, 1'b1} : (
		{6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd3, 1'b0, 1'b1, 2'd0, 1'b1})))))))))); //ILLOP
		

endmodule

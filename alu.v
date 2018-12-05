`timescale 1ns / 1ps

// 
module alu(	input signed [31:0] a, b, 
		input [5:0] fn, 
		output signed [31:0] alu_out);
	`include "risc_constants.vh"
	
	reg [31:0] alu_result;
	assign alu_out = alu_result;
	always @(*) begin
	    case (fn)
	        `alu_CMPEQ: alu_result = {31'd0, a == b};
            `alu_CMPLT: alu_result = {31'd0, a < b};
            `alu_CMPLE: alu_result = {31'd0, a <= b};
            `alu_ADD: alu_result = a + b;
            `alu_SUB: alu_result = a - b;
            `alu_MUL: alu_result = a * b;
            `alu_DIV: alu_result = a / b;
            `alu_AND: alu_result = a & b;
            `alu_OR: alu_result = a | b;
            `alu_XOR: alu_result = a ^ b;
            `alu_XNOR: alu_result = ~(a ^ b);
            `alu_A: alu_result = a;
            `alu_SHL: alu_result = a << b;
            `alu_SHR: alu_result = a >> b;
            `alu_SRA: alu_result = a >>> b;
            default: alu_result = 0;
        endcase
	end
endmodule 

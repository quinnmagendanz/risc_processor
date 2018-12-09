`timescale 1ns / 1ps
// 
module ctl (
        input [5:0] op, 
		input reset, irq, z,
		output [5:0] alufn,
		output [2:0] pcsel,
		output [1:0] wdsel,
		output asel, bsel, moe, mwr, ra2sel, wasel, werf);
	`include "risc_constants.vh"
	
	wire [17:0] op_states [63:0]; 
	                                 //alufn,     asel, bsel, moe,  mwr,  pcsel,ra2sel,wasel,wdsel,werf
    assign op_states[`op_LD] =      {`alu_ADD,   1'b0, 1'b1, 1'b1, 1'b0, 3'd0, 1'b0, 1'b0, 2'd2, 1'b1};
    assign op_states[`op_ST] =      {`alu_ADD,   1'b0, 1'b1, 1'b0, 1'b1, 3'd0, 1'b1, 1'b0, 2'd0, 1'b0};
    assign op_states[`op_JMP] =     {6'b0,       1'b0, 1'b0, 1'b0, 1'b0, 3'd2, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[`op_BEQ] =     {6'b0,       1'b0, 1'b0, 1'b0, 1'b0, {2'd0, z}, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[`op_BNE] =     {6'b0,       1'b0, 1'b0, 1'b0, 1'b0, {2'd0, ~z}, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[`op_LDR] =     {`alu_A,     1'b1, 1'b0, 1'b1, 1'b0, 3'd0, 1'b0, 1'b0, 2'd2, 1'b1};
    assign op_states[`op_ADD] =     {`alu_ADD,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_SUB] =     {`alu_SUB,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_MUL] =     {`alu_MUL,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_DIV] =     {`alu_DIV,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_MOD] =     {`alu_MOD,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_CMPEQ] =   {`alu_CMPEQ, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_CMPLT] =   {`alu_CMPLT, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_CMPLE] =   {`alu_CMPLE, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_AND] =     {`alu_AND,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_OR] =      {`alu_OR,    1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_XOR] =     {`alu_XOR,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_XNOR] =    {`alu_XNOR,  1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_SHL] =     {`alu_SHL,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_SHR] =     {`alu_SHR,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_SRA] =     {`alu_SRA,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_ADDC] =    {`alu_ADD,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_SUBC] =    {`alu_SUB,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_MULC] =    {`alu_MUL,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_DIVC] =    {`alu_DIV,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_MODC] =    {`alu_MOD,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_CMPEQC] =  {`alu_CMPEQ, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_CMPLTC] =  {`alu_CMPLT, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_CMPLEC] =  {`alu_CMPLE, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_ANDC] =    {`alu_AND,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_ORC] =     {`alu_OR,    1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_XORC] =    {`alu_XOR,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_XNORC] =   {`alu_XNOR,  1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_SHLC] =    {`alu_SHL,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_SHRC] =    {`alu_SHR,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[`op_SRAC] =    {`alu_SRA,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    
    wire [31:0] out_irq =       {6'b0, 1'b0, 1'b0, 1'b0, 1'b0, 3'd4, 1'b0, 1'b1, 2'd0, 1'b1};
    wire [31:0] out_reset =     {6'b0, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd0, 1'b0};
    // TODO(magendanz) ILLOP {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd3, 1'b0, 1'b1, 2'd0, 1'b1};

	assign {alufn, asel, bsel, moe, mwr, pcsel, ra2sel, wasel, wdsel, werf} = reset ? out_reset : (irq ? out_irq : op_states[op]);
		

endmodule

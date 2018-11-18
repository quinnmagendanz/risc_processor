`timescale 1ns / 1ps
// 
module ctl (
        input [5:0] op, 
		input reset, irq, z,
		output [5:0] alufn,
		output [2:0] pcsel,
		output [1:0] wdsel,
		output asel, bsel, moe, ra2sel, wasel, werf);
	`include "risc_constants.vh"
	
	wire [17:0] op_states [63:0]; 
	                           //alufn,     asel, bsel, moe,  mwr,  pcsel,ra2sel,wasel,wdsel,werf
    assign op_states[LD] =      {alu_ADD,   1'b0, 1'b1, 1'b1, 1'b0, 3'd0, 1'b0, 1'b0, 2'd2, 1'b1};
    assign op_states[ST] =      {alu_ADD,   1'b0, 1'b1, 1'b0, 1'b1, 3'd0, 1'b1, 1'b0, 2'd0, 1'b0};
    assign op_states[JMP] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd2, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[BEQ] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, {2'd0, z}, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[BNE] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, {2'd0, ~z}, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[LDR] =     {alu_A,     1'b1, 1'b0, 1'b1, 1'b0, 3'd0, 1'b0, 1'b0, 2'd2, 1'b1};
    assign op_states[ADD] =     {alu_ADD,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SUB] =     {alu_SUB,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[MUL] =     {alu_MUL,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[DIV] =     {alu_DIV,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPEQ] =   {alu_CMPEQ, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPLT] =   {alu_CMPLT, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPLE] =   {alu_CMPLE, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[AND] =     {alu_AND,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[OR] =      {alu_OR,    1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[XOR] =     {alu_XOR,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[XNOR] =    {alu_XNOR,  1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SHL] =     {alu_SHL,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SHR] =     {alu_SHR,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SRA] =     {alu_SRA,   1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[ADDC] =    {alu_ADD,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SUBC] =    {alu_SUB,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[MULC] =    {alu_MUL,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[DIVC] =    {alu_DIV,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPEQC] =  {alu_CMPEQ, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPLTC] =  {alu_CMPLT, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPLEC] =  {alu_CMPLE, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[ANDC] =    {alu_AND,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[ORC] =     {alu_OR,    1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[XORC] =    {alu_XOR,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[XNORC] =   {alu_XNOR,  1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SHLC] =    {alu_SHL,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SHRC] =    {alu_SHR,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SRAC] =    {alu_SRA,   1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    
    wire [31:0] out_irq =       {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd4, 1'b0, 1'b1, 2'd0, 1'b1};
    wire [31:0] out_reset =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd0, 1'b0};
    // TODO(magendanz) ILLOP {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd3, 1'b0, 1'b1, 2'd0, 1'b1};

	assign {alufn, asel, bsel, moe, mwr, pcsel, ra2sel, wasel, wdsel, werf} = reset ? out_reset : (irq ? out_irq : op_states[op]);
		

endmodule

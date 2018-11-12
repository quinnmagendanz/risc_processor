
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
    assign op_states[LD] =      {6'b000000, 1'b0, 1'b1, 1'b1, 1'b0, 3'd0, 1'b0, 1'b0, 2'd2, 1'b1};
    assign op_states[ST] =      {6'b000000, 1'b0, 1'b1, 1'b0, 1'b1, 3'd0, 1'b1, 1'b0, 2'd0, 1'b0};
    assign op_states[JMP] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd2, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[BEQ] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, {2'd0, z}, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[BNE] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, {2'd0, ~z}, 1'b0, 1'b0, 2'd0, 1'b1};
    assign op_states[LDR] =     {6'b000000, 1'b1, 1'b0, 1'b1, 1'b0, 3'd0, 1'b0, 1'b0, 2'd2, 1'b1};
    assign op_states[ADD] =     {, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SUB] =     {, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[MUL] =     {, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[DIV] =     {, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPEQ] =   {, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPLT] =   {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPLE] =   {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[AND] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[OR] =      {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[XOR] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[XNOR] =    {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SHL] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SHR] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SRA] =     {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[ADDC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SUBC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[MULC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[DIVC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPEQC] =  {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPLTC] =  {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[CMPLEC] =  {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[ANDC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[ORC] =     {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[XORC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[XNORC] =   {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SHLC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SHRC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};
    assign op_states[SRAC] =    {6'b000000, 1'b0, 1'b1, 1'b0, 1'b0, 3'd0, 1'b0, 1'b0, 2'd1, 1'b1};

	assign {alufn, asel, bsel, moe, mwr, pcsel, ra2sel, wasel, wdsel, werf} = {6'b000000, 1'b0, 1'b0, 1'b0, 1'b0, 3'd3, 1'b0, 1'b1, 2'd0, 1'b1}; //ILLOP
		

endmodule

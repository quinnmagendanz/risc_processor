// 
module alu(	input [31:0] a, b, 
		input [5:0] fn, 
		output [31:0] alu_out);
	
	wire [31:0] shift_out, bool_out, arith_out, cmp_out;
	assign alu_out = fn[5] ? (fn[4] ? shift_out : bool_out) : (fn[4] ? arith_out : cmp_out);

	shift shift_unit(a, b[4:0], fn[1:0], arith_out);
	bool bool_unit(a, b, fn[3:0], bool_out);
	wire z, v, n;
	arith arith_unit(a, b, fn[0], z, v, n, arith_out);
	cmp cmp_unit(z, v, n, fn[2:1], cmp_out);
 
endmodule

// Perform bit shift operation.
module shift(	input [31:0] a, 
		input [4:0] b, 
		input [1:0] sfn, 
		output [31:0] arith_out);
	wire [31:0] shl = a << b;
	wire [31:0] shr = a >> b;
	wire [31:0] sra = a >>> b;
	assign arith_out = sfn[1] ? sra : (sfn[0] ? shr : shl);

endmodule

// Perform bitwise boolean logic.
module bool(	input [31:0] a, b,
		input [3:0] bfn,
		output [31:0] bool_out);

	wire [31:0] and_op = a & b;
	wire [31:0] or_op = a | b;
	wire [31:0] xor_op = a ^ b;
	wire [31:0] xnor_op = ~(a ^ b);
	// TODO(magendanz) Add additional arithmetic ops as needed.
	
	assign bool_out = bfn[3] ? (bfn[2] ? or_op : (bfn[1] ? a : and_op)) : xor_op;

endmodule

// Perform basic arithmatic.
module arith(	input [31:0] a, b,
		input afn,
		output z, v, n,
		output [31:0] arith_out);

	wire [31:0] xb = {32{afn}} ^ b;
	assign arith_out = a + b + afn;

	assign z = (arith_out == 0);
	assign v = (a[31] & xb[31] & ~arith_out[31]) | (~a[31] & ~xb[31] & arith_out[31]);
	assign n = arith_out[31];

endmodule

// Link the arithmatic module to perform a comparison.
module cmp(	input z, v, n,
		input [1:0] fn,
		output [31:0] cmp_out);

	assign cmp_out[31:1] = 0;
	assign cmp_out[0] = fn[1] ? (fn[0] ? (a <= b) : (a < b)) : (fn[0] ? (a == b) : (0));

endmodule

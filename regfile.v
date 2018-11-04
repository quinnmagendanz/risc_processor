// 
module regfile (input [31:0] wdata,
		input [4:0] ra, rb, rc,
		input ra2sel, wasel, werf, clock,
		output [31:0] radata, rbdata);

	reg [31:0] data [31:0];
	initial begin
		for (i=0; i<32; i=i+1) begin
			data = 0;
		end
	end
	always @(negedge clock) begin
		// TODO(magendanz) data[31] always 0.
		if () begin
			data[ra] = wdata;
		end
	end
endmodule

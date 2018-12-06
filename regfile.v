`timescale 1ns / 1ps
// 
module regfile (
        input [31:0] wdata,
		input [4:0] ra, rb, rc,
		input ra2sel, wasel, werf, clock,
		output [31:0] radata, rbdata
		);

	reg [31:0] data [31:0];
	integer i = 0;
	wire [4:0] ra1 = 0;
	wire [4:0] ra2 = 0;
	wire [4:0] wa = 0;
	wire we = 0;
	
	reg [4:0] r31 = 31;
	reg [4:0] XP = 30;
	reg [4:0] SP = 29;
	reg [4:0] LP = 28;
	reg [4:0] BP = 27;
	
	initial begin
	   for (i=0; i<32; i=i+1) begin
		  data[i] <= 0;
	   end
	end
	
	// TODO(magendanz) neg? Shouldnt it be pos?
	// We also need to make sure reads take no clock cycles
	// and writes complete on posedge.

	assign we = werf;
	assign wa = (wasel)? XP : rc;	

	always @(posedge clock) begin
		
		if (!wasel && we) begin
		  data[wa] <= wdata;
		end
	end
	
	assign ra1 = ra;
	assign ra2 = (ra2sel)? rc : rb;
	assign radata = data[ra1];
        assign rbdata = data[ra2];
	
endmodule

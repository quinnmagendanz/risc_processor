`timescale 1ns / 1ps
// 
module regfile (
        input [31:0] wdata,
		input [4:0] ra, rb, rc,
		input ra2sel, wasel, werf, clock,
		output reg [31:0] radata, rbdata
		);

	reg [31:0] data [31:0];
	integer i = 0;
	reg [4:0] ra1 = 0;
	reg [4:0] ra2 = 0;
	reg [4:0] wa = 0;
	reg we = 0;
	
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
	always @(negedge clock) begin
		ra1 <= ra;
		data[r31] <= 0; // TODO(magendanz) Just wire this
		we <= werf;
		
		if (ra2sel) begin
		  ra2 <= rc;
		end
		else ra2 <= rb;
		
		if (wasel) begin
		  wa <= XP;
		end
		else wa <= rc;
		
		radata <= data[ra1];
        rbdata <= data[ra2];
		
		if (we) begin
		  data[wa] <= wdata;
		end
	end
endmodule

// 
module regfile (
        input [31:0] wdata,
		input [4:0] ra, rb, rc,
		input ra2sel, wasel, werf, clock,
		output [31:0] radata, rbdata
		);

	reg [31:0] data [31:0];
	integer i = 0;
	reg [4:0] ra1 = 0;
	reg [4:0] ra2 = 0;
	reg [4:0] wa = 0;
	reg [31:0] wd = 0;
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
	
	always @(negedge clock) begin
		// TODO(magendanz) data[31] always 0.
		ra1 <= ra;
		data[r31] <= 0;
		we <= werf;
		
		if (ra2sel) begin
		  ra2 <= rc;
		end
		else ra2 <= rb;
		
		if (wasel) begin
		  wa <= XP;
		end
		else wa <= rc
		
		if () begin
		  data[ra] = wdata;
		end
	end
endmodule

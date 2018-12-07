`timescale 1ns / 1ps
// 
module regfile_test ();
    reg [31:0] wdata;
	reg [4:0] ra, rb, rc;
	reg ra2sel, wasel, werf, clock;
	wire [31:0] radata, rbdata;
	
    regfile uut(wdata, ra, rb, rc, ra2sel, wasel, werf, clock, radata, rbdata);

	initial begin   // system clock
		forever #5 clock = !clock;
	end

	initial begin
		wdata = 0;
		ra = 0;
		rb = 0;
		rc = 0;
		ra2sel = 0;
		wasel = 0;
		werf = 0;
		clock = 0;

		#50;

		#10 wdata = 1;
		#15 werf = 1;
		#20 rc = 1;
		wdata = 2;
		#10 rc = 5;
		wdata = 3;
		ra2sel = 1;
		#10 rb = 5;
		#50;
		
        $stop;
	end
endmodule

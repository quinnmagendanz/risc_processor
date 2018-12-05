// 
module pc_test ();
	`include "risc_constants.vh"
	
    reg [15:0] id;
    reg [29:0] jt;
    reg [2:0] pcsel;
    reg clock, reset; 
    wire [31:0] pc;
    wire [31:0] pc_inc, pc_offset;

	pc uut(id, jt, pcsel, clock, reset, pc, pc_inc, pc_offset);

	initial begin   // system clock
		forever #5 clock = !clock;
	end

	initial begin
        id = 0;
        jt = 0;
        pcsel = 0;
        reset = 0;
        clock = 1;

		#100;

        pcsel = 2;
        #20;
        id = -1;
        pcsel = 1;
        #20;    
        pcsel = 3;
        #10;
        pcsel = 4;
        #10;
        reset = 1;
        pcsel = 0;

		#100;
		
		$stop;
	end
endmodule
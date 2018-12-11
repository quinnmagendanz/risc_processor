`timescale 1ns / 1ps
// 
module regfile (
        input [31:0] wdata,
		input [4:0] ra, rb, rc,
		input ra2sel, wasel, werf, reset, clock,
		input [31:0] program_selector,
		input [15:0] user_input,
		output [31:0] radata, rbdata,
		output [31:0] disp_data
		);

	reg [31:0] data [31:0];
	
	// Display registers 1-8
	wire [3:0] a1 = data[0][3:0];
	wire [3:0] a2 = data[1][3:0];
	wire [3:0] a3 = data[2][3:0];
	wire [3:0] a4 = data[3][3:0];
	wire [3:0] a5 = data[4][3:0];
	wire [3:0] a6 = data[5][3:0];
	wire [3:0] a7 = data[6][3:0];
    wire [3:0] a8 = data[7][3:0];
	assign disp_data = {a8, a7, a6, a5, a4, a3, a2, a1};

	wire [4:0] ra1;
	wire [4:0] ra2;
	wire [4:0] wa;
	wire we;
	
	reg [4:0] r31 = 31;
	reg [4:0] XP = 30;
	reg [4:0] SP = 29;
	reg [4:0] LP = 28;
	reg [4:0] BP = 27;
	
    integer i = 0;
	initial begin
	   for (i=0; i<32; i=i+1) begin
		  data[i] <= 0;
	   end
	end
	
    assign ra1 = ra;
    assign ra2 = (ra2sel)? rc : rb;
    assign radata = data[ra1];
    assign rbdata = data[ra2];
    
    assign we = werf;
    assign wa = (wasel)? XP : rc;

	always @(posedge clock) begin
        if (werf && wa != 31) begin
		   data[wa] <= wdata;
		end
		
        data[24] <= user_input[7:0];
        data[25] <= user_input[14:8];
        data[26] <= program_selector;
		
		if (reset) begin
		    for (i=0; i<32; i=i+1) begin
                data[i] <= 0;
            end
		end
	end
	

	
endmodule

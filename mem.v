`timescale 1ns / 1ps

`define MAX_MEM_INDEX 127

module mem (
        input clock,reset, mwr, moe, 
        input [31:0] mwd, ma,
        output [31:0] mrd,
        output [31:0] first_eight);
        
    // TODO(magendanz) Probably need to use different type of
    // memory for non-tiny data sets.
    reg [31:0] d_mem [`MAX_MEM_INDEX:0]; // Supports 128 32-bit stores.
    assign first_eight = {d_mem[7][3:0], d_mem[6][3:0], d_mem[5][3:0], d_mem[4][3:0], d_mem[3][3:0], d_mem[2][3:0], d_mem[1][3:0], d_mem[0][3:0]}; 
    
    // TODO(magendanz) not sure exactly why we need MOE.
    assign mrd = (ma >> 2) > `MAX_MEM_INDEX ? 0 : d_mem[ma >> 2] & {32{moe}};
    
    integer i;
    initial begin
        for (i = 0; i <= `MAX_MEM_INDEX; i = i + 1) begin
            d_mem[i] = 0;
        end
    end
    
    integer i;
    always @(posedge clock) begin
        if (mwr && (ma >> 2) <= `MAX_MEM_INDEX) begin
            d_mem[ma >> 2] <= mwd;
        end
	if (reset) begin
	  for (i=0; i<`MAX_MEM_INDEX; i=i+1) begin
            d_mem[i] <= 0;
          end
	end
    end
    

endmodule

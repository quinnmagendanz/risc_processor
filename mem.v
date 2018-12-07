`timescale 1ns / 1ps

`define MAX_MEM_ADDR 9

module mem (
        input clock, mwr, moe, 
        input [31:0] mwd, ma,
        output [31:0] mrd);
        
    // TODO(magendanz) Probably need to use different type of
    // memory for non-tiny data sets.
    reg [31:0] d_mem [`MAX_MEM_ADDR:0]; // Supports 10 32-bit stores.
    
    // TODO(magendanz) not sure exactly why we need MOE.
    assign mrd = ma > `MAX_MEM_ADDR ? 0 : d_mem[ma] & {32{moe}};
    
    integer i;
    initial begin
        for (i = 0; i <= `MAX_MEM_ADDR; i = i + 1) begin
            d_mem[i] = 0;
        end
    end
    
    always @(posedge clock) begin
        if (mwr) begin
            d_mem[ma >> 2] <= mwd;
        end
    end
    

endmodule

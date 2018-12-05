`timescale 1ns / 1ps

module mem (
        input clock, mwr, moe, 
        input [31:0] mwd, ma,
        output [31:0] mrd);
        
    // TODO(magendanz) Probably need to use different type of
    // memory for non-tiny data sets.
    reg [31:0] d_mem [6:0]; // Supports 128 32-bit stores.
    
    // TODO(magendanz) not sure exactly why we need MOE.
    assign mrd = d_mem[ma] & {32{moe}};
    
    always @(posedge clock) begin
        if (mwr) begin
            d_mem[ma] <= mwd;
        end
    end
    

endmodule

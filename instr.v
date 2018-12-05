`timescale 1ns / 1ps

module instr (
            input [31:0] pc, 
            output [31:0] id);

    // TODO(magendanz) Probably need to use different type of
    // memory for non-tiny programs.
    wire [31:0] i_mem [6:0]; // Supports 128 instructions.
    
    assign id = i_mem[pc];
    
    assign i_mem[0] = 32'b01110000001000001111111111111111; // BEQ R1 R0 -1

endmodule

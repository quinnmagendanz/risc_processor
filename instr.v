`timescale 1ns / 1ps

module instr (
            input [31:0] pc, 
            output [31:0] id);
    `include "risc_constants.vh"

    // TODO(magendanz) Probably need to use different type of
    // memory for non-tiny programs.
    wire [31:0] i_mem [6:0]; // Supports 128 instructions.
    
    assign id = i_mem[pc];
    
    // TODO(magendanz) Is there a better way to do this?
    // Static instruction declaration.
    assign i_mem[0] = `BEQ(0, -1, 31); // Remain at first instruction until r0 != 0
    assign i_mem[0] = `SHRC(0, 0, 32);
    assign i_mem[1] = `ADDC(1, 5, 1);
    assign i_mem[2] = `ADDC(2, 1, 1);
    assign i_mem[3] = `ADDC(3, 2, 1);
    assign i_mem[4] = `ADDC(4, 3, 1);
    assign i_mem[5] = `ADDC(5, 4, 1);
    assign i_mem[6] = `JMP(0, 31);
    
    // TODO(magendanz) handle reset, illop, and xadr addresses.

endmodule

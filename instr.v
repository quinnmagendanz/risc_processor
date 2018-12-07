`timescale 1ns / 1ps

`define DEFAULT_ADDR    32'd0
`define FIB_ADDR        32'd20
`define SORT_ADDR       32'd40
`define STORE_ADDR      32'd60
`define LOAD_ADDR       32'd80    

`define d(j) assign i[j + `DEFAULT_ADDR] =
`define f(j) assign i[j + `FIB_ADDR] =
`define s(j) assign i[j + `SORT_ADDR] =
`define t(j) assign i[j + `STORE_ADDR] =
`define l(j) assign i[j + `LOAD_ADDR] =

// Instructions
// TODO(magendanz) Extra imstructions: ZERO, MOV, PUSHA

module instr (
            input [31:0] pc, 
            output [31:0] id);
	`include "risc_constants.vh"

    // TODO(magendanz) Probably need to use different type of
    // memory for non-tiny programs.
    wire [31:0] i [99:0]; // Supports 100 instructions.
    
    assign id = i[pc];
    // TODO(magendanz) handle reset, illop, and xadr addresses.
    
    parameter [15:0] a0 = `DEFAULT_ADDR;
    parameter [15:0] a1 = `FIB_ADDR;
    parameter [15:0] a2 = `SORT_ADDR;
    parameter [15:0] a3 = `STORE_ADDR;
    parameter [15:0] a4 = `LOAD_ADDR;
    
    ///////////////////////////////////////////////////////////////////////
    // TODO(magendanz) Is there a better way to do this?
    // Static instruction declaration.
    ///////////////////////////////////////////////////////////////////////
    //
    // Reserved Registers:
    // r0 program selector
    // r1 - r8 usable return registers.
    // r31 = 0
    //
    // Must specify size of input:
    // Registers - 5 bits
    // Literals - 16 bits
    //
    ///////////////////////////////////////////////////////////////////////
    // Program Selector
    // Takes in literals of the addresses of four other programs to jump to.
    // This program should be located at address 0.
    // r0 (1-4) corresponds to which program to jump to. 
    // r1 is used to store this address to jump.
    
    `d(0) `BEQ(5'd0, -16'd1, 5'd31);    // Remain at first instruction until r0 != 0
    `d(1) `SUBC(5'd0, 16'd1, 5'd0);    // Jump to program specified in r0.
    `d(2) `BNE(5'd0, 16'd2, 5'd31);
    `d(3) `ADDC(5'd31, a1, 5'd1);
    `d(4) `JMP(5'd1, 5'd31);
    `d(5) `SUBC(5'd0, 16'd1, 5'd0);
    `d(6) `BNE(5'd0, 16'd2, 5'd31);
    `d(7) `ADDC(5'd31, a2, 5'd1);
    `d(8) `JMP(5'd1, 5'd31);
    `d(9) `SUBC(5'd0, 16'd1, 5'd0);
    `d(10) `BNE(5'd0, 16'd2, 5'd31);
    `d(11) `ADDC(5'd31, a3, 5'd1);
    `d(12) `JMP(5'd1, 5'd31);
    `d(13) `SUBC(5'd0, 16'd1, 5'd0);
    `d(14) `BNE(5'd0, 16'd2, 5'd31);
    `d(15) `ADDC(5'd31, a4, 5'd1);
    `d(16) `JMP(5'd1, 5'd31);
    `d(17) `ADD(5'd31, 5'd31, 5'd0);    // Should never reach here.
    `d(18) `JMP(5'd31, 5'd31);
    
    ///////////////////////////////////////////////////////////////////////
    // Fibonacci
    // Generates the n'th fibonacci number.
    // r4 stores the current n fibbonacci number.
    // r1 stores the value of the current fibbonacci number.
    // r2 stores n-1.
    // r3 stores n-2. // TODO(magendanz) fix reg numbers.
    // TODO(magendanz) replace this with switch input
    parameter [15:0] n = 5;

    `f(0) `ADDC(5'd31, n, 5'd3);
    `f(1) `BNE(5'd3, 16'd2, 5'd31);    // If n == 0
    `f(2) `ADD(5'd31, 5'd31, 5'd0);
    `f(3) `JMP(5'd31, 5'd31);
    `f(4) `SUBC(5'd3, 16'd1, 5'd3);
    `f(5) `BNE(5'd3, 16'd2, 5'd31);    // If n ==1 
    `f(6) `ADD(5'd31, 5'd1, 5'd0);
    `f(7) `JMP(5'd31, 5'd31);
    `f(8) `ADDC(5'd31, 16'd0, 5'd2);    // Init r1 = 1
    `f(9) `ADDC(5'd31, 16'd1, 5'd1);    // Init r2 = 0
    `f(10) `SUBC(5'd3, 16'd1, 5'd1);    // Loop through
    `f(11) `ADD(5'd1, 5'd2, 5'd0);
    `f(12) `ADD(5'd31, 5'd1, 5'd2);
    `f(13) `ADD(5'd31, 5'd0, 5'd1);
    `f(14) `BNE(5'd3, -16'd5, 5'd31);    // End loop
    `f(15) `JMP(5'd31, 5'd31);
    
    ///////////////////////////////////////////////////////////////////////
    // Sort
    
    ///////////////////////////////////////////////////////////////////////
    // Save
    
    ///////////////////////////////////////////////////////////////////////
    // Load

endmodule

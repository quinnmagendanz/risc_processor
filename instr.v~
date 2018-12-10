`timescale 1ns / 1ps

`define DEFAULT_ADDR    32'd0
`define FIB_ADDR        32'd80
`define SORT_ADDR       32'd120
`define STORE_ADDR      32'd240
`define LOAD_ADDR       32'd320    

`define d(j) assign i[j + (`DEFAULT_ADDR >> 2)] =
`define f(j) assign i[j + (`FIB_ADDR >> 2)] =
`define s(j) assign i[j + (`SORT_ADDR >> 2)] =
`define t(j) assign i[j + (`STORE_ADDR >> 2)] =
`define l(j) assign i[j + (`LOAD_ADDR >> 2)] =

// Instructions
// TODO(magendanz) Extra imstructions: ZERO, MOV, PUSHA

module instr (
            input [31:0] pc, 
            output [31:0] id);
	`include "risc_constants.vh"

    // TODO(magendanz) Probably need to use different type of
    // memory for non-tiny programs.
    wire [31:0] i [99:0]; // Supports 100 instructions.
    
    assign id = i[pc >> 2];
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
    // r0 wired to input program selector
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
    // r0 is the register linked to input specifying which function to jump to.
    // r1 copies r0 and is used to check which function to jump to. 
    // r2 is used to store this address to jump.
    
    `d(0) `BEQ(5'd0, -16'd1, 5'd31);    // Remain at first instruction until r0 != 0
    `d(1) `ADDC(5'd0, 16'd0, 5'd1);
    `d(2) `SUBC(5'd1, 16'd1, 5'd1);    // Jump to program specified in r0.
    `d(3) `BNE(5'd1, 16'd2, 5'd31);
    `d(4) `ADDC(5'd31, a1, 5'd2);
    `d(5) `JMP(5'd2, 5'd31);
    `d(6) `SUBC(5'd1, 16'd1, 5'd1);
    `d(7) `BNE(5'd1, 16'd2, 5'd31);
    `d(8) `ADDC(5'd31, a2, 5'd2);
    `d(9) `JMP(5'd2, 5'd31);
    `d(10) `SUBC(5'd1, 16'd1, 5'd1);
    `d(11) `BNE(5'd1, 16'd2, 5'd31);
    `d(12) `ADDC(5'd31, a3, 5'd2);
    `d(13) `JMP(5'd2, 5'd31);
    `d(14) `SUBC(5'd1, 16'd1, 5'd1);
    `d(15) `BNE(5'd1, 16'd2, 5'd31);
    `d(16) `ADDC(5'd31, a4, 5'd2);
    `d(17) `JMP(5'd2, 5'd31);
    `d(18) `XOR(5'd1, 5'd1, 5'd1);    // Should never reach here.
    `d(19) `JMP(5'd31, 5'd31);
    
    ///////////////////////////////////////////////////////////////////////
    // Fibonacci
    // Generates the n'th fibonacci number.
    // r4 stores the current n fibbonacci number.
    // r1 stores the value of the current fibbonacci number.
    // r2 stores n-1.
    // r3 stores n-2.
    // TODO(magendanz) replace this with switch input
    parameter [15:0] n = 5;

    `f(0) `ADDC(5'd31, n, 5'd4);
    `f(1) `BNE(5'd4, 16'd2, 5'd31);    // If n == 0
    `f(2) `XOR(5'd1, 5'd1, 5'd1);
    `f(3) `JMP(5'd31, 5'd31);
    `f(4) `SUBC(5'd4, 16'd1, 5'd4);
    `f(5) `BNE(5'd4, 16'd2, 5'd31);    // If n ==1 
    `f(6) `ADDC(5'd31, 15'd1, 5'd1);
    `f(7) `JMP(5'd31, 5'd31);
    `f(8) `ADDC(5'd31, 16'd0, 5'd3);    // Init r1 = 1
    `f(9) `ADDC(5'd31, 16'd1, 5'd2);    // Init r2 = 0
    `f(10) `SUBC(5'd4, 16'd1, 5'd4);    // Loop through
    `f(11) `ADD(5'd2, 5'd3, 5'd1);
    `f(12) `ADD(5'd31, 5'd2, 5'd3);
    `f(13) `ADD(5'd31, 5'd1, 5'd2);
    `f(14) `BNE(5'd4, -16'd5, 5'd31);    // End loop
    `f(15) `XOR(5'd2, 5'd2, 5'd2);
    `f(16) `XOR(5'd3, 5'd3, 5'd3);
    `f(17) `XOR(5'd4, 5'd4, 5'd4);
    `f(18) `JMP(5'd31, 5'd31);
    
    ///////////////////////////////////////////////////////////////////////
    // Sort
    
    ///////////////////////////////////////////////////////////////////////
    // Save
    
    ///////////////////////////////////////////////////////////////////////
    // Load

endmodule

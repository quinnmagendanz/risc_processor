`timescale 1ns / 1ps

`define DEFAULT_ADDR    32'd0
`define FIB_ADDR        32'd80
`define SORT_ADDR       32'd200
`define STORE_ADDR      32'd320
`define LOAD_ADDR       32'd400    

`define d(j) assign i[j + (`DEFAULT_ADDR >> 2)] =
`define f(j) assign i[j + (`FIB_ADDR >> 2)] =
`define s(j) assign i[j + (`SORT_ADDR >> 2)] =
`define t(j) assign i[j + (`STORE_ADDR >> 2)] =
`define l(j) assign i[j + (`LOAD_ADDR >> 2)] =

// Instructions
// TODO(magendanz) Extra instructions: ZERO, MOV, PUSHA

module instr (
            input [31:0] pc, 
            output [31:0] id);
	`include "risc_constants.vh"

    // TODO(magendanz) Probably need to use different type of
    // memory for non-tiny programs.
    wire [31:0] i [127:0]; // Supports 128 instructions.
    
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
    // r0 - r7 usable return registers.
    // r24 - wired to input 1
    // r25 - wired to input 2
    // r26 - wired to program selector
    // r27 - base of frame pointer
    // r28 - linkage pointer
    // r29 - stack pointer
    // r30 - exception pointer
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
    // r26 is the register linked to input specifying which function to jump to.
    // r0 copies r26 and is used to check which function to jump to. 
    // r1 is used to store this address to jump.
    
    `d(0) `BEQ(5'd26, -16'd1, 5'd31);    // Remain at first instruction until r0 != 0
    `d(1) `MOV(5'd26, 5'd0);
    `d(2) `SUBC(5'd0, 16'd1, 5'd0);    // Jump to program specified in r0.
    `d(3) `BNE(5'd0, 16'd2, 5'd31);
    `d(4) `MOVC(a1, 5'd1);
    `d(5) `JMP(5'd1, 5'd31);
    `d(6) `SUBC(5'd0, 16'd1, 5'd0);
    `d(7) `BNE(5'd0, 16'd2, 5'd31);
    `d(8) `MOVC(a2, 5'd1);
    `d(9) `JMP(5'd1, 5'd31);
    `d(10) `SUBC(5'd0, 16'd1, 5'd0);
    `d(11) `BNE(5'd0, 16'd2, 5'd31);
    `d(12) `MOVC(a3, 5'd1);
    `d(13) `JMP(5'd1, 5'd31);
    `d(14) `SUBC(5'd0, 16'd1, 5'd0);
    `d(15) `BNE(5'd0, 16'd2, 5'd31);
    `d(16) `MOVC(a4, 5'd1);
    `d(17) `JMP(5'd1, 5'd31);
    `d(19) `JMP(5'd31, 5'd31);     
    
    ///////////////////////////////////////////////////////////////////////
    // Fibonacci
    // Generates the n'th fibonacci number.
    // r3 stores the current n fibbonacci number.
    // r0 stores the value of the current fibbonacci number.
    // r1 stores n-1.
    // r2 stores n-2.

    `f(0) `MOV(5'd24, 5'd3);
    `f(1) `BNE(5'd3, 16'd2, 5'd31);    // If n == 0
    `f(2) `ZERO(5'd0);
    `f(3) `JMP(5'd31, 5'd31);

    `f(4) `SUBC(5'd3, 16'd1, 5'd3);
    `f(5) `BNE(5'd3, 16'd2, 5'd31);    // If n ==1 
    `f(6) `MOVC(15'd1, 5'd0);
    `f(7) `JMP(5'd31, 5'd31);

    `f(8) `ZERO(5'd2);                  // Init r2 = 0
    `f(9) `MOVC(16'd1, 5'd1);    // Init r1 = 1
    `f(10) `SUBC(5'd3, 16'd1, 5'd3);    // Loop through
    `f(11) `ADD(5'd1, 5'd2, 5'd0);
    `f(12) `MOV(5'd1, 5'd2);
    `f(13) `MOV(5'd0, 5'd1);
    `f(14) `BNE(5'd3, -16'd5, 5'd31);    // End loop
    `f(15) `ZERO(5'd1);
    `f(16) `ZERO(5'd2);
    `f(17) `ZERO(5'd3);
    `f(18) `ZERO(5'd4);
    `f(19) `ZERO(5'd5);
    `f(20) `ZERO(5'd6);
    `f(21) `ZERO(5'd7);
    `f(22) `JMP(5'd31, 5'd31);

    
    ///////////////////////////////////////////////////////////////////////
    // Sort
    // Sort the values stored in the first 8 memory addresses..
    // r0 - c
    // r1 - d
    // r2 - d-1
    // r3 - arr[d]
    // r4 - arr[d-1]
    // r5 - comparison bit

    `s(0) `MOVC(16'd4, 5'd0);	// for (c = 1

    `s(1) `MOV(5'd0, 5'd1);	        // d = c
    
    `s(2) `SUBC(5'd1, 16'd4, 5'd2);  // d - 1
    `s(3) `LD(5'd1, 16'd0, 5'd3);	// arr[d]
    `s(4) `LD(5'd2, 16'd0, 5'd4);	// arr[d-1]
    `s(5) `CMPLT(5'd31, 5'd1, 5'd5);	// d > 0
    `s(6) `CMPLT(5'd3, 5'd4, 5'd6);	// arr[d-1] > arr[d]
    `s(7) `AND(5'd5, 5'd6, 5'd5);	// &&
    `s(8) `BEQ(5'd5, 16'd4, 5'd31);	// while

    `s(9) `ST(5'd4, 16'd0, 5'd1);	// arr[d] = arr[d-1]
    `s(10) `ST(5'd3, 16'd0, 5'd2);	// arr[d-1] = arr[d]
    `s(11) `SUBC(5'd1, 16'd4, 5'd1);	// d = d - 1;
    `s(12) `BEQ(5'd31, -16'd11, 5'd31);	// end loop

    `s(13) `ADDC(5'd0, 16'd4, 5'd0);	// c++
    `s(14) `SUBC(5'd0, 16'd32, 5'd5);	// c < n
    `s(15) `BNE(5'd5, -16'd15, 5'd31);	// end loop

    `s(16) `LD(5'd31, 16'd0, 5'd0);
    `s(17) `LD(5'd31, 16'd4, 5'd1);
    `s(18) `LD(5'd31, 16'd8, 5'd2);
    `s(19) `LD(5'd31, 16'd12, 5'd3);
    `s(20) `LD(5'd31, 16'd16, 5'd4);
    `s(21) `LD(5'd31, 16'd20, 5'd5);
    `s(22) `LD(5'd31, 16'd24, 5'd6);
    `s(23) `LD(5'd31, 16'd28, 5'd7);

    `s(24) `JMP(5'd31, 5'd31);
    
    ///////////////////////////////////////////////////////////////////////
    // Save
    `t(0) `ST(5'd24, 16'd0, 5'd25); // store the value in memory
    `t(1) `ZERO(5'd0);
    `t(2) `ZERO(5'd1);
    `t(3) `ZERO(5'd2);
    `t(4) `ZERO(5'd3);
    `t(5) `ZERO(5'd4);
    `t(6) `ZERO(5'd5);
    `t(7) `ZERO(5'd6);
    `t(8) `ZERO(5'd7);
    `t(9) `JMP(5'd31, 5'd31);
    
    ///////////////////////////////////////////////////////////////////////
    // Load
    `l(0) `LD(5'd25, 16'd0, 5'd0); // load value into a display register
    `l(1) `ZERO(5'd1);
    `l(2) `ZERO(5'd2);
    `l(3) `ZERO(5'd3);
    `l(4) `ZERO(5'd4);
    `l(5) `ZERO(5'd5);
    `l(6) `ZERO(5'd6);
    `l(7) `ZERO(5'd7);
    `l(8) `JMP(5'd31, 5'd31);

endmodule

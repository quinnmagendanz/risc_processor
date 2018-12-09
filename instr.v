`timescale 1ns / 1ps

`define DEFAULT_ADDR    32'd0
`define FIB_ADDR        32'd80
`define SORT_ADDR       32'd120
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
    `d(1) `ADDC(5'd26, 16'd0, 5'd0);
    `d(2) `SUBC(5'd0, 16'd1, 5'd0);    // Jump to program specified in r0.
    `d(3) `BNE(5'd0, 16'd2, 5'd31);
    `d(4) `ADDC(5'd31, a1, 5'd1);
    `d(5) `JMP(5'd1, 5'd31);
    `d(6) `SUBC(5'd0, 16'd1, 5'd0);
    `d(7) `BNE(5'd0, 16'd2, 5'd31);
    `d(8) `ADDC(5'd31, a2, 5'd1);
    `d(9) `JMP(5'd1, 5'd31);
    `d(10) `SUBC(5'd0, 16'd1, 5'd0);
    `d(11) `BNE(5'd0, 16'd2, 5'd31);
    `d(12) `ADDC(5'd31, a3, 5'd1);
    `d(13) `JMP(5'd1, 5'd31);
    `d(14) `SUBC(5'd0, 16'd1, 5'd0);
    `d(15) `BNE(5'd0, 16'd2, 5'd31);
    `d(16) `ADDC(5'd31, a4, 5'd1);
    `d(17) `JMP(5'd1, 5'd31);
    `d(19) `JMP(5'd31, 5'd31);     
    
    ///////////////////////////////////////////////////////////////////////
    // Fibonacci
    // Generates the n'th fibonacci number.
    // r4 stores the current n fibbonacci number.
    // r1 stores the value of the current fibbonacci number.
    // r2 stores n-1.
    // r3 stores n-2.

    `f(0) `ADDC(5'd24, 16'd0, 5'd3);
    `f(1) `BNE(5'd3, 16'd2, 5'd31);    // If n == 0
    `f(2) `XOR(5'd0, 5'd0, 5'd0);
    `f(3) `JMP(5'd31, 5'd31);

    `f(4) `SUBC(5'd3, 16'd1, 5'd3);
    `f(5) `BNE(5'd3, 16'd2, 5'd31);    // If n ==1 
    `f(6) `ADDC(5'd31, 15'd1, 5'd0);
    `f(7) `JMP(5'd31, 5'd31);

    `f(8) `ADDC(5'd31, 16'd0, 5'd2);    // Init r2 = 0
    `f(9) `ADDC(5'd31, 16'd1, 5'd1);    // Init r1 = 1
    `f(10) `SUBC(5'd3, 16'd1, 5'd3);    // Loop through
    `f(11) `ADD(5'd1, 5'd2, 5'd0);
    `f(12) `ADD(5'd31, 5'd1, 5'd2);
    `f(13) `ADD(5'd31, 5'd0, 5'd1);
    `f(14) `BNE(5'd3, -16'd5, 5'd31);    // End loop
    `f(15) `XOR(5'd1, 5'd1, 5'd1);
    `f(16) `XOR(5'd2, 5'd2, 5'd2);
    `f(17) `XOR(5'd3, 5'd3, 5'd3);
    `f(18) `JMP(5'd31, 5'd31);

    
    ///////////////////////////////////////////////////////////////////////
    // Sort
    // Sort the values stored in the first 8 memory addresses..
    // r0 - i
    // r1 - j
    // r2 - a[i]
    // r3 - a[j]
    // r4 - tmp
    // r5 - comparison bit

    `s(0) `ADDC(5'd31, 16'd1, 5'd0);	// for (i = 1

    `s(1) `LD(5'd0, 16'd0, 5'd2);	// key = arr[i]
    `s(2) `SUBC(5'd0, 16'd4, 5'd1);	// j = i - 1

    `s(3) `LD(5'd1, 16'd0, 5'd3);	// arr[j]
    `s(4) `CMPLT(5'd1, 5'd31, 5'd5);	// j >= 0
    `s(5) `CMPLT(5'd1, 5'd0, 5'd6);	// arr[j] > key
    `s(6) `AND(5'd5, 5'd6, 5'd5);	// &&
    `s(7) `BNE(5'd5, 16'd3, 5'd31);	// while

    `s(8) `ST(5'd3, 16'd4, 5'd1);	// arr[j+1] = arr[j]
    `s(9) `SUBC(5'd1, 16'd4, 5'd1);	// j = j - 1;
    `s(10) `BEQ(5'd31, -16'd8, 5'd31);	// end loop

    `s(11) `ST(5'd2, 16'd4, 5'd1);	// arr[j+1] = key

    `s(12) `ADDC(5'd0, 16'd4, 5'd0);	// i++
    `s(13) `SUBC(5'd0, 16'd8, 5'd5);	// i < n
    `s(14) `BNE(5'd5, -16'd15, 5'd31);	// end loop

    `s(15) `LD(5'd31, 16'd0, 5'd0);
    `s(16) `LD(5'd31, 16'd4, 5'd1);
    `s(17) `LD(5'd31, 16'd8, 5'd2);
    `s(18) `LD(5'd31, 16'd12, 5'd3);
    `s(19) `LD(5'd31, 16'd16, 5'd4);
    `s(20) `LD(5'd31, 16'd20, 5'd5);
    `s(21) `LD(5'd31, 16'd24, 5'd6);
    `s(22) `LD(5'd31, 16'd28, 5'd7);

    `s(23) `JMP(5'd31, 5'd31);
    
    ///////////////////////////////////////////////////////////////////////
    // Save
    
    ///////////////////////////////////////////////////////////////////////
    // Load

endmodule

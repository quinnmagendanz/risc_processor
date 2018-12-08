`ifndef _risc_constants_vh_
`define _risc_constants_vh_

// OP[5:0]
`define op_LD       6'b011000
`define op_ST       6'b011001
`define op_JMP      6'b011011
`define op_BEQ      6'b011100
`define op_BNE      6'b011101
`define op_LDR      6'b011111
`define op_ADD      6'b100000
`define op_SUB      6'b100001
`define op_MUL      6'b100010
`define op_DIV      6'b100011
`define op_CMPEQ    6'b100100
`define op_CMPLT    6'b100101
`define op_CMPLE    6'b100110
`define op_AND      6'b101000
`define op_OR       6'b101001
`define op_XOR      6'b101010
`define op_XNOR     6'b101011
`define op_SHL      6'b101100
`define op_SHR      6'b101101
`define op_SRA      6'b101110
`define op_ADDC     6'b110000
`define op_SUBC     6'b110001
`define op_MULC     6'b110010
`define op_DIVC     6'b110011
`define op_CMPEQC   6'b110100
`define op_CMPLTC   6'b110101
`define op_CMPLEC   6'b100110
`define op_ANDC     6'b111000
`define op_ORC      6'b111001
`define op_XORC     6'b111010
`define op_XNORC    6'b111011
`define op_SHLC     6'b111100
`define op_SHRC     6'b111101
`define op_SRAC     6'b111110

// ALUFN[5:0]
`define alu_CMPEQ   6'b000011
`define alu_CMPLT   6'b000101
`define alu_CMPLE   6'b000111
`define alu_ADD     6'b010000
`define alu_SUB     6'b010001
`define alu_MUL     6'b010010
`define alu_DIV     6'b010011
`define alu_AND     6'b101000
`define alu_OR      6'b101110
`define alu_XOR     6'b100110
`define alu_XNOR    6'b101001
`define alu_A       6'b101010
`define alu_SHL     6'b110000
`define alu_SHR     6'b110001
`define alu_SRA     6'b110011

// PC
`define RESET       32'h80000000
`define ILLOP       32'h80000004
`define XADR        32'h80000008

// Instructions
// TODO(magendanz) Extra instructions: ZERO, MOV, PUSHA
`define LD(ra, lit, rc)     {`op_LD, rc, ra, lit}
`define ST(rc, lit, ra)     {`op_ST, rc, ra, lit}
`define JMP(ra, rc)         {`op_JMP, rc, ra, 16'b0}
`define BEQ(ra, lit, rc)    {`op_BEQ, rc, ra, lit}
`define BNE(ra, lit, rc)    {`op_BNE, rc, ra, lit}
`define LDR(lit, rc)        {`op_LDR, rc, 5'b0, lit}
`define ADD(ra, rb, rc)     {`op_ADD, rc, ra, rb, 11'b0}
`define SUB(ra, rb, rc)     {`op_SUB, rc, ra, rb, 11'b0}
`define MUL(ra, rb, rc)     {`op_MUL, rc, ra, rb, 11'b0}
`define DIV(ra, rb, rc)     {`op_DIV, rc, ra, rb, 11'b0}
`define CMPEQ(ra, rb, rc)   {`op_CMPEQ, rc, ra, rb, 11'b0}
`define CMPLT(ra, rb, rc)   {`op_CMPLT, rc, ra, rb, 11'b0}
`define CMPLE(ra, rb, rc)   {`op_CMPLE, rc, ra, rb, 11'b0}
`define AND(ra, rb, rc)     {`op_AND, rc, ra, rb, 11'b0}
`define OR(ra, rb, rc)      {`op_OR, rc, ra, rb, 11'b0}
`define XOR(ra, rb, rc)     {`op_XOR, rc, ra, rb, 11'b0}
`define XNOR(ra, rb, rc)    {`op_XNOR, rc, ra, rb, 11'b0}
`define SHL(ra, rb, rc)     {`op_SHL, rc, ra, rb, 11'b0}
`define SHR(ra, rb, rc)     {`op_SHR, rc, ra, rb, 11'b0}
`define ADDC(ra, lit, rc)   {`op_ADDC, rc, ra, lit}
`define MOV(rc, ra)         {`op_MOV, rc, ra, 16'd0}
`define SUBC(ra, lit, rc)   {`op_SUBC, rc, ra, lit}
`define MULC(ra, lit, rc)   {`op_MULC, rc, ra, lit}
`define DIVC(ra, lit, rc)   {`op_DIVC, rc, ra, lit}
`define CMPEQC(ra, lit, rc) {`op_CMPEQC, rc, ra, lit}
`define CMPLTC(ra, lit, rc) {`op_CMPLTC, rc, ra, lit}
`define CMPLEC(ra, lit, rc) {`op_CMPLEC, rc, ra, lit}
`define ANDC(ra, lit, rc)   {`op_ANDC, rc, ra, lit}
`define ORC(ra, lit, rc)    {`op_ORC, rc, ra, lit}
`define XORC(ra, lit, rc)   {`op_XORC, rc, ra, lit}
`define XNORC(ra, lit, rc)  {`op_XNORC, rc, ra, lit}
`define SHLC(ra, lit, rc)   {`op_SHLC, rc, ra, lit}
`define SHRC(ra, lit, rc)   {`op_SHRC, rc, ra, lit}
`define SHRAC(ra, lit, rc)  {`op_SRAC, rc, ra, lit}


/*task LD; input [4:0] rc; input [11:0] lit; input [4:0] ra; output [31:0] ot; ot = {`op_LD, rc, ra, lit}; endtask
task ST; input [4:0] rc; input [11:0] lit; input [4:0] ra; output [31:0] ot; ot = {`op_ST, rc, ra, lit}; endtask
task JMP; input [4:0] ra, rc; output [31:0] ot; ot = {`op_JMP, rc, ra, 16'b0}; endtask
task BEQ; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_BEQ, rc, ra, lit}; endtask
task BNE; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_BNE, rc, ra, lit}; endtask
task LDR; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_LDR, rc, 5'b0, lit}; endtask
task ADD; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_ADD, rc, ra, rb, 11'b00}; endtask
task SUB; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_SUB, rc, ra, rb, 11'b00}; endtask
task MUL; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_MUL, rc, ra, rb, 11'b00}; endtask
task DIV; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_DIV, rc, ra, rb, 11'b00}; endtask
task CMPEQ; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_CMPEQ, rc, ra, rb, 11'b00}; endtask
task CMPLT; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_CMPLT, rc, ra, rb, 11'b00}; endtask
task CMPLE; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_CMPLE, rc, ra, rb, 11'b00}; endtask
task AND; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_AND, rc, ra, rb, 11'b00}; endtask
task OR; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_OR, rc, ra, rb, 11'b00}; endtask
task XOR; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_XOR, rc, ra, rb, 11'b00}; endtask
task XNOR; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_XNOR, rc, ra, rb, 11'b00}; endtask
task SHL; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_SHL, rc, ra, rb, 11'b00}; endtask
task SHR; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_SHR, rc, ra, rb, 11'b00}; endtask
task SRA; input [4:0] ra, rb, rc; output [31:0] ot; ot = {`op_SRA, rc, ra, rb, 11'b00}; endtask
task ADDC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_ADDC, rc, ra, lit}; endtask
task SUBC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_SUBC, rc, ra, lit}; endtask
task MULC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_MULC, rc, ra, lit}; endtask
task DIVC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_DIVC, rc, ra, lit}; endtask
task CMPEQC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_CMPEQC, rc, ra, lit}; endtask
task CMPLTC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_CMPLTC, rc, ra, lit}; endtask
task CMPLEC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_CMPLEC, rc, ra, lit}; endtask
task ANDC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_ANDC, rc, ra, lit}; endtask
task ORC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_ORC, rc, ra, lit}; endtask
task XORC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_XORC, rc, ra, lit}; endtask
task XNORC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_XNORC, rc, ra, lit}; endtask
task SHLC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_SHLC, rc, ra, lit}; endtask
task SHRC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_SHRC, rc, ra, lit}; endtask
task SRAC; input [4:0] ra; input [11:0] lit; input [4:0] rc; output [31:0] ot; ot = {`op_SRAC, rc, ra, lit}; endtask
*/

`endif

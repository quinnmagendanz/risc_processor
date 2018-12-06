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
// TODO(magendanz) Extra imstructions: ZERO, MOV, PUSHA
`define LD(ra, lit, rc)     {`op_LD, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define ST(rc, lit, ra)     {`op_ST, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define JMP(ra, rc)         {`op_JMP, {rc}[4:0], {ra}[4:0], 16'b0}
`define BEQ(ra, lit, rc)    {`op_BEQ, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define BNE(ra, lit, rc)    {`op_BNE, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define LDR(lit, rc)        {`op_LDR, {rc}[4:0], 5'b0, {lit}[15:0]}
`define ADD(ra, rb, rc)     {`op_ADD, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define SUB(ra, rb, rc)     {`op_SUB, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define MUL(ra, rb, rc)     {`op_MUL, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define DIV(ra, rb, rc)     {`op_DIV, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define CMPEQ(ra, rb, rc)   {`op_CMPEQ, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define CMPLT(ra, rb, rc)   {`op_CMPLT, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define CMPLE(ra, rb, rc)   {`op_CMPLE, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define AND(ra, rb, rc)     {`op_AND, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define OR(ra, rb, rc)      {`op_OR, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define XOR(ra, rb, rc)     {`op_XOR, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define XNOR(ra, rb, rc)    {`op_XNOR, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define SHL(ra, rb, rc)     {`op_SHL, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define SHR(ra, rb, rc)     {`op_SHR, {rc}[4:0], {ra}[4:0], {rb}[4:0], 11'b0}
`define ADDC(ra, lit, rc)   {`op_ADDC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define SUBC(ra, lit, rc)   {`op_SUBC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define MULC(ra, lit, rc)   {`op_MULC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define DIVC(ra, lit, rc)   {`op_DIVC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define CMPEQC(ra, lit, rc) {`op_CMPEQC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define CMPLTC(ra, lit, rc) {`op_CMPLTC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define CMPLEC(ra, lit, rc) {`op_CMPLEC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define ANDC(ra, lit, rc)   {`op_ANDC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define ORC(ra, lit, rc)    {`op_ORC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define XORC(ra, lit, rc)   {`op_XORC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define XNORC(ra, lit, rc)  {`op_XNORC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define SHLC(ra, lit, rc)   {`op_SHLC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define SHRC(ra, lit, rc)   {`op_SHRC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}
`define SHRAC(ra, lit, rc)  {`op_SRAC, {rc}[4:0], {ra}[4:0], {lit}[15:0]}

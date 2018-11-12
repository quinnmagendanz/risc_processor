// OP[5:0]
parameter LD = 6'b000011;
parameter ADD = 6'b000100;
parameter AND = 6'b000101;
parameter ADDC = 6'b000110;
parameter ANDC = 6'b000111;
parameter ST = 6'b001011;
parameter SUB = 6'b001100;
parameter OR = 6'b001101;
parameter SUBC = 6'b001110;
parameter ORC = 6'b001111;
parameter MUL = 6'b010100;
parameter XOR = 6'b010101;
parameter MULC = 6'b010110;
parameter XORC = 6'b010111;
parameter JMP = 6'b011011;
parameter DIV = 6'b011100;
parameter XNOR = 6'b011101;
parameter DIVC = 6'b011110;
parameter XNORC = 6'b011111;
parameter BEQ = 6'b100011;
parameter CMPEQ = 6'b100100;
parameter SHL = 6'b100101;
parameter CMPEQC = 6'b100110;
parameter SHLC = 6'b100111;
parameter BNE = 6'b101011;
parameter CMPLT = 6'b101100;
parameter SHR = 6'b101101;
parameter CMPLTC = 6'b101110;
parameter SHRC = 6'b101111;
parameter CMPLE = 6'b110100;
parameter SRA = 6'b110101;
parameter CMPLEC = 6'b110110;
parameter SRAC = 6'b110111;
parameter LDR = 6'b111011;

// ALUFN[5:0]
parameter alu_CMPEQ = 6'b000011;
parameter alu_CMPLT = 6'b000101;
parameter alu_CMPLE = 6'b000111;
parameter alu_ADD = 6'b010000;
parameter alu_SUB = 6'b010001;
parameter alu_MUL = 6'b010010;
parameter alu_DIV = 6'b010011;
parameter alu_AND = 6'b101000;
parameter alu_OR = 6'b101110;
parameter alu_XOR = 6'b100110;
parameter alu_XNOR = 6'b101001;
parameter alu_A = 6'b101010;
parameter alu_SHL = 6'b110000;
parameter alu_SHR = 6'b110001;
parameter alu_SRA = 6'b110011;

// PC
parameter RESET = 32'h80000000;
parameter ILLOP = 32'h80000004;
parameter XADR = 32'h80000008;
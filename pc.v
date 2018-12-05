`timescale 1ns / 1ps

module pc(
    input [15:0] id,
    input [29:0] jt,
    input [2:0] pcsel,
    input clock, reset, 
    output reg [31:0] pc,
    output [31:0] pc_inc, pc_offset);
        `include "risc_constants.vh"
    
    assign pc_inc = {pc[31], pc[30:0] + 31'd4};
    assign pc_offset = pc_inc + 4 * {{16{id[15]}}, id};
    
    initial begin
        pc = 0;
    end
    
    always @(posedge clock) begin
        if (reset) pc <= `RESET;
        else begin
            case (pcsel)
                0: pc <= pc_inc;
                1: pc <= pc_offset;
                2: pc <= {jt, 2'b0};
                3: pc <= `ILLOP;
                4: pc <= `XADR;
            endcase
        end
    end
endmodule

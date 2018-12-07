`timescale 1ns / 1ps

module labkit(
   input CLK100MHZ,
   input[15:0] SW, 
   input BTNC, BTNU, BTNL, BTNR, BTND,
   output[3:0] VGA_R, 
   output[3:0] VGA_B, 
   output[3:0] VGA_G,
   output[7:0] JA, 
   output VGA_HS, 
   output VGA_VS, 
   output LED16_B, LED16_G, LED16_R,
   output LED17_B, LED17_G, LED17_R,
   output[15:0] LED,
   output[7:0] SEG,  // segments A-G (0-6), DP (7)
   output[7:0] AN    // Display 0-7
   );
   

// create 25mhz system clock
    wire clock_25mhz;
    clock_quarter_divider clockgen(.clk100_mhz(CLK100MHZ), .clock_25mhz(clock_25mhz));

//  instantiate 7-segment display;  
    wire [31:0] data;
    wire [6:0] segments;
    display_8hex display(.clk(clock_25mhz),.data(data), .seg(segments), .strobe(AN));    
    assign SEG[6:0] = segments;
    assign SEG[7] = 1'b1;

//////////////////////////////////////////////////////////////////////////////////
//
/*
    assign LED = SW;     
    assign JA[7:0] = 8'b0;
    assign data = {28'h0123456, SW[3:0]};   // display 0123456 + SW
    assign LED16_R = BTNL;                  // left button -> red led
    assign LED16_G = BTNC;                  // center button -> green led
    assign LED16_B = BTNR;                  // right button -> blue led
    assign LED17_R = BTNL;
    assign LED17_G = BTNC;
    assign LED17_B = BTNR; 
*/
    //reg [31:0] disp_data;
    //assign data = disp_data;
    wire clock = clock_25mhz;
    
    wire reset;
    debounce c_db(0, clock, BTNC, reset);
    wire fib_act;
    debounce l_db(reset, clock, BTNL, fib_act);
    wire sort_act;
    debounce r_db(reset, clock, BTNR, save_act);
    wire load_act;
    debounce u_db(reset, clock, BTNU, save_act);
    wire save_act;
    debounce d_db(reset, clock, BTND, save_act);
    
    reg [31:0] program_selector;
    initial program_selector = 0;
    always @(posedge clock) begin // Assume this gets held for more than 1 clock cycle to allow copy.
        if (fib_act) program_selector = 1;
        // TODO(magendanz) Add other programs when ready.
        else program_selector = 0;
    end

    wire irq, z, asel, bsel, moe, mwr, ra2sel, wasel, werf;
    wire [1:0] wdsel;
    wire [2:0] pcsel;
    wire [5:0] ra, rb, rc, op, alufn; 
    wire [31:0] pc, pc_inc, pc_offset, id, jt, wdata, radata, rbdata, mrd;
    wire signed [31:0] a, b, alu_out;
   
    assign irq = 0;
    assign op = id[31:26];
    assign ra = id[20:16];
    assign rb = id[15:11];
    assign rc = id[25:21];
    assign z = radata == 0 ? 1 : 0;
    assign jt = radata;
    assign a = asel ? pc_offset : radata;
    assign b = bsel ? {{16{id[15]}}, id[15:0]} : rbdata;
    assign wdata = wdsel == 0 ? pc_inc : (wdsel == 1 ? alu_out : mrd);
    
    // PC updated on rising clock edge.
    pc counter(id, jt[31:2], pcsel, clock, reset, pc, pc_inc, pc_offset);

    // Reads instruction at PC.
    instr instructions(pc, id);

    // Sets state to match instruction read.
    ctl control(op, reset, irq, z, alufn, pcsel, wdsel, asel, bsel, moe, mwr, ra2sel, wasel, werf);
        
    // Reads occur on wire. On rising clock edge, if WERF, write 
    // to register occurs.
    regfile regs(wdata, ra, rb, rc, ra2sel, wasel, werf, clock, program_selector, radata, rbdata, data /* Processor output */);

    // Perform arithmatic on inputs.
    alu arith(a, b, alufn, alu_out);
    
    // Reads occurs if MOE. On rising clock edge, if MWR, write to memory occurs.
    mem data_memory(clock, rbdata, alu_out, mwr, moe, mrd); 
    

//
//////////////////////////////////////////////////////////////////////////////////
endmodule

module clock_quarter_divider(input clk100_mhz, output reg clock_25mhz = 0);
    reg counter = 0;

    // VERY BAD VERILOG
    // VERY BAD VERILOG
    // VERY BAD VERILOG
    // But it's a quick and dirty way to create a 25Mhz clock
    // Please use the IP Clock Wizard under FPGA Features/Clocking
    //
    // For 1 Hz pulse, it's okay to use a counter to create the pulse as in
    // assign onehz = (counter == 100_000_000); 
    // be sure to have the right number of bits.

    always @(posedge clk100_mhz) begin
        counter <= counter + 1;
        if (counter == 0) begin
            clock_25mhz <= ~clock_25mhz;
        end
    end
endmodule

module labkit_test();
    
    reg [31:0] program_selector;
    wire [31:0] data;
    reg clock, reset, irq;

    wire z, asel, bsel, moe, mwr, ra2sel, wasel, werf;
    wire [1:0] wdsel;
    wire [2:0] pcsel;
    wire [5:0] ra, rb, rc, op, alufn; 
    wire [31:0] pc, pc_inc, pc_offset, id, jt, wdata, radata, rbdata, mrd;
    wire signed [31:0] a, b, alu_out;
   
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
        
    // TODO(magendanz) pass in 16-bit input to specified regesters.
    // Reads occur on wire. On rising clock edge, if ?WERF?, write 
    // to register occurs.
    regfile regs(wdata, ra, rb, rc, ra2sel, wasel, werf, reset, clock, program_selector, radata, rbdata, data);

    // Perform arithmatic on inputs.
    alu arith(a, b, alufn, alu_out);
    
    // Reads occurs if MOE. On rising clock edge, if MWR, write to memory occurs.
    mem data_memory(clock, rbdata, alu_out, mwr, moe, mrd); 
    
    initial begin   // system clock
        forever #5 clock = !clock;
    end 
    
    initial begin
        program_selector = 0;
        clock = 0;
        reset = 0;
        irq = 0;
        
        #50;
        
        program_selector = 1;
        #20 program_selector = 0;
        
        #500;
    
        $stop;
    end
        
endmodule
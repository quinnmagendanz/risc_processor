module labkit_test();
    
    wire [31:0] data;
    wire [15:0] SW;
    wire BTNC, BTNL, BTNR, BTNU, BTND;
    reg clock;
    
    wire [31:0] reg_data;
    // Last switch toggles between displaying input and output.
    assign data = SW[15] ? reg_data : {9'd0, SW[14:8], 8'd0, SW[7:0]};
    
    wire reset = BTNC;
    // debounce c_db(0, clock, BTNC, reset);
    wire fib_act = BTNL;
    // debounce l_db(reset, clock, BTNL, fib_act);
    wire sort_act = BTNR;
    // debounce r_db(reset, clock, BTNR, sort_act);
    wire load_act = BTNU;
    // debounce u_db(reset, clock, BTNU, load_act);
    wire save_act = BTND;
    // debounce d_db(reset, clock, BTND, save_act);
   
    reg [31:0] program_selector;
    initial program_selector = 0;
    always @(posedge clock) begin // Assume this gets held for more than 1 clock cycle to allow copy.
       if (fib_act) program_selector = 1;
       else if (sort_act) program_selector = 2;
       else if (save_act) program_selector = 3;
       else if (load_act) program_selector = 4;
        // TODO(magendanz) Add other programs when ready.
        else program_selector = 0;
    end

    wire irq, z, asel, bsel, moe, mwr, ra2sel, wasel, werf;
    wire [1:0] wdsel;
    wire [2:0] pcsel;
    wire [5:0] ra, rb, rc, op, alufn; 
    wire [31:0] pc, pc_inc, pc_offset, id, jt, wdata, radata, rbdata, mrd;
    wire signed [31:0] a, b, alu_out;
    wire [31:0] first_eight;
   
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
    regfile regs(wdata, ra, rb, rc, ra2sel, wasel, werf, reset, clock, program_selector, SW /* Processor input */, radata, rbdata, reg_data);

    // Perform arithmetic on inputs.
    alu arith(a, b, alufn, alu_out);
    
    // Reads occurs if MOE. On rising clock edge, if MWR, write to memory occurs.
    mem data_memory(clock, reset, mwr, moe, rbdata, alu_out, mrd, first_eight); 
    
    initial begin   // system clock
        forever #5 clock = !clock;
    end 
    
    reg show_output;
    reg [7:0] input1;
    reg [6:0] input2;
    reg do_reset, run_fib, run_sort, run_save, run_load;
    assign SW = {show_output, input2, input1};
    assign BTNC = do_reset;
    assign BTNL = run_fib; 
    assign BTNR = run_sort;
    assign BTNU = run_load ;
    assign BTND = run_save;
    
    integer i;
    initial begin
        show_output = 0;
        input1 = 0;
        input2 = 0;
        do_reset = 0;
        run_fib = 0;
        run_sort = 0;
        run_load = 0;
        run_save = 0;

        clock = 0;
        
        #50;
        
//        // Fib Test
//        run_fib = 1;
//        #20 run_fib = 0;
//        #400 show_output = 1;
//        #20 show_output = 0;
//        #10 show_output = 1;
//        input1 = 6;
//        #10 run_fib = 1;
//        #20 run_fib = 0;
//        #500;
        
        // Sort Test
        // Simple
        input1 = 2;
        input2 = 0;
        run_save = 1;
        #20 run_save = 0;
        #200 input1 = 1;
        input2 = 4;
        run_save = 1;
        #20 run_save = 0;
        #200 show_output = 1;
        run_sort = 1;
        #20 run_sort = 0;
        #3000;
//
//        // Expensive
//        for (i = 0; i < 32; i = i + 4) begin
//            #200 input1 = 9 - (i >> 2);
//            input2 = i;
//            run_save = 1;
//            #20 run_save = 0;
//        end
//        #200 show_output = 1;
//        run_sort = 1;
//        #20 run_sort = 0;
//        #8000; // Need many cycles.

//        // Save and load test
//        input1 = 3;
//        input2 = 4;
//        show_output = 1;
//        #20 run_save = 1;
//        #20 run_save = 0;
//        #200 run_load = 1;
//        #20 run_load = 0;
//        #200 input1 = 6;
//        input2 = 8;
//        run_save = 1;
//        #20 run_save = 0;
//        #200 run_load = 1;
//        #20 run_load = 0;
//        #200 input2 = 4;
//        run_load = 1;
//        #20 run_load = 0;
//        #500;
    
        $stop;
    end
        
endmodule

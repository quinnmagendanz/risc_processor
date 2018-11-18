`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2018 04:21:27 PM
// Design Name: 
// Module Name: regfile_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile_tb(
    );
    
    reg [31:0] wdata;
    reg [4:0] ra, rb, rc;
    reg ra2sel, wasel, werf, clock;
    wire [31:0] radata, rbdata;
    
    regfile test(.wdata(wdata), .ra(ra), .rb(rb), .rc(rc), .ra2sel(ra2sel), .wasel(wasel), .werf(werf), .clock(clock), .radata(radata), .rbdata(rbdata));
    
    initial begin
        
        wdata = 0;
        ra = 0;
        rb = 0;
        rc = 0;
        ra2sel = 0;
        wasel = 0;
        werf = 0;
        clock = 0;
        
        #100
        
        wdata = 55;
        ra = 1;
        rb = 2;
        rc = 3;
        ra2sel = 0;
        wasel = 0;
        werf = 1;
        
        #100
        
        wdata = 55;
        ra = 3;
        rb = 2;
        rc = 3;
        ra2sel = 1;
        wasel = 0;
        werf = 0;
        
        #100
                
        wdata = 20;
        ra = 3;
        rb = 2;
        rc = 3;
        ra2sel = 0;
        wasel = 0;
        werf = 1;
        
    end
    
    always begin
        #10
        clock = ~clock;
    end
    
endmodule

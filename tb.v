`timescale 1ns / 1ps

module top_tb;

    // Inputs
    reg clk;
    reg rst;
    
    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk(clk),
        .rst(rst)
        
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 ns
    end

    // Test sequence
    initial begin
        $dumpfile("res.vcd");
        $dumpvars(0, top_tb);

        // Test 1: Reset
        rst = 0;
        #5; // Wait for reset to propagate
        rst = 1;
        #10
        rst = 0;
        #200 $finish;
    end

endmodule


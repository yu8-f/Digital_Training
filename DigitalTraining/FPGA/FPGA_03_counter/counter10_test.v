// counter10 simulation
`timescale 1ns/1ps

module counter10_test;

    reg clk, rst;
    // reg [3:0] d; // 4-bit data input
    wire [3:0] cnt; // this "q" is wire, and "Q" is reg in dff module

    parameter STEP = 1000; // time step for each test case

    // dff4bit dff4_0(clk, rst, d, q); // instantiate the dff module
    counter10_2 counter10_0(clk, rst, cnt); // instantiate the counter10 module

    always begin // clock generation
        clk = 1'b0;
        #(STEP/2);
        clk = 1'b1;
        #(STEP/2);
        // forever #STEP clk = ~clk; // this explanation is smarter
    end

    initial begin
        rst = 1'b1;
        #(STEP/4) rst = 0;
        #STEP; rst = 1'b1;
        #(STEP*15);
        $finish;
    end

    initial begin
        $monitor($stime, "clk=%b rst=%b cnt=%h", clk, rst, cnt); // print the values of inputs and outputs
        $dumpfile("coutner10.vcd"); // create a VCD file for waveform viewing
        $dumpvars(0, counter10_test); // dump all variables in the testbench
    end

endmodule
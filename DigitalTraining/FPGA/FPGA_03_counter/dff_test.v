// dff simulation
`timescale 1ns/1ps

module dff_test;

    reg clk, rst;
    reg d;
    wire q; // this "q" is wire, and "Q" is reg in dff module

    parameter STEP = 1000; // time step for each test case

    dff dff0(clk, rst, d, q); // instantiate the dff module

    always begin // clock generation
        clk = 1'b0;
        #(STEP/2);
        clk = 1'b1;
        #(STEP/2);
        // forever #STEP clk = ~clk; // this explanation is smarter
    end

    initial begin
        rst = 1'b1; d = 1'b1;
        #(STEP/4) rst = 0;
        #STEP; rst = 1'b1;
        #(STEP*1.1) d = 1;
        #(STEP*2.1) d = 0;
        #(STEP*3.1) d = 1;
        #(STEP*4.1) d = 0;
        #(STEP*2);
        $finish;
    end

    initial begin
        $monitor($stime, "clk=%b rst=%b d=%b q=%b", clk, rst, d, q); // print the values of inputs and outputs
        $dumpfile("dff.vcd"); // create a VCD file for waveform viewing
        $dumpvars(0, dff_test); // dump all variables in the testbench
    end

endmodule
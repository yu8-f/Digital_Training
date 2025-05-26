// dff simulation
`timescale 1ns/1ps

module dff4bit_test;

    reg clk, rst;
    reg [3:0] d; // 4-bit data input
    wire [3:0] q; // this "q" is wire, and "Q" is reg in dff module

    parameter STEP = 1000; // time step for each test case

    dff4bit dff4_0(clk, rst, d, q); // instantiate the dff module

    always begin // clock generation
        clk = 1'b0;
        #(STEP/2);
        clk = 1'b1;
        #(STEP/2);
        // forever #STEP clk = ~clk; // this explanation is smarter
    end

    initial begin
        rst = 1'b1; d = 4'h1;
        #(STEP/4) rst = 0;
        #STEP; rst = 1'b1;
        #(STEP*1.1) d = 4'h3;
        #(STEP*2.1) d = 4'hc;
        #(STEP*3.1) d = 4'h9;
        #(STEP*4.1) d = 4'h0;
        #(STEP*2);
        $finish;
    end

    initial begin
        $monitor($stime, "clk=%b rst=%b d=%h q=%h", clk, rst, d, q); // print the values of inputs and outputs
        $dumpfile("dff4bit.vcd"); // create a VCD file for waveform viewing
        $dumpvars(0, dff4bit_test); // dump all variables in the testbench
    end

endmodule
// simulation of adder4bit
// first, we need to determine the timescale for the simulation
`timescale 1ns / 1ps // time unit is 1ns, time precision is 1ps (precision = marume_gosa)

module adder4bit_test; // testbench module

    reg [7:0] a, b; // inputs are declared as registers
    wire [8:0] res; // outputs are declared as wires

    parameter STEP = 100; // time step for each test case

    // adder4bit2 tashichan(a, b, res); // instantiate the adder4bit module
    adder8bit tashichan(a, b, res); // instantiate the adder4bit module

    initial begin
        a= 8'd0; b = 8'd0; // initialize inputs
        #STEP; // wait for STEP time
        a = 8'd100; b = 8'd77; // test case 1
        #STEP;
        a = 8'd70; b = 8'd35; // test case 2
        #STEP;
        $finish; // end the simulation
    end

    initial begin // monitoring test results (Following codes are like spells)
        $monitor($stime, " a=%b b=%b res=%b", a, b, res); // print the values of inputs and outputs
        $dumpfile("adder4bit_test.vcd"); // create a VCD file for waveform viewing
        $dumpvars(0, adder4bit_test); // dump all variables in the testbench
    end

endmodule
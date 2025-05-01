// simulation of half_tasizan
// first, we need to determine the timescale for the simulation
`timescale 1ns / 1ps // time unit is 1ns, time precision is 1ps (precision = marume_gosa)

module half_tasizan_test; // testbench module

    reg a, b; // inputs are declared as registers
    wire c, s; // outputs are declared as wires

    parameter STEP = 100; // time step for each test case

    half_tasizan tashichan(a, b, c, s); // instantiate the half_tasizan module

    initial begin
        a = 1'b0; b = 1'b0; // initialize inputs
        #STEP; // wait for STEP time
        a = 1'b0; b = 1'b1; // test case 1
        #STEP;
        a = 1'b1; b = 1'b0; // test case 2
        #STEP;
        a = 1'b1; b = 1'b1; // test case 3
        #STEP;
        $finish; // end the simulation
    end

    initial begin // monitoring test results (Following codes are like spells)
        $monitor($stime, " a=%b b=%b c=%b s=%b", a, b, c, s); // print the values of inputs and outputs
        $dumpfile("halfadder_test.vcd"); // create a VCD file for waveform viewing
        $dumpvars(0, half_tasizan_test); // dump all variables in the testbench
    end

endmodule
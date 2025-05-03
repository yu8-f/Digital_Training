// simulation of full_tasizan
// first, we need to determine the timescale for the simulation
`timescale 1ns / 1ps // time unit is 1ns, time precision is 1ps (precision = marume_gosa)

module full_tasizan_test; // testbench module

    reg a, b, cin; // inputs are declared as registers
    wire cout, s; // outputs are declared as wires

    parameter STEP = 100; // time step for each test case

    full_tasizan tashichan(a, b, cin, cout, s); // instantiate the half_tasizan module

    initial begin
        a = 1'b0; b = 1'b0; cin = 1'b0; // initialize inputs
        #STEP; // wait for STEP time
        a = 1'b0; b = 1'b0; cin = 1'b1;// test case 1
        #STEP;
        a = 1'b0; b = 1'b1; cin = 1'b0;// test case 2
        #STEP;
        a = 1'b0; b = 1'b1; cin = 1'b1;// test case 3
        #STEP;
        a = 1'b1; b = 1'b0; cin = 1'b0; // test case 4
        #STEP; // wait for STEP time
        a = 1'b1; b = 1'b0; cin = 1'b1;// test case 5
        #STEP;
        a = 1'b1; b = 1'b1; cin = 1'b0;// test case 6
        #STEP;
        a = 1'b1; b = 1'b1; cin = 1'b1;// test case 7
        #STEP;
        $finish; // end the simulation
    end

    initial begin // monitoring test results (Following codes are like spells)
        $monitor($stime, " a=%b b=%b cin=%b cout=%b s=%b", a, b, cin, cout, s); // print the values of inputs and outputs
        $dumpfile("fulladder_test.vcd"); // create a VCD file for waveform viewing
        $dumpvars(0, full_tasizan_test); // dump all variables in the testbench
    end

endmodule
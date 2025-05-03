// square simulation
`timescale 1ns/1ps

module square_test;

    reg [3:0] x_;
    reg [7:0] x_square;
    wire [3:0] x_inc;
    wire [7:0] x_inc_square;

    parameter STEP = 1000; // time step for each test case

    square square_0(x_, x_square, x_inc, x_inc_square);

    // always begin // clock generation
    //     clk = 1'b0;
    //     #(STEP/2);
    //     clk = 1'b1;
    //     #(STEP/2);
    //     // forever #STEP clk = ~clk; // this explanation is smarter
    // end

    initial begin
        // rst = 1'b1; d = 4'h1;
        #STEP; x_ = 0; x_square = 0;
        #STEP; x_ = 1; x_square = 1;
        #STEP; x_ = 2; x_square = 4;
        #STEP; x_ = 3; x_square = 9;
        #STEP; x_ = x_inc; x_square = x_inc_square;
        #STEP; x_ = x_inc; x_square = x_inc_square;
        #STEP; x_ = x_inc; x_square = x_inc_square;
        #STEP; x_ = x_inc; x_square = x_inc_square;
        #STEP; x_ = x_inc; x_square = x_inc_square;
        #STEP; x_ = x_inc; x_square = x_inc_square;
        $finish;
    end

    initial begin
        $monitor($stime, "x_=%h x_square=%h x_inc=%h x_inc_square=%h", x_, x_square, x_inc, x_inc_square);
        $dumpfile("square.vcd"); // create a VCD file for waveform viewing
        $dumpvars(0, square_test); // dump all variables in the testbench
    end

endmodule
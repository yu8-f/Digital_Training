module square(x_, x_square, x_inc, x_inc_square);
    // we used "x_" instead of "x" because "x" is reserved word

    input [3:0] x_;
    input [7:0] x_square;
    output [3:0] x_inc;
    output [7:0] x_inc_square;

    assign x_inc = x_ + 1;

    assign x_inc_square = x_square + (x_ << 1) + 1;// left shift means * 2

endmodule
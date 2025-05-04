// use look-up table

module square_c(x_, x_square);
    // we used "x_" instead of "x" because "x" is reserved word

    input [3:0] x_;
    output [7:0] x_square;

    function [3:0] square;
        input [3:0] invar;
        case (invar)
            4'h0: square = 8'd0;
            4'h1: square = 8'd1;
            4'h2: square = 8'd4;
            4'h3: square = 8'd9;
            4'h4: square = 8'd16;
            4'h5: square = 8'd25;
            4'h6: square = 8'd36;
            4'h7: square = 8'd49;
            4'h8: square = 8'd64;
            4'h9: square = 8'd81;
            4'ha: square = 8'd100;
            4'hb: square = 8'd121;
            4'hc: square = 8'd144;
            4'hd: square = 8'd169;
            4'he: square = 8'd196;
            4'hf: square = 8'd225;
            default : square = 4'h0; // reset to 0 if input is not in the range
        endcase

    endfunction

    assign x_square = square(x_); // increment the value of q using the square function

endmodule
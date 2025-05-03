// countrer 10

module counter10(clk, rst, cnt);

    input clk, rst; // input signals
    output [3:0] cnt; // 4-bit output signal
    // this "cnt" is wire

    wire [3:0] d, q;

    function [3:0] incr;

        input [3:0] invar;
            case (invar)
                4'h0: incr = 4'h1;
                4'h1: incr = 4'h2;
                4'h2: incr = 4'h3;
                4'h3: incr = 4'h4;
                4'h4: incr = 4'h5;
                4'h5: incr = 4'h6;
                4'h6: incr = 4'h7;
                4'h7: incr = 4'h8;
                4'h8: incr = 4'h9;
                4'h9: incr = 4'ha;
                default : incr = 4'h0; // reset to 0 if input is not in the range
            endcase

    endfunction

    assign d = incr(q); // increment the value of q using the incr function

    dff4bit dff4_0(clk, rst, d, q);

    assign cnt = q;

endmodule
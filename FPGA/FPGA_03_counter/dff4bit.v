// dff 4bit

module dff4bit(clk, rst, d, q);
    input clk, rst; // inputs: clock and reset
    input [3:0] d; // 4-bit data input
    output [3:0] q; // 4-bit data output
    // in this case, q is declared as a wire, not a reg
    // because "Q" as registers are hidden inside the dff module

    dff dff0(clk, rst, d[0], q[0]); // instantiate 4 D flip-flops for each bit of the input
    dff dff1(clk, rst, d[1], q[1]);
    dff dff2(clk, rst, d[2], q[2]);
    dff dff3(clk, rst, d[3], q[3]);


endmodule
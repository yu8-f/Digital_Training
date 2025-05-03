// adder4bit ver2

module adder4bit2(a, b, s);

    input [3:0] a, b; // 4-bit inputs
    output [4:0] s; // 5-bit output (4 bits for sum and 1 bit for carry out)

    assign s = a + b; // simple addition using Verilog's built-in addition operator

endmodule

module adder8bit(a, b, s);

    input [7:0] a, b; // 4-bit inputs
    output [8:0] s; // 5-bit output (4 bits for sum and 1 bit for carry out)

    assign s = a + b; // simple addition using Verilog's built-in addition operator

endmodule
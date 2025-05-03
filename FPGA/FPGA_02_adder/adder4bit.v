// adder 4bit

module adder4bit(a, b, s);

    input [3:0] a, b; // 4-bit inputs
    output [4:0] s; // 5-bit output (4 bits for sum and 1 bit for carry out)
    wire [3:0] c; // carry wires

    half_tasizan ha0(a[0], b[0], c[0], s[0]); // first half-adder
    full_tasizan fa1(a[1], b[1], c[0], c[1], s[1]); // first full-adder
    full_tasizan fa2(.A(a[2]), .B(b[2]), .Cin(c[1]), .Cout(c[2]), .S(s[2])); // we can write like this
    // if we write like the above, we don't need to write unused wires
    // unwritten wires are considered as X (unknown value)
    full_tasizan fa3(a[3], b[3], c[2], c[3], s[3]); // last full-adder

    assign s[4] = c[3]; // final carry out (s[4]) is the last carry output (c[3])

endmodule
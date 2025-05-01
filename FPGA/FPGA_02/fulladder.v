// full-adder
module full_tasizan (A, B, Cin, Cout, S);
    input A, B, Cin; // inputs
    output Cout, S; // outputs
    wire C0, S0, C1; // intermediate wires (Do not use resister instead of wire)

    half_tasizan ha0(A, B, C0, S0); // first half-adder
    half_tasizan ha1(S0, Cin, C1, S); // second half-adder

    assign Cout = C0 | C1; // final carry output (Cout) is the OR of the two carry outputs (C0 and C1)
endmodule
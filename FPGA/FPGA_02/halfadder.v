// half-adder

module half_tasizan (A, B, C, S);

    input A, B; // inputs
    output C, S; // outputs

    assign C = A & B; // carry output
    assign S = A ^ B; // sum output

endmodule
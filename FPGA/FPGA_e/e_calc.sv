module e_calc #(
    parameter WORDS = 32,
    parameter LOG2_N = 15
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    output logic done,
    output logic [16*WORDS-1:0] out_data
);

    e_calc_square #(
        .WORDS(WORDS),
        .LOG2_N(LOG2_N)
    ) u_calc_square (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .out_data(out_data)
    );

endmodule

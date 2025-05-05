`timescale 1ns/1ps

module e_calc_tb;

    parameter WORDS = 32;
    parameter LOG2_N = 15;

    logic clk;
    logic rst_n;
    logic start;
    logic done;
    logic [16*WORDS-1:0] out_data;

    e_calc #(
        .WORDS(WORDS),
        .LOG2_N(LOG2_N)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .out_data(out_data)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        start = 0;
        #20;
        rst_n = 1;
        #20;
        start = 1;
        #10;
        start = 0;
    end

    always_ff @(posedge clk) begin
        if (done) begin
            $display("Calculation done");
            for (int i = WORDS-1; i >= 0; i = i - 1) begin
                $display("%d: %d", i, out_data[i*16 +: 16]);
            end
            $finish;
        end
    end

endmodule

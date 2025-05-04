`timescale 1ns/1ps

module e_calculator_tb;

    parameter WORDS = 32;
    parameter LOG2_N = 15;

    reg clk;
    reg rstn;
    reg start;
    wire done;
    wire [15:0] result [0:2*WORDS-1];

    // テスト対象インスタンス
    e_calculator #(
        .WORDS(WORDS),
        .LOG2_N(LOG2_N)
    ) dut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .done(done),
        .result(result)
    );

    // クロック生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHzクロック
    end

    integer i;

    // テストシナリオ
    initial begin
        $display("=== Simulation Start ===");

        rstn = 0;
        start = 0;
        #20;
        rstn = 1;
        #20;

        start = 1;
        #10;
        start = 0;

        // doneが立つまで待つ
        wait (done == 1);

        $display("Calculation Finished!");

        // 結果出力
        $display("Result (hex):");
        for (i = 2*WORDS-1; i >= 0; i = i - 1) begin
            $write("%h ", result[i]);
        end
        $display("\n");

        $finish;
    end

endmodule
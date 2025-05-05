module e_calc_tb;

    parameter int WORDS = 32;
    parameter int LOG2_N = 15;

    logic clk;
    logic rst_n;
    logic start;
    logic done;
    logic [15:0] result [0:WORDS-1];

    // DUT（Device Under Test）インスタンス
    e_calc #(
        .WORDS(WORDS),
        .LOG2_N(LOG2_N)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .result(result)
    );

    // クロック生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHzクロック（周期10ns）
    end

    // テストシナリオ
    initial begin
        $dumpfile("e_calc.vcd");  // 波形出力ファイル名
        $dumpvars(0, e_calc_tb);  // すべての変数を記録

        rst_n = 0;
        start = 0;
        #20;
        rst_n = 1;
        #20;

        start = 1;
        #10;
        start = 0;

        wait (done);  // 計算完了を待つ

        $display("Calculation done!");
        for (int i = WORDS-1; i >= 0; i--) begin
            $display("result[%0d] = %h", i, result[i]);
        end

        #100;
        $finish;
    end

endmodule

`timescale 1ns / 1ps

module tb_adder_400bit;

    // クロック・リセット
    reg clk;
    reg rst;
    reg start;

    // 入出力
    wire [7:0] sum [0:49];
    reg [7:0] a [0:49];
    reg [7:0] b [0:49];
    wire done;

    integer i;

    // クロック生成（10ns周期）
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 5nsごとに反転 → 10ns周期
    end

    // 被テストモジュール (UUT)
    adder_400bit uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .sum(sum),
        .done(done)
    );

    // 初期化モジュール呼び出し
    init_400bit init_ans (
        .ans(a)  // aに初期値セット
    );

    // テストシーケンス
    initial begin
        // 初期化
        rst = 1;
        start = 0;
        for (i = 0; i < 50; i = i + 1) begin
            b[i] = 8'h01;  // bには全ビット1を入れる（簡単なテスト）
        end
        #20;
        rst = 0;
        #20;

        // スタート信号
        start = 1;
        #10;
        start = 0;

        // 計算が完了するまで待つ
        wait(done);

        // 結果を表示
        $display("Add Results:");
        for (i = 0; i < 50; i = i + 1) begin
            $display("sum[%0d] = %h", i, sum[i]);
        end

        $finish;
    end

endmodule

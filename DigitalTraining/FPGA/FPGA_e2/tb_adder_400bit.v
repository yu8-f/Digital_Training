`timescale 1ns / 1ps

module tb_adder_400bit;

    // クロック・リセット
    reg clk;
    reg rst;
    reg start;

    // 入出力
    wire [399:0] sum;
    reg [399:0] a;
    reg [399:0] b;
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

        $dumpfile("tb_adder_400bit.vcd");
        $dumpvars(0, tb_adder_400bit);

        // 初期化
        rst = 1;
        start = 0;
        b = 0;
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

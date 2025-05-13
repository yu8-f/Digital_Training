`timescale 1ns / 1ps

module tb_e_calc;

    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [399:0] ans;

    // e_calc モジュールをインスタンス化
    e_calc uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .ans(ans)
    );

    // クロック生成（10ns周期 = 100MHz）
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_e_calc.vcd");  // 波形出力
        $dumpvars(0, tb_e_calc);

        // 初期設定
        clk = 0;
        rst = 1;
        start = 0;
        #20;

        rst = 0;
        start = 1;  // スタート信号オン
        #10;
        start = 0;  // ワンショットパルスにする

        // 計算完了を待つ
        wait (done == 1);

        // 計算完了後、結果表示
        $display("e = %h", ans);  // 16進数で出力
        $finish;
    end

endmodule

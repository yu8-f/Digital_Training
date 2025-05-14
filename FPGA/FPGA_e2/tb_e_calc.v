`timescale 1ns / 1ps

module tb_e_calc;

    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [399:0] ans;


    // 10進変換器のインスタンス
    wire [3:0] ascii_result [0:149];
    wire conv_done;
    reg conv_start;
    integer i;

    convert_to_10 conv (
        .clk(clk),
        .rst(rst),
        .start(conv_start),
        .binary(ans),
        .done(conv_done),
        .decimal_digits(ascii_result)
    );


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

        // 10進変換器のスタート信号を出す
        conv_start = 1;
        #10;
        conv_start = 0;
        wait (conv_done == 1);
        // $display("e = ");
        for (i = 0; i < 150; i = i + 1) begin
            if (ascii_result[i] != " ") $display("%d", ascii_result[i]);
        end

        // 計算完了後、結果表示
        // $display("e = %h", ans);  // 16進数で出力
        $finish;
    end

endmodule

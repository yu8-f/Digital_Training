`timescale 1ns / 1ps

module tb_e_calc;

    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [399:0] ans;


    // 10進変換器のインスタンス
    wire [3:0] final_decimal;
    wire conv_valid;
    wire conv_done;
    reg conv_start;

    convert_to_10 conv (
        .clk(clk),
        .rst(rst),
        .start(conv_start),
        .binary(ans),
        .decimal(final_decimal),
        .valid(conv_valid),
        .done(conv_done)
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

    // 出力を監視して表示
    always @(posedge clk) begin
        if (conv_valid) begin
            $display("%0d", final_decimal);
        end
        if (conv_done) begin
            $display("\n Calculation done.");
            $finish;
        end
    end

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
        #20;
        conv_start = 0;
        // $display("e = ");
        // for (i = 0; i < 150; i = i + 1) begin
        //     if (ascii_result[i] != " ") $display("%d", ascii_result[i]);
        // end

        // 計算完了後、結果表示
        // $display("e = %h", ans);  // 16進数で出力
        // $finish;
    end

    // タイムアウト防止（例えば500usで終了）
    initial begin
        #500000;
        $display("\n Timeout: Simulation took too long.");
        $finish;
    end

endmodule

`timescale 1ns / 1ps

module tb_divider_400bit;

    reg clk;
    reg rst;
    reg start;
    reg [399:0] dividend;
    reg [7:0] divisor;
    wire [399:0] quotient;
    wire done;

    // インスタンス化
    divider_400bit uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .done(done)
    );

    // クロック生成 (10ns周期)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // テストシナリオ
    initial begin
        // 初期化
        rst = 1;
        start = 0;
        dividend = 0;
        divisor = 0;
        #20;

        rst = 0;
        #20;

        // 入力データセット
        // 例：dividend = 1.0 (固定小数点表現) , divisor = 2
        dividend = 400'd1 << 392;  // 整数部1、小数部0
        divisor = 8'd2;

        #10;
        start = 1;   // 1クロックだけstartを立てる
        #10;
        start = 0;

        // done待ち
        wait (done == 1);
        #20;

        $display("Quotient = %h", quotient);
        $finish;
    end

    // VCDファイル出力
    initial begin
        $dumpfile("tb_divider_400bit.vcd");
        $dumpvars(0, tb_divider_400bit);
    end

endmodule

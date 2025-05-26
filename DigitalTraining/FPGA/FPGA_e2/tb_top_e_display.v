`timescale 1ns / 1ps

module tb_top_e_display;

    reg clk = 0;
    reg [3:0] KEY = 4'b1111;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    top_e_display dut (
        .CLOCK_50(clk),
        .KEY(KEY),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    always #10 clk = ~clk;  // 50MHz

    initial begin
        // 初期化とリセット
        #0    KEY[0] = 0;
        #100  KEY[0] = 1;

        // 波形観察用メッセージ
        $monitor("T=%0t ns : HEX5=%b HEX4=%b HEX3=%b HEX2=%b HEX1=%b HEX0=%b", $time,
                 HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

        // 実行時間
        #100_000_000 $finish;
    end

endmodule

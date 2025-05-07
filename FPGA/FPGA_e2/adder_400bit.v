// adder 400bit
// 8bit + 8bitの加算器，多倍長により400bitまで加算していく

`timescale 1ns / 1ps

module adder_400bit (
    input wire clk,
    input wire rst,                      // リセット
    input wire start,                    // 加算開始信号
    input wire [7:0] a [0:49],            // 入力a
    input wire [7:0] b [0:49],            // 入力b
    output reg [7:0] sum [0:49],          // 出力sum
    output reg done                      // 加算完了フラグ
);

    reg [6:0] idx;                        // 0〜49までのインデックス
    reg carry;                            // キャリーフラグ（0 or 1）

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            idx <= 0;
            carry <= 0;
            done <= 0;
        end else if (start) begin
            idx <= 0;
            carry <= 0;
            done <= 0;
        end else if (idx < 50) begin
            {carry, sum[idx]} <= a[idx] + b[idx] + carry;  // 足してキャリーもセット
            idx <= idx + 1;
            if (idx == 49) begin
                done <= 1;  // 最後まで足したらdone=1
            end
        end
    end

endmodule
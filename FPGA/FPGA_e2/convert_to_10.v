`timescale 1ns / 1ps

module convert_to_10 (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [399:0] binary_in,
    output reg done,
    output reg [7:0] ascii_out [0:127]  // 最大128文字の10進文字列出力
);

    // 内部変数
    reg [399:0] value;
    reg [6:0] char_index;     // 出力インデックス
    reg [6:0] digit_index;
    reg [7:0] digits [0:127]; // 各桁の10進数字
    integer i;
    reg running;

    always @(posedge clk) begin
        if (rst) begin
            done <= 0;
            running <= 0;
            char_index <= 0;
            digit_index <= 0;
        end else if (start && !running) begin
            // 初期化
            value <= binary_in;
            for (i = 0; i < 128; i = i + 1) begin
                digits[i] <= 0;
                ascii_out[i] <= " ";
            end
            digit_index <= 0;
            running <= 1;
            done <= 0;
        end else if (running) begin
            if (value != 0) begin
                // 10進変換: ビッグナンバー除算
                reg [399:0] q;
                reg [3:0] r;
                q = 0;
                r = 0;
                for (i = 399; i >= 0; i = i - 1) begin
                    q = (q << 1) | value[i];
                    if (q >= 10) begin
                        q = q - 10;
                        r = r + 1;
                    end
                end
                value = q;
                digits[digit_index] <= r + "0";
                digit_index <= digit_index + 1;
            end else begin
                // 完了：digits[]をascii_out[]に逆順コピー
                for (i = 0; i < digit_index; i = i + 1) begin
                    ascii_out[i] <= digits[digit_index - 1 - i];
                end
                done <= 1;
                running <= 0;
            end
        end
    end

endmodule

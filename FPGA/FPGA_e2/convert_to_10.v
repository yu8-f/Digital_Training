`timescale 1ns / 1ps

module convert_to_10 (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [399:0] binary,
    output reg [3:0] decimal [0:149],  // 最大150桁（必要に応じて拡張）
    output reg done
);

    reg [399:0] shift_reg;
    reg [7:0] i;  // 桁数カウンタ（最大400bitなら150回程度で足りる）
    reg active;

    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 0;
            for (i = 0; i < 150; i = i + 1)
                decimal_digits[i] <= 0;
            i <= 0;
            done <= 0;
            active <= 0;
        end else if (start) begin
            shift_reg <= binary;
            for (i = 0; i < 150; i = i + 1)
                decimal_digits[i] <= 0;
            i <= 0;
            done <= 0;
            active <= 1;
        end else if (active) begin
            if (i < 50) begin
                // 1. 上位8bitのうち下位4bitだけ記録
                decimal_digits[i] = shift_reg[395:392];

                // 2. 上位8bitを0クリア
                shift_reg[399:392] <= 8'h00;

                // 3. シフト加算 ans = ans * 10
                // 10 * n = (n << 3) + (n << 1)
                shift_reg <= (shift_reg << 3) + (shift_reg << 1);

                i <= i + 1;
            end else begin
                done <= 1;
                active <= 0;
            end
        end else begin
            done <= 0;
        end
    end

endmodule

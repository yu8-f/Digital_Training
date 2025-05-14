`timescale 1ns / 1ps

module convert_to_10 (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [399:0] binary,
    output reg [3:0] decimal,  // 1桁ずつ
    output reg valid,          // decimalが有効なときに1クロック立つ
    output reg done
);

    reg [399:0] shift_reg;
    reg [7:0] count;  // 桁数カウンタ（最大400bitなら150回程度で足りる）
    reg active;

    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 0;
            decimal <= 0;
            count <= 0;
            done <= 0;
            valid <= 0;
            active <= 0;
        end else if (start) begin
            shift_reg <= binary;
            decimal <= 0;
            count <= 0;
            done <= 0;
            valid <= 0;
            active <= 1;
        end else if (active) begin
            if (count < 150) begin
                // 1. 上位8bitのうち下位4bitだけ記録
                decimal <= shift_reg[395:392];

                // 2. 上位8bitを0クリア
                shift_reg[399:392] <= 8'h00;

                // 3. シフト加算 ans = ans * 10
                // 10 * n = (n << 3) + (n << 1)
                shift_reg <= (shift_reg << 3) + (shift_reg << 1);

                count <= count + 1;
                valid <= 1;  // 有効なデータが出力された
                done <= 0;   // 計算中
            end else begin
                valid <= 0;  // 有効なデータが出力されていない
                done <= 1;
                active <= 0;
            end
        end else begin
            valid <= 0;  // 有効なデータが出力されていない
            done <= 0;
        end
    end

endmodule

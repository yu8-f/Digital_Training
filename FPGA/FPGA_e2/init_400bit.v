// ansと被除数mの初期化

`timescale 1ns / 1ps

module init_400bit (
    output reg [7:0] ans [0:49]  // ans[0]が整数部，ans[1]〜ans[49]が小数部
);

    integer i;

    initial begin
        // 初期化
        ans[0] = 8'h01;  // 最初の8bitを1にセット（整数部）
        for (i = 1; i < 50; i = i + 1) begin
            ans[i] = 8'h00;  // 残りは全部0
        end
    end

endmodule

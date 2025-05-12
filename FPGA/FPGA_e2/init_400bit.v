// ansと被除数mの初期化

`timescale 1ns / 1ps

module init_400bit (
    output reg [399:0] ans  // 8bit × 50 = 400bit
);

    integer i;

    initial begin
        ans = 0;
        ans[399-7] = 1;  // ansの上位8bit目を1にセット
    end

endmodule

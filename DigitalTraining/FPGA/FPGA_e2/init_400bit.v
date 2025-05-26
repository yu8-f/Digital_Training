// ansと被除数mの初期化

`timescale 1ns / 1ps

module init_400bit (
    output wire [399:0] ans
);

    // 初期値は1.0を表現（上位8bitが1、残り392bitは0）
    assign ans = {8'h01, 392'h0};

endmodule

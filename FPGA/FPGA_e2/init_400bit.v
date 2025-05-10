// ansと被除数mの初期化

`timescale 1ns / 1ps

module init_400bit (
    output reg [399:0] ans_flat  // 8bit × 50 = 400bit
);

    integer i;

    initial begin
        ans_flat = 0;
        ans_flat[399 -: 8] = 8'h01;  // ans[0] (最上位の8bit) を1にセット
    end

endmodule

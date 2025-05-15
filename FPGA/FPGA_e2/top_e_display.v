`timescale 1ns / 1ps

module top_e_display (
    input wire clk,        // 50MHz or 100MHz クロック
    input wire rst,
    output reg [6:0] seg [5:0]  // 6桁の7セグ（flattenで対応するなら変更必要）
);

    wire [399:0] ans;
    wire done;
    reg start;

    // convert_to_10 接続
    wire [3:0] decimal;
    wire conv_done, conv_valid;
    reg conv_start;

    convert_to_10 conv (
        .clk(clk),
        .rst(rst),
        .start(conv_start),
        .binary(ans),
        .decimal(decimal),
        .valid(conv_valid),
        .done(conv_done)
    );

    // e_calc 接続
    e_calc ecalc (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .ans(ans)
    );

    // SEG_HEXインスタンス（6個）
    wire [6:0] seg_digits[5:0];
    genvar i;
    generate
        for (i = 0; i < 6; i = i + 1) begin : SEG_GEN
            SEG_HEX seg_inst (
                .iDIG(digit_values[i]),
                .oHEX_D(seg_digits[i])
            );
        end
    endgenerate

    reg [3:0] digit_values[5:0];  // インデックス2桁 + 値4桁
    reg [4:0] index;              // 0〜24
    reg [3:0] e_digits[0:149];     // 最大150桁まで対応（eの計算結果）
    reg [7:0] digit_count;         // 0〜149までのカウント

    // 1秒カウンタ
    reg [25:0] sec_counter;       // 26bitで ~67Mまで数えられる

    // counv_startは2クロック分ないと動かない可能性がある
    reg [1:0] conv_start_cnt;  // 2クロック保持用カウンタ

    parameter IDLE = 2'b00;
    parameter WAIT_DONE = 2'b01;
    parameter FETCH_DECIMAL = 2'b10;
    parameter DISPLAY = 2'b11;

    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start <= 0;
            conv_start <= 0;
            sec_counter <= 0;
            index <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    start <= 1;
                    state <= WAIT_DONE;
                end
                WAIT_DONE: begin
                    start <= 0;
                    if (done) begin
                        conv_start <= 1;
                        conv_start_cnt <= 2;  // 2クロック分保持
                        state <= FETCH_DECIMAL;
                    end
                end
                FETCH_DECIMAL: begin
                    // 変換スタート信号制御
                    if (conv_start_cnt != 0) begin
                        conv_start <= 1;
                        conv_start_cnt <= conv_start_cnt - 1;
                    end else begin
                        conv_start <= 0;
                    end

                    if (conv_valid) begin
                        e_digits[digit_count] <= decimal;
                        digit_count <= digit_count + 1;
                    end
                    if (conv_done) begin
                        state <= DISPLAY;
                        index <= 0;
                        sec_counter <= 0;
                    end
                end
                DISPLAY: begin
                    sec_counter <= sec_counter + 1;
                    if (sec_counter == 50_000_000) begin  // 1秒（50MHzの場合）
                        sec_counter <= 0;
                        index <= (index == 24) ? 0 : index + 1;
                    end

                    // 表示値の更新（6桁）
                    digit_values[5] <= index / 10;
                    digit_values[4] <= index % 10;
                    digit_values[3] <= e_digits[index];
                    digit_values[2] <= (index < 24) ? e_digits[4 * index + 1] : 4'd0;
                    digit_values[1] <= (index < 23) ? e_digits[4 * index + 2] : 4'd0;
                    digit_values[0] <= (index < 22) ? e_digits[4 * index + 3] : 4'd0;
                end
            endcase
        end
    end

    // 出力反映
    always @(*) begin
        seg[0] = seg_digits[0];
        seg[1] = seg_digits[1];
        seg[2] = seg_digits[2];
        seg[3] = seg_digits[3];
        seg[4] = seg_digits[4];
        seg[5] = seg_digits[5];
    end

endmodule

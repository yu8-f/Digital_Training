module e_calc_square #(
    parameter WORDS = 32
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] in_data [0:WORDS-1],
    output reg done,
    output reg [15:0] out_data [0:WORDS-1]
);

    // 状態管理
    localparam IDLE  = 2'd0;
    localparam CALC  = 2'd1;
    localparam DONE  = 2'd2;

    reg [1:0] state;
    reg [4:0] count; // log2(n)=15回とかなので5bitあれば十分

    // 内部データ
    reg [15:0] data [0:WORDS-1];

    integer i;

    // 多倍長掛け算のインスタンス呼び出し用
    wire [15:0] mul_in_a [0:WORDS-1];
    wire [15:0] mul_in_b [0:WORDS-1];
    wire [15:0] mul_out [0:WORDS-1];

    // 乗算器 (常に data×data を実行するイメージ)
    e_multiplier #(
        .WORDS(WORDS)
    ) multiplier_inst (
        .in_a(data),
        .in_b(data),
        .product(mul_out)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            done <= 0;
            count <= 0;
            for (i = 0; i < WORDS; i = i + 1) begin
                data[i] <= 16'd0;
                out_data[i] <= 16'd0;
            end
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        for (i = 0; i < WORDS; i = i + 1) begin
                            data[i] <= in_data[i];
                        end
                        count <= 0;
                        state <= CALC;
                    end
                end

                CALC: begin
                    // 計算開始
                    for (i = 0; i < WORDS; i = i + 1) begin
                        data[i] <= mul_out[i];
                    end
                    count <= count + 1;
                    if (count == 15) begin // log2(32768) = 15
                        state <= DONE;
                    end
                end

                DONE: begin
                    done <= 1;
                    for (i = 0; i < WORDS; i = i + 1) begin
                        out_data[i] <= data[i];
                    end
                    state <= IDLE; // 必要ならここでIDLEに戻る
                end
            endcase
        end
    end

endmodule

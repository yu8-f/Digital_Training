module e_calc #(
    parameter int WORDS = 32,
    parameter int N = 32768,  // n=2^15
    parameter int LOG2_N = 15  // n=2^15
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    output logic done,
    output logic [15:0] result [0:WORDS-1]
);

    // 入力初期値：(1 + 1/n)
    logic [15:0] one_plus_inv_n [0:WORDS-1];

    logic square_done;
    logic [15:0] square_out [0:WORDS-1];

    logic multi_done;
    logic [15:0] multi_out [0:WORDS-1];

    typedef enum logic [1:0] {
        IDLE,
        SQUARE,
        MULTIPLY_N,
        DONE
    } state_t;
    state_t state, next_state;

    // ----------------------------
    // ステートマシン
    // ----------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: if (start) next_state = SQUARE;
            SQUARE: if (square_done) next_state = MULTIPLY_N;
            MULTIPLY_N: if (multi_done) next_state = DONE;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // ----------------------------
    // データパス
    // ----------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < WORDS; i++) begin
                one_plus_inv_n[i] <= 16'd0;
            end
        end else if (state == IDLE && start) begin
            for (int i = 0; i < WORDS; i++) begin
                if (i == 0) begin
                    one_plus_inv_n[i] <= 16'd1;  // 下位16ビット
                end else if (i == 1) begin
                    one_plus_inv_n[i] <= 16'd1;  // 次の16ビット
                end else begin
                    one_plus_inv_n[i] <= 16'd0;  // 残りは0
                end
            end
        end
    end

    // ----------------------------
    // スタートパルス生成
    // ----------------------------
    logic state_was_square;
    logic start_square_pulse;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_was_square <= 1'b0;
        end else begin
            state_was_square <= (state == SQUARE);
        end
    end

    assign start_square_pulse = (state == SQUARE) && !state_was_square;

    logic state_was_multiply;
    logic start_multiply_pulse;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_was_multiply <= 1'b0;
        end else begin
            state_was_multiply <= (state == MULTIPLY_N);
        end
    end

    assign start_multiply_pulse = (state == MULTIPLY_N) && !state_was_multiply;

    // ----------------------------
    // (1+1/n)^n を計算するインスタンス
    // ----------------------------
    e_calc_square #(
        .WORDS(WORDS),
        .LOG2_N(LOG2_N)
    ) squarer (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_square_pulse),
        .in_data(one_plus_inv_n),
        .done(square_done),
        .out_data(square_out)
    );

    // ----------------------------
    // それにnをかけるインスタンス
    // ----------------------------
    e_multi #(
        .WORDS(WORDS)
    ) multiplier (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_multiply_pulse),
        .A(square_out),
        .B(one_plus_inv_n),  // ここBに"n"をかけるイメージ
        .done(multi_done),
        .product(multi_out)
    );

    assign result = multi_out;
    assign done = (state == DONE);

endmodule

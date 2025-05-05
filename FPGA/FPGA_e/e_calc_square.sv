module e_calc_square #(
    parameter int WORDS = 32,
    parameter int LOG2_N = 15  // 2^15回二乗する（例）
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [15:0] in_data [0:WORDS-1],
    output logic done,
    output logic [15:0] out_data [0:WORDS-1]
);

    // 内部信号
    logic [15:0] buffer [0:WORDS-1];
    logic [3:0] count;
    logic multi_start;
    logic multi_done;
    logic [15:0] multi_out [0:WORDS-1];

    typedef enum logic [1:0] {
        IDLE,
        RUN,
        WAIT_MULTI,
        DONE
    } state_t;
    state_t state, next_state;

    // インスタンス：乗算器
    e_multi #(
        .WORDS(WORDS)
    ) multiplier (
        .clk(clk),
        .rst_n(rst_n),
        .start(multi_start),
        .A(buffer),
        .B(buffer),
        .done(multi_done),
        .product(multi_out)
    );

    // ステートマシン
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: if (start) next_state = RUN;
            RUN: next_state = WAIT_MULTI;
            WAIT_MULTI: if (multi_done) next_state = (count == LOG2_N-1) ? DONE : RUN;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // ロジック
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
            multi_start <= 0;
            for (int i = 0; i < WORDS; i++) begin
                buffer[i] <= 0;
            end
        end else begin
            case (state)
                IDLE: begin
                    count <= 0;
                    multi_start <= 0;
                    for (int i = 0; i < WORDS; i++) begin
                        buffer[i] <= in_data[i];
                    end
                end
                RUN: begin
                    multi_start <= 1;  // 乗算開始
                end
                WAIT_MULTI: begin
                    multi_start <= 0;
                    if (multi_done) begin
                        count <= count + 1;
                        for (int i = 0; i < WORDS; i++) begin
                            buffer[i] <= multi_out[i];
                        end
                    end
                end
                DONE: begin
                    // 何もしない
                end
            endcase
        end
    end

    assign done = (state == DONE);
    assign out_data = buffer;

endmodule

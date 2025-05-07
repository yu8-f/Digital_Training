module fixed_to_real #(
    parameter int WORDS = 32
)(
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [15:0] fixed_data [0:WORDS-1],
    output logic done,
    output real value
);

    localparam int TOTAL_BITS = WORDS * 16;

    logic [TOTAL_BITS-1:0] fixed_concat;
    logic [5:0] bit_idx; // 0～(TOTAL_BITS-3)まで数える
    real acc;            // 累積結果
    real frac_weight;    // 2^-1, 2^-2, ... の重み

    typedef enum logic [1:0] {
        IDLE,
        CONVERT,
        DONE_STATE
    } state_t;
    state_t state, next_state;

    // 配列を連結
    always_comb begin
        fixed_concat = '0;
        for (int i = 0; i < WORDS; i++) begin
            fixed_concat[TOTAL_BITS-1-i*16 -: 16] = fixed_data[i];
        end
    end

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
            IDLE: if (start) next_state = CONVERT;
            CONVERT: if (bit_idx == TOTAL_BITS-3) next_state = DONE_STATE;
            DONE_STATE: next_state = DONE_STATE;
            default: next_state = IDLE;
        endcase
    end

    // 変換処理
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 0.0;
            frac_weight <= 0.5;  // 2^-1
            bit_idx <= 0;
        end else begin
            case (state)
                IDLE: begin
                    acc <= 2.0;  // 最上位の「10」= 2
                    frac_weight <= 0.5;
                    bit_idx <= 0;
                end
                CONVERT: begin
                    if (fixed_concat[TOTAL_BITS-3 - bit_idx]) begin
                        acc <= acc + frac_weight;
                    end
                    frac_weight <= frac_weight / 2.0;
                    bit_idx <= bit_idx + 1;
                end
                DONE_STATE: begin
                    // stay
                end
            endcase
        end
    end

    assign value = acc;
    assign done = (state == DONE_STATE);

endmodule

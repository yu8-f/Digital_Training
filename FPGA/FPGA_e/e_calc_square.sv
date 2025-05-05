module e_calc_square #(
    parameter WORDS = 32,
    parameter LOG2_N = 15
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    output logic done,
    output logic [16*WORDS-1:0] out_data
);

    typedef enum logic [1:0] {
        IDLE,
        RUN,
        WAIT_MULTI,
        DONE
    } state_t;

    state_t state, next_state;
    logic [16*WORDS-1:0] result;
    logic [16*2*WORDS-1:0] multi_out;
    logic multi_start;
    logic multi_done;
    logic [15:0] one_word;
    integer count;

    e_multi #(
        .WORDS(WORDS)
    ) u_multi (
        .in_a(result),
        .in_b(result),
        .out_data(multi_out)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 0;
            result <= 0;
        end else begin
            state <= next_state;
            if (state == RUN && next_state == WAIT_MULTI) begin
                count <= count + 1;
            end
            if (state == IDLE && start) begin
                // 初期値 (1 + 1/n)
                result <= { {(WORDS-2){16'd0}}, 16'd1, 16'd1 };
                count <= 0;
            end else if (state == WAIT_MULTI && multi_done) begin
                result <= multi_out[16*WORDS-1:0];
            end
        end
    end

    always_comb begin
        next_state = state;
        multi_start = 0;
        case (state)
            IDLE: if (start) next_state = RUN;
            RUN: begin
                multi_start = 1;
                next_state = WAIT_MULTI;
            end
            WAIT_MULTI: if (multi_done) next_state = (count == LOG2_N-1) ? DONE : RUN;
            DONE: next_state = DONE;
        endcase
    end

    assign done = (state == DONE);
    assign out_data = result;

endmodule

module e_multi #(
    parameter int WORDS = 32
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [15:0] A [0:WORDS-1],
    input  logic [15:0] B [0:WORDS-1],
    output logic done,
    output logic [15:0] product [0:WORDS-1]
);

    // 内部レジスタ
    logic [31:0] temp [0:2*WORDS-1];
    int i, j;
    logic calc_running;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            calc_running <= 0;
            done <= 0;
            i <= 0;
            j <= 0;
            for (int k = 0; k < 2*WORDS; k++) begin
                temp[k] <= 32'd0;
            end
        end else begin
            if (start && !calc_running) begin
                // 計算開始
                calc_running <= 1;
                done <= 0;
                i <= 0;
                j <= 0;
                for (int k = 0; k < 2*WORDS; k++) begin
                    temp[k] <= 32'd0;
                end
            end else if (calc_running) begin
                // 1クロックで1個だけ掛け算して加算
                temp[i+j] <= temp[i+j] + (A[i] * B[j]);

                if (j == WORDS-1) begin
                    j <= 0;
                    if (i == WORDS-1) begin
                        // 全部終わった
                        calc_running <= 0;
                        done <= 1;
                    end else begin
                        i <= i + 1;
                    end
                end else begin
                    j <= j + 1;
                end
            end else begin
                done <= 0; // 1サイクルだけdone=1にする
            end
        end
    end

    // 繰り上がり処理（後段で別モジュールにしてもいい）
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int k = 0; k < 2*WORDS-1; k++) begin
                temp[k] <= 32'd0;
            end
        end else if (done) begin
            for (int k = 0; k < 2*WORDS-1; k++) begin
                temp[k+1] <= temp[k+1] + (temp[k] >> 16);
                temp[k] <= temp[k] & 16'hFFFF;
            end
        end
    end

    // 出力
    genvar gi;
    generate
        for (gi = 0; gi < WORDS; gi++) begin
            assign product[gi] = temp[gi][15:0];
        end
    endgenerate

endmodule

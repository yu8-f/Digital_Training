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
    integer i, j;
    logic calc_done;
    logic calc_running;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            calc_done <= 0;
            calc_running <= 0;
            for (i = 0; i < 2*WORDS; i++) begin
                temp[i] <= 32'd0;
            end
        end else begin
            if (start && !calc_running) begin
                // 計算開始
                calc_running <= 1;
                calc_done <= 0;

                // 掛け算（多倍長）
                for (i = 0; i < WORDS; i++) begin
                    for (j = 0; j < WORDS; j++) begin
                        temp[i+j] <= temp[i+j] + (A[i] * B[j]);
                    end
                end
            end else if (calc_running) begin
                // 繰り上がり処理
                for (i = 0; i < 2*WORDS-1; i++) begin
                    temp[i+1] <= temp[i+1] + (temp[i] >> 16);
                    temp[i] <= temp[i] & 16'hFFFF;
                end
                calc_done <= 1;
                calc_running <= 0;
            end
        end
    end

    // 出力
    assign done = calc_done;

    genvar gi;
    generate
        for (gi = 0; gi < WORDS; gi++) begin
            assign product[gi] = temp[gi][15:0];
        end
    endgenerate

endmodule
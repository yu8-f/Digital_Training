module e_calc #(
    parameter WORDS = 32,
    parameter N = 32768 // n = 2^15
)(
    input wire clk,
    input wire rst_n,
    input wire start,
    output wire done,
    output wire [15:0] out_data [0:WORDS-1]
);

    // 初期値を持つレジスタ
    reg [15:0] in_data [0:WORDS-1];

    // スタート信号を内部保持
    reg start_calc;

    // 初期化制御用
    reg init_done;
    integer i;

    // e_calc_squareの出力を受け取る用
    wire [15:0] square_out_data [0:WORDS-1];
    wire square_done;

    // -------------------------------
    // 初期化部分
    // -------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            init_done <= 0;
            start_calc <= 0;
            for (i = 0; i < WORDS; i = i + 1) begin
                in_data[i] <= 16'd0;
            end
        end else begin
            if (start && !init_done) begin
                // (1 + 1/n) を作る
                for (i = 0; i < WORDS; i = i + 1) begin
                    in_data[i] <= 16'd0;
                end
                in_data[0] <= 16'd1;                // 整数部「1」
                in_data[1] <= 16'd(65536 / N);       // 小数部「1/N」
                init_done <= 1;
                start_calc <= 1;
            end else begin
                start_calc <= 0;
            end
        end
    end

    // -------------------------------
    // 計算モジュールインスタンス
    // -------------------------------
    e_calc_square #(
        .WORDS(WORDS)
    ) calc_square_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_calc),
        .in_data(in_data),
        .done(square_done),
        .out_data(square_out_data)
    );

    // 出力はそのまま渡す
    assign done = square_done;
    genvar gi;
    generate
        for (gi = 0; gi < WORDS; gi = gi + 1) begin
            assign out_data[gi] = square_out_data[gi];
        end
    endgenerate

endmodule

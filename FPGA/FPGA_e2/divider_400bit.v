module divider_400bit (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [399:0] dividend,
    input wire [7:0] divisor,
    output reg [399:0] quotient,
    output reg done
);

    reg [7:0] residue;    // 前回のあまり
    reg [5:0] index;       // 0〜49のインデックス (6bitあればOK)
    reg working;           // 演算中フラグ
    reg [15:0] current;    // 16bit作るためのレジスタ

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 400'd0;
            residue <= 8'd0;
            index <= 0;
            working <= 0;
            done <= 0;
        end else begin
            if (start && !working) begin
                // スタート時の初期化
                quotient <= 400'd0;
                residue <= 8'd0;
                index <= 0;
                working <= 1;
                done <= 0;
            end else if (working) begin
                // 16bit作る (あまり8bit + dividendの上位8bit)
                current = {residue, dividend[399 - 8*index -: 8]};
                // 16bit / 8bit の除算
                quotient[399 - 8*index -: 8] <= current / divisor;
                residue <= current % divisor;  // 次回のためにあまりを保存

                if (index == 49) begin
                    working <= 0;
                    done <= 1;
                end else begin
                    index <= index + 1;
                end
            end
        end
    end

endmodule

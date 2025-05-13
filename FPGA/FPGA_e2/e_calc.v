`timescale 1ns / 1ps

module e_calc (
    input wire clk,
    input wire rst,
    input wire start,
    output reg done,
    output reg [399:0] ans
);

    reg [399:0] dividend;
    reg [7:0] divisor;
    reg [7:0] counter;
    reg div_start, add_start;

    wire div_done, add_done;
    wire [399:0] quotient;
    wire [399:0] add_result;

    // 初期値モジュールのインスタンス
    wire [399:0] init_ans;

    init_400bit init_inst (
        .ans(init_ans)
    );

    // DividerとAdderのインスタンス（既に作ったやつを使う）
    divider_400bit div_inst (
        .clk(clk),
        .rst(rst),
        .start(div_start),
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .done(div_done)
    );

    adder_400bit add_inst (
        .clk(clk),
        .rst(rst),
        .start(add_start),
        .a(ans),
        .b(quotient),
        .sum(add_result),
        .done(add_done)
    );

    // 状態管理用
    reg [1:0] state;
    localparam IDLE = 2'd0, DIVIDE = 2'd1, ADD = 2'd2, FINISH = 2'd3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            ans <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    ans <= init_ans;
                    dividend <= init_ans;
                    divisor <= 8'h01;
                    counter <= 8'd1;
                    div_start <= 1;
                    add_start <= 0;
                    state <= DIVIDE;
                end

                DIVIDE: begin
                    div_start <= 0;
                    if (div_done) begin
                        add_start <= 1;
                        state <= ADD;
                    end
                end

                ADD: begin
                    add_start <= 0;
                    if (add_done) begin
                        ans <= add_result;  // 加算結果を保存
                        if (counter == 8'd70) begin
                            done <= 1;
                            state <= FINISH;
                        end else begin
                            dividend <= quotient;  // 前回の商が次の割り算の被除数
                            divisor <= counter + 8'd1;
                            counter <= counter + 8'd1;
                            div_start <= 1;
                            state <= DIVIDE;
                        end
                    end
                end

                FINISH: begin
                    done <= 1;
                    state <= FINISH;  // 完了状態
                end

            endcase
        end
        // $display("STATE = %d", state);
        // $display("div_done = %b, add_done = %b, counter = %d", div_done, add_done, counter);
    end

endmodule

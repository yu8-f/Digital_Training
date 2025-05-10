// adder 400bit
// 8bit + 8bitの加算器，多倍長により400bitまで加算していく

`timescale 1ns / 1ps

module adder_400bit (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [399:0] a_flat,
    input wire [399:0] b_flat,
    output reg [399:0] sum_flat,
    output reg done
);

    reg carry;   // ★たった1bitだけ！
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            sum_flat <= 0;
            done <= 0;
        end else if (start) begin
            carry = 0;
            for (i = 0; i < 50; i = i + 1) begin
                {carry, sum_flat[i*8 +: 8]} <= a_flat[i*8 +: 8] + b_flat[i*8 +: 8] + carry;
            end
            done <= 1;
        end else begin
            done <= 0;
        end
    end

endmodule
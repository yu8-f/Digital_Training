`timescale 1ns / 1ps

module adder_400bit (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [399:0] a,
    input wire [399:0] b,
    output reg [399:0] sum,
    output reg done
);

    reg [7:0] temp_sum;
    reg carry;
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            sum <= 0;
            done <= 0;
        end else if (start) begin
            carry = 0;
            for (i = 0; i < 50; i = i + 1) begin
                {carry, temp_sum} = a[i*8 +: 8] + b[i*8 +: 8] + carry;
                sum[i*8 +: 8] <= temp_sum;
            end
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule

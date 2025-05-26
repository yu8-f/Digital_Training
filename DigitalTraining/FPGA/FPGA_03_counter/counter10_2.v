// counter10

module counter10_2(CLK, RST, CNT); // module name and ports

    input CLK, RST; // inputs: clock, reset, data
    output reg [3:0] CNT; // 4-bit output signal

    always @(posedge CLK or negedge RST) begin // on rising edge of clock or reset
        if (RST == 1'b0) begin
            CNT <= 4'h0;
        end else begin
            if (CNT == 4'hc) begin
                CNT <= 4'h0; // reset to 0 if input is not in the range
            end else begin
                CNT <= CNT + 4'h1; // increment the value of CNT
            end
        end
    end

endmodule
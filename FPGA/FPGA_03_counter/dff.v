// D-flipflop

module dff(CLK, RST, D, Q);

    input CLK, RST, D; // inputs: clock, reset, data
    output Q; // output: data output
    reg Q; // output is declared as a register
    // Q is set as reg because DFF refer to the previous value of Q

    always @(posedge CLK or negedge RST) begin // on rising edge of clock or reset
        if (RST == 1'b0) begin
            Q <= 1'b0; // you can assign 1'b0 because Q is reg
        end else begin
            Q <= D;
        end
    end

endmodule
module e_multi #(
    parameter WORDS = 32
)(
    input  logic [16*WORDS-1:0] in_a,
    input  logic [16*WORDS-1:0] in_b,
    output logic [16*2*WORDS-1:0] out_data
);

    logic [31:0] temp [2*WORDS-1:0];
    logic [15:0] a [WORDS-1:0];
    logic [15:0] b [WORDS-1:0];

    integer i;

    always_comb begin
        for (i = 0; i < WORDS; i++) begin
            a[i] = in_a[i*16 +: 16];
            b[i] = in_b[i*16 +: 16];
        end

        for (i = 0; i < 2*WORDS; i++) begin
            temp[i] = 0;
        end

        for (i = 0; i < WORDS; i++) begin
            temp[i] = a[i] * b[0];
        end

        for (int j = 1; j < WORDS; j++) begin
            for (i = 0; i < WORDS; i++) begin
                temp[i+j] += a[i] * b[j];
            end
        end

        for (i = 0; i < 2*WORDS-1; i++) begin
            temp[i+1] += temp[i] >> 16;
            temp[i] &= 16'hFFFF;
        end
        temp[2*WORDS-1] &= 16'hFFFF;

        for (i = 0; i < 2*WORDS; i++) begin
            out_data[i*16 +: 16] = temp[i][15:0];
        end
    end

endmodule

`define SEG_OUT_0 7'b011_1111
`define SEG_OUT_1 7'b000_0110
`define SEG_OUT_2 7'b101_1011
`define SEG_OUT_3 7'b100_1111
`define SEG_OUT_4 7'b110_0110
`define SEG_OUT_5 7'b110_1101
`define SEG_OUT_6 7'b111_1101
`define SEG_OUT_7 7'b010_0111
`define SEG_OUT_8 7'b111_1111
`define SEG_OUT_9 7'b110_1111
`define SEG_OUT_A 7'b111_0111
`define SEG_OUT_B 7'b111_1100
`define SEG_OUT_C 7'b011_1001
`define SEG_OUT_D 7'b101_1110
`define SEG_OUT_E 7'b111_1001
`define SEG_OUT_F 7'b111_0001

module SEG_HEX (
    //////////////////// 4 Binary bits Input ////////////////////
    iDIG,
    //////////////////// HEX 7-SEG Output ////////////////////
    oHEX_D
    );

    input [3:0] iDIG;
    output [6:0] oHEX_D;
    reg [6:0] oHEX_D;

    always @(iDIG) begin
        case(iDIG)
            4'h0: oHEX_D <= ~(`SEG_OUT_0);
            4'h1: oHEX_D <= ~(`SEG_OUT_1);
            4'h2: oHEX_D <= ~(`SEG_OUT_2);
            4'h3: oHEX_D <= ~(`SEG_OUT_3);
            4'h4: oHEX_D <= ~(`SEG_OUT_4);
            4'h5: oHEX_D <= ~(`SEG_OUT_5);
            4'h6: oHEX_D <= ~(`SEG_OUT_6);
            4'h7: oHEX_D <= ~(`SEG_OUT_7);
            4'h8: oHEX_D <= ~(`SEG_OUT_8);
            4'h9: oHEX_D <= ~(`SEG_OUT_9);
            4'ha: oHEX_D <= ~(`SEG_OUT_A);
            4'hb: oHEX_D <= ~(`SEG_OUT_B);
            4'hc: oHEX_D <= ~(`SEG_OUT_C);
            4'hd: oHEX_D <= ~(`SEG_OUT_D);
            4'he: oHEX_D <= ~(`SEG_OUT_E);
            4'hf: oHEX_D <= ~(`SEG_OUT_F);
            default: oHEX_D <= ~(`SEG_OUT_0);
        endcase
    end
endmodule
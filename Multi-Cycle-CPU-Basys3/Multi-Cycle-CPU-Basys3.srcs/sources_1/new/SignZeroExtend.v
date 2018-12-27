`timescale 1ns / 1ps

module SZE(
    input ExtSel,
    input [15:0] Origin,
    output [31:0] Extended
);

    assign Extended[15:0] = Origin[15:0];
    assign Extended[31:16] = (ExtSel && Origin[15]) ? 16'hffff : 16'h0000;

endmodule
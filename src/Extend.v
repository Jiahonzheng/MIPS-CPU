`timescale 1ns / 1ps
`include "Constants.v"

module Extend(
  input [15:0] Immediate16,
  input ExtSel,
  output [31:0] Immediate32
);

  assign Immediate32[15:0] = Immediate16[15:0];
  assign Immediate32[31:16] = (ExtSel && Immediate16[15]) ? 16'hFFFF : 16'h0000;

endmodule
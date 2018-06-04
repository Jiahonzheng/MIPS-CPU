`timescale 1ns / 1ps
`include "Constants.v"

module Extend(
  input [15:0] Immediate,
  input ExtSel,
  output [31:0] ExtImmediate
);

  assign ExtImmediate[15:0] = Immediate[15:0];
  assign ExtImmediate[31:16] = (ExtSel && Immediate[15]) ? 16'hFFFF : 16'h0000;

endmodule
`timescale 1ns / 1ps

module DataMemory(
  input CLK,
  input [31:0] Daddr,
  input [31:0] DataIn,
  output [31:0] DataOut,
  input RD,
  input WR
);

  reg [7:0] RAM [0:60];

  assign DataOut[7:0] = RD ? RAM[Daddr + 3] : 8'bz;
  assign DataOut[15:8] = RD ? RAM[Daddr + 2] : 8'bz;
  assign DataOut[23:16] = RD ? RAM[Daddr + 1] : 8'bz;
  assign DataOut[31:24] = RD ? RAM[Daddr] : 8'bz;

  always@(negedge CLK) begin
    if (WR) begin
      RAM[Daddr] <= DataIn[31:24];
      RAM[Daddr + 1] <= DataIn[23:16];
      RAM[Daddr + 2] <= DataIn[15:8];
      RAM[Daddr + 3] <= DataIn[7:0];
    end
  end

endmodule
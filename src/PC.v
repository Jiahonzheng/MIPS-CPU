`timescale 1ns / 1ps
`include "Constants.v"

module PC(
  input CLK,
  input Reset,
  input PCWre,
  input [31:0] NextPC, 
  output reg [31:0] Address
);

  initial begin
    Address = 0;
  end

  always@(posedge CLK or negedge Reset) begin
    pc <= (Reset ? NextPC : 0);
  end

endmodule
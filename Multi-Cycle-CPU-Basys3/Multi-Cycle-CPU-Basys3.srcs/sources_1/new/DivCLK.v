`timescale 1ns / 1ps

module ClockDiv(
  input originClock,
  output divClock
  );

  reg [16:0] counter;

  always @(posedge originClock) begin
    counter <= counter + 1;
  end

  assign divClock = counter[16];
endmodule
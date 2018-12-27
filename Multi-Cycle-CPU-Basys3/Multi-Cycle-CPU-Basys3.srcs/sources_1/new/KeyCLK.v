`timescale 1ns / 1ps

module KeyClock(
  input CLK,
  input Key_Pressed,
  output reg CPU_CLK
  );

  always @(posedge CLK) begin
    if (Key_Pressed) begin
      CPU_CLK <= 0;
    end else begin
      CPU_CLK <= 1;
    end
  end
endmodule
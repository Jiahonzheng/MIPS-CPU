`timescale 1ns / 1ps

module KeyCLK(
  input CLK,
  input KeyPressed,
  output reg CPU_CLK
);

  always @(posedge CLK) begin
    if (KeyPressed) begin
      CPU_CLK <= 0;
    end else begin
      CPU_CLK <= 1;
    end
  end

endmodule
`timescale 1ns/1ps

module Main_tb();
  reg CLK = 1;
  reg Reset = 1;

  always begin
    #5;
    CLK = ~CLK;
  end

  initial begin
    #1;
    Reset = 0;
    #1;
    Reset = 1;
  end
  
  CPU CPU(
    .CLK(CLK),
    .Reset(Reset)
  );

endmodule
`timescale 1ns/1ps

module InstructionMemory(
  input [31:0] Address,
  output reg [31:0] Ins
);

  reg [7:0] rom [0:99];
  
  initial begin
    $readmemh ("D:/Users/Documents/Code/Single-Cycle-CPU/Data/ROM.txt", rom);
  end
    
  always@(*) begin
    Ins[31:24] = rom[Address];
    Ins[23:16] = rom[Address + 1];
    Ins[15:8] = rom[Address + 2];
    Ins[7:0] = rom[Address + 3];
  end

endmodule
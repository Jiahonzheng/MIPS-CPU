`timescale 1ns/1ps

module InstructionMemory(
  input [31:0] Address,
  output reg [31:0] Ins
);

  reg [7:0] ROM [0:99];

  // Here, you should replace my file path as your own Instruction machine code's
  // location. And you must use the absolute path.
  initial begin
    $readmemh ("D:/Users/Documents/Code/Single-Cycle-CPU/Data/ROM.txt", ROM);
  end
  
  // MIPS Architecture uses the Big-Endian order.
  always@(*) begin
    Ins[31:24] = ROM[Address];
    Ins[23:16] = ROM[Address + 1];
    Ins[15:8] = ROM[Address + 2];
    Ins[7:0] = ROM[Address + 3];
  end

endmodule
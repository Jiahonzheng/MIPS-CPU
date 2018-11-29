`timescale 1ns/1ps

module InstructionMemory(
  input [31:0] Iaddr,
  input [31:0] IDataIn,
  input RW,
  output reg [31:0] IDataOut
);

  reg [7:0] ROM [0:99];

  // Here, you should replace my file path as your own Instruction machine code's
  // location. And you must use the absolute path. Notice the slash characters
  // in the path.
  initial begin
    $readmemh ("E:/Users/Code/MIPS-CPU/Single-Cycle-CPU-Vivado-ECOP-02/data/ROM.txt", ROM);
  end

  // MIPS Architecture uses the Big-Endian order.
  always@(*) begin
    IDataOut[31:24] = ROM[Iaddr];
    IDataOut[23:16] = ROM[Iaddr + 1];
    IDataOut[15:8] = ROM[Iaddr + 2];
    IDataOut[7:0] = ROM[Iaddr + 3];
  end

endmodule
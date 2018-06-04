`timescale 1ns / 1ps

/* Instruction formats
 * Instructions are divided into three types: R, I and J. Every instruction
 * starts with a 6-bit opcode. In addition to the opcode, R-type instructions
 * specify three registers, a shift amount field, and a function field; I-type
 * instructions specify two registers and a 16-bit immediate value; J-type 
 * instructions follow the opcode with a 26-bit jump target.
 * 
 * https://en.wikipedia.org/wiki/MIPS_architecture#Instruction_formats
 */

module Decoder(
  input [31:0] Ins,
  output [5:0] Opcode,
  output [5:0] Funct,
  output [4:0] Shamt,
  output [4:0] rs,
  output [4:0] rt,
  output [4:0] rd,
  output [15:0] Immediate,
  output [25:0] Address
);

  assign Opcode = Ins[31:26];
  assign Funct = Ins[5:0];
  assign Shamt = Ins[10:6];
  assign rs = Ins[25:21];
  assign rt = Ins[20:16];
  assign rd = Ins[15:11];
  assign Immediate = Ins[15:0];
  assign Address = Ins[25:0];

endmodule
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
  input [31:0] ins,
  output [5:0] opcode,
  output [5:0] funct,
  output [4:0] shamt,
  output [4:0] rs,
  output [4:0] rt,
  output [4:0] rd,
  output [15:0] immediate,
  output [25:0] address
);

  assign opcode = ins[31:26];
  assign funct = ins[5:0];
  assign shamt =ins[10:6];
  assign rs = ins[25:21];
  assign rt = ins[20:16];
  assign rd = ins[15:11];
  assign immediate = ins[15:0];
  assign address = ins[25:0];

endmodule
`timescale 1ns / 1ps
`include "Constants.v"

module CU(
  input [5:0] Opcode,
  input [5:0] Funct,
  input Zero,
  input Sign,
  output PCWre,
  output ALUSrcA,
  output reg ALUSrcB,
  output DBDataSrc,
  output reg RegWre,
  output InsMemRW,
  output mRD,
  output mWR,
  output RegDst,
  output ExtSel,
  output reg [1:0] PCSrc,
  output reg [2:0] ALUOp
);

  // PCWre
  assign PCWre = Opcode == `OP_HALT ? 0 : 1;

  // ALUSrcA
  assign ALUSrcA = Opcode == `OP_SLL ? `ALU_FROM_SA : `ALU_FROM_DATA;

  // ALUSrcB
  always@(*) begin
    case(Opcode)
      `OP_ADDIU, `OP_LW, `OP_SW, `OP_ORI, `OP_SLTI, `OP_ANDI: ALUSrcB = `ALU_FROM_IMMD;
      default: ALUSrcB = `ALU_FROM_DATA;
    endcase
  end

  // DBDataSrc
  assign DBDataSrc = Opcode == `OP_LW ? `REG_FROM_DATAMEMORY : `REG_FROM_ALU;

  // RegWre
  always@(*) begin
    case(Opcode)
      `OP_SW, `OP_BEQ, `OP_BNE, `OP_BLTZ, `OP_J, `OP_HALT: RegWre = 0;
      default: RegWre = 1;
    endcase
  end

  // InsMemRW
  assign InsMemRW = 1;

  // mRD
  assign mRD = Opcode == `OP_LW ? 1 : 0;

  // mWR
  assign mWR = Opcode == `OP_SW ? 1 : 0;

  // RegDst
  assign RegDst = Opcode == `OP_LW || Opcode == `OP_ADDIU || Opcode == `OP_ORI || Opcode == `OP_ANDI || Opcode == `OP_SLTI ? `REG_FROM_RT : `REG_FROM_RD;

  // ExtSel
  assign ExtSel = Opcode == `OP_ANDI || Opcode == `OP_ORI ? `EXT_ZERO : `EXT_SIGN;

  // PCSrc
  always@(*) begin
    case(Opcode)
      `OP_BEQ: PCSrc = Zero == 1 ? `PC_REL_JMP : `PC_NEXT_INS;
      `OP_BNE: PCSrc = Zero == 1 ? `PC_NEXT_INS : `PC_REL_JMP;
      `OP_BLTZ: PCSrc = Sign == 1 ? `PC_REL_JMP : `PC_NEXT_INS;
      `OP_J: PCSrc = `PC_ABS_JMP;
      `OP_HALT: PCSrc = `PC_HALT;
      default: PCSrc = `PC_NEXT_INS;
    endcase
  end

  // ALUOp
  always@(*) begin
    case(Opcode)
      `OP_ADD, `OP_ADDIU, `OP_SW, `OP_LW: ALUOp = `ALU_ADD;
      `OP_AND, `OP_ANDI: ALUOp = `ALU_AND;
      `OP_OR, `OP_ORI: ALUOp = `ALU_OR;
      `OP_SLL: ALUOp = `ALU_SLL;
      `OP_SLTI: ALUOp = `ALU_CMPS;
      `OP_SUB, `OP_BEQ, `OP_BNE, `OP_BLTZ: ALUOp= `ALU_SUB;
      default: ALUOp = `ALU_ADD;
    endcase
  end

endmodule
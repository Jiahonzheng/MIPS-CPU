`timescale 1ns / 1ps
`include "head.v"

module CU(
  input [5:0] Opcode,
  input [5:0] Funct,
  input Zero,
  input Sign,
  output ALUSrcA,
  output RegDst,
  output DB,
  output ExtSel,
  output nRD,
  output, nWR,
  output reg ALUSrcB,
  output reg RegWre,
  output reg [1:0] PCSel,
  output reg [2:0] ALUOp,
);

  // ALUSrcA
  assign ALUSrcA = (Opcode == `OP_SLL && Funct == `FUNCT_SLL) ? `ALU_FROM_SA : `ALU_FROM_DATA;

  // ALUSrcB
  always@(*) begin
    case(Opcode)
      `OP_ADD, `OP_LW, `OP_SW, `OP_ORI: ALUSrcB = `ALU_FROM_IMMD;
      default: ALUSrcB = `ALU_FROM_DATA;
    endcase
  end

  // DB
  assign DB = (Opcode == `OP_LW) ? `DB_FROM_DM : `DB_FROM_ALU;

  // nRD
  assign nRD = (Opcode == `OP_LW) ? 0 : 1;
  
  // nWR
  assign nWR = (Opcode == `OP_SW) ? 0 : 1;
  
  // RegWre
  always@(*) begin
    case(Opcode)
      `OP_SW, `OP_BEQ, `OP_BNE, `OP_BGTZ, `OP_J, `OP_HALT: RegWre = 0;
      default: RegWre = 1;
    endcase
  end

  // RegDst
  assign RegDst = (Opcode == `OP_LW || Opcode == `OP_ADDI || Opcode == `OP_ORI) ? `REG_FROM_RT : `REG_FROM_RD;

  // ExtSel
  assign ExtSel = (Opcode == `OP_ORI) ? `EXT_ZERO : `EXT_SIGN;

  // PCSel
  always@(*) begin
    case(Opcode)
      `OP_BEQ: PCSel = Zero == 1 ? `PC_REL_JMP : `PC_NEXT_INS;
      `OP_BNE: PCSel = Zero == 1 ? `PC_NEXT_INS : `PC_REL_JMP;
      `OP_BGTZ: PCSel = (Sign == 0 && Zero == 0) ? `PC_REL_JMP : `PC_NEXT_INS;
      `OP_J: PCSel = `PC_ABS_JMP;
      `OP_HALT: PCSel = `PC_HALT;
      default: PCSel = `PC_NEXT_INS;
    endcase
  end

  // ALUOp
  always@(*) begin
    case(Opcode)
      `OP_R_DEV: begin
        case(Funct)
          `FUNCT_ADD: ALUOp = `ALU_ADD;
          `FUNCT_SUB: ALUOp = `ALU_SUB;
          `FUNCT_AND: ALUOp = `ALU_AND;
          `FUNCT_OR: ALUOp = `ALU_OR;
          `FUNCT_SLL: ALUOp = `ALU_SLL;
          `FUNCT_SLT: ALUOp = `ALU_SLT;
          // Perhaps, default case is not neccessary.
          // default: ALUOp = `ALU_ADD;
        endcase
      end
      `OP_ORI: ALUOp = `ALU_OR;
      `OP_BEQ, `OP_BNE, `OP_BGTZ: ALUOp = `ALU_SUB;
      default: ALUOp = `ALU_ADD;
    endcase
  end

endmodule
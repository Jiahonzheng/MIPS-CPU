`timescale 1ns / 1ps
`include "Constants.v"

module ALU(
  input [2:0] ALUOp,
  input [31:0] ReadData1,
  input [31:0] ReadData2,
  output reg [31:0] Result,
  output Zero,
  output Sign
);

  initial begin
    Result = 0;
  end

  assign Zero = Result == 0 ? 1 : 0;
  assign Sign = Result[31];

  always@(*) begin
    case(ALUOp)
      `ALU_ADD: Result = ReadData1 + ReadData2;
      `ALU_SUB: Result = ReadData1 - ReadData2;
      `ALU_AND: Result = ReadData1 & ReadData2;
      `ALU_OR: Result = ReadData1 | ReadData2;
      `ALU_SLL: Result = ReadData2 << ReadData1;
      `ALU_CMPU: Result = (ReadData1 < ReadData2) ? 1 : 0;
      `ALU_CMPS: Result = (((ReadData1 < ReadData2) && (ReadData1[31] == ReadData2[31])) || (ReadData1[31] == 1 && ReadData2[31] == 0)) ? 1 : 0;
      default: Result = 8'h00000000;
    endcase
  end

endmodule
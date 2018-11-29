`timescale 1ns / 1ps
`include "Constants.v"

module PC(
  input CLK,
  input Reset,
  input [31:0] NewPC,
  output reg [31:0] pc
);

  always@(posedge CLK or negedge Reset) begin
    pc <= Reset == 0 ? 0 : NewPC;
  end

endmodule

module PCHelper(
  input [31:0] pc,
  input [15:0] Immediate,
  input [25:0] Address,
  input [1:0] PCSrc,
  output reg [31:0] NewPC
);

  initial begin
    NewPC = 0;
  end

  // Extend 16-bit immediate value to 32-bit immediate value
  wire [31:0] ExtImmediate = {{16{Immediate[15]}}, Immediate};

  always@(*) begin
    case(PCSrc)
      `PC_NEXT_INS: NewPC <= pc + 4;
      `PC_REL_JMP: NewPC <= pc + 4 + (ExtImmediate << 2);
      `PC_ABS_JMP: NewPC <= {pc[31:28], Address, 2'b00};
      `PC_HALT: NewPC <= pc;
    endcase
  end

endmodule
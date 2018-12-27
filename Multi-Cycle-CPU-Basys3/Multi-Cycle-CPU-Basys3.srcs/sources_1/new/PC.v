`timescale 1ns / 1ps

module PC(
  input CLK,
  input RST,
  input PCWre,
  input [31:0] pc,
  output reg [31:0] IAddr = 0,
  output [31:0] PC4
);

  always @(posedge CLK or negedge RST) begin
    if (!RST) begin
      IAddr <= 0;
    end
    else if (PCWre) begin
      IAddr <= pc;
    end
  end

  assign PC4 = IAddr + 4;

endmodule

module PC_Source (
  input [31:0] PC4,
  input [31:0] PC_Brench,
  input [31:0] PC_JumpRigister,
  input [31:0] PC_Jump,
  input [1:0] PC_Src,
  output reg [31:0] pc
);

  always @(*) begin
    case(PC_Src)
      2'b00: pc <= PC4;
      2'b01: pc <= (PC_Brench << 2) + PC4;
      2'b10: pc <= PC_JumpRigister;
      2'b11: pc <= PC_Jump;
    endcase
  end

endmodule

module PC_Jumper (
  input [31:0] PC4,
  input [25:0] pc,
  output [31:0] PC_Jump
);

  assign PC_Jump[31:28] = PC4[31:28];
  assign PC_Jump[27:0] = pc << 2;

endmodule
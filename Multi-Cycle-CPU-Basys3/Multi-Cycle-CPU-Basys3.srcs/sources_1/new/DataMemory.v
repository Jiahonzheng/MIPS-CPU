`timescale 1ns / 1ps

module DM(
  input CLK,
  input RD,
  input WR,
  input DBDataSrc,
  input [31:0] result,
  input [31:0] DAddr,
  input [31:0] DataIn,
  output reg [31:0] DB
);

  wire [31:0] DataOut;
  reg [7:0] Data_Mem[0:127];
  integer i = 0;

  initial begin
    repeat(128) begin
        Data_Mem[i] = 0;
        i = i + 1;
    end
  end

  assign DataOut[7:0] = (RD) ? Data_Mem[DAddr + 3] : 8'bz;
  assign DataOut[15:8] = (RD) ? Data_Mem[DAddr + 2] : 8'bz;
  assign DataOut[23:16] = (RD) ? Data_Mem[DAddr + 1] : 8'bz;
  assign DataOut[31:24] = (RD) ? Data_Mem[DAddr] : 8'bz;

  always @(negedge CLK) begin
    if (WR) begin
      Data_Mem[DAddr] <= DataIn[31:24];
      Data_Mem[DAddr + 1] <= DataIn[23:16];
      Data_Mem[DAddr + 2] <= DataIn[15:8];
      Data_Mem[DAddr + 3] <= DataIn[7:0];
    end
  end

  always @(*) begin
    DB <= (DBDataSrc) ? DataOut : result;
  end

endmodule
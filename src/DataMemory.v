`timescale 1ns / 1ps

module DataMemory(
  input CLK,
  input [31:0] Address,
  input [31:0] WriteData,
  input MemRead,
  input MemWrite,
  output [31:0] ReadData
);

  reg [7:0] ram[0:60];

  assign ReadData[7:0] = MemRead == 0 ? ram[Address + 3] : 8'bz;
  assign ReadData[15:8] = MemRead == 0 ? ram[Address + 2] : 8'bz;
  assign ReadData[23:16] = MemRead == 0 ? ram[Address + 1] : 8'bz;
  assign ReadData[31:24] = MemRead == 0 ? ram[Address] : 8'bz;

  always@(negedge CLK) begin
    if (MemWrite == 0) begin
      ram[Address] <= WriteData[31:24];
      ram[Address + 1] <= WriteData[23:16];
      ram[Address + 2] <= WriteData[15:8];
      ram[Address + 3] <= WriteData[7:0];
    end
  end

endmodule
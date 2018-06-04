`timescale 1ns / 1ps

module RAM(
  input CLK,
  input [31:0] Address,
  input [31:0] WriteData,
  input nRD,
  input nWR,
  output [31:0] DataOut
);

  reg [7:0] ram[0:60];

  assign DataOut[7:0] = nRD == 0 ? ram[Address + 3] : 8'bz;
  assign DataOut[15:8] = nRD == 0 ?ram[Address + 2] : 8'bz;
  assign DataOut[23:16] = nRD == 0 ?ram[Address + 1] : 8'bz;
  assign DataOut[31:24] = nRD == 0 ?ram[Address] : 8'bz;

  always@(negedge CLK) begin
    if (nWR == 0) begin
      ram[Address] <= WriteData[31:24];
      ram[Address + 1] <= WriteData[23:16];
      ram[Address + 2] <= WriteData[15:8];
      ram[Address + 3] <= WriteData[7:0];
    end
  end

endmodule
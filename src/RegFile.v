`timescale 1ns / 1ps

module RegFile(
  input CLK,
  input Reset,
  input RegWrite,
  input [4:0] ReadReg1,
  input [4:0] ReadReg2,
  input [4:0] WriteReg,
  input [31:0] WriteData,
  output [31:0] ReadData1,
  output [31:0] ReadData2
);

  integer index;
  reg [31:0] regFile[1:31];

  assign ReadData1 = ReadReg1 == 0 ? 0 : regFile[ReadReg1];
  assign ReadData2 = ReadReg2 == 0 ? 0 : regFile[ReadReg2];

  always@(negedge CLK or negedge Reset) begin
    if (Reset == 0) begin
      // The for statement using here would increase unneccessary units'usage.
      // However, to make the code more developer-friendly, I used this kind 
      // of statement.
      for (index = 1; index < 32; index = index + 1) begin
        regFile[index] <= 0;
      end
    end
    else if (RegWrite == 1 && WriteReg != 0) begin
      regFile[WriteReg] <= WriteData;
    end
  end

endmodule
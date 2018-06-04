`timescale 1ns / 1ps

module RegFile(
  input CLK,
  input Reset,
  input RegWre,
  input [4:0] ReadReg1,
  input [4:0] ReadReg2,
  input [4:0] WriteReg,
  input [31:0] WriteData,
  output [31:0] ReadData1,
  output [31:0] ReadData2
);

  integer index;
  reg [31:0] regFile[1:31];

  assign ReadData1 = ReadData1 ? regFile[ReadReg1] : 0;
  assign ReadData2 = ReadData2 ? regFile[ReadReg2] : 0;

  always@(negedge CLK or negedge Reset) begin
    if (Reset == 0) begin
      for (index = 1; index < 32; index = index + 1) begin
        regFile[index] <= 0;
      end
    end
    else if (RegWre == 1 && WriteReg) begin
      regFile[WriteReg] <= WriteData;
    end
  end

endmodule
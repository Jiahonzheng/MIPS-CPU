`timescale 1ns / 1ps

module IM(
  input CLK,
  input [31:0] IAddr,
  input RW,
  input IRWre,
  output reg [31:0] IROut
);

  reg [7:0] Mem[0:127];
  reg [31:0] IDataOut;

  initial begin
    $readmemb("C:/Users/Jiahonzheng/Desktop/MIPS-CPU/Multi-Cycle-CPU-Vivado/data/instructions.txt", Mem);
  end

  always @(*) begin
    if (RW == 1) begin
      IDataOut[31:24] <= Mem[IAddr];
      IDataOut[23:16] <= Mem[IAddr + 1];
      IDataOut[15:8] <= Mem[IAddr + 2];
      IDataOut[7:0] <= Mem[IAddr + 3];
    end
  end

  always @(posedge CLK) begin
    if (IRWre == 1) begin
        IROut[31:0] <= IDataOut[31:0];
    end
  end

endmodule
`timescale 1ns / 1ps

module RF(
    input CLK,
    input WE,
    input WrRegDSrc,
    input [1:0] RegDst,
    input [4:0] RReg1,
    input [4:0] RReg2,
    input [4:0] rd,
    input [31:0] DB,
    input [31:0] PC4,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
);

    reg [4:0] WReg;
    wire [31:0] WriteData;

    always @(*) begin
        case(RegDst)
            2'b00:
                WReg <= 5'b11111;
            2'b01:
                WReg <= RReg2;
            2'b10:
                WReg <= rd;
        endcase
    end

    assign WriteData = (WrRegDSrc) ? DB : PC4;

    reg [31:0] Regs[0:31];

    integer i = 0;
    initial begin
      repeat(32) begin
        Regs[i] = 0;
        i = i + 1;
      end
    end

    always @(*) begin
        ReadData1 <= Regs[RReg1];
        ReadData2 <= Regs[RReg2];
    end

    always @(negedge CLK) begin
      if (WE) begin
        Regs[WReg] <= WriteData;
      end
    end

endmodule
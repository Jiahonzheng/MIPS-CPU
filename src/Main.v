`timescale 1ns / 1ps

module CPU(
  input Ori_CLK,
  input Key_CLK,
  input [1:0] status,
  input Reset,
  output [3:0] LED_Number,
  output [6:0] LED_Code
);

  wire CLK;
  wire Div_CLK;

  // Control Unit
  wire PCWre;
  wire ALUSrcA;
  wire ALUSrcB;
  wire MemToReg;
  wire WE;
  wire InsMemRW;
  wire RD;
  wire WR;
  wire RegDst;
  wire ExtSel;
  wire [1:0] PCSrc;
  wire [2:0] ALUOp;

  // PC
  wire [31:0] pc;
  wire [31:0] NewPC;

  // Instruction Memory
  wire [31:0] IDataIn;

  // Data Memory
  wire [31:0] RAMOut;

  // Register File
  wire [4:0] WriteReg;
  wire [31:0] RegWriteData;
  wire [31:0] RegReadData1;
  wire [31:0] RegReadData2;

  // ALU
  wire [31:0] ALUReadData1;
  wire [31:0] ALUReadData2;
  wire [31:0] ALUResult;
  wire Zero;
  wire Sign;

  // Size Zero Extend
  wire [31:0] ExtImmediate;

  // Instruction Structure
  wire [31:0] Ins;
  wire [5:0] Opcode;
  wire [5:0] Funct;
  wire [4:0] Shamt;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;
  wire [15:0] Immediate;
  wire [25:0] Address;

  // Decode Instruction
  assign Opcode = Ins[31:26];
  assign Funct = Ins[5:0];
  assign Shamt = Ins[10:6];
  assign rs = Ins[25:21];
  assign rt = Ins[20:16];
  assign rd = Ins[15:11];
  assign Immediate = Ins[15:0];
  assign Address = Ins[25:0];

  assign WriteReg = RegDst == `REG_FROM_RT ? rt : rd;
  assign RegWriteData = MemToReg == `REG_FROM_ALU ? ALUResult : RAMOut;

  assign ALUReadData1 = ALUSrcA == `ALU_FROM_DATA ? RegReadData1 : {{27{1'b0}}, Shamt};
  assign ALUReadData2 = ALUSrcB == `ALU_FROM_DATA ? RegReadData2 : ExtImmediate;

  DivCLK divCLK(
    .originClock(Ori_CLK),
    .divClock(Div_CLK)
  );

  KeyCLK keyCLK(
    .CLK(Div_CLK),
    .KeyPressed(Key_CLK),
    .CPU_CLK(CLK)
  );

  LED led(
    .Switch_Status(status),
    .Div_CLK(Div_CLK),
    .presentPC(pc),
    .nextPC(NewPC),
    .RS_Addr({2'b00, rs}),
    .RS_Data(RegReadData1),
    .RT_Addr({2'b00, rt}),
    .RT_Data(RegReadData2),
    .ALU_Result(ALUResult[7:0]),
    .DB_Data(RAMOut[7:0]),
    .LED_Number(LED_Number),
    .LED_Code(LED_Code)
  );

  PC PC(
    .CLK(CLK),
    .Reset(Reset),
    .PCWre(PCWre),
    .NewPC(NewPC),
    .pc(pc)
  );

  PCHelper PCHelper(
    .pc(pc),
    .Immediate(Immediate),
    .Address(Address),
    .PCSrc(PCSrc),
    .NewPC(NewPC)
  );

  InstructionMemory InstructionMemory(pc, IDataIn, InsMemRW, Ins);

  RegFile RegFile(
    .CLK(CLK),
    .Reset(Reset),
    .ReadReg1(rs),
    .ReadReg2(rt),
    .WriteReg(WriteReg),
    .WriteData(RegWriteData),
    .ReadData1(RegReadData1),
    .ReadData2(RegReadData2),
    .WE(WE)
  );

  Extend Extend(
    .Immediate(Immediate),
    .ExtSel(ExtSel),
    .ExtImmediate(ExtImmediate)
  );

  ALU ALU(
    .ALUOp(ALUOp),
    .ReadData1(ALUReadData1),
    .ReadData2(ALUReadData2),
    .Result(ALUResult),
    .Zero(Zero),
    .Sign(Sign)
  );

  DataMemory DataMemory(
    .CLK(CLK),
    .Daddr(ALUResult),
    .DataIn(RegReadData2),
    .DataOut(RAMOut),
    .RD(RD),
    .WR(WR)
  );

  CU CU(
    .Opcode(Opcode),
    .Funct(Funct),
    .Zero(Zero),
    .Sign(Sign),
    .PCWre(PCWre),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .DBDataSrc(MemToReg),
    .RegWre(WE),
    .InsMemRW(InsMemRW),
    .mRD(RD),
    .mWR(WR),
    .RegDst(RegDst),
    .ExtSel(ExtSel),
    .PCSrc(PCSrc),
    .ALUOp(ALUOp)
  );

endmodule
`timescale 1ns / 1ps

module CPU(
  input CLK,
  input Reset
);

  wire [31:0] pc;
  wire [31:0] NewPC;
  wire [15:0] Immediate;
  wire [25:0] Address;
  wire [1:0] PCSrc;

  wire [31:0] Ins;

  wire [5:0] Opcode;
  wire [5:0] Funct;
  wire [4:0] Shamt;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;

  wire [31:0] ALUResult;
  wire [31:0] RAMOut;

  wire [4:0] WriteReg;
  wire [31:0] RegWriteData;
  wire [31:0] RegReadData1;
  wire [31:0] RegReadData2;

  wire [31:0] ExtImmediate;

  wire Zero;
  wire Sign;
  wire ALUSrcA;
  wire ALUSrcB;
  wire DB;
  wire RegWre;
  wire nRD;
  wire nWR;
  wire RegDst;
  wire ExtSel;
  wire [2:0] ALUOp;

  wire [31:0] ALUReadData1;
  wire [31:0] ALUReadData2;

  PC PC(
    .CLK(CLK),
    .Reset(Reset),
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

  InstructionMemory InstructionMemory(
    .Address(pc),
    .Ins(Ins)
  );
  
  Decoder decoder(
    .Ins(Ins),
    .Opcode(Opcode),
    .Funct(Funct),
    .Shamt(Shamt),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .Immediate(Immediate),
    .Address(Address)
  );

  assign WriteReg = RegDst == `REG_FROM_RT ? rt : rd;
  assign RegWriteData = DB == `DB_FROM_ALU ? ALUResult : RAMOut;

  RegFile RegFile(
    .CLK(CLK),
    .Reset(Reset),
    .RegWre(RegWre),
    .ReadReg1(rs),
    .ReadReg2(rt),
    .WriteReg(WriteReg),
    .WriteData(RegWriteData),
    .ReadData1(RegReadData1),
    .ReadData2(RegReadData2)
  );

  Extend Extend(
    .Immediate(Immediate),
    .ExtSel(ExtSel),
    .ExtImmediate(ExtImmediate) 
  );

  assign ALUReadData1 = ALUSrcA == `ALU_FROM_DATA ? RegReadData1 : {{27{1'b0}}, Shamt};
  assign ALUReadData2 = ALUSrcB == `ALU_FROM_DATA ? RegReadData2 : ExtImmediate;

  ALU ALU(
    .ALUOp(ALUOp),
    .ReadData1(ALUReadData1),
    .ReadData2(ALUReadData2),
    .Result(ALUResult),
    .Zero(Zero),
    .Sign(Sign)
  );

  RAM RAM(
    .CLK(CLK),
    .Address(ALUResult),
    .WriteData(RegReadData2),
    .nRD(nRD),
    .nWR(nWR),
    .DataOut(RAMOut)
  );

  CU CU(
    .Opcode(Opcode),
    .Funct(Funct),
    .Zero(Zero),
    .Sign(Sign),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .DB(DB),
    .ExtSel(ExtSel),
    .nRD(nRD),
    .nWR(nWR),
    .RegDst(RegDst),
    .RegWre(RegWre),
    .PCSrc(PCSrc),
    .ALUOp(ALUOp)
  );

endmodule
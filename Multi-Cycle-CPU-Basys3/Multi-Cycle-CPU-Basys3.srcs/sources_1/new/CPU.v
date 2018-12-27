`timescale 1ns / 1ps

module Multiple_Cycle_CPU(
    input CLK,
    input RST,

    output [31:0] IAddr,
    output [31:0] PC4,
    output [31:0] PC_Next,
    output [31:0] PC_Jump,

    output [31:0] IROut,

    output [31:0] ReadData1,
    output [31:0] ReadData2,

    output zero,
    output sign,
    output [31:0] result,

    output [31:0] extended,

    output [31:0] DB,

    output [5:0] op,
    output [4:0] rs,
    output [4:0] rt,
    output [4:0] rd,
    output [4:0] sa,
    output [15:0] immediate,
    output [25:0] jumpaddr, 
	
    output ExtSel,
	output PCWre,
	output IRWre,
	output InsMemRW,
	output WrRegDSrc,
	output RegWre,
	output ALUSrcA,
	output ALUSrcB,
	output mRD,
	output mWR,
	output DBDataSrc,
	output [2:0] ALUOp,
	output [1:0] RegDst,
    output [1:0] PCSrc,
    output [2:0] State
);

    assign op = IROut[31:26];
    assign rs = IROut[25:21];
    assign rt = IROut[20:16];
    assign rd = IROut[15:11];
    assign sa = IROut[10:6];
    assign immediate = IROut[15:0];
    assign jumpaddr = IROut[25:0];

    PC pc_ins(CLK, RST, PCWre, PC_Next, IAddr, PC4);
    PC_Source pc_source_ins(PC4, extended, ReadData1, PC_Jump, PCSrc, PC_Next);
    PC_Jumper pc_jumper_ins(PC4, jumpaddr, PC_Jump);

    IM im_ins(CLK, IAddr, InsMemRW, IRWre, IROut);

    RF rf_ins(CLK, RegWre, WrRegDSrc, RegDst, rs, rt,
        rd, DB, PC4, ReadData1, ReadData2);
    
    ALU alu_ins(ALUSrcA, ALUSrcB, ReadData1, ReadData2, sa, extended,
        ALUOp, zero, sign, result);
    
    SZE sze_ins(ExtSel, immediate, extended);

    DM dm_ins(CLK, mRD, mWR, DBDataSrc, result, result, ReadData2, DB);

    CU cu_ins(op, CLK, RST, zero, sign,
        ExtSel, PCWre, IRWre, InsMemRW, WrRegDSrc, RegWre,
        ALUSrcA, ALUSrcB, mRD, mWR, DBDataSrc,
        ALUOp, RegDst, PCSrc, State);
        
endmodule
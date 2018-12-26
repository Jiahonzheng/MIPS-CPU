`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/23 14:08:05
// Design Name: 
// Module Name: mcc_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mcc_sim();
    reg CLK;
    reg RST;

    // PC
    wire [31:0] IAddr;
    wire [31:0] PC4;
    wire [31:0] PC_Next;
    wire [31:0] PC_Jump;

    // IM
    wire [31:0] IROut;

    // RF
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // ALU
    wire zero;
    wire sign;
    wire [31:0] result;

    // SZE
    wire [31:0] extended;

    // DM
    wire [31:0] DB;

    // ÷∏¡Ó∑÷∂Œ
    wire [5:0] op;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] sa;
    wire [15:0] immediate;
    wire [25:0] jumpaddr; 
	
    // ControlUnit
    wire ExtSel;
	wire PCWre;
	wire IRWre;
	wire InsMemRW;
	wire WrRegDSrc;
	wire RegWre;
	wire ALUSrcA;
	wire ALUSrcB;
	wire mRD;
	wire mWR;
	wire DBDataSrc;
	wire [2:0] ALUOp;
	wire [1:0] RegDst;
    wire [1:0] PCSrc;
    wire [2:0] State;

    Multiple_Cycle_CPU mcc(
        .CLK(CLK), .RST(RST),
        
        .IAddr(IAddr), .PC4(PC4),
        .PC_Next(PC_Next), .PC_Jump(PC_Jump),
        
        .IROut(IROut),

        .ReadData1(ReadData1), .ReadData2(ReadData2),

        .zero(zero), .sign(sign), .result(result),

        .extended(extended),

        .DB(DB),

        .op(op), .rs(rs), .rt(rt), .rd(rd), .sa(sa),
        .immediate(immediate), .jumpaddr(jumpaddr),
        
        .ExtSel(ExtSel), .PCWre(PCWre), .IRWre(IRWre),
        .InsMemRW(InsMemRW), .WrRegDSrc(WrRegDSrc), .RegWre(RegWre),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .mRD(mRD), .mWR(mWR),
        .DBDataSrc(DBDataSrc), .ALUOp(ALUOp), .RegDst(RegDst),
        .PCSrc(PCSrc), .State(State)
    );

    initial begin
        CLK = 0;
        RST = 0;
        #50;
            CLK=1;
        #50;
            RST=1;
        forever #50 begin
            CLK=~CLK;
        end
    end
endmodule
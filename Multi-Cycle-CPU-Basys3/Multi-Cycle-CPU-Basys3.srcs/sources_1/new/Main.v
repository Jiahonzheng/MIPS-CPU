`timescale 1ns / 1ps

module MCC_IMP(
    input Ori_CLK,
    input Key_Clk,
    input reset,
    input [1:0] status,

    output [3:0] Led_Number,
    output [6:0] Led_Code,
    output [2:0] State
 );

    wire CLK;
    wire Div_Clk;
    wire [31:0] IAddr;
    wire [31:0] PC_Next;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] result;
    wire [31:0] DB;
    wire [4:0] rs;
    wire [4:0] rt;

    ClockDiv clkdiv_ins(.originClock(Ori_CLK), .divClock(Div_Clk));
    KeyClock keyclk_ins(.CLK(Div_Clk), .Key_Pressed(Key_Clk), .CPU_CLK(CLK));
    LedDisplay led_ins(.Switch_Status(status), .Div_CLK(Div_Clk),
        .presentPC(IAddr), .nextPC(PC_Next),
        .RS_Addr({2'b00, rs}), .RS_Data(ReadData1),
        .RT_Addr({2'b00, rt}), .RT_Data(ReadData2),
        .ALU_Result(result[7:0]), .DB_Data(DB[7:0]),
        .Led_Number(Led_Number), .Led_Code(Led_Code)
    );

    Multiple_Cycle_CPU mcc_ins(
        .CLK(CLK), .RST(reset),
        .IAddr(IAddr), .PC_Next(PC_Next),
        .ReadData1(ReadData1), .ReadData2(ReadData2),
        .result(result), .DB(DB),
        .State(State), .rs(rs), .rt(rt)
    );
endmodule
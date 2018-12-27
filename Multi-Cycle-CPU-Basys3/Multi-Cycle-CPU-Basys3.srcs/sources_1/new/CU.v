`timescale 1ns / 1ps

module CU(
	input [5:0] op,
	input CLK,
	input RST,
	input zero,
	input sign,

	output reg ExtSel,
	output reg PCWre,
	output reg IRWre,
	output reg InsMemRW,
	output reg WrRegDSrc,
	output reg RegWre,
	output reg ALUSrcA,
	output reg ALUSrcB,
	output reg mRD,
	output reg mWR,
	output reg DBDataSrc,
	output reg [2:0] ALUOp,
	output reg [1:0] RegDst,
	output reg [1:0] PCSrc,
	output reg [2:0] State
);

	`define OP_ADD 6'b000000
	`define OP_SUB 6'b000001
	`define OP_ADDIU 6'b000010
	`define OP_AND 6'b010000
	`define OP_ANDI 6'b010001
	`define OP_ORI 6'b010010
	`define OP_XORI 6'b010011
	`define OP_SLL 6'b011000
	`define OP_SLTI 6'b100110
	`define OP_SLT 6'b100111
	`define OP_SW 6'b110000
	`define OP_LW 6'b110001
	`define OP_BEQ 6'b110100
	`define OP_BNE 6'b110101
	`define OP_BLTZ 6'b110110
	`define OP_J 6'b111000
	`define OP_JR 6'b111001
	`define OP_JAL 6'b111010
	`define OP_HALT 6'b111111

	`define S_IF 3'b000
	`define S_ID 3'b001
	`define S_EXE_1 3'b110
	`define S_EXE_2 3'b101
	`define S_EXE_3 3'b010
	`define S_MEM 3'b011
	`define S_WB_1 3'b111
	`define S_WB_2 3'b100

	initial begin
		State = `S_IF;
		PCWre = 1;
		ALUSrcA = 0;
		ALUSrcB = 0;
		DBDataSrc = 0;
		RegWre = 1;
		WrRegDSrc = 1;
		InsMemRW = 0;
		mRD = 1;
		mWR = 1;
		IRWre = 0;
		ExtSel = 0;
		PCSrc = 2'b00;
		RegDst = 2'b10;
		ALUOp = 3'b000;
	end

  always @(posedge CLK or negedge RST) begin
		if (RST == 0) begin
			State <= `S_IF;
		end
		else begin
			case(State)
				`S_IF: State <= `S_ID;
				`S_ID:
					begin
						case(op)
							`OP_J, `OP_JAL, `OP_JR, `OP_HALT: State <= `S_IF;
							`OP_BEQ, `OP_BNE, `OP_BLTZ: State <= `S_EXE_2;
							`OP_SW, `OP_LW: State <= `S_EXE_3;
							default: State <= `S_EXE_1;
						endcase
					end
				`S_EXE_1: State <= `S_WB_1;
				`S_EXE_2: State <= `S_IF;
				`S_EXE_3: State <= `S_MEM;
				`S_MEM:
					begin
						State <= op == `OP_SW ? `S_IF : `S_WB_2;
					end
				`S_WB_1: State <= `S_IF;
				`S_WB_2: State <= `S_IF;
			endcase
		end
	end

	always @(negedge CLK) begin
		case (State)
      `S_ID: begin
        if (op == `OP_J || op == `OP_JAL || op == `OP_JR)  PCWre <= 1;
      end

      `S_EXE_1, `S_EXE_2, `S_EXE_3: begin
        if (op == `OP_BEQ || op == `OP_BNE || op == `OP_BLTZ)  PCWre <= 1;
      end
      
      `S_MEM: begin
        if (op == `OP_SW)  PCWre <= 1;
      end
      
      `S_WB_1, `S_WB_2: PCWre <= 1;
      
      default:  PCWre <= 0;
    endcase
	end

	always @(State or zero or sign or op or RST) begin
		RegWre = (State == `S_ID && op == `OP_JAL) || State == `S_WB_1 || State == `S_WB_2;
		WrRegDSrc = State == `S_ID && op == `OP_JAL ? 0 : 1;
		mRD = (State == `S_MEM || State == `S_WB_2) && op == `OP_LW;
		mWR = State == `S_MEM && op == `OP_SW;

		case (State)
			`S_IF:
				begin
					IRWre <= 1;
					InsMemRW <= 1;
				end
			`S_ID:
				begin
					IRWre <= 0;

					case(op)
						`OP_ADDIU, `OP_ORI, `OP_XORI, `OP_SW, `OP_LW, `OP_BEQ, `OP_BNE, `OP_BLTZ: ExtSel <= 1;
						default: ExtSel <= 0;
					endcase

					case(op)
						`OP_BEQ: PCSrc <= zero == 0 ? 2'b00 : 2'b01;
						`OP_BNE: PCSrc <= zero != 0 ? 2'b00 : 2'b01;
						`OP_BLTZ: PCSrc <= (sign == 0 | zero == 1) ? 2'b00 : 2'b01;
						`OP_J, `OP_JAL: PCSrc <= 2'b11;
						`OP_JR: PCSrc <= 2'b10;
						default: PCSrc <= 2'b00;
					endcase

					case(op)
						`OP_ADD, `OP_SUB, `OP_AND, `OP_SLT, `OP_SLL: RegDst <= 2'b10;
						`OP_ADDIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_SLTI, `OP_LW: RegDst <= 2'b01;
						default: RegDst <= 2'b00;
					endcase
				end
			`S_EXE_1, `S_EXE_2, `S_EXE_3:
				begin
					ALUSrcA <= op == `OP_SLL;
					ALUSrcB <= op == `OP_ADDIU || op == `OP_ANDI || op == `OP_ORI || op == `OP_XORI || op == `OP_SLTI || op == `OP_SW || op == `OP_LW;

					case(op)
						`OP_BEQ: PCSrc <= zero == 0 ? 2'b00 : 2'b01;
						`OP_BNE: PCSrc <= zero != 0 ? 2'b00 : 2'b01;
						`OP_BLTZ: PCSrc <= (sign == 0 | zero == 1) ? 2'b00 : 2'b01;
						`OP_J, `OP_JAL: PCSrc <= 2'b11;
						`OP_JR: PCSrc <= 2'b10;
						default: PCSrc <= 2'b00;
					endcase

					case(op)
						`OP_SUB, `OP_BEQ, `OP_BNE, `OP_BLTZ: ALUOp = 3'b001;
						`OP_ORI: ALUOp = 3'b011;
						`OP_AND, `OP_ANDI: ALUOp = 3'b100;
						`OP_SLL: ALUOp = 3'b010;
						`OP_SLT, `OP_SLTI: ALUOp = 3'b110;
						`OP_XORI: ALUOp = 3'b111;
						default: ALUOp = 3'b000;
					endcase

					DBDataSrc <= op == `OP_LW;
				end
			`S_WB_1, `S_WB_2:
				begin
					mWR <= 0;

					case(op)
						`OP_ADD, `OP_SUB, `OP_AND, `OP_SLT, `OP_SLL: RegDst <= 2'b10;
						`OP_ADDIU, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_SLTI, `OP_LW: RegDst <= 2'b01;
						default: RegDst <= 2'b00;
					endcase
				end
		endcase
	end

endmodule
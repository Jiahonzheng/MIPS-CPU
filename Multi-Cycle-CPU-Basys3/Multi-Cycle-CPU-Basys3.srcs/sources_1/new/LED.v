`timescale 1ns / 1ps

module LedDisplay(
  input [1:0] Switch_Status,
  input Div_CLK,

  input [7:0] presentPC,
  input [7:0] nextPC,

  input [7:0] RS_Addr,
  input [7:0] RS_Data,

  input [7:0] RT_Addr,
  input [7:0] RT_Data,

  input [7:0] ALU_Result,
  input [7:0] DB_Data,

  output reg [3:0] Led_Number, // Select LED
  output reg [6:0] Led_Code // Display
  );

  reg [15:0] toDisplay;
  reg [3:0] Digital;
  integer selector = 0;

  always @(posedge Div_CLK) begin
    case(Switch_Status) 
      2'b00: toDisplay <= {presentPC, nextPC};
      2'b01: toDisplay <= {RS_Addr, RS_Data};
      2'b10: toDisplay <= {RT_Addr, RT_Data};
      2'b11: toDisplay <= {ALU_Result, DB_Data};
    endcase
    
    selector = (selector + 1) % 4;
    
    case(selector)
      0: Digital = toDisplay[3:0];
      1: Digital = toDisplay[7:4];
      2: Digital = toDisplay[11:8];
      3: Digital = toDisplay[15:12];
    endcase
  end

  always @(posedge Div_CLK) begin
    case (Digital) 
      4'h0: Led_Code <= 7'b0000001; 
      4'h1: Led_Code <= 7'b1001111; 
      4'h2: Led_Code <= 7'b0010010; 
      4'h3: Led_Code <= 7'b0000110; 
      4'h4: Led_Code <= 7'b1001100; 
      4'h5: Led_Code <= 7'b0100100; 
      4'h6: Led_Code <= 7'b0100000; 
      4'h7: Led_Code <= 7'b0001111; 
      4'h8: Led_Code <= 7'b0000000; 
      4'h9: Led_Code <= 7'b0000100; 
      4'hA: Led_Code <= 7'b0001000; 
      4'hB: Led_Code <= 7'b1100000; 
      4'hC: Led_Code <= 7'b0110001; 
      4'hD: Led_Code <= 7'b1000010; 
      4'hE: Led_Code <= 7'b0110000; 
      4'hF: Led_Code <= 7'b0111000; 
    endcase
  end

  always @(posedge Div_CLK) begin
    Led_Number = 4'b1111;
    Led_Number[3 - selector] = 0;
  end
endmodule
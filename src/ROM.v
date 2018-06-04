`timescale 1ns/1ps

module ROM (
  input nrd, 
  input [31:0] Address
  output reg [31:0] DataOut
);
    
  reg [7:0] rom [0:99];
  
  initial begin
      $readmemh ("C:/Users/Administrator/Desktop/workplace/CPU/ROMdata/data.txt", rom);
  end
    
  always@(*) begin
    if (nrd == 0) begin
      DataOut[31:24] = rom[Address];
      DataOut[23:16] = rom[Address + 1];
      DataOut[15:8] = rom[Address + 2];
      DataOut[7:0] = rom[Address + 3];
    end
    else begin
      DataOut[31:0] = {32{1'bz}};
    end
  end

endmodule
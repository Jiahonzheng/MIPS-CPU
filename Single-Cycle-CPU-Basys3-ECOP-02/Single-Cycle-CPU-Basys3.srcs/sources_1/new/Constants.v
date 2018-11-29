// Opcode
`define OP_ADD 6'b000000     // Add
`define OP_ADDIU 6'b000010   // Add Unsigned Immediate
`define OP_AND 6'b010001     // And
`define OP_ANDI 6'b010000    // And Immediate
`define OP_BEQ 6'b110000     // Branch on Equal
`define OP_BLTZ 6'b110010    // Branch on Greater Than Zero
`define OP_BNE 6'b110001     // Branch on Not Equal
`define OP_HALT 6'b111111    // Halt
`define OP_J 6'b111000       // Jump
`define OP_LW 6'b100111      // Load Word
`define OP_OR 6'b010011      // Or
`define OP_ORI 6'b010010     // Or Immediate
`define OP_SLL 6'b011000     // Shift Left Logical
`define OP_SLTI 6'b011100    // Set on Less Than Immediate
`define OP_SUB 6'b000001     // Sub
`define OP_SW 6'b100110      // Save Word

// ALU
`define ALU_ADD 3'b000
`define ALU_AND 3'b100
`define ALU_CMPS 3'b110
`define ALU_CMPU 3'b101
`define ALU_OR 3'b011
`define ALU_SLL 3'b010
`define ALU_SUB 3'b001
`define ALU_XOR 3'b111

// ALUSrc
`define ALU_FROM_DATA 1'b0
`define ALU_FROM_IMMD 1'b1
`define ALU_FROM_SA 1'b1

// PC
`define PC_ABS_JMP 2'b10
`define PC_HALT 2'b11
`define PC_NEXT_INS 2'b00
`define PC_REL_JMP 2'b01

// Reg
`define REG_FROM_ALU 1'b0
`define REG_FROM_DATAMEMORY 1'b1
`define REG_FROM_RD 1'b1
`define REG_FROM_RT 1'b0

// Extend
`define EXT_SIGN 1'b1
`define EXT_ZERO 1'b0
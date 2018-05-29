// Loads and stores - opcode
`define OP_LW 6'b100011
`define OP_SW 6'b101011

// ALU - opcode
`define OP_ADD 6'b000000
`define OP_SUB 6'b000000
`define OP_AND 6'b000000
`define OP_OR 6'b000000
`define OP_SLT 6'b000000
`define OP_ADDI 6'b001000
`define OP_ORI 6'b001101

// Shifts - opcode
`define OP_SLL 6'b000000

// Jump and branch - opcode
`define OP_J 6'b000010
`define OP_HALT 6'b111111
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_BGTZ 6'b000111 

// ALU - function code
`define FUNCT_ADD 6'b100000
`define FUNCT_SUB 6'b100010
`define FUNCT_AND 6'b100100
`define FUNCT_OR 6'b100101
`define FUNCT_SLT 6'b101010

// Shifts - function code
`define FUNCT_SLL 6'b000000

// ALU control
`define ALU_ADD 3'b010
`define ALU_SUB 3'b110
`define ALU_SLT 3'b111
`define ALU_AND 3'b000
`define ALU_OR 3'b001
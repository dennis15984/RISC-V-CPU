`ifndef CONSTANT
`define CONSTANT /////// 
//Rtype
    `define ADD  5'b00000
    `define SUB  5'b00001
    `define SLL  5'b00010
    `define SLT  5'b00011
    `define SLTU 5'b00100
    `define XOR  5'b00101
    `define SRL  5'b00110
    `define SRA  5'b00111
    `define OR   5'b01000
    `define AND  5'b01001
	`define MUL  5'b01010
	`define MULH    5'b01011
	`define MULHSU  5'b01100
	`define MULHU   5'b01101

//Imm_Sel
    `define Rtype  3'b000
    `define Itype  3'b001
    `define Stype  3'b010
    `define Btype  3'b011
    `define Utype  3'b100
    `define Jtype  3'b101

// CSR
    `define RDINSTRETH   2'b00; //rd instret HIS
	`define RDINSTRET    2'b01; 
	`define RDCYCLEH     2'b10; //rd cycle HIS
	`define RDCYCLE      2'b11; 

//Branctrl
    `define BNONE  3'b000
    `define BEQ    3'b001
    `define BNE    3'b010
    `define BLT    3'b011
    `define BGE    3'b100
    `define BLTU   3'b101
    `define BGEU   3'b110
    
//MemReWr
    `define MNONE  2'b00
	  `define READ   2'b01
    `define WRITE  2'b10

//MemWHB
      `define WORD   3'b000
	  `define HALF   3'b001
	  `define HALFU  3'b101
	  `define BYTE   3'b010
	  `define BYTEU  3'b110
	 
//aludata1type_out
    `define RS1  2'd0
    `define PC   2'd1
    `define ZERO 2'd2

//aludata2type_out
    `define RS2   2'd0
    `define IMM   2'd1
    `define SHAMT 2'd2
	 
//forwardA
	 `define NOFA   2'd0 //no forwardA
	 `define MEMRDA 2'd1
	 `define WBRDA  2'd2

//forwardB
    `define NOFB   2'd0 //no forwardB
	 `define MEMRDB 2'd1
	 `define WBRDB  2'd2
`endif
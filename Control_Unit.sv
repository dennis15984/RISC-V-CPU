`include "parameter_define.sv"

module Control_Unit(opcode ,funct3 ,funct7 ,alucrl ,jump ,RegWrite ,MemReWr ,MemWHB ,alu_res_pc4 ,Branctrl ,alu_val1_type ,alu_val2_type ,Imm_Sel ,CSR_sel);

input [2:0]funct3;
input [6:0]opcode,funct7;
output logic [1:0]alu_val1_type ,alu_val2_type ,MemReWr ;
output logic [2:0] Branctrl ,Imm_Sel ,MemWHB;
output logic [4:0] alucrl;
output logic RegWrite ,jump ,alu_res_pc4 ,CSR_sel;

always_comb begin 
	case(opcode)
	 7'b0110011:
	 begin//////////////////////Rtype 
	  jump           = 1'b0;
	  RegWrite       = 1'b1;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b0;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `RS1;
	  alu_val2_type  = `RS2;
	  Imm_Sel        = `Rtype;

	  case (funct3) ////////////consider functioncode3 
         3'b000 : alucrl = (funct7 == 7'b0)	?`ADD:(funct7 == 7'b0100000)?`SUB:`MUL;
		 3'b001 : alucrl = (funct7 == 7'b0) ?`SLL:`MULH;
		 3'b010 : alucrl = (funct7 == 7'b0) ?`SLT:`MULHSU;
		 3'b011 : alucrl = (funct7 == 7'b0) ?`SLTU:`MULHU;
		 3'b100 : alucrl = `XOR;
		 3'b101 : alucrl = (funct7 == 7'b0) ?`SRL:`SRA;
		 3'b110 : alucrl = `OR;
		default : alucrl = `AND;
	   endcase
	 end 
    
	7'b0010011:
	begin////////////////////Itype
	  jump           = 1'b0;
	  RegWrite       = 1'b1;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b0;
	  alucrl         = `ADD;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `RS1;
	  alu_val2_type  = (funct3 == 3'b101 || funct3 == 3'b001)? `SHAMT : `IMM;
	  Imm_Sel        = `Itype;

	  case(funct3) 
		 3'b000 : alucrl = `ADD; //ADDI
		 3'b001 : alucrl = `SLL; //SLLI
		 3'b010 : alucrl = `SLT; //SLTI
		 3'b011 : alucrl = `SLTU; //SLTIU
		 3'b100 : alucrl = `XOR; //XORI
		 3'b110 : alucrl = `OR;  //ORI
		 3'b111 : alucrl = `AND; //ANDI
		 default: alucrl = (funct7 == 7'b0000000)?`SRL:`SRA;//SRLI  SRAI
		endcase
    end
    


    7'b1100111:
	begin/////////////////////JALR
	  jump           = 1'b1;
	  RegWrite       = 1'b1;
      alu_res_pc4    = 1'b1;
	  CSR_sel        = 1'b0;
	  alucrl         = `ADD;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `RS1;
	  alu_val2_type  = `IMM;
	  Imm_Sel        = `Itype;
	end

	7'b0000011:
	begin////////////////////LWHB
	  jump           = 1'b0;
	  RegWrite       = 1'b1;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b0;
	  alucrl         = `ADD;
	  MemReWr        = `READ;
      Branctrl       = `BNONE;
	  alu_val1_type  = `RS1;
	  alu_val2_type  = `IMM;
	  Imm_Sel        = `Itype;

	  case(funct3)
	    3'b010 : MemWHB = `WORD; //LW
        3'b000 : MemWHB = `BYTE; //LB
		3'b001 : MemWHB = `HALF; //LH
		3'b100 : MemWHB = `BYTEU;//LBU
		3'b101 : MemWHB = `HALFU;//LHU
		default: MemWHB = `WORD;
	  endcase
	end

	7'b0100011:
	begin//////////////////////Stype
	  jump           = 1'b0;
	  RegWrite       = 1'b0;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b0;
	  alucrl         = `ADD;
	  MemReWr        = `WRITE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `RS1;
	  alu_val2_type  = `IMM;
	  Imm_Sel        = `Stype;
	  
	  case (funct3)
		3'b010 : MemWHB = `WORD; //SW 
		3'b000 : MemWHB = `BYTE; //
		3'b001 : MemWHB = `HALF; //SH
		default: MemWHB = `WORD;
	  endcase
	end

	7'b1100011:
	begin////////////////////Btype PC+Imm: PC+4;
	  jump           = 1'b0;
	  RegWrite       = 1'b0;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b0;
	  alucrl         = `ADD;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `PC;
	  alu_val2_type  = `IMM;
	  Imm_Sel        = `Btype; 

	  case (funct3)
		3'b000 : Branctrl = `BEQ;
		3'b001 : Branctrl = `BNE;
		3'b100 : Branctrl = `BLT;
		3'b101 : Branctrl = `BGE;
		3'b110 : Branctrl = `BLTU;
		3'b111 : Branctrl = `BGEU;
		default: Branctrl = `BEQ;
	  endcase
	end

	7'b0010111:
	begin///////////////////////Utype AUIPC
	  jump           = 1'b0;
	  RegWrite       = 1'b1;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b0;
	  alucrl         = `ADD;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `PC;
	  alu_val2_type  = `IMM;
	  Imm_Sel        = `Utype; 
	end
 
	7'b0110111:
	begin/////////////////////////Utype LUI
      jump           = 1'b0;
	  RegWrite       = 1'b1;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b0;
	  alucrl         = `ADD;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `ZERO;
	  alu_val2_type  = `IMM;
	  Imm_Sel        = `Utype;
	end
    
	7'b1101111:
	begin////////////////////////JAL
	  jump           = 1'b1;
	  RegWrite       = 1'b1;
      alu_res_pc4    = 1'b1;
	  CSR_sel        = 1'b0;
	  alucrl         = `ADD;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `PC;
	  alu_val2_type  = `IMM;
	  Imm_Sel        = `Jtype;
	end
	
    7'b1110011:
	begin////////////////////////CSR
	  jump           = 1'b0;
	  RegWrite       = 1'b1;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b1;
	  alucrl         = `ADD;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `PC;
	  alu_val2_type  = `IMM;
	  Imm_Sel        = `Jtype;	  
	end

 default:
   begin
	  jump           = 1'b0;
	  RegWrite       = 1'b0;
      alu_res_pc4    = 1'b0;
	  CSR_sel        = 1'b0;
	  alucrl           = `ADD;
	  MemReWr        = `MNONE;
	  MemWHB         = `WORD;
      Branctrl       = `BNONE;
	  alu_val1_type  = `RS1;
	  alu_val2_type  = `RS2;
	  Imm_Sel        = `Rtype; 
   end
  endcase
end
endmodule
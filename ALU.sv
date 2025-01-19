`include "parameter_define.sv"

module ALU(op1,op2,alucrl,alures);
input [31:0] op1,op2;    //rs1,rs2
input [4:0]alucrl;    //controller
output logic [31:0] alures; 
logic [63:0] product;   
   always_comb begin
        case(alucrl)
			`ADD:  alures = $signed(op1)+$signed(op2) ;
            `SUB:  alures = $signed(op1)-$signed(op2) ; 
            `SRA:  alures = $signed(op1)>>>op2[4:0] ; 
            `SRL:  alures = op1>>op2[4:0] ; 
            `SLL:  alures = op1<<op2[4:0] ; 
            `AND:  alures = op1&op2 ; 
            `OR:   alures = op1|op2 ; 
            `XOR:  alures = op1^op2; 
            `SLTU: alures = op1<op2?32'b1:32'b0 ; 
            `SLT:  alures = ($signed(op1)<$signed(op2))?32'b1:32'b0 ; 
            `MUL:  alures = product[31:0];
            `MULH: alures = product[63:32];
            `MULHSU:alures = product[63:32];
            `MULHU:alures = product[63:32];
            default: alures = 32'b0;
        endcase
    end

    always_comb begin 
        case (alucrl)
            `MUL:product = $signed(op1)*$signed(op2) ; 
            `MULH:product = $signed(op1)*$signed(op2) ;
            `MULHSU:product = $signed(op1)*$signed({1'b0,op2});           
            `MULHU:product = op1*op2;
           default:product = 64'b0;    
       endcase    
    end
endmodule	 

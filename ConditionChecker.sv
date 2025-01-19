`include "parameter_define.sv"

 module ConditionChecker (reg1 ,reg2 ,Branctrl ,Branch_Out );
  input [2:0]  Branctrl;
  input [31:0] reg1, reg2;
  wire signed [31:0] sreg1=reg1, sreg2=reg2;
  output logic   Branch_Out;

  
  always_comb begin
    case (Branctrl)
      `BNONE : Branch_Out = 1'b0;
		  `BEQ   : Branch_Out = (reg1 == reg2)  ? 1'b1 : 1'b0;
      `BNE   : Branch_Out = (reg1 != reg2)  ? 1'b1 : 1'b0;
      `BLT   : Branch_Out = (sreg1 < sreg2) ? 1'b1 : 1'b0;
      `BGE   : Branch_Out = (sreg1 >= sreg2)? 1'b1 : 1'b0;
      `BLTU  : Branch_Out = (reg1 < reg2)   ? 1'b1 : 1'b0;
      `BGEU  : Branch_Out = (reg1 >= reg2)  ? 1'b1 : 1'b0;
      default : Branch_Out = 1'b0;
    endcase
  end
endmodule // ConditionChecker


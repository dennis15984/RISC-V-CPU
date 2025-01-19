`include "parameter_define.sv"  

module Immediate_Unit(instr, Imm_Sel, Imm_Out);
input [2:0] Imm_Sel;
input [31:0] instr;
output logic [31:0] Imm_Out;

always_comb begin
    case(Imm_Sel)
    `Itype : Imm_Out = { {21{instr[31]}}, instr[30:20] };
    `Stype : Imm_Out = { {20{instr[31]}}, instr[31:25], instr[11:7]};
    `Btype : Imm_Out = { {19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    `Utype : Imm_Out = { instr[31:12], 12'b0};
    `Jtype : Imm_Out = { {12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
    default: Imm_Out = 32'b0;
    endcase
end 
endmodule
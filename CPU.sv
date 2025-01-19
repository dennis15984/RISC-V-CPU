`include "parameter_define.sv"
`include "PCReg.sv"
`include "IFtoID.sv"
`include "RegFile.sv"
`include "Control_Unit.sv"
`include "Immediate_Unit.sv"
`include "IDtoEXE.sv"
`include "ALU.sv"
`include "MUX.sv"
`include "MUX3.sv"
`include "ConditionChecker.sv"
`include "EXEtoMEM.sv"
`include "MEMtoWB.sv"
`include "Forwarding_Unit.sv"
`include "LoadSignExtend.sv"
`include "SaveControl.sv"
`include "HazardDetection.sv"
`include "CSR.sv"

module CPU(clk ,rst ,IM_cs ,DM_cs ,IM_oe ,DM_oe ,IM_web ,DM_web ,IM_addr ,DM_addr ,IM_datain ,IM_dataout ,DM_datain ,DM_dataout);
input clk, rst; 
input [31:0] IM_dataout ,DM_dataout ;
output logic [3:0] IM_web ,DM_web ;
output logic [13:0] IM_addr ,DM_addr ;
output logic [31:0] IM_datain ,DM_datain ;
output logic IM_cs ,DM_cs ,IM_oe ,DM_oe ;

logic [31:0] pcin_IF, pcadd4_IF, pc_IF, instr, instr_old;
logic [31:0] pcadd4_ID, pc_ID, RegVal1_ID, RegVal2_ID, Imm_ID;
logic [2:0] funct3;
logic [6:0] funct7, opcode;
logic [4:0] RegAddr1_ID, RegAddr2_ID, RdAddr_ID;

logic [4:0] aluc_ID;
logic [2:0] Branctrl_ID, Imm_Sel_ID, MemWHB_ID;
logic [1:0] instr_mux, MemReWr_ID, alu_val1_type_ID, alu_val2_type_ID;
logic RegWrite_ID, alu_res_pc4_ID, jump_ID, CSR_sel_ID; 

logic [31:0] pcadd4_E, pc_E, RegVal1_E, RegVal2_E, Imm_E, instr_csr_E;  
logic [4:0] RdAddr_E, RegAddr1_E, RegAddr2_E;
logic [4:0] aluc_E;
logic [2:0] MemWHB_E, Branctrl_E;
logic [1:0] alu_val1_type_E, alu_val2_type_E, MemReWr_E; 
logic [31:0] alusrc1, alusrc2, RsVal1, RsVal2, alures_E;
logic branch_E, RegWrite_E, alu_res_pc4_E, jump_E, CSR_sel_E;

logic [31:0] RegVal2_M, RdVal_M, RdVal_M2 ,DMdata_M ,instr_csr_M;
logic [31:0] pcadd4_M, alures_M;
logic [4:0] RdAddr_M;
logic [2:0] MemWHB_M;
logic [1:0] MemReWr_M;
logic RegWrite_M, alu_res_pc4_M, CSR_sel_M, BranchorJump;
logic [31:0] CSR_out;

logic [4:0] RdAddr_W;
logic [1:0] MemReWr_W;
logic [2:0] MemWHB_W;
logic RegWrite_W;
logic [31:0] RdVal_W, DMdata_W;
logic [31:0] RdVal_final;


logic [1:0] RegVal1_sel, RegVal2_sel;
logic pc_stall, IF_stall, IF_flush, ID_stall, ID_flush;

//IF stage//

assign pcadd4_IF = pc_IF + 32'd4;
assign IM_addr = {pc_IF[15:2]};
assign IM_cs = (rst)? 1'd0 : 1'd1;
assign IM_oe = 1'd1;
assign IM_web = 4'b1111;
assign IM_datain = 32'd0;
assign instr = (instr_mux==2'd1) ? 32'd0 : (instr_mux==2'd2) ? instr_old : IM_dataout;
assign funct7 = instr[31:25];
assign RegAddr2_ID = instr[24:20];
assign RegAddr1_ID = instr[19:15];
assign funct3 = instr[14:12];
assign RdAddr_ID = instr[11:7];
assign opcode = instr[6:0];

PCReg PC
(.clk(clk), .rst(rst), .pcin(pcin_IF), .pcout(pc_IF), .pc_stall(pc_stall));

IFtoID IFIDreg
(.clk(clk), .rst(rst), .IF_stall(IF_stall), .IF_flush(IF_flush), .pcadd4_in(pcadd4_IF), .pc_in(pc_IF), 
 .pcadd4_out(pcadd4_ID), .pc_out(pc_ID), .instr_in(IM_dataout), .instr_mux(instr_mux), .instr_out(instr_old));
					 


//ID stage//

Control_Unit control
(.opcode(opcode), .funct3(funct3), .funct7(funct7), .alucrl(aluc_ID), .Imm_Sel(Imm_Sel_ID), .Branctrl(Branctrl_ID),
                     .alu_val1_type(alu_val1_type_ID), .alu_val2_type(alu_val2_type_ID), .MemReWr(MemReWr_ID),
                     .MemWHB(MemWHB_ID), .RegWrite(RegWrite_ID), .alu_res_pc4(alu_res_pc4_ID), .CSR_sel(CSR_sel_ID), .jump(jump_ID));
           
RegFile RF
(.clk(clk), .rst(rst), .RegWrite(RegWrite_W), .ReAddr1(RegAddr1_ID), .ReAddr2(RegAddr2_ID), .WrAddr(RdAddr_W), .WrVal(RdVal_final), 
           .Val1(RegVal1_ID), .Val2(RegVal2_ID));
			  
Immediate_Unit ImmG
(.instr(instr), .Imm_Sel(Imm_Sel_ID), .Imm_Out(Imm_ID));

IDtoEXE IDEXEreg
(.clk(clk), .rst(rst), .ID_stall(ID_stall), .ID_flush(ID_flush),
                .pcadd4_in(pcadd4_ID), .RdAddr_in(RdAddr_ID), .MemReWr_in(MemReWr_ID), .MemWHB_in(MemWHB_ID), .RegWrite_in(RegWrite_ID), .aluc_in(aluc_ID), 
                .alu_res_pc4_in(alu_res_pc4_ID), .CSR_sel_in(CSR_sel_ID), .pc_in(pc_ID), .alu_val1_type_in(alu_val1_type_ID), .alu_val2_type_in(alu_val2_type_ID), .jump_in(jump_ID),
				.Branctrl_in(Branctrl_ID), .RegVal1_in(RegVal1_ID), .RegVal2_in(RegVal2_ID), .instr_in(instr), .Imm_in(Imm_ID), .RegAddr1_in(RegAddr1_ID), .RegAddr2_in(RegAddr2_ID),
                .pcadd4_out(pcadd4_E), .RdAddr_out(RdAddr_E), .MemReWr_out(MemReWr_E), .MemWHB_out(MemWHB_E), .RegWrite_out(RegWrite_E), .aluc_out(aluc_E), 
                .alu_res_pc4_out(alu_res_pc4_E), .CSR_sel_out(CSR_sel_E), .pc_out(pc_E), .alu_val1_type_out(alu_val1_type_E), .alu_val2_type_out(alu_val2_type_E), .jump_out(jump_E),
					 .Branctrl_out(Branctrl_E), .RegVal1_out(RegVal1_E), .instr_out(instr_csr_E), .RegVal2_out(RegVal2_E), .Imm_out(Imm_E), .RegAddr1_out(RegAddr1_E), .RegAddr2_out(RegAddr2_E));

//EX stage//

assign BranchorJump = (branch_E || jump_E) ? 1'b1 : 1'b0;

MUX3 ForwardB
(.sel(RegVal2_sel), .in1(RegVal2_E), .in2(RdVal_M2), .in3(RdVal_final), .out(RsVal2));

MUX3 alusrc2mux
(.sel(alu_val2_type_E), .in1(RsVal2), .in2(Imm_E), .in3({27'd0, Imm_E[4:0]}), .out(alusrc2));

MUX3 ForwardA
(.sel(RegVal1_sel), .in1(RegVal1_E), .in2(RdVal_M2), .in3(RdVal_final), .out(RsVal1));

MUX3 alusrc1mux
(.sel(alu_val1_type_E), .in1(RsVal1), .in2(pc_E), .in3(32'd0), .out(alusrc1));

ALU ALU1
(.op1(alusrc1), .op2(alusrc2), .alucrl(aluc_E), .alures(alures_E));

ConditionChecker compare
( .Branctrl(Branctrl_E) ,.Branch_Out(branch_E) ,.reg1(RsVal1) ,.reg2(RsVal2));

EXEtoMEM EXEMEMreg
(.clk(clk), .rst(rst), 
.RdAddr_in(RdAddr_E), .MemReWr_in(MemReWr_E), .MemWHB_in(MemWHB_E), .RegWrite_in(RegWrite_E), 
.alu_res_pc4_in(alu_res_pc4_E), .CSR_sel_in(CSR_sel_E), .pcadd4_in(pcadd4_E), .alures_in(alures_E), .RegVal2_in(RsVal2), .instr_in(instr_csr_E), .instr_out(instr_csr_M),
.RdAddr_out(RdAddr_M), .MemReWr_out(MemReWr_M), .MemWHB_out(MemWHB_M), .RegWrite_out(RegWrite_M), 
.alu_res_pc4_out(alu_res_pc4_M),.CSR_sel_out(CSR_sel_M)  ,.pcadd4_out(pcadd4_M), .alures_out(alures_M), .RegVal2_out(RegVal2_M));

//MEM stage//

MUX RdValMUX
(.sel(alu_res_pc4_M), .in1(alures_M), .in2(pcadd4_M), .out(RdVal_M));

CSR csr
(.clk(clk), .rst(rst), .instr(instr_csr_M), .csr_data(CSR_out));

MUX RdValMUX2
(.sel(CSR_sel_M), .in1(RdVal_M), .in2(CSR_out), .out(RdVal_M2));

assign DM_addr = alures_M[15:2];
assign DM_cs = 1'b1;
assign DM_oe = 1'b1;

SaveControl SC
(.MemWrite(MemReWr_M[1]), .MemWHB(MemWHB_M), .web_sel(alures_M[1:0]), .RegVal2(RegVal2_M), .DM_datain(DM_datain), .DM_web(DM_web));

MEMtoWB MEMWBreg1
(.clk(clk), .rst(rst), 
.RdAddr_in(RdAddr_M), .MemReWr_in(MemReWr_M), .MemWHB_in(MemWHB_M), .RegWrite_in(RegWrite_M), .RdVal_in(RdVal_M2),
.RdAddr_out(RdAddr_W), .MemReWr_out(MemReWr_W), .MemWHB_out(MemWHB_W), .RegWrite_out(RegWrite_W), .RdVal_out(RdVal_W));

//WB stage//

LoadSignExtend LSE
(.MemWHB(MemWHB_W), .DM_dataout(DM_dataout), .LoadoutVal(DMdata_W));

MUX WBMUX
(.sel(MemReWr_W[0]), .in1(RdVal_W), .in2(DMdata_W), .out(RdVal_final));

Forwarding_Unit Forwarding
(.RegAddr1(RegAddr1_E), .RegAddr2(RegAddr2_E), .MEM_RdAddr(RdAddr_M), .WB_RdAddr(RdAddr_W), .MEM_RegWrite(RegWrite_M), .WB_RegWrite(RegWrite_W), 
                           .forwardA(RegVal1_sel), .forwardB(RegVal2_sel));

MUX PCMUX
(.sel(BranchorJump), .in1(pcadd4_IF), .in2(alures_E), .out(pcin_IF));

HazardDetection HD
(.BranchorJump(BranchorJump), .RdAddr(RdAddr_E), .MemRead(MemReWr_E[0]), .RegAddr1(RegAddr1_ID), .RegAddr2(RegAddr2_ID),
                   .pc_stall(pc_stall), .IF_stall(IF_stall), .IF_flush(IF_flush), .ID_stall(ID_stall), .ID_flush(ID_flush));



endmodule

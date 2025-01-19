module IDtoEXE(clk, rst ,ID_stall ,ID_flush ,pc_in ,pc_out ,aluc_in ,aluc_out ,alu_val1_type_in ,
              alu_val1_type_out ,alu_val2_type_in ,alu_val2_type_out ,jump_in ,jump_out ,Branctrl_in ,Branctrl_out ,RegAddr1_in, 
               RegAddr1_out, RegAddr2_in, RegAddr2_out, RegVal1_in, RegVal1_out , RegVal2_in, RegVal2_out, Imm_in, Imm_out,MemReWr_in ,
		       MemReWr_out , MemWHB_in, MemWHB_out, alu_res_pc4_in, alu_res_pc4_out,
		       pcadd4_in, pcadd4_out, RegWrite_in, RegWrite_out, RdAddr_in, RdAddr_out, CSR_sel_in, CSR_sel_out, instr_in ,instr_out);

		 	 
input clk ,rst ,jump_in ,alu_res_pc4_in ,RegWrite_in ,ID_flush ,ID_stall ,CSR_sel_in;
input [1:0] alu_val1_type_in ,alu_val2_type_in ,MemReWr_in ;
input [2:0] MemWHB_in ,Branctrl_in ;
input [4:0] aluc_in ;
input [4:0] RegAddr1_in ,RegAddr2_in ,RdAddr_in  ;
input [31:0] pc_in ,pcadd4_in ,RegVal1_in ,RegVal2_in,Imm_in  ,instr_in;

output logic RegWrite_out ,jump_out ,alu_res_pc4_out ,CSR_sel_out;
output logic [1:0] MemReWr_out ,alu_val1_type_out ,alu_val2_type_out ;
output logic [2:0] MemWHB_out ,Branctrl_out ;
output logic [4:0] aluc_out ;
output logic [4:0] RegAddr1_out ,RegAddr2_out ,RdAddr_out ;
output logic [31:0]pcadd4_out ,pc_out ,RegVal1_out ,RegVal2_out ,Imm_out ,instr_out;

always_ff @(posedge clk, posedge rst)begin
  if(rst)
     begin
     pcadd4_out<=        32'd0;
     RdAddr_out<=        5'd0;
	 jump_out<=          1'b0;
	 RegWrite_out<=      1'b0;
	 MemReWr_out<=       2'b0;
	 MemWHB_out<=        3'b0;
	 alu_res_pc4_out<=   1'b0;
	 CSR_sel_out<=       1'b0;
     Branctrl_out<=      3'b0;
     aluc_out<=          5'b0;
	 alu_val1_type_out<= 2'b0;
	 alu_val2_type_out<= 2'b0;
	 pc_out<=            32'b0;
	 RegVal1_out<=       32'b0;
	 RegVal2_out<=       32'b0;
     Imm_out<=           32'b0;
     RegAddr1_out<=      5'b0;
	 RegAddr2_out<=      5'b0;
	 instr_out<=        32'b0;
	 end

  else if(ID_flush)
     begin
     pcadd4_out<=        32'd0;
     RdAddr_out<=        5'd0;
	 jump_out<=          1'b0;
	 RegWrite_out<=      1'b0;
	 MemReWr_out<=       2'b0;
	 MemWHB_out<=        3'b0;
	 alu_res_pc4_out<=   1'b0;
	 CSR_sel_out<=       1'b0;
     Branctrl_out<=      3'b0;
     aluc_out<=          5'b0;
	 alu_val1_type_out<= 2'b0;
	 alu_val2_type_out<= 2'b0;
	 pc_out<=            32'b0;
	 RegVal1_out<=       32'b0;
	 RegVal2_out<=       32'b0;
     Imm_out<=           32'b0;
     RegAddr1_out<=      5'b0;
	 RegAddr2_out<=      5'b0; 
	 instr_out<=        32'b0;
     end
  
  else if(~ID_stall)begin
     pcadd4_out<=       pcadd4_in;
     RdAddr_out<=        RdAddr_in;
	 jump_out<=          jump_in;
	 RegWrite_out<=      RegWrite_in;
	 MemReWr_out<=       MemReWr_in;
	 MemWHB_out<=        MemWHB_in;
	 alu_res_pc4_out<=   alu_res_pc4_in;
	 CSR_sel_out<=       CSR_sel_in;
     Branctrl_out<=      Branctrl_in;
     aluc_out<=          aluc_in;
	 alu_val1_type_out<= alu_val1_type_in;
	 alu_val2_type_out<= alu_val2_type_in;
	 pc_out<=            pc_in;
	 RegVal1_out<=       RegVal1_in;
	 RegVal2_out<=       RegVal2_in;
     Imm_out<=           Imm_in;
     RegAddr1_out<=      RegAddr1_in;
	 RegAddr2_out<=      RegAddr2_in;
	 instr_out<=         instr_in;
  end
end
endmodule
